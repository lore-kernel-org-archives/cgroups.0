From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm/memcontrol: make the slab calculation consistent
Date: Fri, 4 Dec 2020 14:08:04 -0800
Message-ID: <20201204220804.GA1772002@carbon.DHCP.thefacebook.com>
References: <20201203031111.3187-1-songmuchun@bytedance.com>
 <20201204154613.GA176901@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xCuMDqKmf4r3RjVCZ2F0m5yMJtln7l6L8DwWpETl2Io=;
 b=OOF7DKvNZ8R8DHyZgHToP3x+DLMyPqteSVnnzaEZlB4+Z/FBrw+ZggS3FvQY9XSdRLof
 8lB9n0lkDGRuMS57uDKAlrq+SaTeC2auN0me+O7G33c/FgZ5Y6JvJTqcUZ49094Nl1zu
 9ptRHsqedhwgR59uGPvcdU65mJQ1da4Z08s= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCuMDqKmf4r3RjVCZ2F0m5yMJtln7l6L8DwWpETl2Io=;
 b=PuKiMuotcRiKWBHpSVC+vJD+J26B7RC+7kTXI2UJARhk+f+kAo7BfA34yZmCe40XK/wMi5ZboHC2REDuJMDcN+NS0r22kohTqGk70nYtFs3qNKBFmh/TiUIUwNmXDFPCsnjtk76Iqk5x4rbjM/0E2VVVJOJSlAPeTPg/TDy2dpg=
Content-Disposition: inline
In-Reply-To: <20201204154613.GA176901@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Dec 04, 2020 at 10:46:13AM -0500, Johannes Weiner wrote:
> On Thu, Dec 03, 2020 at 11:11:11AM +0800, Muchun Song wrote:
> > Although the ratio of the slab is one, we also should read the ratio
> > from the related memory_stats instead of hard-coding. And the local
> > variable of size is already the value of slab_unreclaimable. So we
> > do not need to read again. Simplify the code here.
> > 
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Acked-by: Roman Gushchin <guro@fb.com>
> 
> I agree that ignoring the ratio right now is not very pretty, but
> 
> 		size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
> 		       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
> 		seq_buf_printf(&s, "slab %llu\n", size);
> 
> is way easier to understand and more robust than using idx and idx + 1
> and then requiring a series of BUG_ONs to ensure these two items are
> actually adjacent and in the right order.
> 
> There is a redundant call to memcg_page_state(), granted, but that
> function is extremely cheap compared with e.g. seq_buf_printf().
> 
> >  mm/memcontrol.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> IMO this really just complicates the code with little discernible
> upside. It's going to be a NAK from me, unfortunately.
> 
> 
> In retrospect, I think that memory_stats[] table was a mistake. It
> would probably be easier to implement this using a wrapper for
> memcg_page_state() that has a big switch() for unit
> conversion. Something like this:

+1

> 
> /* Translate stat items to the correct unit for memory.stat output */
> static unsigned long memcg_page_state_output(memcg, item)
> {
> 	unsigned long value = memcg_page_state(memcg, item);
> 	int unit = PAGE_SIZE;
> 
> 	switch (item) {
> 	case NR_SLAB_RECLAIMABLE_B:
> 	case NR_SLAB_UNRECLAIMABLE_B:
> 	case WORKINGSET_REFAULT_ANON:
> 	case WORKINGSET_REFAULT_FILE:
> 	case WORKINGSET_ACTIVATE_ANON:
> 	case WORKINGSET_ACTIVATE_FILE:
> 	case WORKINGSET_RESTORE_ANON:
> 	case WORKINGSET_RESTORE_FILE:
> 	case MEMCG_PERCPU_B:
> 		unit = 1;
> 		break;
> 	case NR_SHMEM_THPS:
> 	case NR_FILE_THPS:
> 	case NR_ANON_THPS:
> 		unit = HPAGE_PMD_SIZE;
> 		break;
             ^^^^^^^^^^^^
These can be easily converted to ordinary pages,
so we can completely avoid this exception.

> 	case NR_KERNEL_STACK_KB:
> 		unit = 1024;
> 		break;
> 	}

And NR_KERNEL_STACK_KB can be converted to bytes.

Then we'll have everything kernel-related in bytes and
everything userspace-related in PAGE_SIZE's.

> 	
> 	return value * unit;
> }
> 
> This would fix the ratio inconsistency, get rid of the awkward mix of
> static and runtime initialization of the table, is probably about the
> same amount of code, but simpler and more obvious overall.

+1
