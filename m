From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Thu, 9 Oct 2014 15:47:58 +0200
Message-ID: <20141009134758.GU10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
 <20141009130611.GA14387@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141009130611.GA14387-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 09, 2014 at 09:06:11AM -0400, Tejun Heo wrote:
> On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> > However what remains to be answered is that the V2 of cgroup design -
> > the default hierarchy, tracks hotplug operations for children cgroups as
> > well. Tejun, Li, will not the concerns that Peter raised above hold for
> > the default hierarchy as well?
> 
> I don't think the legacy one is a good design.  Kernel shouldn't lose
> configurations in an irreversible way and the legacy one is also
> making random cpuset flips by migrating tasks upwards anyway. 

You do know we disagree on this :-)

The thing is, if you restrict a process to one cpu and then take that
cpu away you have a fail, pretending its 'OK' because you'll place it
back once the cpu appears again doesn't make it right.

And while legacy will indeed move tasks upwards, it does so under
protest, its a clear error and the user needs to go figure out wtf to do
about it.

And while you all can try and pretend hotplug is a 'normal' and 'sane'
operation with cpusets, the same failure more very much still exists
with the regular affinity controls. So you can pretend all you want, but
its a clear and utter fail.

You cannot give the kernel contradictory instructions and then pretend
all is well and dandy.
