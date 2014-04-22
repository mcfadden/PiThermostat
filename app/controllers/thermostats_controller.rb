class ThermostatsController < ApplicationController
  respond_to :html, :json

  before_filter :load_thermostat

  def new
    respond_with @thermostat
  end

  def update
    @thermostat = Thermostat.find( params[:id] )

    @thermostat.update_attributes( thermostat_params )

    respond_with @thermostat
  end

  def log_current_data
    @thermostat = Thermostat.find( params[:id] )

    @history = ThermostatHistory.now_for_thermostat( @thermostat ).first

    if @history.nil?
      @history = ThermostatHistory.create( { thermostat: @thermostat, year: Time.now.year, day_of_year: Time.now.yday } )
    end

    @history.capture_current_data!

    respond_with [@thermostat, @history]
  end

  private

  def thermostat_params
    params.require( :thermostat ).permit( :name, :current_temperature, :target_temperature, :mode, :running, :hysteresis )
  end

  def load_thermostat
    @thermostat = Thermostat.find( params[:id] )
  end


end
