From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Tue, 31 Jan 2023 23:14:27 -0500
Message-ID: <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675224872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/eKFn64VzPTEGVhGDDJ4Rj8PWdwFHGYC51EzAnMCzcw=;
        b=brjveYrL/0ZZcQ4zTYRg6o3a1QMZR0DmPsf0iUU0M3BG0ochPV/FaNtOLw+Pf5yPfqUdRu
        nWIdaQ4a/rY8RNH/j60cyfBt3kHPTwbQ9DRTzPnjy9CFrWWXePqhAewt4/v4E6EoOmyEvD
        HKkvHd+NOV3/lfLmeTjnaMIyPdOt+Ws=
Content-Language: en-US
In-Reply-To: <20230131221719.3176-2-will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/31/23 17:17, Will Deacon wrote:
> From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>
> There is a difference in behaviour between CPUSET={y,n} that is now
> wrecking havoc with {relax,force}_compatible_cpus_allowed_ptr().
>
> Specifically, since commit 8f9ea86fdf99 ("sched: Always preserve the
> user requested cpumask")  relax_compatible_cpus_allowed_ptr() is
> calling __sched_setaffinity() unconditionally.
>
> But the underlying problem goes back a lot further, possibly to
> commit: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}") which
> switched cpuset_cpus_allowed() from cs->cpus_allowed to
> cs->effective_cpus.
>
> The problem is that for CPUSET=y cpuset_cpus_allowed() will filter out
> all offline CPUs. For tasks that are part of a (!root) cpuset this is
> then later fixed up by the cpuset hotplug notifiers that re-evaluate
> and re-apply cs->effective_cpus, but for (normal) tasks in the root
> cpuset this does not happen and they will forever after be excluded
> from CPUs onlined later.
>
> As such, rewrite cpuset_cpus_allowed() to return a wider mask,
> including the offline CPUs.
>
> Fixes: 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
> Reported-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Link: https://lkml.kernel.org/r/20230117160825.GA17756@willie-the-truck
> Signed-off-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Before cgroup v2, cpuset had only one cpumask - cpus_allowed. It only 
tracked online cpus and ignored the offline ones. It behaves more like 
effective_cpus in cpuset v2. With v2, we have 2 cpumasks - cpus_allowed 
and effective_cpus. When cpuset v1 is mounted, cpus_allowed and 
effective_cpus are effectively the same and track online cpus. With 
cpuset v2, cpus_allowed contains what the user has written into and it 
won't be changed until another write happen. However, what the user 
written may not be what the system can give it and effective_cpus is 
what the system decides a cpuset can use.

Cpuset v2 is able to handle hotplug correctly and update the task's 
cpumask accordingly. So missing previously offline cpus won't happen 
with v2.

Since v1 keeps the old behavior, previously offlined cpus are lost in 
the cpuset's cpus_allowed. However tasks in the root cpuset will still 
be fine with cpu hotplug as its cpus_allowed should track 
cpu_online_mask. IOW, only tasks in a non-root cpuset suffer this problem.

It was a known issue in v1 and I believe is one of the major reasons of 
the cpuset v2 redesign.

A major concern I have is the overhead of creating a poor man version of 
v2 cpus_allowed. This issue can be worked around even for cpuset v1 if 
it is mounted with the cpuset_v2_mode option to behave more like v2 in 
its cpumask handling. Alternatively we may be able to provide a config 
option to make this the default for v1 without the special mount option, 
if necessary.

Cheers,
Longman

