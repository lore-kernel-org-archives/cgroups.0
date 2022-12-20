From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] mm: kmem: add direct objcg pointer to task_struct
Date: Tue, 20 Dec 2022 20:44:51 +0000
Message-ID: <20221220204451.gm5d3pdbfvd5ki6b@google.com>
References: <20221220182745.1903540-1-roman.gushchin@linux.dev> <20221220182745.1903540-3-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cBjT4mczGAcRKDxekCfUuigKoWGhE5GXVDzxsCw5lgg=;
        b=OA4QXKd1zWYDWeOzVIH4Wrq5hlCeBDbXDJWgpzsHk99f4TlV6VjTbZnrGQYSmZIzsp
         wptYRnLPhR0gqxp6ulCpkDMq4n+DAEbCNTd3W0705Vi6ViIVRHozFSAG+Vc6ud9u5XhJ
         F5VLTAa2nRkAY7dVYZRbEMWZa/goOubpR+k1LSoQbHiO5GM9jHhaKxbwsa2aV8VlXoeR
         jFUSkhVqK9NZ2OPbp4t4azw2rU6IQebrmbydwjbXgx5eoblFkjy+GCT+hEIHq3tympjp
         q+b4x3p+FN60peVEBp+HM4OAlUwig2nY1Sko9FzvcUKknWf9/EiHSSDMAk385v5U20aR
         HrKQ==
In-Reply-To: <20221220182745.1903540-3-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Dec 20, 2022 at 10:27:45AM -0800, Roman Gushchin wrote:
> To charge a freshly allocated kernel object to a memory cgroup, the
> kernel needs to obtain an objcg pointer. Currently it does it
> indirectly by obtaining the memcg pointer first and then calling to
> __get_obj_cgroup_from_memcg().
> 
> Usually tasks spend their entire life belonging to the same object
> cgroup. So it makes sense to save the objcg pointer on task_struct
> directly, so it can be obtained faster. It requires some work on fork,
> exit and cgroup migrate paths, but these paths are way colder.
> 
> The old indirect way is still used for remote memcg charging.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

This looks good too. Few comments below:

[...]
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset)
> +{
> +	struct task_struct *task;
> +	struct cgroup_subsys_state *css;
> +
> +	cgroup_taskset_for_each(task, css, tset) {
> +		struct mem_cgroup *memcg;
> +
> +		if (task->objcg)
> +			obj_cgroup_put(task->objcg);
> +
> +		rcu_read_lock();
> +		memcg = container_of(css, struct mem_cgroup, css);
> +		task->objcg = __get_obj_cgroup_from_memcg(memcg);
> +		rcu_read_unlock();
> +	}
> +}
> +#else
> +static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset) {}
> +#endif /* CONFIG_MEMCG_KMEM */
> +
> +#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MEMCG_KMEM)

I think you want CONFIG_LRU_GEN in the above check.

>  static void mem_cgroup_attach(struct cgroup_taskset *tset)
>  {
> +	mem_cgroup_lru_gen_attach(tset);
> +	mem_cgroup_kmem_attach(tset);
>  }
> -#endif /* CONFIG_LRU_GEN */
> +#endif
>  
>  static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
>  {
> @@ -6816,9 +6872,15 @@ struct cgroup_subsys memory_cgrp_subsys = {
>  	.css_reset = mem_cgroup_css_reset,
>  	.css_rstat_flush = mem_cgroup_css_rstat_flush,
>  	.can_attach = mem_cgroup_can_attach,
> +#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MEMCG_KMEM)

Same here.

>  	.attach = mem_cgroup_attach,
> +#endif
>  	.cancel_attach = mem_cgroup_cancel_attach,
>  	.post_attach = mem_cgroup_move_task,
> +#ifdef CONFIG_MEMCG_KMEM
> +	.fork = mem_cgroup_fork,
> +	.exit = mem_cgroup_exit,
> +#endif
>  	.dfl_cftypes = memory_files,
>  	.legacy_cftypes = mem_cgroup_legacy_files,
>  	.early_init = 0,
> -- 
> 2.39.0
> 
