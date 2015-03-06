From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: print cgroup information when system panics due
 to panic_on_oom
Date: Fri, 6 Mar 2015 17:40:26 +0100
Message-ID: <20150306164026.GG22716@dhcp22.suse.cz>
References: <1425634769-21340-1-git-send-email-balasubramani_vivekanandan@mentor.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425634769-21340-1-git-send-email-balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balasubramani Vivekanandan <balu252-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Balasubramani Vivekanandan <balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>

On Fri 06-03-15 15:09:29, Balasubramani Vivekanandan wrote:
> If panic_on_oom=2, then there was no cgroup information printed,
> if system panics due of cgroup memory limit reached. Information is
> only printed when configured to kill task. This patch prints
> information of the cgroup whose limit triggerred panic

Yes the patch makes sense but the changelog is missing information why
this is a problem.

We will see that the OOM happened because of "compulsory panic_on_oom
is enabled" but this doesn't tell the difference between mempolicy and
memcg. And dumping system wide information is plain wrong and more
confusing.

Please mention something like that in the changelog so that the
motivation is clear.

> Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>

minor fixes/suggestion below, other than that it looks OK to me.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  include/linux/oom.h |  3 ++-
>  mm/memcontrol.c     | 21 ++++++++++++---------
>  mm/oom_kill.c       |  7 ++++---
>  3 files changed, 18 insertions(+), 13 deletions(-)
> 
[...]
> @@ -1442,17 +1442,20 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  	struct mem_cgroup *iter;
>  	unsigned int i;
>  
> -	if (!p)
> -		return;
> -
>  	mutex_lock(&oom_info_lock);
>  	rcu_read_lock();
>  
> -	pr_info("Task in ");
> -	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
> -	pr_cont(" killed as a result of limit of ");
> -	pr_cont_cgroup_path(memcg->css.cgroup);
> -	pr_cont("\n");
> +	if (p) {
> +		pr_info("Task in ");
> +		pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
> +		pr_cont(" killed as a result of limit of ");
> +		pr_cont_cgroup_path(memcg->css.cgroup);
> +		pr_cont("\n");
> +	} else {
> +		pr_info("Memory limit reached of cgroup ");

s@of@for@

> +		pr_cont_cgroup_path(memcg->css.cgroup);
> +		pr_cont("\n");
> +	}

and there is no reason to duplicate pr_cont_cgroup_path and the followup
pr_cont becayse both branches are doing the same.

>  
>  	rcu_read_unlock();
>  
-- 
Michal Hocko
SUSE Labs
