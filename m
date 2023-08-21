From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] mm: Fix kernel-doc warning from tlb_flush_rmaps()
Date: Mon, 21 Aug 2023 17:51:34 +0300
Message-ID: <20230821145134.GB9849@kernel.org>
References: <20230818200630.2719595-1-willy@infradead.org>
 <20230818200630.2719595-2-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692629520;
        bh=o7TMneqKMD7yd3mxtbwuDOYsNFG2NCLJL2n2vsDbDak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M99vuKPwGvKRrYNdVSJYyDlnJ2w+2bMfB7rIbbb0zMav+2u04juf4V+a2CsgqzNDo
         zY6p3etAWgX2q0/22uvpOXZ/Wzv2xTeEA24KwFEji65i1wZTlYystv6gRAw4+2MQyU
         oaEd6VKB8db0tJ0jyQCgDFMURy4ykFZ8qlFZzqlpCL3m5/CT0XKkZ//9TDuKHgVv1B
         1bj5jxEglUDzU7LJyjnLgzdtFv9TCTgkDman9YPVSVaDL/+xpgTfKLthde6DWuRUfj
         mL5fOqnuU3mR99U8NW/yi1PUgJ+e9n5c7OFWa20Kvwh1o+Ql5Jeha1cJb0MI9W7Aaa
         CYGgkZ4MlB+0Q==
Content-Disposition: inline
In-Reply-To: <20230818200630.2719595-2-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 18, 2023 at 09:06:27PM +0100, Matthew Wilcox (Oracle) wrote:
> The vma parameter wasn't described.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Mike Rapoport (IBM) <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

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
> -- 
> 2.40.1
> 

-- 
Sincerely yours,
Mike.
