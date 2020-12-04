From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm/memcontrol: make the slab calculation consistent
Date: Fri, 4 Dec 2020 10:46:13 -0500
Message-ID: <20201204154613.GA176901@cmpxchg.org>
References: <20201203031111.3187-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nwbnY1/AV2FFPs1NQO0btBf2+S5LCFRr1hUU4wSaSQQ=;
        b=hCSiWy3HwYppo4VxA8ax1Gw1Vky5CN2uyplFnDzpqV5sUx45gMT5u+D0dKhPJ24uif
         kIt5r7osKzB/LNSMvClSCCCssvQzyFWpZQv3zDXaOEQ+TAgDUgVWwAG5Oce2rARebo/d
         vQURlgZ1gSdu9kqPR5StVTkj0ZweBohSOI7GmsAVPmNQA381cNF36vu69Rx274gnYPcT
         wv6jNjFjq+av4h9y9xgXEd9gJeMEhxlBtk/aK85wocMiN3/bu3/3pGxuv8ngHrADpn9L
         il4t1Kuv5lvozpqGBjLp80sk0hh4vVAU/asrOM38P16qlOEXKmQrDaSAydzjpZzXaHDo
         N8Eg==
Content-Disposition: inline
In-Reply-To: <20201203031111.3187-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Thu, Dec 03, 2020 at 11:11:11AM +0800, Muchun Song wrote:
> Although the ratio of the slab is one, we also should read the ratio
> from the related memory_stats instead of hard-coding. And the local
> variable of size is already the value of slab_unreclaimable. So we
> do not need to read again. Simplify the code here.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <guro@fb.com>

I agree that ignoring the ratio right now is not very pretty, but

		size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
		       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
		seq_buf_printf(&s, "slab %llu\n", size);

is way easier to understand and more robust than using idx and idx + 1
and then requiring a series of BUG_ONs to ensure these two items are
actually adjacent and in the right order.

There is a redundant call to memcg_page_state(), granted, but that
function is extremely cheap compared with e.g. seq_buf_printf().

>  mm/memcontrol.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)

IMO this really just complicates the code with little discernible
upside. It's going to be a NAK from me, unfortunately.


In retrospect, I think that memory_stats[] table was a mistake. It
would probably be easier to implement this using a wrapper for
memcg_page_state() that has a big switch() for unit
conversion. Something like this:

/* Translate stat items to the correct unit for memory.stat output */
static unsigned long memcg_page_state_output(memcg, item)
{
	unsigned long value = memcg_page_state(memcg, item);
	int unit = PAGE_SIZE;

	switch (item) {
	case NR_SLAB_RECLAIMABLE_B:
	case NR_SLAB_UNRECLAIMABLE_B:
	case WORKINGSET_REFAULT_ANON:
	case WORKINGSET_REFAULT_FILE:
	case WORKINGSET_ACTIVATE_ANON:
	case WORKINGSET_ACTIVATE_FILE:
	case WORKINGSET_RESTORE_ANON:
	case WORKINGSET_RESTORE_FILE:
	case MEMCG_PERCPU_B:
		unit = 1;
		break;
	case NR_SHMEM_THPS:
	case NR_FILE_THPS:
	case NR_ANON_THPS:
		unit = HPAGE_PMD_SIZE;
		break;
	case NR_KERNEL_STACK_KB:
		unit = 1024;
		break;
	}
	
	return value * unit;
}

This would fix the ratio inconsistency, get rid of the awkward mix of
static and runtime initialization of the table, is probably about the
same amount of code, but simpler and more obvious overall.
