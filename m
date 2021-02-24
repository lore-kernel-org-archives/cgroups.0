From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup root memcg checks
Date: Wed, 24 Feb 2021 10:30:57 +0100
Message-ID: <YDYc0WHOcCbwOS8h@dhcp22.suse.cz>
References: <20210223205625.2792891-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614159058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RHDb1EdzW6ls0b9fIDV8fGOOuVEVrb7XhiXVWuec/l4=;
        b=sdh8e/w5oTQCb745WEPHxOHWYf5r0wxjB/z4beRQ4u39gmoCbGLGEmfsRGI/HaRqjS4Kmh
        YIK7mWaAXmjWIOSgk8wZ8aFvrivXgmVghdLlilVsChCKuTF/XPP7ZwytmBizpe8HCFizS8
        ZBToJTW5QZiLS+U7WWzpcvk663uYC9s=
Content-Disposition: inline
In-Reply-To: <20210223205625.2792891-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 23-02-21 12:56:25, Shakeel Butt wrote:
> Replace the implicit checking of root memcg with explicit root memcg
> checking i.e. !css->parent with mem_cgroup_is_root().
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dcb5665aeb69..79046ad3eec0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4141,7 +4141,7 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
>  	if (val > 100)
>  		return -EINVAL;
>  
> -	if (css->parent)
> +	if (!mem_cgroup_is_root(memcg))
>  		memcg->swappiness = val;
>  	else
>  		vm_swappiness = val;
> @@ -4491,7 +4491,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
>  	/* cannot set to root cgroup and only 0 and 1 are allowed */
> -	if (!css->parent || !((val == 0) || (val == 1)))
> +	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
>  		return -EINVAL;
>  
>  	memcg->oom_kill_disable = val;
> -- 
> 2.30.0.617.g56c4b15f3c-goog

-- 
Michal Hocko
SUSE Labs
