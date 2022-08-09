From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 9 Aug 2022 09:55:21 -1000
Message-ID: <YvK7qVkmzbA12Eut@slm.duckdns.org>
References: <20220801154124.2011987-1-longman@redhat.com>
 <20220801154124.2011987-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=9MuUym0qseMztmmB08QIe6J0PxQHYo7/9v1WA9Ef9Bg=;
        b=oC3ymHBJylR7XqQ1/YsoJWKU1vaS4NJ9iVSdgfEdCt9FgymssN/Wxfz4zV0wTqb8ox
         mHrHVPgBvk1V5bINjpZmmSZ2YVsLiVWbMc0QHAlLbxmlYteVr0eseqlyDpS3+otxKogh
         8n/4AHVa6kc0D7E4Nj6mrsGdmf7c/OQjhIbyhwrB9YafOwrvn6lCkvFCwEL8hV8uLSwx
         CYCfs9tOBHKWRpPEnz9suBU2fGtc5Jv3JLCCnD4ANllmc1h1yVvAZQMGRSRKbV9MiSKL
         SBzlVoS1vtOQUaMUVkuMOTZw/vBbRy4Qj8otjY2kg7ehzaT9sqR+sB2yizTxBQEx4EV1
         /GyA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220801154124.2011987-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(cc'ing Linus)

Hello,

On Mon, Aug 01, 2022 at 11:41:24AM -0400, Waiman Long wrote:
> It was found that any change to the current cpuset hierarchy may reset
> the cpumask of the tasks in the affected cpusets to the default cpuset
> value even if those tasks have cpus affinity explicitly set by the users
> before. That is especially easy to trigger under a cgroup v2 environment
> where writing "+cpuset" to the root cgroup's cgroup.subtree_control
> file will reset the cpus affinity of all the processes in the system.
> 
> That is problematic in a nohz_full environment where the tasks running
> in the nohz_full CPUs usually have their cpus affinity explicitly set
> and will behave incorrectly if cpus affinity changes.
> 
> Fix this problem by looking at user_cpus_ptr which will be set if
> cpus affinity have been explicitly set before and use it to restrcit
> the given cpumask unless there is no overlap. In that case, it will
> fallback to the given one.
> 
> With that change in place, it was verified that tasks that have its
> cpus affinity explicitly set will not be affected by changes made to
> the v2 cgroup.subtree_control files.

The fact that the kernel clobbers user-specified cpus_allowed as cpu
availability changes always bothered me and it has been causing this sort of
problems w/ cpu hotplug and cpuset. We've been patching this up partially
here and there but I think it would be better if we just make the rules
really simple - ie. allow users to configure whatever cpus_allowed as long
as that's within cpu_possible_mask and override only the effective
cpus_allowed if the mask leaves no runnable CPUs, so that we can restore the
original configured behavior if and when some of the cpus become available
again.

One obvious problem with changing the behavior is that it may affect /
confuse users expecting the current behavior however inconsistent it may be,
but given that we have partially changed how cpus_allowed interacts with
hotplug in the past and the current behavior can be inconsistent and
surprising, I don't think this is a bridge we can't cross. What do others
think?

Thanks.

-- 
tejun
