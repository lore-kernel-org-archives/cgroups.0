From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Sat, 11 Apr 2015 10:35:37 +0200
Message-ID: <20150411083537.GR27490@worktop.programming.kicks-ass.net>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150410141118.11284.36206.stgit-KrPcdFQQmm2yUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
> The cpus_allowed and mems_allowed masks of a cpuset get overwritten
> after each hotplug operation on the legacy hierarchy of cgroups so as to
> remain in sync with the online mask. But there are use cases which
> expect user configured masks to remain unchanged.
> 
> For instance, when hotplugged out CPUs are brought back online, they
> remain idle with none of the existing tasks allowed to run on them since
> the cpus_allowed mask was overwritten to not include them when they were
> offlined.
> 
> We cannot change the legacy hierarchy design now to keep the allowed
> masks hotplug invariant since it is a user visible change. It was
> suggested instead to add a knob in the root cpuset directory which
> allows the user to specify if he wants the user configured masks to be
> hotplug invariant [1]. This knob will enforce the choice throughout the
> hierarchy. If the knob is set, the allowed maks will not be varied on
> hotplug. It is also to to be noted that this knob will appear in the
> root cgroup mounted on the legacy hierarchy alone since the default
> hierarchy does not overwrite the allowed masks anyway.
> 
> Having said this, there are fair reasons to argue that the kernel is not
> responsible for taking care of user configurations in the face of
> hotplug. But one of the consequences of the current legacy hierarchy
> design, is that CPUs are left out from being used at all on online
> operations. The reason for this is not very obvious at first and several
> users have raised the issue as a bug. Hence the patch was strongly
> called for.
> 
> Moreover the default hierarchy keeps the allowed masks hotplug invariant
> too. So the patch is not bringing about a fundamental change in the
> design of cgroups.

What you've not explained is why you can use this knob but not use the
other new mode?
