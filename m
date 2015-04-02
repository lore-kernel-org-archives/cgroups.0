From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Thu, 02 Apr 2015 12:26:32 +0530
Message-ID: <551CE820.9090900@linux.vnet.ibm.com>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com> <20141008080706.GC10832@worktop.programming.kicks-ass.net> <543505EF.7070804@linux.vnet.ibm.com> <20141008101828.GG10832@worktop.programming.kicks-ass.net> <54364564.3090305@linux.vnet.ibm.com> <20141009130611.GA14387@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141009130611.GA14387-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

Hi Tejun, Peter,

On 10/09/2014 06:36 PM, Tejun Heo wrote:
> On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
>> However what remains to be answered is that the V2 of cgroup design -
>> the default hierarchy, tracks hotplug operations for children cgroups as
>> well. Tejun, Li, will not the concerns that Peter raised above hold for
>> the default hierarchy as well?
> 
> I don't think the legacy one is a good design.  Kernel shouldn't lose
> configurations in an irreversible way and the legacy one is also
> making random cpuset flips by migrating tasks upwards anyway.  In
> terms of hotunplug behavior, the legacy and unified ones behave the
> same.  The only difference is that the configuration is independent of
> the current state and the configured behavior is restored when the
> cpus come back.  The other side is that the legacy hierarchy behavior
> simply can't be allowed when the hierarchy is shared among multiple
> controllers as in the unified hierarchy.  It affects all other
> controllers attached to the hierarchy.

We have a use case currently, which needs this to be fixed one way or
the other. While running in a virtualized setup, there may be a need to
hotplug in resources to VMs at runtime. This includes CPUs and Memory.
Due to the behavior of the legacy hierarchy, the new CPUs never get
used. This is not even a scenario where we hot-unplugged CPUs and ask
for it to be plugged back again. Its a case where the workloads running
within a VM are in need of more resources than they began with.

> 
> That said, we can't change the behavior on the legacy one.  It's a
> very userland visible behavior.  We simply can't change it, so

By ensuring that the user configured cpusets are untouched, I don't see
how we affect userspace adversely. The expectation usually is that the
kernel keeps track of the user configurations. If anything we would be
fixing an undesired behavior, wouldn't we?

> unfortunately you're stuck with it at least on the legacy hierarchy.

Given that we are in much need for this to be fixed and that we cannot
easily move to the default hierarchy, can you please take a look at this
patch again?

It is understandable that there are good reasons why legacy hierarchy
currently behaves this way or how we cannot drastically change its
behavior, but there is no sane way in which userspace can get around
this for the sake of genuine use cases such as the above.

Regards
Preeti U Murthy
> 
> Thanks.
> 
