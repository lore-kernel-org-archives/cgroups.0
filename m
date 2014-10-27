From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: shorten the page statistics update
 slowpath
Date: Mon, 27 Oct 2014 13:08:02 +0300
Message-ID: <20141027100802.GA12335@esperanza>
References: <1414158020-25347-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414158020-25347-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 24, 2014 at 09:40:20AM -0400, Johannes Weiner wrote:
> While moving charges from one memcg to another, page stat updates must
> acquire the old memcg's move_lock to prevent double accounting.  That
> situation is denoted by an increased memcg->move_accounting.  However,
> the charge moving code declares this way too early for now, even
> before summing up the RSS and pre-allocating destination charges.
> 
> Shorten this slowpath mode by increasing memcg->move_accounting only
> right before walking the task's address space with the intention of
> actually moving the pages.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c50176429fa3..23cf27cca370 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5263,8 +5263,6 @@ static void __mem_cgroup_clear_mc(void)
>  
>  static void mem_cgroup_clear_mc(void)
>  {
> -	struct mem_cgroup *from = mc.from;
> -
>  	/*
>  	 * we must clear moving_task before waking up waiters at the end of
>  	 * task migration.
> @@ -5275,8 +5273,6 @@ static void mem_cgroup_clear_mc(void)
>  	mc.from = NULL;
>  	mc.to = NULL;
>  	spin_unlock(&mc.lock);
> -
> -	atomic_dec(&from->moving_account);
>  }
>  
>  static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
> @@ -5310,15 +5306,6 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
>  			VM_BUG_ON(mc.moved_charge);
>  			VM_BUG_ON(mc.moved_swap);
>  
> -			/*
> -			 * Signal mem_cgroup_begin_page_stat() to take
> -			 * the memcg's move_lock while we're moving
> -			 * its pages to another memcg.  Then wait for
> -			 * already started RCU-only updates to finish.
> -			 */
> -			atomic_inc(&from->moving_account);
> -			synchronize_rcu();
> -
>  			spin_lock(&mc.lock);
>  			mc.from = from;
>  			mc.to = memcg;
> @@ -5450,6 +5437,13 @@ static void mem_cgroup_move_charge(struct mm_struct *mm)
>  	struct vm_area_struct *vma;
>  
>  	lru_add_drain_all();
> +	/*
> +	 * Signal mem_cgroup_begin_page_stat() to take the memcg's
> +	 * move_lock while we're moving its pages to another memcg.
> +	 * Then wait for already started RCU-only updates to finish.
> +	 */
> +	atomic_inc(&mc.from->moving_account);
> +	synchronize_rcu();
>  retry:
>  	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
>  		/*
> @@ -5482,6 +5476,7 @@ retry:
>  			break;
>  	}
>  	up_read(&mm->mmap_sem);
> +	atomic_dec(&mc.from->moving_account);
>  }
>  
>  static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
> -- 
> 2.1.2
> 
