From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: deprecate charge moving
Date: Tue, 6 Dec 2022 17:58:14 -0800 (PST)
Message-ID: <02b9663-4377-bd67-8da2-aad72240da@google.com>
References: <20221206171340.139790-1-hannes@cmpxchg.org> <20221206171340.139790-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8963QVuWzMlre8yLN4891ujCBmWo5SyqcLZ8tSbZjQ=;
        b=eBRBdaHXvgKpW6/nBEGd/saUzFoozLpzIKQmkJccf22pFYLqqUwQmUXP7zz+NHarWr
         y6oNwxxTkbGSuO+M05BGsjg+XcnEor7+ZxHUaOF9F0dTgXN7JIhH9mxY69OxgcpyIJtb
         qj/GNdr7md0XD0zM0Hpy6wzMv9vqEvJfEd51lxXbNqMjf1P3z2dC4uoPY6R4fKcFL2FB
         9h3S323dKwW0PyiDSM/OYs9Vn6du77A0CRL7M/dX4DwA8nNcujWN5Rkdp2SbA9XC6Lsj
         UTrD1polfnjmptxxWF4CLi5v3jR2pGansFPDF0QCUdjds6TL4/tG/rF5tcpCKINWjhf6
         5Gaw==
In-Reply-To: <20221206171340.139790-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 6 Dec 2022, Johannes Weiner wrote:

> Charge moving mode in cgroup1 allows memory to follow tasks as they
> migrate between cgroups. This is, and always has been, a questionable
> thing to do - for several reasons.
> 
> First, it's expensive. Pages need to be identified, locked and
> isolated from various MM operations, and reassigned, one by one.
> 
> Second, it's unreliable. Once pages are charged to a cgroup, there
> isn't always a clear owner task anymore. Cache isn't moved at all, for
> example. Mapped memory is moved - but if trylocking or isolating a
> page fails, it's arbitrarily left behind. Frequent moving between
> domains may leave a task's memory scattered all over the place.
> 
> Third, it isn't really needed. Launcher tasks can kick off workload
> tasks directly in their target cgroup. Using dedicated per-workload
> groups allows fine-grained policy adjustments - no need to move tasks
> and their physical pages between control domains. The feature was
> never forward-ported to cgroup2, and it hasn't been missed.
> 
> Despite it being a niche usecase, the maintenance overhead of
> supporting it is enormous. Because pages are moved while they are live
> and subject to various MM operations, the synchronization rules are
> complicated. There are lock_page_memcg() in MM and FS code, which
> non-cgroup people don't understand. In some cases we've been able to
> shift code and cgroup API calls around such that we can rely on native
> locking as much as possible. But that's fragile, and sometimes we need
> to hold MM locks for longer than we otherwise would (pte lock e.g.).
> 
> Mark the feature deprecated. Hopefully we can remove it soon.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

but I wonder if it would be helpful to mention move_charge_at_immigrate
in the deprecation message: maybe the first line should be
"Cgroup memory moving (move_charge_at_immigrate) is deprecated.\n"

> ---
>  Documentation/admin-guide/cgroup-v1/memory.rst | 11 ++++++++++-
>  mm/memcontrol.c                                |  4 ++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
> index 60370f2c67b9..87d7877b98ec 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -86,6 +86,8 @@ Brief summary of control files.
>   memory.swappiness		     set/show swappiness parameter of vmscan
>  				     (See sysctl's vm.swappiness)
>   memory.move_charge_at_immigrate     set/show controls of moving charges
> +                                     This knob is deprecated and shouldn't be
> +                                     used.
>   memory.oom_control		     set/show oom controls.
>   memory.numa_stat		     show the number of memory usage per numa
>  				     node
> @@ -717,9 +719,16 @@ Soft limits can be setup by using the following commands (in this example we
>         It is recommended to set the soft limit always below the hard limit,
>         otherwise the hard limit will take precedence.
>  
> -8. Move charges at task migration
> +8. Move charges at task migration (DEPRECATED!)
>  =================================
>  
> +THIS IS DEPRECATED!
> +
> +It's expensive and unreliable! It's better practice to launch workload
> +tasks directly from inside their target cgroup. Use dedicated workload
> +cgroups to allow fine-grained policy adjustments without having to
> +move physical pages between control domains.
> +
>  Users can move charges associated with a task along with task migration, that
>  is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
>  This feature is not supported in !CONFIG_MMU environments because of lack of
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b696354c1b21..e650a38d9a90 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3919,6 +3919,10 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
> +	pr_warn_once("Cgroup memory moving is deprecated. "
> +		     "Please report your usecase to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org if you "
> +		     "depend on this functionality.\n");
> +
>  	if (val & ~MOVE_MASK)
>  		return -EINVAL;
>  
> -- 
> 2.38.1
> 
> 
