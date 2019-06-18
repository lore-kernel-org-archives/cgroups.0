From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Tue, 18 Jun 2019 09:12:59 +0300
Message-ID: <20190618061259.GB15497@rapoport-lnx>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
 <20190604142338.GC24467@lakrids.cambridge.arm.com>
 <20190610114326.GF15979@fuggles.cambridge.arm.com>
 <1560187575.6132.70.camel@lca.pw>
 <20190611100348.GB26409@lakrids.cambridge.arm.com>
 <20190613121100.GB25164@rapoport-lnx>
 <20190617151252.GF16810@rapoport-lnx>
 <20190617163630.GH30800@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:Message-Id:In-Reply-To:MIME-Version:
	References:Subject:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=kF+nEANiRuQxERUeFu7JrZqeShqC3Stuc6CtPWERSC4=; b=rYiyr6RUjGitAb
	sqJ8ZP8d2ICzhHBbhEIXLiz+xctoZ0uqyU7Q9vV+TtoxiQ90k0C4AvEV6Y/tcgm5fo6SHvj1GO6IU
	LTCSwAGUorw7Z7PZ2p/syaPx/k0bwghK1o4RxT7Ov0L3Ia4oWdLLCsPDK5VW6b9fXABK7u1qtFCle
	UdKokuwKLV5wBp6Pbv0isi38MfPhbIsxTck8v5wNJsNS4VGpRZ7E0pK4Y2i69ZkOlTkqjQwdZC0fD
	1lTHNpCzEngMFqhVyvpWBOZcxwQcPgVH9A0c6IZnMqlwdghjKRMt8CwbUli37HS743gak8jUIJ+Bt
	Lb6zbV09IsDV2lyVZblg==;
Content-Disposition: inline
In-Reply-To: <20190617163630.GH30800@fuggles.cambridge.arm.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, Qian Cai <cai@lca.pw>, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, akpm@linux-foundation.org, Roman Gushchin <guro@fb.com>, linux-arm-kernel@lists.infradead.org

On Mon, Jun 17, 2019 at 05:36:30PM +0100, Will Deacon wrote:
> Hi Mike,
> 
> On Mon, Jun 17, 2019 at 06:12:52PM +0300, Mike Rapoport wrote:
> > Andrew, can you please add the patch below as an incremental fix?
> > 
> > With this the arm64::pgd_alloc() should be in the right shape.
> > 
> > 
> > From 1c1ef0bc04c655689c6c527bd03b140251399d87 Mon Sep 17 00:00:00 2001
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > Date: Mon, 17 Jun 2019 17:37:43 +0300
> > Subject: [PATCH] arm64/mm: don't initialize pgd_cache twice
> > 
> > When PGD_SIZE != PAGE_SIZE, arm64 uses kmem_cache for allocation of PGD
> > memory. That cache was initialized twice: first through
> > pgtable_cache_init() alias and then as an override for weak
> > pgd_cache_init().
> > 
> > After enabling accounting for the PGD memory, this created a confusion for
> > memcg and slub sysfs code which resulted in the following errors:
> > 
> > [   90.608597] kobject_add_internal failed for pgd_cache(13:init.scope) (error: -2 parent: cgroup)
> > [   90.678007] kobject_add_internal failed for pgd_cache(13:init.scope) (error: -2 parent: cgroup)
> > [   90.713260] kobject_add_internal failed for pgd_cache(21:systemd-tmpfiles-setup.service) (error: -2 parent: cgroup)
> > 
> > Removing the alias from pgtable_cache_init() and keeping the only pgd_cache
> > initialization in pgd_cache_init() resolves the problem and allows
> > accounting of PGD memory.
> > 
> > Reported-by: Qian Cai <cai@lca.pw>
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> >  arch/arm64/include/asm/pgtable.h | 3 +--
> >  arch/arm64/mm/pgd.c              | 5 +----
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> Looks like this actually fixes caa841360134 ("x86/mm: Initialize PGD cache
> during mm initialization") due to an unlucky naming conflict!
> 
> In which case, I'd actually prefer to take this fix asap via the arm64
> tree. Is that ok?

I suppose so, it just won't apply as is. Would you like a patch against the
current upstream?

> Will

-- 
Sincerely yours,
Mike.
