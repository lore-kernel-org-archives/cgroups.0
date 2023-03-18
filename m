From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Clean up cpuset_node_allowed
Date: Fri, 17 Mar 2023 21:35:39 -0400
Message-ID: <299c9c34-0c07-ae52-61d7-6332f35c6245@redhat.com>
References: <9953284e-05da-56b0-047d-ecf18aa53892@redhat.com>
 <20230228083537.102665-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679103346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXGU9grUyOEEZr4lmDbjI1nN/h/jed2HEhYFOagp+3w=;
        b=GmA9tAr5QSzDM41ybAivU3go58Pk1OMBz5jwEmDJ9UfoLGbdutkzkpHE3EmntnfBvJAa5x
        JVuotBn2nAEt9pPd82lGqiNHHn+BF6hyhgeGBoybZGluYs01DYsZr+sxlqXbxd8AFFdycc
        2P7HOI6Dr/K+J2cCI39hdT2g2HTgMRQ=
Content-Language: en-US
In-Reply-To: <20230228083537.102665-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/28/23 03:35, Haifeng Xu wrote:
> Commit 002f290627c2 ("cpuset: use static key better and convert to new API")
> has used __cpuset_node_allowed() instead of cpuset_node_allowed() to check
> whether we can allocate on a memory node. Now this function isn't used by
> anyone, so we can do the follow things to clean up it.
>
> 1. remove unused codes
> 2. rename __cpuset_node_allowed() to cpuset_node_allowed()
> 3. update comments in mm/page_alloc.c
>
> Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/cpuset.h | 16 ++--------------
>   kernel/cgroup/cpuset.c |  4 ++--
>   mm/page_alloc.c        |  4 ++--
>   3 files changed, 6 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index d58e0476ee8e..980b76a1237e 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -80,18 +80,11 @@ extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>   void cpuset_init_current_mems_allowed(void);
>   int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
>   
> -extern bool __cpuset_node_allowed(int node, gfp_t gfp_mask);
> -
> -static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
> -{
> -	if (cpusets_enabled())
> -		return __cpuset_node_allowed(node, gfp_mask);
> -	return true;
> -}
> +extern bool cpuset_node_allowed(int node, gfp_t gfp_mask);
>   
>   static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
>   {
> -	return __cpuset_node_allowed(zone_to_nid(z), gfp_mask);
> +	return cpuset_node_allowed(zone_to_nid(z), gfp_mask);
>   }
>   
>   static inline bool cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
> @@ -223,11 +216,6 @@ static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
>   	return 1;
>   }
>   
> -static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
> -{
> -	return true;
> -}
> -

Sorry for the late reply as I apparently drop the ball.

You need to keep the above cpuset_node_allowed() inline function or you 
will get compilation error when compiling with a config without 
CONFIG_CPUSETS. Other than that, the other changes look good.

Cheers,
Longman

