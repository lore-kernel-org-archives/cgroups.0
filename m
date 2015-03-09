From: riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v4 RESEND 0/4] cpusets,isolcpus: exclude isolcpus from load balancing in cpusets
Date: Mon,  9 Mar 2015 12:12:06 -0400
Message-ID: <1425917530-1771-1-git-send-email-riel@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Ensure that cpus specified with the isolcpus= boot commandline
option stay outside of the load balancing in the kernel scheduler.

Operations like load balancing can introduce unwanted latencies,
which is exactly what the isolcpus= commandline is there to prevent.

Previously, simply creating a new cpuset, without even touching the
cpuset.cpus field inside the new cpuset, would undo the effects of
isolcpus=, by creating a scheduler domain spanning the whole system,
and setting up load balancing inside that domain. The cpuset root
cpuset.cpus file is read-only, so there was not even a way to undo
that effect.

This does not impact the majority of cpusets users, since isolcpus=
is a fairly specialized feature used for realtime purposes.

This version fixes the UP compilation issue, in the same way done
for the other cpumasks.
