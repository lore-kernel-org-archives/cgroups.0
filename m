From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: make the slab calculation consistent
Date: Wed, 2 Dec 2020 13:16:46 -0800
Message-ID: <20201202211646.GA1517142@carbon.lan>
References: <20201202121434.75099-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oZ07i7MpPX+Ffa5uHH9P9ixLS7lxGFSDBft5r+BM73k=;
 b=FZDEd0V6JTvtoSVNjgM3vjSbKyG1pDCOIGeWldc6qkuErdyKYxvJnsDFug4/sL8r1sZk
 LYHi9SB+eGN5D8i2CVKHsrNyHLn0EbV3h3JXTU4bnyAzzm+4V9J0FXygSkEhGGP3URND
 cnsexik/ASl6UT/prTByXrZZkHtSxYTXMsY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZ07i7MpPX+Ffa5uHH9P9ixLS7lxGFSDBft5r+BM73k=;
 b=PlzTcFYkXSV4Z3quW5nA6WNnPyupplJwK61vivweBSDOE17WXzliqPzgJwH3GtWKAc8soByUh0LG16FdqriIXYZhUZ8FZLvxCTTD9A+AmOQRNrVk2O5LGZwk3/PB/WkEYGFCQU7PU9Pf+j5rfxMRgJxBQSVk5rj+A3oCa/pMDsA=
Content-Disposition: inline
In-Reply-To: <20201202121434.75099-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 02, 2020 at 08:14:34PM +0800, Muchun Song wrote:
> Although the ratio of the slab is one, we also should read the ratio
> from the related memory_stats instead of hard-coding. And the local
> variable of size is already the value of slab_unreclaimable. So we
> do not need to read again. Simplify the code here.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/memcontrol.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)

Hi Muchun!

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9922f1510956..03a9c64560f6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1545,12 +1545,22 @@ static int __init memory_stats_init(void)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
> +		switch (memory_stats[i].idx) {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -		if (memory_stats[i].idx == NR_ANON_THPS ||
> -		    memory_stats[i].idx == NR_FILE_THPS ||
> -		    memory_stats[i].idx == NR_SHMEM_THPS)
> +		case NR_ANON_THPS:
> +		case NR_FILE_THPS:
> +		case NR_SHMEM_THPS:
>  			memory_stats[i].ratio = HPAGE_PMD_SIZE;
> +			break;
>  #endif
> +		case NR_SLAB_UNRECLAIMABLE_B:
> +			VM_BUG_ON(i < 1);
> +			VM_BUG_ON(memory_stats[i - 1].idx != NR_SLAB_RECLAIMABLE_B);

Please, convert these to BUILD_BUG_ON(), they don't have to be runtime checks.


> +			break;
> +		default:
> +			break;
> +		}
> +
>  		VM_BUG_ON(!memory_stats[i].ratio);
>  		VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
>  	}
> @@ -1587,8 +1597,10 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
>  		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
>

Can you, please, add a small comment here stating that we're printing
unreclaimable, reclaimable and the sum of both? It will simplify the reading of the code.

>  		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
> -			size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
> -			       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
> +			int idx = i - 1;
> +
> +			size += memcg_page_state(memcg, memory_stats[idx].idx) *
> +				memory_stats[idx].ratio;
>  			seq_buf_printf(&s, "slab %llu\n", size);
>  		}
>  	}

Otherwise the patch looks good to me! Please, feel free to add
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
after addressing my comments.

Thanks!
> -- 
> 2.11.0
> 
