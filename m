From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 7/9] slab: introduce __kmemcg_cache_deactivate()
Date: Sat, 14 Jan 2017 16:42:11 +0300
Message-ID: <20170114134211.GF2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-8-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=RmfB1NHyfF7OQGXXapLW4crDnt4N7kndhc6bAehdZbM=;
        b=Yyz8OVxAEKmfnqPte65cqSP7T8TITQYCZ3ODmr5f5r9CNapbivbx+YlHtOFMngWa4/TGum4RNbjHc6pyZrtaU9I6mLEJZkJdOL+ydlse6vgV/ZdJGihEQg8IrvWlDDmBVzJKXYP6QdXFykcw9TDlw+diu9YKouBBiAqq7zKbCA4=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-8-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 12:54:47AM -0500, Tejun Heo wrote:
> __kmem_cache_shrink() is called with %true @deactivate only for memcg
> caches.  Remove @deactivate from __kmem_cache_shrink() and introduce
> __kmemcg_cache_deactivate() instead.  Each memcg-supporting allocator
> should implement it and it should deactivate and drain the cache.
> 
> This is to allow memcg cache deactivation behavior to further deviate
> from simple shrinking without messing up __kmem_cache_shrink().
> 
> This is pure reorganization and doesn't introduce any observable
> behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

...
> diff --git a/mm/slab.h b/mm/slab.h
> index 8f47a44..73ed6b5 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -164,7 +164,10 @@ static inline unsigned long kmem_cache_flags(unsigned long object_size,
>  
>  int __kmem_cache_shutdown(struct kmem_cache *);
>  void __kmem_cache_release(struct kmem_cache *);
> -int __kmem_cache_shrink(struct kmem_cache *, bool);
> +int __kmem_cache_shrink(struct kmem_cache *);
> +#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
> +void __kmemcg_cache_deactivate(struct kmem_cache *s);
> +#endif

nit: ifdef is not necessary
