From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/8] mm: Use find_get_swap_page in memcontrol
Date: Wed, 26 Aug 2020 10:20:02 -0400
Message-ID: <20200826142002.GA988805@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-3-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9cipQfYQtv7cAiG+G38dpVGRbXrdKVedcuYm2vqWBLE=;
 b=r/aSAxJIwBhxZNYLfslR2WgJGk8qwXY7iEQclmhmk8/Z831e3QGoww9xiThSt0fEU1
 3PCNg6JDfrF1/obSDOg5HsFvZFIVHfQRu1wEC8OOFd01VUmXaBhZfoP40svMW802E1Tf
 3JM0RIrOw2BqmfIUSfn+mz+17yNzZAIeFBAzVEuU92gtGA0FhaBtdyMpFRnKxer1CMCB
 uRQRHSXbROCHtEjVH2hlrpYARZm43Cce7Ri3XnIpVGznmEarT4V3wLqHduh1Bx6VHn2P
 SpXJ+RpUhQnm0DVrncjQNiJ0vYYkEqEu1U1x+3Xu36kJKVEtOiBRhvf0vTaw+hdySoFf
 ns/g==
Content-Disposition: inline
In-Reply-To: <20200819184850.24779-3-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org, Matthew Auld <matthew.auld@intel.com>, Huang Ying <ying.huang@intel.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Aug 19, 2020 at 07:48:44PM +0100, Matthew Wilcox (Oracle) wrote:
> The current code does not protect against swapoff of the underlying
> swap device, so this is a bug fix as well as a worthwhile reduction in
> code complexity.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/memcontrol.c | 25 ++-----------------------
>  1 file changed, 2 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b807952b4d43..4075f214a841 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5539,35 +5539,14 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>  static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
>  			unsigned long addr, pte_t ptent, swp_entry_t *entry)
>  {
> -	struct page *page = NULL;
> -	struct address_space *mapping;
> -	pgoff_t pgoff;
> -
>  	if (!vma->vm_file) /* anonymous vma */
>  		return NULL;
>  	if (!(mc.flags & MOVE_FILE))
>  		return NULL;
>  
> -	mapping = vma->vm_file->f_mapping;
> -	pgoff = linear_page_index(vma, addr);
> -
>  	/* page is moved even if it's not RSS of this task(page-faulted). */
> -#ifdef CONFIG_SWAP
> -	/* shmem/tmpfs may report page out on swap: account for that too. */
> -	if (shmem_mapping(mapping)) {
> -		page = find_get_entry(mapping, pgoff);
> -		if (xa_is_value(page)) {
> -			swp_entry_t swp = radix_to_swp_entry(page);
> -			*entry = swp;
> -			page = find_get_page(swap_address_space(swp),
> -					     swp_offset(swp));
> -		}
> -	} else
> -		page = find_get_page(mapping, pgoff);
> -#else
> -	page = find_get_page(mapping, pgoff);
> -#endif
> -	return page;
> +	return find_get_swap_page(vma->vm_file->f_mapping,
> +			linear_page_index(vma, addr));

The refactor makes sense to me, but the name is confusing. We're not
looking for a swap page, we're primarily looking for a file page in
the page cache mapping that's handed in. Only in the special case
where it's a shmem mapping and there is a swap entry do we consult the
auxiliary swap cache.

How about find_get_page_or_swapcache()? find_get_page_shmemswap()?
Maybe you have a better idea. It's a fairly specialized operation that
isn't widely used, so a longer name isn't a bad thing IMO.
