From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/8] mm: Use find_get_swap_page in memcontrol
Date: Wed, 26 Aug 2020 12:26:47 -0400
Message-ID: <20200826162647.GA995045@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-3-willy@infradead.org>
 <20200826142002.GA988805@cmpxchg.org>
 <20200826145414.GS17456@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+AffAjKsRXV4iuuUyWXhmFhrbRKp4ijCwhOH6K1QUoM=;
 b=zTWK1kAaol1sXKzKa6Zh0erJPvRLYszBA6l3yTnCoVH1T8/16/AW1V2nsDX9y2EX9B
 vDiOxAlRGWwrxcKHjAxU7j78zHdQwgGe/v70HlXNkP5X2hCozTh8lik5JFO2+R01Ei67
 h9aE6og5sbeZ7AFl8Lu8+u4Ek1C+h9N66vnSS2jqAX7DwFlLUw8wTnH7RS4/hMhxJygL
 N2Y5K4YgzBaAhiNjLgLPYJO5vbwE102QQsoK+Ha2mp3sz4VVikKedZRfUVAz/iWuX19Y
 DmmVCSiYFWZc6j+9h4hnBnvooK7Kb0Jc2IWSn+vIp4ddlDhyvd2dEAXNN8LGa3SwG/Mw
 02QQ==
Content-Disposition: inline
In-Reply-To: <20200826145414.GS17456@casper.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org, Matthew Auld <matthew.auld@intel.com>, Huang Ying <ying.huang@intel.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Aug 26, 2020 at 03:54:14PM +0100, Matthew Wilcox wrote:
> On Wed, Aug 26, 2020 at 10:20:02AM -0400, Johannes Weiner wrote:
> > On Wed, Aug 19, 2020 at 07:48:44PM +0100, Matthew Wilcox (Oracle) wrote:
> > > +	return find_get_swap_page(vma->vm_file->f_mapping,
> > > +			linear_page_index(vma, addr));
> > 
> > The refactor makes sense to me, but the name is confusing. We're not
> > looking for a swap page, we're primarily looking for a file page in
> > the page cache mapping that's handed in. Only in the special case
> > where it's a shmem mapping and there is a swap entry do we consult the
> > auxiliary swap cache.
> > 
> > How about find_get_page_or_swapcache()? find_get_page_shmemswap()?
> > Maybe you have a better idea. It's a fairly specialized operation that
> > isn't widely used, so a longer name isn't a bad thing IMO.
> 
> Yeah, I had trouble with the naming here too.
> 
> get_page_even_from_swap()
> find_get_shmem_page()
> 
> or maybe refactor the whole thing:
> 
> 	struct page *page = find_get_entry(mapping, index);
> 	page = find_swap_page(mapping, page);
> 
> struct page *find_swap_page(struct address_space *mapping, struct page *page)
> {
> 	swp_entry_t swp;
> 	struct swap_info_struct *si;
> 
> 	if (!xa_is_value(page))
> 		return page;
> 	if (!shmem_mapping(mapping))
> 		return NULL;
> 
> 	...
> }

Yeah, I like the idea of two lookups if we can't find a good name for
the operation that combines them. I'd just bubble the control flow
that links them up to the callsite - that still seems plenty compact
for two callsites, and keeps all the shmem magic in shmem code:

	page = find_get_entry(mapping, index);
	if (xa_is_value(page))
		if (shmem_mapping(mapping))
			page = lookup_shmem_swap_cache(page);
		else
			page = NULL;

So close to making radix_to_swp_entry() & co. private to shmem.c, too
- if it weren't for force_shm_swapin_readahead(). Ah well.
