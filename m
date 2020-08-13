From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm: Drop locked from isolate_migratepages_block
Date: Thu, 13 Aug 2020 15:44:51 +0800
Message-ID: <4403f572-03c3-3061-6fc4-f56e3b6d7b67@linux.alibaba.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040224.13054.96724.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200813040224.13054.96724.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org



在 2020/8/13 下午12:02, Alexander Duyck 写道:
> -		rcu_read_lock();
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> -
>  		/* If we already hold the lock, we can skip some rechecking */
> -		if (lruvec != locked) {
> -			if (locked)
> -				unlock_page_lruvec_irqrestore(locked, flags);
> +		if (!lruvec || !lruvec_holds_page_lru_lock(page, lruvec)) {

Ops, lruvec_holds_page_lru_lock need rcu_read_lock. 

> +			if (lruvec)
> +				unlock_page_lruvec_irqrestore(lruvec, flags);
>  
> +			lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
> -			locked = lruvec;
>  			rcu_read_unlock();
>  

and some bugs:
[  534.564741] CPU: 23 PID: 545 Comm: kcompactd1 Kdump: loaded Tainted: G S      W         5.8.0-next-20200803-00028-g9a7ff2cd6e5c #85
[  534.577320] Hardware name: Alibaba Alibaba Cloud ECS/Alibaba Cloud ECS, BIOS 1.0.PL.IP.P.027.02 05/29/2020
[  534.587693] Call Trace:
[  534.590522]  dump_stack+0x96/0xd0
[  534.594231]  ___might_sleep.cold.90+0xff/0x115
[  534.599102]  kcompactd+0x24b/0x370
[  534.602904]  ? finish_wait+0x80/0x80
[  534.606897]  ? kcompactd_do_work+0x3d0/0x3d0
[  534.611566]  kthread+0x14e/0x170
[  534.615182]  ? kthread_park+0x80/0x80
[  534.619252]  ret_from_fork+0x1f/0x30
[  535.629483] BUG: sleeping function called from invalid context at include/linux/freezer.h:57
[  535.638691] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 545, name: kcompactd1
[  535.647601] INFO: lockdep is turned off.
