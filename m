From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Set the correct memcg swappiness
 restriction
Date: Fri, 30 Jul 2021 08:39:13 +0200
Message-ID: <YQOekWWgtZUfim4M@dhcp22.suse.cz>
References: <d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627627155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=agHfFzHW+xeGrdhw4hG5J5joqngPV2b0VMzApVyqQ8E=;
        b=PeRG1lTled8ApH7cHx8hsRdcE5UrL2oXTe256ZUWp/ZadsVhirozoTQeLdTqZoHnVZ0faD
        uzg08Gto5i2+eAUb8udHkBWFpdFHPw5lWAYyUYEwgW3/zu4yE0Jf5/+nDpOxtpNzrDQgRF
        NscVVZDtu9NtvzMgXo4UGqtbkegUass=
Content-Disposition: inline
In-Reply-To: <d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 30-07-21 14:26:35, Baolin Wang wrote:
> Since commit c843966c556d ("mm: allow swappiness that prefers reclaiming
> anon over the file workingset") has expended the swappiness value to
> make swap to be preferred in some systems. We should also change the
> memcg swappiness restriction to allow memcg swap-preferred.
> 
> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Yes, this looks like an omission. It doesn't really make sense to have
two different constrains on the value.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6580c23..988fc94 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4046,7 +4046,7 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
> -	if (val > 100)
> +	if (val > 200)
>  		return -EINVAL;
>  
>  	if (!mem_cgroup_is_root(memcg))
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
