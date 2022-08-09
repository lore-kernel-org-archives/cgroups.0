From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 9 Aug 2022 16:15:24 -0400
Message-ID: <7bd2c5c9-edb4-c071-0d24-28c6744f826b@redhat.com>
References: <20220801154124.2011987-1-longman@redhat.com>
 <20220801154124.2011987-3-longman@redhat.com>
 <YvK7qVkmzbA12Eut@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660076129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzTWuyHwis4b2KJ9R8kWXsQlD0tgnuiVwQ48okOh2B0=;
        b=Hxb1IcnzyZnq84YVJcfM0JN++ux6BjP5iwTngr6bHHOxUWwNnQA7OutyHxGHvgt6PvoJi8
        SsgJ8Nt92jDLeAUk0DSxajQ6AYd3IofoARoDoH4Tu7N327vfuocyX0RhIFDc/71RAsjmCh
        E8CM5yiogkwbDoV5wAqE9Iu2Kq0PsyU=
Content-Language: en-US
In-Reply-To: <YvK7qVkmzbA12Eut-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/9/22 15:55, Tejun Heo wrote:
> (cc'ing Linus)
>
> Hello,
>
> On Mon, Aug 01, 2022 at 11:41:24AM -0400, Waiman Long wrote:
>> It was found that any change to the current cpuset hierarchy may reset
>> the cpumask of the tasks in the affected cpusets to the default cpuset
>> value even if those tasks have cpus affinity explicitly set by the users
>> before. That is especially easy to trigger under a cgroup v2 environment
>> where writing "+cpuset" to the root cgroup's cgroup.subtree_control
>> file will reset the cpus affinity of all the processes in the system.
>>
>> That is problematic in a nohz_full environment where the tasks running
>> in the nohz_full CPUs usually have their cpus affinity explicitly set
>> and will behave incorrectly if cpus affinity changes.
>>
>> Fix this problem by looking at user_cpus_ptr which will be set if
>> cpus affinity have been explicitly set before and use it to restrcit
>> the given cpumask unless there is no overlap. In that case, it will
>> fallback to the given one.
>>
>> With that change in place, it was verified that tasks that have its
>> cpus affinity explicitly set will not be affected by changes made to
>> the v2 cgroup.subtree_control files.
> The fact that the kernel clobbers user-specified cpus_allowed as cpu
> availability changes always bothered me and it has been causing this sort of
> problems w/ cpu hotplug and cpuset. We've been patching this up partially
> here and there but I think it would be better if we just make the rules
> really simple - ie. allow users to configure whatever cpus_allowed as long
> as that's within cpu_possible_mask and override only the effective
> cpus_allowed if the mask leaves no runnable CPUs, so that we can restore the
> original configured behavior if and when some of the cpus become available
> again.
>
> One obvious problem with changing the behavior is that it may affect /
> confuse users expecting the current behavior however inconsistent it may be,
> but given that we have partially changed how cpus_allowed interacts with
> hotplug in the past and the current behavior can be inconsistent and
> surprising, I don't think this is a bridge we can't cross. What do others
> think?

My patch will still subject the cpus_allowed list to the constraint 
imposed by the current cpuset. It will keep as much of what the user 
specified though. If we are worrying about backward compatibility, maybe 
we can restrict that change in behavior to cgroup v2 only or we can add 
a sysctl parameter to restore old behavior if the user choose to.

Users are now gradually migrating over to cgroup v2 and they do 
understand that there are some changes in behavior when using cgroup v2.

Cheers,
Longman

