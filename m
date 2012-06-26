From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 05/11] Add a __GFP_KMEMCG flag
Date: Mon, 25 Jun 2012 21:25:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206252123230.26640@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=DctB6vkFEtfki3Ar6GnvhKliU+MMSjOhfdjL0qUMhtI=;
        b=fkCJ0q/cRbURkrl8XFiYDKizdXvm2bLXFO3DsICRjXS5M5MkbqkE2+7r7W9J1DF8cR
         HPUmHTfgoD8QfQFSw3UGXEJmVgJsTKUg+GZQ1ikdMeLYuWeoWUcg1DxLuL/MPRhTzldk
         8in6W3AJqV5YDyapLmlvMHKS2Hup6YsYNZisTAJ+Z8R2FZi2xa5arylDUjEduMiigf1r
         787hATuHTTZZzLBsUquyFvnSR/r/Iec8z0Izpo1mJdulBDe4Knf12HsZIkwaOAtRquaF
         zaKrwdh3SbpuwQlwTIFSVwD1TOQwwrbPaxgIu4tgZt4NPcffBCCvPtuvAHQV3kAv0vOx
         0hmg==
In-Reply-To: <1340633728-12785-6-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Mon, 25 Jun 2012, Glauber Costa wrote:

> This flag is used to indicate to the callees that this allocation will be
> serviced to the kernel. It is not supposed to be passed by the callers
> of kmem_cache_alloc, but rather by the cache core itself.
> 

Not sure what "serviced to the kernel" means, does this mean that the 
memory will not be accounted for to the root memcg?

> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> ---
>  include/linux/gfp.h |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 1e49be4..8f4079f 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -37,6 +37,9 @@ struct vm_area_struct;
>  #define ___GFP_NO_KSWAPD	0x400000u
>  #define ___GFP_OTHER_NODE	0x800000u
>  #define ___GFP_WRITE		0x1000000u
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +#define ___GFP_KMEMCG		0x2000000u
> +#endif
>  
>  /*
>   * GFP bitmasks..
> @@ -88,13 +91,16 @@ struct vm_area_struct;
>  #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
>  #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
>  
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +#define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG)/* Allocation comes from a memcg-accounted resource */
> +#endif

Needs a space.

>  /*
>   * This may seem redundant, but it's a way of annotating false positives vs.
>   * allocations that simply cannot be supported (e.g. page tables).
>   */
>  #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
>  
> -#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
> +#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>  
>  /* This equals 0, but use constants in case they ever change */

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
