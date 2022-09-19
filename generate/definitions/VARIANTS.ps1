# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package = 'chrony'
        package_version = '4.2-r0'
        distro = 'alpine'
        distro_version = '3.16'
        subvariants = @(
            @{ components = @(); tag_as_latest = $true }
        )
    }
    @{
        package = 'chrony'
        package_version = '4.1-r0'
        distro = 'alpine'
        distro_version = '3.14'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '4.0-r1'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'chrony'
        package_version = '3.5.1-r0'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
        )
    }
)

$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package = $variant['package']
                    package_version = $variant['package_version']
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = & {
                        if ($variant -in @( '3.3', '3.4', '3.5' ) ) {
                            'linux/amd64'
                        }else {
                            'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                        }
                    }
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. '3.8-curl'
                tag = @(
                        "v$( $variant['package_version'] )" -replace '-r\d+', ''    # E.g. Strip out the '-r' in '2.3.0.0-r1'
                        # $variant['distro']
                        # $variant['distro_version']
                        $subVariant['components'] | ? { $_ }
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
