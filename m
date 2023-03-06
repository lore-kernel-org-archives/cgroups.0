From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2, 1/4] mm, memcg: Prevent memory.oom.group load/store
 tearing
Date: Mon, 6 Mar 2023 18:47:04 +0100
Message-ID: <ZAYnGK8mXjxmarDm@dhcp22.suse.cz>
References: <20230306154138.3775-1-findns94@gmail.com>
 <20230306154138.3775-2-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678124825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yyo0XeW7H32v2n33gFS+jMOXmRmlgHGjCX1E7zeS1w0=;
        b=R5OU+pfkoKfQA+ShDkrA2Ab/7GQX8V5UAbQDog+dOafDsBbUj/UFcnZ9pk4PuaqeDlUO+f
        oEJZK3fuTgGttOPw1FFsK2b1lsEmqtpmRJraKGUb4fXL/rOpwohtJYV8v2U74LbuU0qxLx
        7GQOmS+j6Iq/Ip1rqQ6QQwJHu958cZ8=
Content-Disposition: inline
In-Reply-To: <20230306154138.3775-2-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon 06-03-23 23:41:35, Yue Zhao wrote:
> The knob for cgroup v2 memory controller: memory.oom.group
> is not protected by any locking so it can be modified while it is used.
> This is not an actual problem because races are unlikely (the knob is
> usually configured long before any workloads hits actual memcg oom)
> but it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
> doing anything funky.
> 
> The access of memcg->oom_group is lockless, so it can be
> concurrently set at the same time as we are trying to read it.
> 
> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Thanks!

> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5abffe6f8389..06821e5f7604 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2067,7 +2067,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
>  	 * highest-level memory cgroup with oom.group set.
>  	 */
>  	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> -		if (memcg->oom_group)
> +		if (READ_ONCE(memcg->oom_group))
>  			oom_group = memcg;
>  
>  		if (memcg == oom_domain)
> @@ -6623,7 +6623,7 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
>  
> -	seq_printf(m, "%d\n", memcg->oom_group);
> +	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
>  
>  	return 0;
>  }
> @@ -6645,7 +6645,7 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
>  	if (oom_group != 0 && oom_group != 1)
>  		return -EINVAL;
>  
> -	memcg->oom_group = oom_group;
> +	WRITE_ONCE(memcg->oom_group, oom_group);
>  
>  	return nbytes;
>  }
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
