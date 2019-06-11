From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Tue, 11 Jun 2019 15:41:19 +0300
Message-ID: <20190611124118.GA4761@rapoport-lnx>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
 <20190604142338.GC24467@lakrids.cambridge.arm.com>
 <20190610114326.GF15979@fuggles.cambridge.arm.com>
 <1560187575.6132.70.camel@lca.pw>
 <20190611100348.GB26409@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190611100348.GB26409@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mark Rutland <mark.rutland@arm.com>
Cc: Qian Cai <cai@lca.pw>, Will Deacon <will.deacon@arm.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Tue, Jun 11, 2019 at 11:03:49AM +0100, Mark Rutland wrote:
> On Mon, Jun 10, 2019 at 01:26:15PM -0400, Qian Cai wrote:
> > On Mon, 2019-06-10 at 12:43 +0100, Will Deacon wrote:
> > > On Tue, Jun 04, 2019 at 03:23:38PM +0100, Mark Rutland wrote:
> > > > On Tue, Jun 04, 2019 at 10:00:36AM -0400, Qian Cai wrote:
> > > > > The commit "arm64: switch to generic version of pte allocation"
> > > > > introduced endless failures during boot like,
> > > > >=20
> > > > > kobject_add_internal failed for pgd_cache(285:chronyd.service) (e=
rror:
> > > > > -2 parent: cgroup)
> > > > >=20
> > > > > It turns out __GFP_ACCOUNT is passed to kernel page table allocat=
ions
> > > > > and then later memcg finds out those don't belong to any cgroup.
> > > >=20
> > > > Mike, I understood from [1] that this wasn't expected to be a probl=
em,
> > > > as the accounting should bypass kernel threads.
> > > >=20
> > > > Was that assumption wrong, or is something different happening here?
> > > >=20
> > > > >=20
> > > > > backtrace:
> > > > > =A0 kobject_add_internal
> > > > > =A0 kobject_init_and_add
> > > > > =A0 sysfs_slab_add+0x1a8
> > > > > =A0 __kmem_cache_create
> > > > > =A0 create_cache
> > > > > =A0 memcg_create_kmem_cache
> > > > > =A0 memcg_kmem_cache_create_func
> > > > > =A0 process_one_work
> > > > > =A0 worker_thread
> > > > > =A0 kthread
> > > > >=20
> > > > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > > > ---
> > > > > =A0arch/arm64/mm/pgd.c | 2 +-
> > > > > =A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
> > > > > index 769516cb6677..53c48f5c8765 100644
> > > > > --- a/arch/arm64/mm/pgd.c
> > > > > +++ b/arch/arm64/mm/pgd.c
> > > > > @@ -38,7 +38,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
> > > > > =A0	if (PGD_SIZE =3D=3D PAGE_SIZE)
> > > > > =A0		return (pgd_t *)__get_free_page(gfp);
> > > > > =A0	else
> > > > > -		return kmem_cache_alloc(pgd_cache, gfp);
> > > > > +		return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_KERNEL);
> > > >=20
> > > > This is used to allocate PGDs for both user and kernel pagetables (=
e.g.
> > > > for the efi runtime services), so while this may fix the regression=
, I'm
> > > > not sure it's the right fix.
> > > >=20
> > > > Do we need a separate pgd_alloc_kernel()?
> > >=20
> > > So can I take the above for -rc5, or is somebody else working on a di=
fferent
> > > fix to implement pgd_alloc_kernel()?
> >=20
> > The offensive commit "arm64: switch to generic version of pte allocatio=
n" is not
> > yet in the mainline, but only in the Andrew's tree and linux-next, and =
I doubt
> > Andrew will push this out any time sooner given it is broken.
>=20
> I'd assumed that Mike would respin these patches to implement and use
> pgd_alloc_kernel() (or take gfp flags) and the updated patches would
> replace these in akpm's tree.
>=20
> Mike, could you confirm what your plan is? I'm happy to review/test
> updated patches for arm64.

Sorry for the delay, I'm mostly offline these days.

I wanted to understand first what is the reason for the failure. I've tried
to reproduce it with qemu, but I failed to find a bootable configuration
that will have PGD_SIZE !=3D PAGE_SIZE :(

Qian Cai, can you share what is your environment and the kernel config?
=20
> Thanks,
> Mark.
>=20

--=20
Sincerely yours,
Mike.

