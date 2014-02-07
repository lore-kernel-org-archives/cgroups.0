From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Date: Fri, 7 Feb 2014 14:45:33 +0100
Message-ID: <20140207134533.GC5121@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402061541560.31342-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 06-02-14 15:56:01, Hugh Dickins wrote:
> Sometimes the cleanup after memcg hierarchy testing gets stuck in
> mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> 
> There may turn out to be several causes, but a major cause is this: the
> workitem to offline parent can get run before workitem to offline child;
> parent's mem_cgroup_reparent_charges() circles around waiting for the
> child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> which prevents the child from reaching its mem_cgroup_reparent_charges().
> 
> Just use an ordered workqueue for cgroup_destroy_wq.

Hmm, interesting. Markus has seen hangs even with mem_cgroup_css_offline
and the referenced cgroup fixes, maybe this is the the right one
finally.

> Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> Suggested-by: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.10+

Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

e5fca243abae was marked for 3.9 stable but I do not see it in the Greg's
3.9 stable branch so 3.10+ seems to be sufficient.

> ---
> 
>  kernel/cgroup.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 3.14-rc1/kernel/cgroup.c	2014-02-02 18:49:07.737302111 -0800
> +++ linux/kernel/cgroup.c	2014-02-06 15:20:35.548904965 -0800
> @@ -4845,12 +4845,12 @@ static int __init cgroup_wq_init(void)
>  	/*
>  	 * There isn't much point in executing destruction path in
>  	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
> -	 * Use 1 for @max_active.
> +	 * Must be ordered to make sure parent is offlined after children.
>  	 *
>  	 * We would prefer to do this in cgroup_init() above, but that
>  	 * is called before init_workqueues(): so leave this until after.
>  	 */
> -	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
> +	cgroup_destroy_wq = alloc_ordered_workqueue("cgroup_destroy", 0);
>  	BUG_ON(!cgroup_destroy_wq);
>  
>  	/*

-- 
Michal Hocko
SUSE Labs
