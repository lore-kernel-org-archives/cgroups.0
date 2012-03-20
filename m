From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] provide a function to register more cftype files
 into memcg
Date: Tue, 20 Mar 2012 11:32:33 -0700
Message-ID: <20120320183233.GC20832@google.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com>
 <1332262256-13407-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rMLmPP5GLerZd1R6rCyEouxGs8fmTxOjsEUMeUSLQr0=;
        b=n+qgmHWy4Gp35fq1TJvIuT6OuI+rly/vTL+YAphtc41PSbGGYC+nNwljaHpvOPb8sw
         338RmIA4deN5F4kxLQPlh7pU8OrdsrzFanxLoWfnZTOJxJEeuubkHDhIdDK+DNk5DiNE
         9VwW6cMiZEDLL0INM6KZu2h+NRvuAU3V9L9+dbPq7XQpjEcFUgazgDGAOYZ+Pcn31Zgg
         qJHJ5Zbi5civ/NEGnIHVIBr00Ywtf1w3ppZjgpLSsjK4WI095ikpWL7A9mO8u0ek77Qr
         MHNs9vVoBXoocBQYZS2lW19wPAfoJAkuIsQfUOIzaoiR9/lNHsyvcIAfE993QINIT4CW
         HSdA==
Content-Disposition: inline
In-Reply-To: <1332262256-13407-4-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Hey,

On Tue, Mar 20, 2012 at 08:50:55PM +0400, Glauber Costa wrote:
> The function mem_cgroup_register_cftype() is provided here, so
> an optional memcg subsystem that needs to register files at
> a time later than memcg initialization can do it.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  include/linux/memcontrol.h |    1 +
>  mm/memcontrol.c            |    6 ++++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d34356..bcf8de3 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -141,6 +141,7 @@ static inline bool mem_cgroup_disabled(void)
>  	return false;
>  }
>  
> +int mem_cgroup_register_cftype(const struct cftype *cfts);
>  void mem_cgroup_update_page_stat(struct page *page,
>  				 enum mem_cgroup_page_stat_item idx,
>  				 int val);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f7c6727..bd91a46 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -444,6 +444,12 @@ struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
>  	return &memcg->css;
>  }
>  
> +int mem_cgroup_register_cftype(const struct cftype *cfts)
> +{
> +	return WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, cfts));
> +}
> +EXPORT_SYMBOL(mem_cgroup_register_cftype);

Why not just export mem_cgroup_subsys?

Thanks.

-- 
tejun
