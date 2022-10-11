From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Don't increase effective low/min if no
 protection needed
Date: Tue, 11 Oct 2022 17:39:41 +0200
Message-ID: <Y0WOPZxWSnUjzZ8e@dhcp22.suse.cz>
References: <20221011143015.1152968-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1665502782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vB0AXXBtm0Hrdk0bg6YG9HeCQbPU+AcCqyHQMZO7aHU=;
        b=AOyiExVT8ICluY29f7EISViuBP4fZfaDGjWt/zgw/wKFtAhm86QAWBAMm3OGNO88yDbw4L
        dCppJmVuT0D38ZQBGQ4D/GsypMU9r0HpZIlyL+USdsMoBBwX+vizkRdpijHy57HK/3+fS7
        wQVsY/OckiDS1Src/EUzygFkKRStZJs=
Content-Disposition: inline
In-Reply-To: <20221011143015.1152968-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Tue 11-10-22 10:30:15, Waiman Long wrote:
> Since commit bc50bcc6e00b ("mm: memcontrol: clean up and document
> effective low/min calculations"), the effective low/min protections can
> be non-zero even if the corresponding memory.low/min values are 0. That
> can surprise users to see MEMCG_LOW events even when the memory.low
> value is not set. One example is the LTP's memcontrol04 test which fails
> because it detects some MEMCG_LOW events for a cgroup with a memory.min
> value of 0.

Is this with memory_recursiveprot mount option?

> Fix this by updating effective_protection() to not returning a non-zero
> low/min protection values if the corresponding memory.low/min values
> or those of its parent are 0.
> 
> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b69979c9ced5..893d4d5e518a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6660,6 +6660,9 @@ static unsigned long effective_protection(unsigned long usage,
>  	unsigned long protected;
>  	unsigned long ep;
>  
> +	if (!setting || !parent_effective)
> +		return 0UL;	/* No protection is needed */
> +

This will break the above memory_recursiveprot AFAICS.

>  	protected = min(usage, setting);
>  	/*
>  	 * If all cgroups at this level combined claim and use more
> -- 
> 2.31.1

-- 
Michal Hocko
SUSE Labs
