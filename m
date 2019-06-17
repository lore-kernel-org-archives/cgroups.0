From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Mon, 17 Jun 2019 18:12:52 +0300
Message-ID: <20190617151252.GF16810@rapoport-lnx>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
 <20190604142338.GC24467@lakrids.cambridge.arm.com>
 <20190610114326.GF15979@fuggles.cambridge.arm.com>
 <1560187575.6132.70.camel@lca.pw>
 <20190611100348.GB26409@lakrids.cambridge.arm.com>
 <20190613121100.GB25164@rapoport-lnx>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190613121100.GB25164@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mark Rutland <mark.rutland@arm.com>
Cc: Qian Cai <cai@lca.pw>, Will Deacon <will.deacon@arm.com>, akpm@linux-foundation.org, Roman Gushchin <guro@fb.com>, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Thu, Jun 13, 2019 at 03:11:01PM +0300, Mike Rapoport wrote:
> On Tue, Jun 11, 2019 at 11:03:49AM +0100, Mark Rutland wrote:
> > On Mon, Jun 10, 2019 at 01:26:15PM -0400, Qian Cai wrote:
> > > On Mon, 2019-06-10 at 12:43 +0100, Will Deacon wrote:
> > > > On Tue, Jun 04, 2019 at 03:23:38PM +0100, Mark Rutland wrote:
> > > > > On Tue, Jun 04, 2019 at 10:00:36AM -0400, Qian Cai wrote:
> > > > > > The commit "arm64: switch to generic version of pte allocation"
> > > > > > introduced endless failures during boot like,
> > > > > >=20
> > > > > > kobject_add_internal failed for pgd_cache(285:chronyd.service) =
(error:
> > > > > > -2 parent: cgroup)
> > > > > >=20
> > > > > > It turns out __GFP_ACCOUNT is passed to kernel page table alloc=
ations
> > > > > > and then later memcg finds out those don't belong to any cgroup.
> > > > >=20
> > > > > Mike, I understood from [1] that this wasn't expected to be a pro=
blem,
> > > > > as the accounting should bypass kernel threads.
> > > > >=20
> > > > > Was that assumption wrong, or is something different happening he=
re?
> > > > >=20
> > > > > >=20
> > > > > > backtrace:
> > > > > > =A0 kobject_add_internal
> > > > > > =A0 kobject_init_and_add
> > > > > > =A0 sysfs_slab_add+0x1a8
> > > > > > =A0 __kmem_cache_create
> > > > > > =A0 create_cache
> > > > > > =A0 memcg_create_kmem_cache
> > > > > > =A0 memcg_kmem_cache_create_func
> > > > > > =A0 process_one_work
> > > > > > =A0 worker_thread
> > > > > > =A0 kthread
> > > > > >=20
> > > > > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > > > > ---
> > > > > > =A0arch/arm64/mm/pgd.c | 2 +-
> > > > > > =A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >=20
> > > > > > diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
> > > > > > index 769516cb6677..53c48f5c8765 100644
> > > > > > --- a/arch/arm64/mm/pgd.c
> > > > > > +++ b/arch/arm64/mm/pgd.c
> > > > > > @@ -38,7 +38,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
> > > > > > =A0	if (PGD_SIZE =3D=3D PAGE_SIZE)
> > > > > > =A0		return (pgd_t *)__get_free_page(gfp);
> > > > > > =A0	else
> > > > > > -		return kmem_cache_alloc(pgd_cache, gfp);
> > > > > > +		return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_KERNEL);
> > > > >=20
> > > > > This is used to allocate PGDs for both user and kernel pagetables=
 (e.g.
> > > > > for the efi runtime services), so while this may fix the regressi=
on, I'm
> > > > > not sure it's the right fix.
> > > > >=20
> > > > > Do we need a separate pgd_alloc_kernel()?
> > > >=20
> > > > So can I take the above for -rc5, or is somebody else working on a =
different
> > > > fix to implement pgd_alloc_kernel()?
> > >=20
> > > The offensive commit "arm64: switch to generic version of pte allocat=
ion" is not
> > > yet in the mainline, but only in the Andrew's tree and linux-next, an=
d I doubt
> > > Andrew will push this out any time sooner given it is broken.
> >=20
> > I'd assumed that Mike would respin these patches to implement and use
> > pgd_alloc_kernel() (or take gfp flags) and the updated patches would
> > replace these in akpm's tree.
> >=20
> > Mike, could you confirm what your plan is? I'm happy to review/test
> > updated patches for arm64.
>=20
> The log Qian Cai posted at [1] and partially cited below confirms that the
> failure happens when *user* PGDs are allocated and the addition of
> __GFP_ACCOUNT to gfp flags used by pgd_alloc() only uncovered another
> issue.

Indeed the accounting of the PGD memory uncovered a dangling pointer to
pgd_cache :)

The pgd_cache was initialized twice and it made memcg and slub sysfs go
nuts. To be frank, I've got lost in their cross-initialization,
cross-referencing and update sequences, but for sure extra initialization
of pgd_cache was bogus.

I've double checked the 'if (mm =3D=3D &init_mm)' and it's not needed. The =
EFI
PGD is allocated before memcg is up and other kernel allocations of pgd (if
we'll have any) would be bypassed by memcg_kmem_bypass().

Andrew, can you please add the patch below as an incremental fix?

With this the arm64::pgd_alloc() should be in the right shape.


From 1c1ef0bc04c655689c6c527bd03b140251399d87 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Mon, 17 Jun 2019 17:37:43 +0300
Subject: [PATCH] arm64/mm: don't initialize pgd_cache twice

When PGD_SIZE !=3D PAGE_SIZE, arm64 uses kmem_cache for allocation of PGD
memory. That cache was initialized twice: first through
pgtable_cache_init() alias and then as an override for weak
pgd_cache_init().

After enabling accounting for the PGD memory, this created a confusion for
memcg and slub sysfs code which resulted in the following errors:

[   90.608597] kobject_add_internal failed for pgd_cache(13:init.scope) (er=
ror: -2 parent: cgroup)
[   90.678007] kobject_add_internal failed for pgd_cache(13:init.scope) (er=
ror: -2 parent: cgroup)
[   90.713260] kobject_add_internal failed for pgd_cache(21:systemd-tmpfile=
s-setup.service) (error: -2 parent: cgroup)

Removing the alias from pgtable_cache_init() and keeping the only pgd_cache
initialization in pgd_cache_init() resolves the problem and allows
accounting of PGD memory.

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/arm64/include/asm/pgtable.h | 3 +--
 arch/arm64/mm/pgd.c              | 5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgta=
ble.h
index 3191b9f..c7a802d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -851,8 +851,7 @@ extern int kern_addr_valid(unsigned long addr);
=20
 #include <asm-generic/pgtable.h>
=20
-void pgd_cache_init(void);
-#define pgtable_cache_init	pgd_cache_init
+static inline void pgtable_cache_init(void) { }
=20
 /*
  * On AArch64, the cache coherency is handled via the set_pte_at() functio=
n.
diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
index 53c48f5..3f0a744 100644
--- a/arch/arm64/mm/pgd.c
+++ b/arch/arm64/mm/pgd.c
@@ -32,13 +32,10 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	gfp_t gfp =3D GFP_PGTABLE_USER;
=20
-	if (unlikely(mm =3D=3D &init_mm))
-		gfp =3D GFP_PGTABLE_KERNEL;
-
 	if (PGD_SIZE =3D=3D PAGE_SIZE)
 		return (pgd_t *)__get_free_page(gfp);
 	else
-		return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_KERNEL);
+		return kmem_cache_alloc(pgd_cache, gfp);
 }
=20
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
--=20
2.7.4


> [1] https://cailca.github.io/files/dmesg.txt
>=20
> --=20
> Sincerely yours,
> Mike.
>=20

--=20
Sincerely yours,
Mike.

