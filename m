From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 22/33] mm: Convert struct page to struct slab in
 functions used by other subsystems
Date: Tue, 14 Dec 2021 15:31:13 +0100
Message-ID: <YbiqseeMBeqbn5CR@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-23-vbabka@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PnyBX2cL3sw5aLNMKdlSdA2yt3vqpypZzbVoHtQrrVM=;
        b=wZQgz4iU8dcVuhq+qYq/G7JuK2OMB/oVTHlwJL/bGG8B1tlSX7/4hh4ix6KV0qclCe
         i0p8A7YvgdoSpgXZ/SxRZlPpizsWJShi6R94vn29FY7VRmBOcMDDxHeSIA1NnYhxyNuc
         d9SPlqd44LLK+PovtTV3viokDxrETGdMx0CFnL6zi4frZMiAmHmjHjVTcG+xzpIL83UH
         QPOoFB9Qsoc13xmJdPxzR1/IbsYCdSMaxQ4Z+h1pdkhF7y0wmIKTliqukN6tM1HwBG1v
         9+KC78lRYmxL23WMEmFgQvThoJ+vPtAVEQr6sUPuT8Ewb3OCafsexZCaYI7y5UahftT+
         qZZQ==
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-23-vbabka-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 01, 2021 at 07:14:59PM +0100, Vlastimil Babka wrote:
> KASAN, KFENCE and memcg interact with SLAB or SLUB internals through functions
> nearest_obj(), obj_to_index() and objs_per_slab() that use struct page as
> parameter. This patch converts it to struct slab including all callers, through
> a coccinelle semantic patch.
> 
> // Options: --include-headers --no-includes --smpl-spacing include/linux/slab_def.h include/linux/slub_def.h mm/slab.h mm/kasan/*.c mm/kfence/kfence_test.c mm/memcontrol.c mm/slab.c mm/slub.c
> // Note: needs coccinelle 1.1.1 to avoid breaking whitespace
> 
> @@
> @@
> 
> -objs_per_slab_page(
> +objs_per_slab(
>  ...
>  )
>  { ... }
> 
> @@
> @@
> 
> -objs_per_slab_page(
> +objs_per_slab(
>  ...
>  )
> 
> @@
> identifier fn =~ "obj_to_index|objs_per_slab";
> @@
> 
>  fn(...,
> -   const struct page *page
> +   const struct slab *slab
>     ,...)
>  {
> <...
> (
> - page_address(page)
> + slab_address(slab)
> |
> - page
> + slab
> )
> ...>
>  }
> 
> @@
> identifier fn =~ "nearest_obj";
> @@
> 
>  fn(...,
> -   struct page *page
> +   const struct slab *slab
>     ,...)
>  {
> <...
> (
> - page_address(page)
> + slab_address(slab)
> |
> - page
> + slab
> )
> ...>
>  }
> 
> @@
> identifier fn =~ "nearest_obj|obj_to_index|objs_per_slab";
> expression E;
> @@
> 
>  fn(...,
> (
> - slab_page(E)
> + E
> |
> - virt_to_page(E)
> + virt_to_slab(E)
> |
> - virt_to_head_page(E)
> + virt_to_slab(E)
> |
> - page
> + page_slab(page)
> )
>   ,...)
> 
> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>
> Cc: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
> Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

LGTM.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
