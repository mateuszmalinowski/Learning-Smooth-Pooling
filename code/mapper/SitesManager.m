classdef SitesManager < Mapper
  %SITESMANAGER Maintains list of all sites.
  %
  % Written by: Mateusz Malinowski
  % Email: m4linka@gmail.com
  % Created: 31.05.2010
  % 
  
  properties
    
    % contains sites
    sites
    
  end
  
  methods
    
    function obj = SitesManager( varargin )
      % Constructor.
      %
      % Params:
      %   varargin - mappers that we want to consider as one site;
      %
      
      % arguments of the function are given as a cell array
      obj.sites = varargin;
      
    end
    
    function cat( obj, sitesManager )
      % Concatenates current sites manager with the new one.
      %
      % Params:
      %   sitesManager - sites manager to concatenate
      %
      
      % we cannot use [a,b] since sites are cell arrays
      obj.sites = cat( 2, obj.sites, sitesManager.sites );
      
    end
    
    function value = eval( obj, u )
      % Evaluates sites, that is if s1, s2, ..., sn are sites then
      % value = s1.eval + s2.eval + ... + sn.eval
      %
      % Params:
      %   u - variable [optional, but if not given please read
      %   specification of the given sites about default u]
      %
      % Return:
      %   value - value of the sum of sites
      %
      
      value = 0;
      
      nSites = length( obj.sites );
      
      for ii = 1:nSites
        
        iSites = obj.sites{ ii };
        
        if nargin == 2
          value = value + iSites.eval( u );
        else
          value = value + iSites.eval;
        end
        
      end
      
    end
    
    function set_multiplier( obj, t )
      % Sets multiplier for all sites
      %
      % Params:
      %   t - multiplier to set
      %
      
      nSites = length( obj.sites );
      
      for ii = 1:nSites
        
        iSites = obj.sites{ ii };
        
        iSites.set_multiplier( t );
        
      end
      
    end
    
    
    function gradient = compute_gradient( obj, u )
      % Computes sum of sites' gradients, 
      % that is if s1, s2, ..., sn are sites then 
      % gradient = s1.gradient + s2.gradient + ... + sn.gradient
      %
      % Params:
      %   u - latent variable [optional, but if not given please read
      %   specification of the given sites about default u]
      %
      % Return:
      %   gradient - gradient of the sites
      %
      
      nSites = length( obj.sites );
      
      for ii = 1:nSites
        
        iSites = obj.sites{ ii };
        
        if nargin == 2
          if ii == 1
            gradient = iSites.compute_gradient( u );
          else
            gradient = gradient + iSites.compute_gradient( u );
          end
        else
          if ii == 1
            gradient = iSites.compute_gradient;
          else
            gradient = gradient + iSites.compute_gradient;
          end
        end
        
      end
      
    end
    
    function hessianV = compute_hessian( obj, v, u )
      % Computes Hessians of sites, 
      % that is if s1, s2, ..., sn are sites then
      % hessianV = s1.hessian * v + s2.hessian * v + ... + sn.hessian * v
      %
      % Params:
      %   v - vector to multiply by
      %   u - variable [optional, but if not given please read
      %   specification of the given sites about default u]
      %
      % Return:
      %   hessianV - hessian of sites multiply by vector v
      %
      
      nSites = length( obj.sites );
      
      for ii = 1:nSites
        
        iSites = obj.sites{ ii };
        
        if nargin == 3
          hessian = iSites.compute_hessian( u );
        else
          hessian = iSites.compute_hessian;    
        end
      
        if ii == 1
          hessianV = hessian( v );
        else
          hessianV = hessianV + hessian( v );
        end
        
      end
      
    end
    
  end
  
end

