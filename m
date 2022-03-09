From: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH linux-next] cgroup: fix suspicious
 rcu_dereference_check() usage warning
Date: Wed, 9 Mar 2022 08:10:26 +0100
Message-ID: <1be951c7-442f-eb45-a4fc-41fdb771eef7@samsung.com>
References: <20220305034103.57123-1-zhouchengming@bytedance.com>
        <CGME20220309071027eucas1p1f066b42f49e524404d898929b60b344f@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220309071028euoutp01bcb322db18626cb9b6f3ed8dd985d28a~apNBUJ4ER3177831778euoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646809828;
        bh=TjJEXRfVW4361xBOm+SseNKtnQiXRSWqUUa3WAQ1Cj8=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=hV4/QhmnUfl4CmIIXt2Ah4Oh1n2aOFiC9nETBVRPgE7NjZcH5ZBSYGE5EA8cv1K/V
         Qb1FUKRdi05wvtvPGH7Cpemxuo9VuxFdc6lgAN6rZ/jAhCcTlpjEzPHZUMeDKnh4El
         ncxX/CCzIkdzCTnx0niXPI0tDCKCAaSGARapk4lo=
Content-Language: en-US
In-Reply-To: <20220305034103.57123-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Linux Kernel Functional Testing <lkft-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, syzbot+16e3f2c77e7c5a0113f9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 05.03.2022 04:41, Chengming Zhou wrote:
> task_css_set_check() will use rcu_dereference_check() to check for
> rcu_read_lock_held() on the read-side, which is not true after commit
> dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
> commit drop explicit rcu_read_lock(), change to RCU-sched read-side
> critical section. So fix the RCU warning by adding check for
> rcu_read_lock_sched_held().
>
> Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
> Reported-by: Linux Kernel Functional Testing <lkft-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Reported-by: syzbot+16e3f2c77e7c5a0113f9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> Tested-by: Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Right, this fixes the issue I've reported here:

https://lore.kernel.org/all/f4bc652b-115f-35b5-91db-bad3b30fed9b-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org/

Tested-by: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

> ---
>   include/linux/cgroup.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1e356c222756..0d1ada8968d7 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -450,6 +450,7 @@ extern struct mutex cgroup_mutex;
>   extern spinlock_t css_set_lock;
>   #define task_css_set_check(task, __c)					\
>   	rcu_dereference_check((task)->cgroups,				\
> +		rcu_read_lock_sched_held() ||				\
>   		lockdep_is_held(&cgroup_mutex) ||			\
>   		lockdep_is_held(&css_set_lock) ||			\
>   		((task)->flags & PF_EXITING) || (__c))

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

