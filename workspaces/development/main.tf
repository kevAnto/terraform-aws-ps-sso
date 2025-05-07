locals {
  config = yamldecode(file("${path.module}/locals.yaml"))
}

# Security Module
module "security" {
  source = "../../modules/security"

  namePrefix = local.config.namePrefix
  vpcId      = module.networking.vpcId
  vpcCidr    = module.networking.vpcCidr
  commonTags = local.config.commonTags
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  namePrefix         = local.config.namePrefix
  vpcCidr            = local.config.vpcCidr
  publicSubnetCidrs  = local.config.publicSubnetCidrs
  privateSubnetCidrs = local.config.privateSubnetCidrs
  availabilityZones  = local.config.availabilityZones
  region             = var.awsRegion
  securityGroupId    = module.security.securityGroupId
  commonTags         = local.config.commonTags
}

# Splunk Components Module
module "splunk_components" {
  source = "../../modules/splunk-components"

  namePrefix         = local.config.namePrefix
  splunkAmi          = local.config.splunkAmi
  publicSubnetIds    = module.networking.publicSubnetIds
  privateSubnetIds   = module.networking.privateSubnetIds
  securityGroupId    = module.security.securityGroupId
  instanceProfileName = module.security.instanceProfileName
  scriptPath         = local.config.scriptPath
  
  # Search Head Configuration
  searchHeadCount        = local.config.searchHeadCount
  searchHeadInstanceType = local.config.searchHeadInstanceType
  searchHeadVolumeSize   = local.config.searchHeadVolumeSize
  
  # Indexer Configuration
  indexerCount        = local.config.indexerCount
  indexerInstanceType = local.config.indexerInstanceType
  indexerVolumeSize   = local.config.indexerVolumeSize
  
  # Manager Configuration
  clusterManagerInstanceType  = local.config.clusterManagerInstanceType
  licenseManagerInstanceType  = local.config.licenseManagerInstanceType
  monitoringConsoleInstanceType = local.config.monitoringConsoleInstanceType
  managerVolumeSize   = local.config.managerVolumeSize
  
  splunkSecret  = var.splunkSecret
  clusterLabel  = local.config.clusterLabel
  commonTags    = local.config.commonTags
  
  depends_on = [
    module.networking,
    module.security
  ]
}

# Load Balancer Module
module "load_balancer" {
  source = "../../modules/load-balancer"

  namePrefix        = local.config.namePrefix
  vpcId             = module.networking.vpcId
  publicSubnetIds   = module.networking.publicSubnetIds
  targetInstanceIds = module.splunk_components.searchHeadIds
  targetPort        = local.config.lbTargetPort
  listenerPort      = local.config.lbListenerPort
  commonTags        = local.config.commonTags
  dependsOn         = [module.splunk_components.searchHeadIds]
}