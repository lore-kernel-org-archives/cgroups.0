From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Add new cpus.partition type with no
 load balancing
Date: Thu, 10 Jun 2021 21:00:09 +0200
Message-ID: <YMJhObisfWJ1PzgR@hirez.programming.kicks-ass.net>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xTRjHtkMVfiEz4i7gVCu050JHA1BAAViAhxBjNTqnr0=; b=v0ermCJCsvrKcJozDIgJaQ9mAs
        QK/N1tf1IVJBqXRoU2Zjqfd+0nWnmqmjfB7N0ptRxKQd/2eFgSKzsRLMxX9DTKtCZydrecLkoxpLW
        5T7E7oDDx3F/yKl//Z2wdkyNvkSZXpc8J+xNo/jsDiDMyp49ayMBMqljhsnuO6Qdg+S9faxM3hg1x
        01xaJ91axH5I7Hi6Kylz6tgA2IxY/nZKF67bPkr6jN6Tvx9t718+/WOotzmIkTl9/zxWQf5MeKyXk
        RZCP/M4Xkx4p+UsrO0GCP+fqlm+fQN9Nhe5RlpXZCgaJQeW2k3WEICEjPExfpHYhZ9IFs0fDN7dwk
        uwoPK1uQ==;
Content-Disposition: inline
In-Reply-To: <20210603212416.25934-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Jun 03, 2021 at 05:24:13PM -0400, Waiman Long wrote:
> Cpuset v1 uses the sched_load_balance control file to determine if load
> balancing should be enabled.  Cpuset v2 gets rid of sched_load_balance
> as its use may require disabling load balancing at cgroup root.
> 
> For workloads that require very low latency like DPDK, the latency
> jitters caused by periodic load balancing may exceed the desired
> latency limit.
> 
> When cpuset v2 is in use, the only way to avoid this latency cost is to
> use the "isolcpus=" kernel boot option to isolate a set of CPUs. After
> the kernel boot, however, there is no way to add or remove CPUs from
> this isolated set. For workloads that are more dynamic in nature, that
> means users have to provision enough CPUs for the worst case situation
> resulting in excess idle CPUs.

Also, can we change isolcpus to create a default cgroup hierarchy
instead of being the fugly hack that it is? I really hate isolcpus with
a passion, it needs to die.
