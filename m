From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2, 3/4] mm, memcg: Prevent memory.oom_control load/store
 tearing
Date: Mon, 6 Mar 2023 18:53:15 +0100
Message-ID: <ZAYoi8ZwwbXT9j7f@dhcp22.suse.cz>
References: <20230306154138.3775-1-findns94@gmail.com>
 <20230306154138.3775-4-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678125196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C1hwoiYmIzjyFk8ZALc5sULe62pU2P1ms/hhtGj0y1k=;
        b=jwHB7kNZdVMu7pORMKiDgDdWZI0fuRoEnFOqAwGt0mE6k4eAt5T1x+raVUsiRb0qyU9riW
        /SXi4S4tVqanqOvQoom/OxpX4HBsaGCkjfQqJxpcVgINgSZL+rhxKWmFU8fDVzgu1acaMV
        /jN2VHcmUYjvKvHqXSsbaYb3PY9Heng=
Content-Disposition: inline
In-Reply-To: <20230306154138.3775-4-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon 06-03-23 23:41:37, Yue Zhao wrote:
> The knob for cgroup v1 memory controller: memory.oom_control
> is not protected by any locking so it can be modified while it is used.
> This is not an actual problem because races are unlikely.
> But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
> doing anything funky.
> 
> The access of memcg->oom_kill_disable is lockless,
> so it can be concurrently set at the same time as we are
> trying to read it.
> 
> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dca895c66a9b..26605b2f51b1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4515,7 +4515,7 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
>  
> -	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
> +	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
>  	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
>  	seq_printf(sf, "oom_kill %lu\n",
>  		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
> @@ -4531,7 +4531,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
>  	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
>  		return -EINVAL;
>  
> -	memcg->oom_kill_disable = val;
> +	WRITE_ONCE(memcg->oom_kill_disable, val);
>  	if (!val)
>  		memcg_oom_recover(memcg);

Any specific reasons you haven't covered other accesses
(mem_cgroup_css_alloc, mem_cgroup_oom, mem_cgroup_oom_synchronize)?
>  
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
