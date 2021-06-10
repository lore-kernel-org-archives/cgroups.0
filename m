From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Add new cpus.partition type with no
 load balancing
Date: Thu, 10 Jun 2021 20:50:52 +0200
Message-ID: <YMJfDHr1+xxm6SBi@hirez.programming.kicks-ass.net>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q5QvTqrG2xVL3YDck5+IL8BU+tiEEtCfhbIy/ABm4q4=; b=CU4PzQCpc4kXcm5s/Gn6dBy1bI
        V+bvyjbmJQGo1ViZ8M3QSJME2yJXvw18DkMN+PtxeOXj+8+8NryifDEg/1SbgFUDgIIQONtiohFJm
        VczSDtj8wDlrpDsvkX807Py7w3g9QrQJ6Let0xe8y/sGb9k5vj/gtk/+8jRhPjsVvDg9UrJTeHjJo
        k6w3VKJzl57npRQq7X3vWd935MbBTgXVSAqvWxZeF0o6G+QDvkIu0EutYlEZTsUeV3fau/0QiRj25
        zngxTnlIHcTVkM1c25vJcE00sNpDB8t73WJyUxKztTGqU1f/pmgEjjcDqbzb2PadC/+R4VgNC0kkZ
        dSSrqCaw==;
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
> 
> To address this issue for cpuset v2, a new cpuset.cpus.partition type
> "root-nolb" is added which allows the creation of a cpuset partition with
> no load balancing. This will allow system administrators to dynamically
> adjust the size of the no load balancing partition to the current need
> of the workload without rebooting the system.

I'm confused, why do you need this? Just create a parition for each cpu.
