From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Tue, 4 Jun 2019 17:54:22 +0300
Message-ID: <20190604145422.GG8417@rapoport-lnx>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
 <20190604142338.GC24467@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190604142338.GC24467@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Qian Cai <cai@lca.pw>, akpm@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, guro@fb.com, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Tue, Jun 04, 2019 at 03:23:38PM +0100, Mark Rutland wrote:
> On Tue, Jun 04, 2019 at 10:00:36AM -0400, Qian Cai wrote:
> > The commit "arm64: switch to generic version of pte allocation"
> > introduced endless failures during boot like,
> > 
> > kobject_add_internal failed for pgd_cache(285:chronyd.service) (error:
> > -2 parent: cgroup)
> > 
> > It turns out __GFP_ACCOUNT is passed to kernel page table allocations
> > and then later memcg finds out those don't belong to any cgroup.
> 
> Mike, I understood from [1] that this wasn't expected to be a problem,
> as the accounting should bypass kernel threads.
> 
> Was that assumption wrong, or is something different happening here?

I was under impression that all allocations are going through
__memcg_kmem_charge() which does the bypass.

Apparently, it's not the case :(

> > 
> > backtrace:
> >   kobject_add_internal
> >   kobject_init_and_add
> >   sysfs_slab_add+0x1a8
> >   __kmem_cache_create
> >   create_cache
> >   memcg_create_kmem_cache
> >   memcg_kmem_cache_create_func
> >   process_one_work
> >   worker_thread
> >   kthread
> > 
> > Signed-off-by: Qian Cai <cai@lca.pw>
> > ---
> >  arch/arm64/mm/pgd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
> > index 769516cb6677..53c48f5c8765 100644
> > --- a/arch/arm64/mm/pgd.c
> > +++ b/arch/arm64/mm/pgd.c
> > @@ -38,7 +38,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
> >  	if (PGD_SIZE == PAGE_SIZE)
> >  		return (pgd_t *)__get_free_page(gfp);
> >  	else
> > -		return kmem_cache_alloc(pgd_cache, gfp);
> > +		return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_KERNEL);
> 
> This is used to allocate PGDs for both user and kernel pagetables (e.g.
> for the efi runtime services), so while this may fix the regression, I'm
> not sure it's the right fix.

Me neither.
 
> Do we need a separate pgd_alloc_kernel()?
 
I'd like to take a closer look at memcg paths once again before adding
pgd_alloc_kernel().

Johannes, Roman, can you please advise anything?

> Thanks,
> Mark.
> 
> [1] https://lkml.kernel.org/r/20190505061956.GE15755@rapoport-lnx
> 

-- 
Sincerely yours,
Mike.

