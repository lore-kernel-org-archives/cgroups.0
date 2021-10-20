From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 2/3] memcg: remove charge forcinig for dying tasks
Date: Wed, 20 Oct 2021 14:41:49 +0200
Message-ID: <YXAOjQO5r1g/WKmn@dhcp22.suse.cz>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
 <56180e53-b705-b1be-9b60-75e141c8560c@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634733710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sFOP+dXf4qmtNkZTV2k2qUHOsofKbRuJJn1maDYI9oM=;
        b=UyA4wEqa/V+upXfbz6kZdRsrMWrhneLtYsx4sBI86AeeX2S3ehCZ4BDkFEnycu5zd2sJl3
        LnV5NPVglpzp6+B09XkTkngMgzrn3L+mqavxH1k4wy/sMfEI197G2RHcdR3wlgqLZKwwMc
        pcVa15Jctosy5pc5u8tsB+BMAhY3abU=
Content-Disposition: inline
In-Reply-To: <56180e53-b705-b1be-9b60-75e141c8560c-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed 20-10-21 15:13:46, Vasily Averin wrote:
> ToDo: should we keep task_is_dying() in mem_cgroup_out_of_memory() ?
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  mm/memcontrol.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6da5020a8656..74a7379dbac1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -239,7 +239,7 @@ enum res_type {
>  	     iter != NULL;				\
>  	     iter = mem_cgroup_iter(NULL, iter, NULL))
>  
> -static inline bool should_force_charge(void)
> +static inline bool task_is_dying(void)
>  {
>  	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
>  		(current->flags & PF_EXITING);
> @@ -1575,7 +1575,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * A few threads which were not waiting at mutex_lock_killable() can
>  	 * fail to bail out. Therefore, check again after holding oom_lock.
>  	 */
> -	ret = should_force_charge() || out_of_memory(&oc);
> +	ret = task_is_dying() || out_of_memory(&oc);

Why are you keeping the task_is_dying check here? IIRC I have already
pointed out that out_of_memory already has some means to do a bypass
when needed.
-- 
Michal Hocko
SUSE Labs
