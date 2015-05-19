From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/7] memcg: restructure mem_cgroup_can_attach()
Date: Tue, 19 May 2015 11:03:43 +0200
Message-ID: <20150519090343.GC6847@dhcp22.suse.cz>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=U5wffHAmR86oxXZ5OHbjHMkYPJ6S/YY4oxzDx42gLdw=;
        b=YJT8dZvpaxjjsjGHVxFdPwTIQ8E66ZfbH9s6z3sD4YqqW2J1cf50SI2yC6REex2VgD
         oU3zfIjok2660bMop1Vb7TNVmcgoacRdVByu/bTU2B8Din8okpPF6zWZZ2nM2okTUI0n
         w9J0Cs0gqoBtuWa5K+8SG1sELybvksRWeEr1ultQYjIia+/fsBwWi/+tRvd18Iq4GTuX
         qjOn/ia4hmbZyAVf6IvdnYuHiUIZ3EaDzFHrZzXX2C6ArRp+jZG9TGmh0dCVeD6yThhI
         EKxrOUKINrUY9LfmtzcUNdC574MD9C3z7DoAzmr0PjxCOYisqxke/RMri3XGAk9KDxdA
         GHVg==
Content-Disposition: inline
In-Reply-To: <1431978595-12176-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 18-05-15 15:49:50, Tejun Heo wrote:
> Restructure it to lower nesting level and help the planned threadgroup
> leader iteration changes.
> 
> This is pure reorganization.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 61 ++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 32 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 14c2f20..b1b834d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4997,10 +4997,12 @@ static void mem_cgroup_clear_mc(void)
>  static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
>  				 struct cgroup_taskset *tset)
>  {
> -	struct task_struct *p = cgroup_taskset_first(tset);
> -	int ret = 0;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +	struct mem_cgroup *from;
> +	struct task_struct *p;
> +	struct mm_struct *mm;
>  	unsigned long move_flags;
> +	int ret = 0;
>  
>  	/*
>  	 * We are now commited to this value whatever it is. Changes in this
> @@ -5008,36 +5010,37 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
>  	 * So we need to save it, and keep it going.
>  	 */
>  	move_flags = READ_ONCE(memcg->move_charge_at_immigrate);
> -	if (move_flags) {
> -		struct mm_struct *mm;
> -		struct mem_cgroup *from = mem_cgroup_from_task(p);
> +	if (!move_flags)
> +		return 0;
>  
> -		VM_BUG_ON(from == memcg);
> +	p = cgroup_taskset_first(tset);
> +	from = mem_cgroup_from_task(p);
>  
> -		mm = get_task_mm(p);
> -		if (!mm)
> -			return 0;
> -		/* We move charges only when we move a owner of the mm */
> -		if (mm->owner == p) {
> -			VM_BUG_ON(mc.from);
> -			VM_BUG_ON(mc.to);
> -			VM_BUG_ON(mc.precharge);
> -			VM_BUG_ON(mc.moved_charge);
> -			VM_BUG_ON(mc.moved_swap);
> -
> -			spin_lock(&mc.lock);
> -			mc.from = from;
> -			mc.to = memcg;
> -			mc.flags = move_flags;
> -			spin_unlock(&mc.lock);
> -			/* We set mc.moving_task later */
> -
> -			ret = mem_cgroup_precharge_mc(mm);
> -			if (ret)
> -				mem_cgroup_clear_mc();
> -		}
> -		mmput(mm);
> +	VM_BUG_ON(from == memcg);
> +
> +	mm = get_task_mm(p);
> +	if (!mm)
> +		return 0;
> +	/* We move charges only when we move a owner of the mm */
> +	if (mm->owner == p) {
> +		VM_BUG_ON(mc.from);
> +		VM_BUG_ON(mc.to);
> +		VM_BUG_ON(mc.precharge);
> +		VM_BUG_ON(mc.moved_charge);
> +		VM_BUG_ON(mc.moved_swap);
> +
> +		spin_lock(&mc.lock);
> +		mc.from = from;
> +		mc.to = memcg;
> +		mc.flags = move_flags;
> +		spin_unlock(&mc.lock);
> +		/* We set mc.moving_task later */
> +
> +		ret = mem_cgroup_precharge_mc(mm);
> +		if (ret)
> +			mem_cgroup_clear_mc();
>  	}
> +	mmput(mm);
>  	return ret;
>  }
>  
> -- 
> 2.4.0
> 

-- 
Michal Hocko
SUSE Labs
