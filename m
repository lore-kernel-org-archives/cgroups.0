From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: avoid accessing memcg after releasing reference
Date: Mon, 1 Apr 2013 11:39:27 +0200
Message-ID: <20130401093927.GB30749@dhcp22.suse.cz>
References: <5158F344.9020509@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=6Ue1BNap2zGQO+Ap061PcEB576MhHcVs4P2nt4XWN7k=;
        b=C2ZqJ4p+wpZw7Gk0CJQaVx79KSky10HcDcL1TdTdTD4n26bkR96K+xf7gI8kc/4d+3
         guciV5T7zAT0z3QttmS9s5ilpgyF7ss4DXm+RF6llO5bd1zncR9pQSSbDce7fatodq1y
         2JuapylS24d2990/Fiu+XRxX7N6CiAqkqI+gtKsTJefVsxO3008yIC3bRm6JJGee8+6i
         yNjOPAU2PgAQ+tVoZco5SvtMPYyW/ZR4/AbqaRDsyVMDLaYZwCPXpfXuDUgOqllOYCJ7
         bt4kuZ3R2c5neC2LY9+VYTqY4KkZ/lQ/fUrYLCUnLKwW/kysy3hLR4QaI83OsKP6YUHP
         xMcQ==
Content-Disposition: inline
In-Reply-To: <5158F344.9020509-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon 01-04-13 10:39:00, Li Zefan wrote:
> This might cause use-after-free bug.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
> 
> found when reading the code.
> 
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8ec501c..6391046 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3186,12 +3186,12 @@ void memcg_release_cache(struct kmem_cache *s)
>  
>  	root = s->memcg_params->root_cache;
>  	root->memcg_params->memcg_caches[id] = NULL;
> -	mem_cgroup_put(memcg);
>  
>  	mutex_lock(&memcg->slab_caches_mutex);
>  	list_del(&s->memcg_params->list);
>  	mutex_unlock(&memcg->slab_caches_mutex);
>  
> +	mem_cgroup_put(memcg);
>  out:
>  	kfree(s->memcg_params);
>  }
> -- 
> 1.8.0.2

-- 
Michal Hocko
SUSE Labs
