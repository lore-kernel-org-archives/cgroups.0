From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Mon, 10 Jun 2019 13:26:15 -0400
Message-ID: <1560187575.6132.70.camel@lca.pw>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
         <20190604142338.GC24467@lakrids.cambridge.arm.com>
         <20190610114326.GF15979@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSkPLH9vDolbJlk5XvbY4CtX+5a/+fS/moYDl/wZCzc=;
        b=X3Tymq+lxR/tOVHDBtZz1webVwVCP2s2oH0yXtVQRx3F32sM/CMH9jfTJyOBuymJKm
         AbMh0J4rg6ag0Vr4a6szOR3XFKbXYEsuf2pDjpqlniCE88NG1+QgtA+I4bUYf20y6G5j
         qbmJ5YPzUYXwPkWRulV6e89Bz7Yi1Tac77kreGT6csAXiPEOiieFiFQIazrLMFSy6nkR
         os18qdAJHoUPec7y2vIYdi37NRolbTVYeS8VJKE9CK5NgF0+axbk/jMZYOoulIbJ90sY
         M840savZid7ZE8+ALK7/oDvvu4+jmXF3g66cBYskWNvrubs9qRXg+eJjoCiWfwQz2O5u
         SlJw==
In-Reply-To: <20190610114326.GF15979@fuggles.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: rppt@linux.ibm.com, akpm@linux-foundation.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Mon, 2019-06-10 at 12:43 +0100, Will Deacon wrote:
> On Tue, Jun 04, 2019 at 03:23:38PM +0100, Mark Rutland wrote:
> > On Tue, Jun 04, 2019 at 10:00:36AM -0400, Qian Cai wrote:
> > > The commit "arm64: switch to generic version of pte allocation"
> > > introduced endless failures during boot like,
> > > 
> > > kobject_add_internal failed for pgd_cache(285:chronyd.service) (error:
> > > -2 parent: cgroup)
> > > 
> > > It turns out __GFP_ACCOUNT is passed to kernel page table allocations
> > > and then later memcg finds out those don't belong to any cgroup.
> > 
> > Mike, I understood from [1] that this wasn't expected to be a problem,
> > as the accounting should bypass kernel threads.
> > 
> > Was that assumption wrong, or is something different happening here?
> > 
> > > 
> > > backtrace:
> > >   kobject_add_internal
> > >   kobject_init_and_add
> > >   sysfs_slab_add+0x1a8
> > >   __kmem_cache_create
> > >   create_cache
> > >   memcg_create_kmem_cache
> > >   memcg_kmem_cache_create_func
> > >   process_one_work
> > >   worker_thread
> > >   kthread
> > > 
> > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > ---
> > >  arch/arm64/mm/pgd.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
> > > index 769516cb6677..53c48f5c8765 100644
> > > --- a/arch/arm64/mm/pgd.c
> > > +++ b/arch/arm64/mm/pgd.c
> > > @@ -38,7 +38,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
> > >  	if (PGD_SIZE == PAGE_SIZE)
> > >  		return (pgd_t *)__get_free_page(gfp);
> > >  	else
> > > -		return kmem_cache_alloc(pgd_cache, gfp);
> > > +		return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_KERNEL);
> > 
> > This is used to allocate PGDs for both user and kernel pagetables (e.g.
> > for the efi runtime services), so while this may fix the regression, I'm
> > not sure it's the right fix.
> > 
> > Do we need a separate pgd_alloc_kernel()?
> 
> So can I take the above for -rc5, or is somebody else working on a different
> fix to implement pgd_alloc_kernel()?

The offensive commit "arm64: switch to generic version of pte allocation" is not
yet in the mainline, but only in the Andrew's tree and linux-next, and I doubt
Andrew will push this out any time sooner given it is broken.
