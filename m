From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 3/4] mm: Fix clean_record_shared_mapping_range kernel-doc
Date: Mon, 21 Aug 2023 17:54:34 +0300
Message-ID: <20230821145434.GD9849@kernel.org>
References: <20230818200630.2719595-1-willy@infradead.org>
 <20230818200630.2719595-4-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692629699;
        bh=48bXFABCG3RekOXEork4KjEus4UPEb02K4FMMIA6aIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lw3R69kcL91pV8PMKSoZRXOEtIj7oHZ39cPwDwsQVsiK/fRZKt37Mza2ihKYPDvhz
         KU2WO32msinRqUGwu2iPSRZNx0BPXQpNwSEY0ilytvnKrH6h8MMkqh9dzAFnK079ig
         c5toYLnPdDGJJsdRy2pQTROxMNrxSN+xVUHKZBESQbC24/ZbnKsAkKdSBW/u+4GNtO
         r6NlJzZI5Oq4eDY4a3xNMViUbEGDo11RNo27j3nUcasVlwPr1II0Ctss4iHhRc2Z23
         lBB/R2A5poZz2xF+AjO9c7ygNDG+IZlVe7oyNRxaSjRILKcl+L9l7t3xOO32N819Rb
         9HUcYiYdUWHUw==
Content-Disposition: inline
In-Reply-To: <20230818200630.2719595-4-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Aug 18, 2023 at 09:06:29PM +0100, Matthew Wilcox (Oracle) wrote:
> Turn the a), b) into an unordered ReST list and remove the unnecessary
> 'Note:' prefix.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>

> ---
>  mm/mapping_dirty_helpers.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
> index a26dd8bcfcdb..2f8829b3541a 100644
> --- a/mm/mapping_dirty_helpers.c
> +++ b/mm/mapping_dirty_helpers.c
> @@ -288,13 +288,14 @@ EXPORT_SYMBOL_GPL(wp_shared_mapping_range);
>   * @end: Pointer to the number of the last set bit in @bitmap.
>   * none set. The value is modified as new bits are set by the function.
>   *
> - * Note: When this function returns there is no guarantee that a CPU has
> + * When this function returns there is no guarantee that a CPU has
>   * not already dirtied new ptes. However it will not clean any ptes not
>   * reported in the bitmap. The guarantees are as follows:
> - * a) All ptes dirty when the function starts executing will end up recorded
> - *    in the bitmap.
> - * b) All ptes dirtied after that will either remain dirty, be recorded in the
> - *    bitmap or both.
> + *
> + * * All ptes dirty when the function starts executing will end up recorded
> + *   in the bitmap.
> + * * All ptes dirtied after that will either remain dirty, be recorded in the
> + *   bitmap or both.
>   *
>   * If a caller needs to make sure all dirty ptes are picked up and none
>   * additional are added, it first needs to write-protect the address-space
> -- 
> 2.40.1
> 

-- 
Sincerely yours,
Mike.
