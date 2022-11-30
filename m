From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Wed, 30 Nov 2022 14:15:06 +0100
Message-ID: <Y4dXWsaLKRwJvWEY@dhcp22.suse.cz>
References: <20221130070158.44221-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669814106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78kBTVjk9NN3b//OL4d2dPMzsmFl6kOFvw+wnxdUvC0=;
        b=CJ5yMJnrkOzf4sfqOWKQ1oSbCwMifCAwlufTAq1pWndcvZ5cAeOuB0nUqN676FKRXuNrLs
        VanShgHoCm8feQxtJEpumXrdKUFYdFlrhjNoHTeVkyWn3K/SDlL9mo3hqvI/V/M59IYJW1
        bgTi/RkuuLd/q/bmdszcfp1VvqnOwSE=
Content-Disposition: inline
In-Reply-To: <20221130070158.44221-1-chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sujiaxun-xX5NlYq76+e1Z/+hSey0Gg@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 30-11-22 15:01:58, chengkaitao wrote:
> From: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> We created a new interface <memory.oom.protect> for memory, If there is
> the OOM killer under parent memory cgroup, and the memory usage of a
> child cgroup is within its effective oom.protect boundary, the cgroup's
> tasks won't be OOM killed unless there is no unprotected tasks in other
> children cgroups. It draws on the logic of <memory.min/low> in the
> inheritance relationship.

Could you be more specific about usecases? How do you tune oom.protect
wrt to other tunables? How does this interact with the oom_score_adj
tunining (e.g. a first hand oom victim with the score_adj 1000 sitting
in a oom protected memcg)?

I haven't really read through the whole patch but this struck me odd.

> @@ -552,8 +552,19 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
>  	unsigned long totalpages = totalram_pages() + total_swap_pages;
>  	unsigned long points = 0;
>  	long badness;
> +#ifdef CONFIG_MEMCG
> +	struct mem_cgroup *memcg;
>  
> -	badness = oom_badness(task, totalpages);
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(task);
> +	if (memcg && !css_tryget(&memcg->css))
> +		memcg = NULL;
> +	rcu_read_unlock();
> +
> +	update_parent_oom_protection(root_mem_cgroup, memcg);
> +	css_put(&memcg->css);
> +#endif
> +	badness = oom_badness(task, totalpages, MEMCG_OOM_PROTECT);

the badness means different thing depending on which memcg hierarchy
subtree you look at. Scaling based on the global oom could get really
misleading.

-- 
Michal Hocko
SUSE Labs
