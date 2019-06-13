From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Thu, 13 Jun 2019 15:11:01 +0300
Message-ID: <20190613121100.GB25164@rapoport-lnx>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
 <20190604142338.GC24467@lakrids.cambridge.arm.com>
 <20190610114326.GF15979@fuggles.cambridge.arm.com>
 <1560187575.6132.70.camel@lca.pw>
 <20190611100348.GB26409@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:Message-Id:In-Reply-To:MIME-Version:
	References:Subject:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=tr7pmhfluxBRJT3TYBEHVw1hFIE5h2qPGrTObry/IrM=; b=MxJ44idg0uje+y
	8JFJAI4GR2psqUMNMtBjYXPhjr3afAIWsTBluJQxkw8bAO8Sujeh3O7boQIq5RJ0MsqTk1Vw/Lhwp
	VJf6S1Xw0Scoi3M1fz97lQa2LmbueMqEGpRmpl9v/1M2gvPAaBQAFAW8o0wtGYFYezxXOzbwCsTyg
	ClGhcv6f9m0+13nflz9u0iebiWcPEcVPgFcJzTOmKYZeovB2TnwQLwphl8qIaGYRw7kQSPKqJkVKA
	0zGB1oS0GPfc9hTyrhFEBraKqkJTFhOTTWGUJ9EqmGszSdz0LlHNnVkhQKiIoSiLTviUg8PTeEZih
	ZvNB8mE6GoNAJXTmYHtQ==;
Content-Disposition: inline
In-Reply-To: <20190611100348.GB26409@lakrids.cambridge.arm.com>
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
To: Mark Rutland <mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, Qian Cai <cai@lca.pw>, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, akpm@linux-foundation.org, Roman Gushchin <guro@fb.com>, linux-arm-kernel@lists.infradead.org

(added Roman)

On Tue, Jun 11, 2019 at 11:03:49AM +0100, Mark Rutland wrote:
> On Mon, Jun 10, 2019 at 01:26:15PM -0400, Qian Cai wrote:
> > On Mon, 2019-06-10 at 12:43 +0100, Will Deacon wrote:
> > > On Tue, Jun 04, 2019 at 03:23:38PM +0100, Mark Rutland wrote:
> > > > On Tue, Jun 04, 2019 at 10:00:36AM -0400, Qian Cai wrote:
> > > > > The commit "arm64: switch to generic version of pte allocation"
> > > > > introduced endless failures during boot like,
> > > > > =

> > > > > kobject_add_internal failed for pgd_cache(285:chronyd.service) (e=
rror:
> > > > > -2 parent: cgroup)
> > > > > =

> > > > > It turns out __GFP_ACCOUNT is passed to kernel page table allocat=
ions
> > > > > and then later memcg finds out those don't belong to any cgroup.
> > > > =

> > > > Mike, I understood from [1] that this wasn't expected to be a probl=
em,
> > > > as the accounting should bypass kernel threads.
> > > > =

> > > > Was that assumption wrong, or is something different happening here?
> > > > =

> > > > > =

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
> > > > > =

> > > > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > > > ---
> > > > > =A0arch/arm64/mm/pgd.c | 2 +-
> > > > > =A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > > =

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
> > > > =

> > > > This is used to allocate PGDs for both user and kernel pagetables (=
e.g.
> > > > for the efi runtime services), so while this may fix the regression=
, I'm
> > > > not sure it's the right fix.
> > > > =

> > > > Do we need a separate pgd_alloc_kernel()?
> > > =

> > > So can I take the above for -rc5, or is somebody else working on a di=
fferent
> > > fix to implement pgd_alloc_kernel()?
> > =

> > The offensive commit "arm64: switch to generic version of pte allocatio=
n" is not
> > yet in the mainline, but only in the Andrew's tree and linux-next, and =
I doubt
> > Andrew will push this out any time sooner given it is broken.
> =

> I'd assumed that Mike would respin these patches to implement and use
> pgd_alloc_kernel() (or take gfp flags) and the updated patches would
> replace these in akpm's tree.
> =

> Mike, could you confirm what your plan is? I'm happy to review/test
> updated patches for arm64.

The log Qian Cai posted at [1] and partially cited below confirms that the
failure happens when *user* PGDs are allocated and the addition of
__GFP_ACCOUNT to gfp flags used by pgd_alloc() only uncovered another
issue.

I'm still failing to reproduce it with qemu and I'm not really familiar
with slub/memcg code to say anything smart about it. Will keep looking.

Note, that as failures start way after efi_virtmap_init() that allocates a
PGD for efi_mm, there are no real fixes required for the original series,
except that the check for mm =3D=3D &init_mm I copied for some reason from
powerpc is bogus and can be removed.

I surely can add pgd_alloc_kernel() to be used by the EFI code to make sure
we won't run into issues with memcg in the future.

[   82.125966] Freeing unused kernel memory: 28672K
[   87.940365] Checked W+X mappings: passed, no W+X pages found
[   87.946769] Run /init as init process
[   88.040040] systemd[1]: System time before build time, advancing clock.
[   88.054593] systemd[1]: Failed to insert module 'autofs4': No such file =
or directory
[   88.374129] modprobe (1726) used greatest stack depth: 28464 bytes left
[   88.470108] systemd[1]: systemd 239 running in system mode. (+PAM +AUDIT
+SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT
+GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2
default-hierarchy=3Dlegacy)
[   88.498398] systemd[1]: Detected architecture arm64.
[   88.506517] systemd[1]: Running in initial RAM disk.
[   89.621995] mkdir (1730) used greatest stack depth: 27872 bytes left
[   90.222658] random: systemd: uninitialized urandom read (16 bytes read)
[   90.230072] systemd[1]: Reached target Swap.
[   90.240205] random: systemd: uninitialized urandom read (16 bytes read)
[   90.251088] systemd[1]: Reached target Timers.
[   90.261303] random: systemd: uninitialized urandom read (16 bytes read)
[   90.271209] systemd[1]: Listening on udev Control Socket.
[   90.283238] systemd[1]: Reached target Local File Systems.
[   90.296232] systemd[1]: Reached target Slices.
[   90.307239] systemd[1]: Listening on udev Kernel Socket.
[   90.608597] kobject_add_internal failed for pgd_cache(13:init.scope) (er=
ror: -2 parent: cgroup)
[   90.678007] kobject_add_internal failed for pgd_cache(13:init.scope)(err=
or: -2 parent: cgroup)
[   90.713260] kobject_add_internal failed for pgd_cache(21:systemd-tmpfile=
s-setup.service) (error: -2 parent: cgroup)
[   90.820012] systemd-tmpfile (1759) used greatest stack depth: 27184 byte=
s left
[   90.861942] kobject_add_internal failed for pgd_cache(13:init.scope) err=
or: -2 parent: cgroup)
 =

> Thanks,
> Mark.
> =


[1] https://cailca.github.io/files/dmesg.txt

-- =

Sincerely yours,
Mike.
