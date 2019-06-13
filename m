From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH -next] arm64/mm: fix a bogus GFP flag in pgd_alloc()
Date: Thu, 13 Jun 2019 22:44:28 +0300
Message-ID: <20190613194427.GC25164@rapoport-lnx>
References: <1559656836-24940-1-git-send-email-cai@lca.pw>
 <20190604142338.GC24467@lakrids.cambridge.arm.com>
 <20190610114326.GF15979@fuggles.cambridge.arm.com>
 <1560187575.6132.70.camel@lca.pw>
 <20190611100348.GB26409@lakrids.cambridge.arm.com>
 <20190613121100.GB25164@rapoport-lnx>
 <1560432156.5154.11.camel@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1560432156.5154.11.camel@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Qian Cai <cai@lca.pw>
Cc: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, akpm@linux-foundation.org, Roman Gushchin <guro@fb.com>, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org, vdavydov.dev@gmail.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Thu, Jun 13, 2019 at 09:22:36AM -0400, Qian Cai wrote:
> On Thu, 2019-06-13 at 15:11 +0300, Mike Rapoport wrote:
> > The log Qian Cai posted at [1] and partially cited below confirms that =
the
> > failure happens when *user* PGDs are allocated and the addition of
> > __GFP_ACCOUNT to gfp flags used by pgd_alloc() only uncovered another
> > issue.
> >=20
> > I'm still failing to reproduce it with qemu and I'm not really familiar
> > with slub/memcg code to say anything smart about it. Will keep looking.
> >=20
> > Note, that as failures start way after efi_virtmap_init() that allocate=
s a
> > PGD for efi_mm, there are no real fixes required for the original serie=
s,
> > except that the check for mm =3D=3D &init_mm I copied for some reason f=
rom
> > powerpc is bogus and can be removed.
>=20
> Yes, there is more places are not happy with __GFP_ACCOUNT other than efi=
_mm.
> For example,

Here we allocate the pgd for a user process and it should be accounted.

Actually, the whole point of changing the gfp flags in arm64::pgd_alloc()
was to enable the accounting for memory occupied by user pgds, just like
x86 and powerpc do.

> [=A0=A0132.786842][ T1501] kobject_add_internal failed for pgd_cache(49:s=
ystemd-
> udevd.service) (error: -2 parent: cgroup)
> [=A0=A0132.795589][ T1889] CPU: 9 PID: 1889 Comm: systemd-udevd Tainted:
> G=A0=A0=A0=A0=A0=A0=A0=A0W=A0=A0=A0=A0=A0=A0=A0=A0=A05.2.0-rc4-next-20190=
613+ #8
> [=A0=A0132.807356][ T1889] Hardware name: HPE Apollo
> 70=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/C01_APACHE_MB=A0=A0=A0=A0=A0=A0=
=A0=A0=A0, BIOS L50_5.13_1.0.9 03/01/2019
> [=A0=A0132.817872][ T1889] Call trace:
> [=A0=A0132.821017][ T1889]=A0=A0dump_backtrace+0x0/0x268
> [=A0=A0132.825372][ T1889]=A0=A0show_stack+0x20/0x2c
> [=A0=A0132.829380][ T1889]=A0=A0dump_stack+0xb4/0x108
> [=A0=A0132.833475][ T1889]=A0=A0pgd_alloc+0x34/0x5c
> [=A0=A0132.837396][ T1889]=A0=A0mm_init+0x27c/0x32c
> [=A0=A0132.841315][ T1889]=A0=A0dup_mm+0x84/0x7b4
> [=A0=A0132.845061][ T1889]=A0=A0copy_process+0xf20/0x24cc
> [=A0=A0132.849500][ T1889]=A0=A0_do_fork+0xa4/0x66c
> [=A0=A0132.853420][ T1889]=A0=A0__arm64_sys_clone+0x114/0x1b4
> [=A0=A0132.858208][ T1889]=A0=A0el0_svc_handler+0x198/0x260
> [=A0=A0132.862821][ T1889]=A0=A0el0_svc+0x8/0xc
>=20
> >=20
> > I surely can add pgd_alloc_kernel() to be used by the EFI code to make =
sure
> > we won't run into issues with memcg in the future.
> >=20
> > [=A0=A0=A082.125966] Freeing unused kernel memory: 28672K
> > [=A0=A0=A087.940365] Checked W+X mappings: passed, no W+X pages found
> > [=A0=A0=A087.946769] Run /init as init process
> > [=A0=A0=A088.040040] systemd[1]: System time before build time, advanci=
ng clock.
> > [=A0=A0=A088.054593] systemd[1]: Failed to insert module 'autofs4': No =
such file or
> > directory
> > [=A0=A0=A088.374129] modprobe (1726) used greatest stack depth: 28464 b=
ytes left
> > [=A0=A0=A088.470108] systemd[1]: systemd 239 running in system mode. (+=
PAM +AUDIT
> > +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT
> > +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2
> > default-hierarchy=3Dlegacy)
> > [=A0=A0=A088.498398] systemd[1]: Detected architecture arm64.
> > [=A0=A0=A088.506517] systemd[1]: Running in initial RAM disk.
> > [=A0=A0=A089.621995] mkdir (1730) used greatest stack depth: 27872 byte=
s left
> > [=A0=A0=A090.222658] random: systemd: uninitialized urandom read (16 by=
tes read)
> > [=A0=A0=A090.230072] systemd[1]: Reached target Swap.
> > [=A0=A0=A090.240205] random: systemd: uninitialized urandom read (16 by=
tes read)
> > [=A0=A0=A090.251088] systemd[1]: Reached target Timers.
> > [=A0=A0=A090.261303] random: systemd: uninitialized urandom read (16 by=
tes read)
> > [=A0=A0=A090.271209] systemd[1]: Listening on udev Control Socket.
> > [=A0=A0=A090.283238] systemd[1]: Reached target Local File Systems.
> > [=A0=A0=A090.296232] systemd[1]: Reached target Slices.
> > [=A0=A0=A090.307239] systemd[1]: Listening on udev Kernel Socket.
> > [=A0=A0=A090.608597] kobject_add_internal failed for pgd_cache(13:init.=
scope)
> > (error: -2 parent: cgroup)
> > [=A0=A0=A090.678007] kobject_add_internal failed for pgd_cache(13:init.=
scope)(error:
> > -2 parent: cgroup)
> > [=A0=A0=A090.713260] kobject_add_internal failed for pgd_cache(21:syste=
md-tmpfiles-
> > setup.service) (error: -2 parent: cgroup)
> > [=A0=A0=A090.820012] systemd-tmpfile (1759) used greatest stack depth: =
27184 bytes
> > left
> > [=A0=A0=A090.861942] kobject_add_internal failed for pgd_cache(13:init.=
scope) error:
> > -2 parent: cgroup)
> > =A0
> > > Thanks,
> > > Mark.
> > >=20
> >=20
> > [1] https://cailca.github.io/files/dmesg.txt
> >=20

--=20
Sincerely yours,
Mike.

