From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/4] mm: Fix kernel-doc warning from tlb_flush_rmaps()
Date: Sat, 19 Aug 2023 17:51:45 -0700
Message-ID: <c9f237da-011c-00fa-77e4-f92141b2d573@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
 <20230818200630.2719595-2-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=z6tDJX3iE9WkH16DGbZfC/qfqDY64xLkrMSU2jg2cjI=; b=MN5+pzncrWpz6PLPg4sKOAsFqm
        C3lwrWECiZUOvaPW819HaqQiJzMesSNHsLHNb1xijoV8EgZ8TS8eBN7bLaTrbHD7OyykpU6Z7/2x+
        zUnytDizw77mSs5cUqlDmeE0DFbHDCfgQxXGB7XCUAWPYabT8eRsovW6fRBi2C5Wi6uypuvh/OwGJ
        Ii6kplUNzf6uALPy8Um5g4uP49tmtAXN7bufd0iSK+CNT1DfsFN/qV/H2eHbFmMtn4CHrSJFksLXV
        koqWx+NdEilYR3dLgK0Z4/CMeZ+9/tmLTSPQLogyOgh3+Y8LZgcDklViNPYgkagDZ8k/Ix+hGMWU1
        4hdiTZFA==;
Content-Language: en-US
In-Reply-To: <20230818200630.2719595-2-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 8/18/23 13:06, Matthew Wilcox (Oracle) wrote:
> The vma parameter wasn't described.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Thanks.

> ---
>  mm/mmu_gather.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index ea9683e12936..4f559f4ddd21 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -63,6 +63,7 @@ static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_
>  /**
>   * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
>   * @tlb: the current mmu_gather
> + * @vma: The memory area from which the pages are being removed.
>   *
>   * Note that because of how tlb_next_batch() above works, we will
>   * never start multiple new batches with pending delayed rmaps, so

-- 
~Randy
