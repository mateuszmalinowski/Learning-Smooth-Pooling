classdef Mapper < handle
  %MAPPER The Mapper which aggregates matrix-dependent terms under uniform
  % framework that provides evaluation of the terms, computing its gradient
  % or Hessian (as a function of vector).
  %
  % The Mapper can also be seen as a function: 
  %   Mapper : M x P -> R+
  % where M - matrix domain, P - parameters domain, R+ - semipositive
  %   orthant
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 29.05.2010
  % 
  
  methods( Abstract )
    
    % evaluates the expression
    val = eval( obj, u, varargin )
    
    % computes gradient
    gradient = compute_gradient( obj, u, varargin )
    
    % computes Hessian as a function of vector v
    hessian = compute_hessian( obj, u, varargin )
    
    % sets multiplier
    set_multiplier( obj, t )
    
  end
  
end

