From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for
 next
Date: Thu, 19 Jan 2012 15:58:39 +0900
Message-ID: <20120119155839.ad57620c.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1201182155480.7862-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 18 Jan 2012 22:05:12 -0800 (PST)
Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Commit c1e2ee2dc436 "memcg: replace ss->id_lock with a rwlock" has
> now been seen to cause the unfair behavior we should have expected
> from converting a spinlock to an rwlock: softlockup in cgroup_mkdir(),
> whose get_new_cssid() is waiting for the wlock, while there are 19
> tasks using the rlock in css_get_next() to get on with their memcg
> workload (in an artificial test, admittedly).  Yet lib/idr.c was
> made suitable for RCU way back.
> 
> 1. Revert that commit, restoring ss->id_lock to a spinlock.
> 
> 2. Make one small adjustment to idr_get_next(): take the height from
> the top layer (stable under RCU) instead of from the root (unprotected
> by RCU), as idr_find() does.
> 
> 3. Remove lock and unlock around css_get_next()'s call to idr_get_next():
> memcg iterators (only users of css_get_next) already did rcu_read_lock(),
> and comment demands that, but add a WARN_ON_ONCE to make sure of it.
> 
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thank you ! This seems much better.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

