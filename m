From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: fix build error around the usage of
 kmem_caches
Date: Wed, 5 Feb 2020 18:18:56 +0100
Message-ID: <1ef8ee2e-0f50-fcd6-ae13-d6524fcf9764@redhat.com>
References: <1580922215-5272-1-git-send-email-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580923157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gIyB4KCgThCAN1Ny4WvXktKwaa2MWcRreFTLvoHvsE0=;
        b=Yz8Sb8f1Ywqf9q8P9XbuM5jSqdFvd++E86E0a2hfusFBph/TLY2hyD8xl37cO4iEJmEmal
        3apMS3bF87xK0+gAm/t7LixyYvGQ9P7lqRJEo4KVO5opFwbJ0d+ehTSjaoY9HQO/UpJS+6
        jeFLQHvllp19McpGd1IHCXHfifbz2nY=
In-Reply-To: <1580922215-5272-1-git-send-email-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 05.02.20 18:03, Yafang Shao wrote:
> When I manually set default n to MEMCG_KMEM in init/Kconfig, bellow error
> occurs,
> 
> mm/slab_common.c: In function 'memcg_slab_start':
> mm/slab_common.c:1530:30: error: 'struct mem_cgroup' has no member named
> 'kmem_caches'
>   return seq_list_start(&memcg->kmem_caches, *pos);
>                               ^
> mm/slab_common.c: In function 'memcg_slab_next':
> mm/slab_common.c:1537:32: error: 'struct mem_cgroup' has no member named
> 'kmem_caches'
>   return seq_list_next(p, &memcg->kmem_caches, pos);
>                                 ^
> mm/slab_common.c: In function 'memcg_slab_show':
> mm/slab_common.c:1551:16: error: 'struct mem_cgroup' has no member named
> 'kmem_caches'
>   if (p == memcg->kmem_caches.next)
>                 ^
>   CC      arch/x86/xen/smp.o
> mm/slab_common.c: In function 'memcg_slab_start':
> mm/slab_common.c:1531:1: warning: control reaches end of non-void function
> [-Wreturn-type]
>  }
>  ^
> mm/slab_common.c: In function 'memcg_slab_next':
> mm/slab_common.c:1538:1: warning: control reaches end of non-void function
> [-Wreturn-type]
>  }
>  ^
> 
> That's because kmem_caches is defined only when CONFIG_MEMCG_KMEM is set,
> while memcg_slab_start() will use it no matter CONFIG_MEMCG_KMEM is defined
> or not.
> 
> By the way, the reason I mannuly undefined CONFIG_MEMCG_KMEM is to verify
> whether my some other code change is still stable when CONFIG_MEMCG_KMEM is
> not set. Unfortunately, the existing code has been already unstable since
> v4.11.
> 
> Fixes: bc2791f857e1 ("slab: link memcg kmem_caches on their associated memory cgroup")
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c  | 2 ++
>  mm/slab_common.c | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6f6dc8712e39..43f0125b45bb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4723,6 +4723,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
>  		.write = mem_cgroup_reset,
>  		.read_u64 = mem_cgroup_read_u64,
>  	},
> +#ifdef CONFIG_MEMCG_KMEM
>  #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)

Not sure if

#if defined(CONFIG_MEMCG_KMEM) && \
    (defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))

is preffered


-- 
Thanks,

David / dhildenb

