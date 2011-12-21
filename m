From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3] memcg: return -EINTR at bypassing try_charge().
Date: Wed, 21 Dec 2011 13:28:15 +0100
Message-ID: <20111221122815.GF3870@cmpxchg.org>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
 <20111221172423.5d036cdd.kamezawa.hiroyu@jp.fujitsu.com>
 <20111221192934.2751f8f1.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111221192934.2751f8f1.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Dec 21, 2011 at 07:29:34PM +0900, KAMEZAWA Hiroyuki wrote:
> Thank you for review.
> I'm sorry if my response is delayed.
> ==
> >From 1e8c917c64b3947d2e54c6e5073d53d80bd97c30 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Date: Wed, 21 Dec 2011 16:27:25 +0900
> Subject: [PATCH] memcg: return -EINTR at bypassing try_charge().
> 
> This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patch
> When running testprogram and stop it by Ctrl-C, add_lru/del_lru
> will find pc->mem_cgroup is NULL and get panic. The reason
> is bypass code in try_charge().
> 
> At try_charge(), it checks the thread is fatal or not as..
> fatal_signal_pending() or TIF_MEMDIE. In this case, __try_charge()
> returns 0(success) with setting *ptr as NULL.
> 
> Now, lruvec are deteremined by pc->mem_cgroup. So, it's better
> to reset pc->mem_cgroup as root_mem_cgroup. This patch does
> following change in try_charge()
>   1. return -EINTR at bypassing.
>   2. set *ptr = root_mem_cgroup at bypassing.
> 
> By this change, in page fault / radix-tree-insert path,
> the page will be charged against root_mem_cgroup and the thread's
> operations will go ahead without trouble. In other path,
> migration or move_account etc..., -EINTR will stop the operation.
> (may need some cleanup later..)
> 
> After this change, pc->mem_cgroup will have valid pointer if
> the page is used.
> 
> Changelog: v2 -> v3
>  - handle !mm case in another way.
>  - removed redundant commments
>  - fixed move_parent bug of uninitialized pointer
> Changelog: v1 -> v2
>  - returns -EINTR at bypassing.
>  - change error code handling at callers.
>  - changed the name of patch.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Looks good now, thanks.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
