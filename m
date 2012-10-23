From: JoonSoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 05/18] slab/slub: struct memcg_params
Date: Wed, 24 Oct 2012 02:25:48 +0900
Message-ID: <CAAmzW4PVEb6WezFAjgNwYiAkNXE745ys6HejeNA4uRhUXqWe_g@mail.gmail.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
	<1350656442-1523-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=oiqp9Fh13omsNp6QhqpSiCxFN8EIC9eaL+dlZRZxhtI=;
        b=hEerwWuyeKQzs44X1ZHh9KOjq0Zrwk8pJL7yklGOG5A/6AfuVjJCCGXNg6fdNFbseA
         c6CyO/MlDMnBvSeJhwV1f0Vy0VUPYnFyu1g9gG0Yw5xcRSKVEi10n4q+4meebu2wLRq3
         ZNQRwmYvJU4WrhGvYKFZzX9gMJi258HaB4B+FerHNMSPEXqsLSI+v95JWT347GlK6Xuv
         nAsYjfoQIr/M3VgF/UbQ5kaAkfNAV0v1KZanNHVSyuvfQJj8hKzCMSTM4Onc7Cn2FaZc
         sof/G7jnsIHmXJMn+p9s5kkB4qpeGZMymIUnShhWftd+7oMV/uWexXMcPW5GcoOu6lnN
         aJAw==
In-Reply-To: <1350656442-1523-6-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

Hi, Glauber.

2012/10/19 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>:
> For the kmem slab controller, we need to record some extra
> information in the kmem_cache structure.
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Signed-off-by: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/linux/slab.h     | 25 +++++++++++++++++++++++++
>  include/linux/slab_def.h |  3 +++
>  include/linux/slub_def.h |  3 +++
>  mm/slab.h                | 13 +++++++++++++
>  4 files changed, 44 insertions(+)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 0dd2dfa..e4ea48a 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -177,6 +177,31 @@ unsigned int kmem_cache_size(struct kmem_cache *);
>  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>  #endif
>
> +#include <linux/workqueue.h>

Why workqueue.h is includede at this time?
It may be future use, so is it better to add it later?
Adding it at proper time makes git blame works better.
