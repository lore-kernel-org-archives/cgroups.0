From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Date: Wed, 29 May 2013 08:18:00 +0530
Message-ID: <51A56C60.9030306@parallels.com>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org> <20130528155326.0a8b66a7711746e827d5fdea@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130528155326.0a8b66a7711746e827d5fdea-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 05/29/2013 04:23 AM, Andrew Morton wrote:
> On Tue, 14 May 2013 16:38:38 +0400 Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> 
>> struct memcg_cache_params has a union. Different parts of this union are
>> used for root and non-root caches. A part with destroying work is used only
>> for non-root caches.
> 
> That union is a bit dangerous.  Perhaps it would be better to do
> something like
> 
> --- a/include/linux/slab.h~a
> +++ a/include/linux/slab.h
> @@ -337,15 +337,17 @@ static __always_inline int kmalloc_size(
>  struct memcg_cache_params {
>  	bool is_root_cache;
>  	union {
> -		struct kmem_cache *memcg_caches[0];
> -		struct {
> +		struct memcg_root_cache {
> +			struct kmem_cache *caches[0];
> +		} memcg_root_cache;
> +		struct memcg_child_cache {
>  			struct mem_cgroup *memcg;
>  			struct list_head list;
>  			struct kmem_cache *root_cache;
>  			bool dead;
>  			atomic_t nr_pages;
>  			struct work_struct destroy;
> -		};
> +		} memcg_child_cache;
>  	};
>  };
> 
> And then adopt the convention of selecting either memcg_root_cache or
> memcg_child_cache at the highest level then passing the more strongly
> typed pointer to callees.
> 

Since it is already creating problems, yes, I agree.

I will try to cook up something soon.
