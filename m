From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Relax restrictions on kernel threads moving out
 of root cpu cgroup
Date: Tue, 6 Apr 2021 09:36:00 -0400
Message-ID: <YGxjwKbec68sCcqo@slm.duckdns.org>
References: <1617714261-18111-1-git-send-email-pkondeti@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YXOWvNOAIfgi9gqBy5DvwnTrsEdHbB64uWkA3abilWU=;
        b=QLQkqzAeiYAjql/CBYeCXbnB9686oKnalJzTqApxbMhRQqeBZWrm69SrvTPBvXPGUz
         HnNDlwIuv8W4dZFeKPUTn/pS2aKrnF1F1vSjWvV3u4ttyPszRWoHhUmDbFxyKOEgAeoe
         FX1/ANr4FBT/9uIdb9Ge3vgwEu78kw4ErBowRW9guepBIvhhW+HZoI/yTUB5W4psNpJE
         QxRTWAyFVIHksYuoc/hP8xDpVTjs4qVrdgwQ6XCU/rx1JX6avFSVsN+HcMnLA5CMXzf/
         686ZRKvFNnk3jwGtO6UHZnqLYjYJmAJgQIZDYh0fNGuhbuWggvzXgfQnjOvZO1RtJFAT
         vUDg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1617714261-18111-1-git-send-email-pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavankumar Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Apr 06, 2021 at 06:34:21PM +0530, Pavankumar Kondeti wrote:
> In Android GKI, CONFIG_FAIR_GROUP_SCHED is enabled [1] to help prioritize
> important work. Given that CPU shares of root cgroup can't be changed,
> leaving the tasks inside root cgroup will give them higher share
> compared to the other tasks inside important cgroups. This is mitigated
> by moving all tasks inside root cgroup to a different cgroup after
> Android is booted. However, there are many kernel tasks stuck in the
> root cgroup after the boot.
> 
> We see all kworker threads are in the root cpu cgroup. This is because,
> tasks with PF_NO_SETAFFINITY flag set are forbidden from cgroup migration.
> This restriction is in place to avoid kworkers getting moved to a cpuset
> which conflicts with kworker affinity. Relax this restriction by explicitly
> checking if the task is moving out of a cpuset cgroup. This allows kworkers
> to be moved out root cpu cgroup when cpu and cpuset cgroup controllers
> are mounted on different hierarchies.
> 
> We also see kthreadd_task and any kernel thread created after the Android boot
> also stuck in the root cgroup. The current code prevents kthreadd_task moving
> out root cgroup to avoid the possibility of creating new RT kernel threads
> inside a cgroup with no RT runtime allocated. Apply this restriction when tasks
> are moving out of cpu cgroup under CONFIG_RT_GROUP_SCHED. This allows all
> kernel threads to be moved out of root cpu cgroup if the kernel does not
> enable RT group scheduling.

The fundamental reason why those kthreads are in the root cgroup is because
they're doing work on behalf of the entire system and their resource usages
can't be attributed to any specific cgroup. What we want to do is accounting
actual usages to the originating cgroups so that cpu cycles spent by kswapd
is charged to the originating cgroups, however well we can define them, and
then throttle the origin if the consumption is going over budget for that
cgroup's allocation. This is how we already handle shared IOs.

The problem with the proposed patch is that it breaks the logical
organization of resource hierarchy in a way which hinders proper future
solutions.

If all you want is deprioritizing certain kworkers, please use workqueue
attrs instead.

Thanks.

-- 
tejun
