From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Wed, 8 Oct 2014 10:07:06 +0200
Message-ID: <20141008080706.GC10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141008070739.1170.33313.stgit-KrPcdFQQmm2yUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Oct 08, 2014 at 12:37:40PM +0530, Preeti U Murthy wrote:
> There are two masks associated with cpusets. The cpus/mems_allowed
> and effective_cpus/mems. On the legacy hierarchy both these masks
> are consistent with each other. This is the intersection of their
> value and the currently active cpus. This means that we destroy the
> original values set in these masks on each cpu/mem hot unplug operation.
> 	As a consequence when we hot plug back the cpus/mems, the tasks
> no longer run on them and performance degrades, inspite of having
> resources to run on.
> 
> This effect is not seen in the default hierarchy since the
> allowed and effective masks are distinctly maintained.
> allowed masks are never touched once configured and effective masks
> alone are hotplug variant.
> 
> This patch replicates the above design even for the legacy hierarchy,
> so that:
> 
> 1. Tasks always run on the cpus/memory nodes that they are allowed to run on
> as long as they are online. The allowed masks are hotplug invariant.
> 
> 2. When all cpus/memory nodes in a cpuset are hot unplugged out, the tasks
> are moved to their nearest ancestor which has resources to run on.
> 
> There were discussions earlier around this issue:
> https://lkml.org/lkml/2012/5/4/265
> http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133
> 
> The argument against making the allowed masks hotplug invariant was that
> hotplug is destructive and hence cpusets cannot expect to regain resources
> that have gone through a hotplug operation by the user.
> 
> But on powerpc we do smt mode switch to suit the workload running.
> We therefore need to keep track of the original cpuset configuration
> so as to make use of them when they are back online due to a mode switch.
> Moreover there is no real harm in keeping the allowed masks invariant
> on hotplug since the effective masks will anyway keep track of the
> online cpus. In fact there are use cases which need the cpuset's
> original configuration to be retained. The v2 of cgroup design therefore
> does not overwrite this configuration.
> 

I still completely hate all that.. It basically makes cpusets useless,
they no longer guarantee anything, it makes then an optional placement
hint instead.

You also break long standing behaviour.

Also, power is insane if it needs/uses hotplug for operational crap
like that.
