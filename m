From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug invariant
 on legacy hierarchy
Date: Mon, 13 Apr 2015 17:46:37 +0530
Message-ID: <552BB3A5.9060905@linux.vnet.ibm.com>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com> <20150411083537.GR27490@worktop.programming.kicks-ass.net> <20150413070117.GX24151@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413070117.GX24151-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On 04/13/2015 12:31 PM, Peter Zijlstra wrote:
> On Sat, Apr 11, 2015 at 10:35:37AM +0200, Peter Zijlstra wrote:
>> On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
>>> The cpus_allowed and mems_allowed masks of a cpuset get overwritten
>>> after each hotplug operation on the legacy hierarchy of cgroups so as to
>>> remain in sync with the online mask. But there are use cases which
>>> expect user configured masks to remain unchanged.
>>>
>>> For instance, when hotplugged out CPUs are brought back online, they
>>> remain idle with none of the existing tasks allowed to run on them since
>>> the cpus_allowed mask was overwritten to not include them when they were
>>> offlined.
>>>
>>> We cannot change the legacy hierarchy design now to keep the allowed
>>> masks hotplug invariant since it is a user visible change. It was
>>> suggested instead to add a knob in the root cpuset directory which
>>> allows the user to specify if he wants the user configured masks to be
>>> hotplug invariant [1]. This knob will enforce the choice throughout the
>>> hierarchy. If the knob is set, the allowed maks will not be varied on
>>> hotplug. It is also to to be noted that this knob will appear in the
>>> root cgroup mounted on the legacy hierarchy alone since the default
>>> hierarchy does not overwrite the allowed masks anyway.
>>>
>>> Having said this, there are fair reasons to argue that the kernel is not
>>> responsible for taking care of user configurations in the face of
>>> hotplug. But one of the consequences of the current legacy hierarchy
>>> design, is that CPUs are left out from being used at all on online
>>> operations. The reason for this is not very obvious at first and several
>>> users have raised the issue as a bug. Hence the patch was strongly
>>> called for.
>>>
>>> Moreover the default hierarchy keeps the allowed masks hotplug invariant
>>> too. So the patch is not bringing about a fundamental change in the
>>> design of cgroups.
>>
>> What you've not explained is why you can use this knob but not use the
>> other new mode?
> 
> Urgh, it looks like the new mode is only available through the default
> hierarchy (whatever that is).
> 
> Would it not make sense to make that a mount option and limit the amount
> of semantic variants of cpusets?
> 

I spent some time analyzing if this would be a better option than the
sysfs knob and I think not for the following reasons:

1. Mount options tend to be generic across the controllers of a cgroup.
But use case addressed by this patch is specific to the cpuset controller.

2. The behavior that this patch is trying to bring about is not a
drastic one to call for a mount option equivalent to the __SANE_BEHAVIOR
one that existed earlier. This option was used to switch the legacy
design to the default one.

However this patch is not *wholly* mimicking the default hierarchy
behavior. The behavior when cpusets become empty is left untouched for
instance. The patch borrows one of the behaviors from the default
hierarchy only and hence just not justify the use of a mount flag.

3. cpuset controller already has flags that allow a runtime change in
the semantics of scheduling, memory allocation.
Eg: CS_SCHED_LOAD_BALANCE, CS_SPREAD_PAGE. This page intends to bring
about a runtime change in the semantics of maintaining the allowed cpus
and mem masks in the face of hotplug. So adding a flag to take care of
this looks better and the design falls in place.

4. The worry was around possible race conditions when the user tries to
change this sysfs knob during runtime after mounting a cgroup hierarchy.
But the sites are protected by the cpuset_lock. Moreover all of the
cpuset behavior enforced by its flags can be changed after mounting the
cgroup. So cpuset controller already expects twiddling of these knobs at
will by the user.

So it doesn't look like a good option to change the sysfs knob in this
patch to a mount flag.

Regards
Preeti U Murthy
