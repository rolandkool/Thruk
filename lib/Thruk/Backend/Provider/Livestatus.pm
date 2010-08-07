package Thruk::Backend::Provider::Livestatus;

use strict;
use warnings;
use Carp;
use Data::Dumper;
use Monitoring::Livestatus::Class;
use parent 'Thruk::Backend::Provider::Base';

=head1 NAME

Thruk::Backend::Provider::Livestatus - connection provider for livestatus connections

=head1 DESCRIPTION

connection provider for livestatus connections

=head1 METHODS

=cut
##########################################################

=head2 new

create new manager

=cut
sub new {
    my( $class, $config ) = @_;
    my $self = {
        'live' => Monitoring::Livestatus::Class->new($config),
    };
    bless $self, $class;

    return $self;
}

##########################################################

=head2 peer_key

return the peers key

=cut
sub peer_key {
    my $self = shift;
    return $self->{'live'}->{'backend_obj'}->peer_key();
}


##########################################################

=head2 peer_addr

return the peers address

=cut
sub peer_addr {
    my $self = shift;
    return $self->{'live'}->{'backend_obj'}->peer_addr();
}

##########################################################

=head2 get_processinfo

return the process info

=cut
sub get_processinfo {
    my $self = shift;
    #my $processinfo = $self->{'live'}->{'backend_obj'}->selectall_hashref("GET status\n".Thruk::Utils::Auth::get_auth_filter($c, 'status')."\nColumns: livestatus_version program_version accept_passive_host_checks accept_passive_service_checks check_external_commands check_host_freshness check_service_freshness enable_event_handlers enable_flap_detection enable_notifications execute_host_checks execute_service_checks last_command_check last_log_rotation nagios_pid obsess_over_hosts obsess_over_services process_performance_data program_start interval_length", 'peer_key', { AddPeer => 1});
    my $processinfo = $self->{'live'}->{'backend_obj'}->selectall_hashref("GET status\nColumns: livestatus_version program_version accept_passive_host_checks accept_passive_service_checks check_external_commands check_host_freshness check_service_freshness enable_event_handlers enable_flap_detection enable_notifications execute_host_checks execute_service_checks last_command_check last_log_rotation nagios_pid obsess_over_hosts obsess_over_services process_performance_data program_start interval_length", 'peer_key', { AddPeer => 1});
    return $processinfo;
}

##########################################################

=head2 get_can_submit_commands

returns if this user is allowed to submit commands

=cut
sub get_can_submit_commands {
    my $self = shift;
    my $user = shift;
    
    #my $contacts = $self->{'live'}->table('contacts');
    #my $data = $contacts->columns(qw/can_submit_commands alias/)->filter({ name => { '='  => $user } })->hashref_array();
    #my $data = $self->{'live'}->table('contacts')->columns(qw/can_submit_commands alias/)->filter({ name => { '='  => $user } })->hashref_array();
    #my $data = $self->{'live'}->table('contacts')->columns(qw/can_submit_commands alias/)->filter({ name => { '='  => $user } })->hashref_array();
    my $hosts = $self->{'live'}->table('contacts');
    my $data  = $hosts->columns('can_submit_commands')->filter({ name => { '-or' => [$user] } })->hashref_array();
print STDERR Dumper $data;
    return;

    #return $self->{'live'}->{'backend_obj'}->selectall_arrayref("GET contacts\nColumns: can_submit_commands alias\nFilter: name = $user", { Slice => 1 });
}

=head1 AUTHOR

Sven Nierlein, 2010, <nierlein@cpan.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
