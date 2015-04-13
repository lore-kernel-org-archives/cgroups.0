From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Mon, 13 Apr 2015 16:43:11 +0200
Message-ID: <20150413144311.GF5029@twins.programming.kicks-ass.net>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552BB3A5.9060905-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On Mon, Apr 13, 2015 at 05:46:37PM +0530, Preeti U Murthy wrote:
> On 04/13/2015 12:31 PM, Peter Zijlstra wrote:

> > Would it not make sense to make that a mount option and limit the amount
> > of semantic variants of cpusets?
> 
> I spent some time analyzing if this would be a better option than the
> sysfs knob and I think not for the following reasons:
> 
> 1. Mount options tend to be generic across the controllers of a cgroup.
> But use case addressed by this patch is specific to the cpuset controller.

Surely we can get around that somehow.

> 2. The behavior that this patch is trying to bring about is not a
> drastic one to call for a mount option equivalent to the __SANE_BEHAVIOR
> one that existed earlier. This option was used to switch the legacy
> design to the default one.
> 
> However this patch is not *wholly* mimicking the default hierarchy
> behavior. The behavior when cpusets become empty is left untouched for
> instance. The patch borrows one of the behaviors from the default
> hierarchy only and hence just not justify the use of a mount flag.

So the 'problem' I have is that you introduce a 3rd semantic for the
cpuset thing.

You also do not answer if you can live with the default hierarchy
behaviour, only that your patch mimicks a subset of it.

Why not all of it?

> 3. cpuset controller already has flags that allow a runtime change in
> the semantics of scheduling, memory allocation.
> Eg: CS_SCHED_LOAD_BALANCE, CS_SPREAD_PAGE. This page intends to bring
> about a runtime change in the semantics of maintaining the allowed cpus
> and mem masks in the face of hotplug. So adding a flag to take care of
> this looks better and the design falls in place.

s/page/patch/

I disagree, you change global semantics, the ONLY_ON_ROOT is a hint
here. If such a file really is the only option, then at least take the
entire semantics from default hierarchy, not only part of it.

> 4. The worry was around possible race conditions when the user tries to
> change this sysfs knob during runtime after mounting a cgroup hierarchy.
> But the sites are protected by the cpuset_lock. Moreover all of the
> cpuset behavior enforced by its flags can be changed after mounting the
> cgroup. So cpuset controller already expects twiddling of these knobs at
> will by the user.

That just doesn't parse. cpuset_lock doesn't protect anything userspace.

You cannot atomically read this flag and do something else. It being
ONLY_ON_ROOT might mean you don't even have access to the flag.
