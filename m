From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Thu, 9 Apr 2015 16:13:49 -0500
Message-ID: <20150409211349.GA28729@mail.hallyn.com>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
 <20141009130611.GA14387@htj.dyndns.org>
 <551CE820.9090900@linux.vnet.ibm.com>
 <20150406174735.GG10582@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150406174735.GG10582-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

On Mon, Apr 06, 2015 at 01:47:35PM -0400, Tejun Heo wrote:
> Hello, Preeti.
> 
> On Thu, Apr 02, 2015 at 12:26:32PM +0530, Preeti U Murthy wrote:
> > By ensuring that the user configured cpusets are untouched, I don't see
> > how we affect userspace adversely. The expectation usually is that the
> > kernel keeps track of the user configurations. If anything we would be
> > fixing an undesired behavior, wouldn't we?
> 
> The problem is not really about which behavior is "righter" but rather
> it's fairly likely that there are users / tools out there expecting
> the current behavior and they wouldn't be too happy to see the
> behavior flipping underneath them.
> 
> One way forward would be implementing a knob in cpuset which makes it
> switch sbetween the old and new behaviors in the legacy hierarchy.
> It's yucky but doable if absoluately necessary, but what's the reason
> for you not being able to transition to the unified hierarchy (except

If the userspace is entirely new then this should work.  The
unified hierarchy's behavior is not backward-compatible so any old
software which tried to create cgroups (libcgroup, lxc, etc) will
not work with it (since it won't, for instance, know to fill in 
the enabled controllers in every newly created cgroup).

Preeti, can you confirm that you don't have any need to run any
legacy programs which use cgroups?  Long as that's the case, new
software can certainly be written to DTRT, and mounting just cpusets
under unified hierarchy seems best.

> for it being under the devel flag but I'm really taking that devel
> mask out in the next merge window)?  The default hierarchy can happily
> co-exist with legacy hierarchies so you can just move over the cpuset
> part to it if you need it.
> 
> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
