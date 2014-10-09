From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Thu, 9 Oct 2014 10:32:59 +0200
Message-ID: <20141009083259.GQ10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54364564.3090305-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> >> SMT 8 on Power8 can help/hinder workloads. Hence we dynamically switch
> >> the modes at runtime.
> > 
> > That's just a horrible piece of crap hack and you deserve any and all
> > pain you get from doing it.
> > 
> > Randomly removing/adding cpus like that is horrible and makes a mockery
> > of all the affinity interfaces we have.
> 
> We observed this on ubuntu kernel, in which systemd explicitly mounts
> cgroup controllers under a child cgroup identified by the user pid.
> Since we had not observed this additional cgroup being added under the
> hood, it came as a surprise to us that cgroup/cpuset handling in the
> kernel should indeed kick in.
> 
> At best we expect hotplug to be handled well if the users have not
> explicitly configured cpusets, hence implicitly specifying that task
> affinity is for all online cpus. This is indeed the case today, so that
> is good.
> 
> However what remains to be answered is that the V2 of cgroup design -
> the default hierarchy, tracks hotplug operations for children cgroups as
> well. Tejun, Li, will not the concerns that Peter raised above hold for
> the default hierarchy as well?

None of this addresses the piece of crap thing you did with power8. You
cannot just make CPUs go away at random.
