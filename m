From: Michal Hocko <mhocko@kernel.org>
Subject: Re: cgroups iptables-restor: vmalloc: allocation failure
Date: Thu, 26 Jul 2018 10:13:43 +0200
Message-ID: <20180726081343.GZ28386@dhcp22.suse.cz>
References: <a1a4eb7c-e85c-dc6d-cfac-6d40af302182@icdsoft.com>
 <alpine.DEB.2.21.1807251241380.201050@chino.kir.corp.google.com>
 <b0b46aee-7a66-2166-4f19-61e5e5c5dcfc@icdsoft.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b0b46aee-7a66-2166-4f19-61e5e5c5dcfc@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Georgi Nikolov <gnikolov@icdsoft.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

For more context this is a follow up for http://lkml.kernel.org/r/df6f501c-=
8546-1f55-40b1-7e3a8f54d872@icdsoft.com

On Thu 26-07-18 09:53:20, Georgi Nikolov wrote:
> Hello,
>=20
> Servers are with 64bit kernel and 32bit userland.
>=20
> here is the log:
>=20
> [=A0 485.467359] iptables-restor: vmalloc: allocation failure, allocated
> 2367488 of 3608576 bytes, mode:0x14010c0(GFP_KERNEL|__GFP_NORETRY),
> nodemask=3D(null)
> [=A0 485.467871] iptables-restor cpuset=3D/ mems_allowed=3D0
> [=A0 485.468089] CPU: 0 PID: 18093 Comm: iptables-restor Not tainted
> 4.14.50 #1
> [=A0 485.468399] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1 04/01/2014
> [=A0 485.468725]=A0 0000000000000000 ffffffff81ed2b8b ffffffff8333a330
> bb5cfe6a5a821e59
> [=A0 485.469114]=A0 0000000000000000 ffffc90004aaba80 ffffffff811fa3ea
> ffffc90004aaba90
> [=A0 485.469422]=A0 ffffffff825e11d0 014010c000000000 ffffffff825e11d0
> ffffc90004aaba18
> [=A0 485.469735] Call Trace:
> [=A0 485.469941]=A0 [<ffffffff81ed2b8b>] dump_stack+0x9a/0x10f
> [=A0 485.470159]=A0 [<ffffffff811fa3ea>] warn_alloc+0x18a/0x270
> [=A0 485.470379]=A0 [<ffffffff8124c9c1>] __vmalloc_node_range+0x251/0x470
> [=A0 485.470614]=A0 [<ffffffff8124ccfe>] ? __vmalloc_node_flags_caller+0x=
3e/0x70
> [=A0 485.470881]=A0 [<ffffffff8124ccfe>] __vmalloc_node_flags_caller+0x3e=
/0x70
> [=A0 485.471160]=A0 [<ffffffff81d7cebe>] ? xt_alloc_table_info+0x4e/0xa0
> [=A0 485.471395]=A0 [<ffffffff8121a1ca>] kvmalloc_node+0x7a/0xd0
> [=A0 485.471618]=A0 [<ffffffff81d7cebe>] xt_alloc_table_info+0x4e/0xa0
> [=A0 485.471849]=A0 [<ffffffff81e57357>] ?
> translate_compat_table.constprop.19+0x447/0x870
> [=A0 485.472197]=A0 [<ffffffff81e57357>]
> translate_compat_table.constprop.19+0x447/0x870
> [=A0 485.472514]=A0 [<ffffffff81e57917>] ?
> compat_do_replace.isra.10.constprop.18+0x197/0x370
> [=A0 485.472833]=A0 [<ffffffff81e57917>]
> compat_do_replace.isra.10.constprop.18+0x197/0x370
> [=A0 485.473230]=A0 [<ffffffff81e57b7b>] compat_do_ipt_set_ctl+0x8b/0xb0
> [=A0 485.473465]=A0 [<ffffffff81d643ea>] compat_nf_setsockopt+0x6a/0xd0
> [=A0 485.473701]=A0 [<ffffffff81df3ad3>] compat_ip_setsockopt+0x73/0xd0
> [=A0 485.473936]=A0 [<ffffffff81e2129c>] compat_raw_setsockopt+0x7c/0xd0
> [=A0 485.474208]=A0 [<ffffffff8123750c>] ? handle_mm_fault+0xec/0x240
> [=A0 485.474441]=A0 [<ffffffff81cd3852>] compat_sock_common_setsockopt+0x=
32/0x80
> [=A0 485.474689]=A0 [<ffffffff81d2ed6a>] compat_sys_setsockopt+0x9a/0x2e0
> [=A0 485.474926]=A0 [<ffffffff81d309e5>] compat_sys_socketcall+0x415/0x570
> [=A0 485.475197]=A0 [<ffffffff820018bc>] ? page_fault+0x5c/0x90
> [=A0 485.475416]=A0 [<ffffffff82000ae6>] ? retint_user+0x2b/0x2b
> [=A0 485.475638]=A0 [<ffffffff81d30b54>] ? rap_compat_sys_socketcall+0x14=
/0x40
> [=A0 485.475884]=A0 [<ffffffff81002391>] ? do_fast_syscall_32+0xe1/0x2f0
> [=A0 485.476170]=A0 [<ffffffff82001f03>] ? entry_SYSENTER_compat+0x93/0xa5
> [=A0 485.476414] Mem-Info:
> [=A0 485.476579] active_anon:79884 inactive_anon:103007 isolated_anon:0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 active_file:54010 inactive_=
file:219014 isolated_file:0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unevictable:1822 dirty:22 w=
riteback:0 unstable:0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 slab_reclaimable:8637 slab_=
unreclaimable:25015
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mapped:16094 shmem:2271 pag=
etables:1481 bounce:0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free:3459 free_pcp:180 free=
_cma:0
> [=A0 485.477691] Node 0 active_anon:320376kB inactive_anon:412028kB
> active_file:216040kB inactive_file:875844kB unevictable:7288kB
> isolated(anon):0kB isolated(file):0kB mapped:64376kB dirty:88kB
> writeback:0kB shmem:9084kB writeback_tmp:0kB unstable:0kB
> all_unreclaimable? no
> [=A0 485.478457] Node 0 DMA free:7896kB min:44kB low:56kB high:68kB
> active_anon:2324kB inactive_anon:0kB active_file:12kB
> inactive_file:5228kB unevictable:0kB writepending:0kB present:15992kB
> managed:15892kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB
> free_pcp:0kB local_pcp:0kB free_cma:0kB
> [=A0 485.479233] lowmem_reserve[]: 0 1963 1963 1963
> [=A0 485.479483] Node 0 DMA32 free:5364kB min:5644kB low:7652kB
> high:9660kB active_anon:317672kB inactive_anon:412028kB
> active_file:216028kB inactive_file:871340kB unevictable:7288kB
> writepending:88kB present:2080624kB managed:2015900kB mlocked:7288kB
> kernel_stack:5584kB pagetables:5924kB bounce:0kB free_pcp:1052kB
> local_pcp:720kB free_cma:0kB
> [=A0 485.480425] lowmem_reserve[]: 0 0 0 0
> [=A0 485.480612] Node 0 DMA: 38*4kB (UMEH) 54*8kB (MEH) 51*16kB (UMEH)
> 35*32kB (UMEH) 16*64kB (MEH) 12*128kB (MH) 7*256kB (UMEH) 0*512kB
> 1*1024kB (E) 0*2048kB 0*4096kB =3D 7896kB
> [=A0 485.481173] Node 0 DMA32: 12*4kB (MH) 16*8kB (H) 264*16kB (UH) 7*32kB
> (H) 6*64kB (H) 1*128kB (H) 0*256kB 1*512kB (H) 0*1024kB 0*2048kB
> 0*4096kB =3D 5648kB
> [=A0 485.481642] Node 0 hugepages_total=3D0 hugepages_free=3D0
> hugepages_surp=3D0 hugepages_size=3D1048576kB
> [=A0 485.481975] Node 0 hugepages_total=3D0 hugepages_free=3D0
> hugepages_surp=3D0 hugepages_size=3D2048kB
> [=A0 485.482309] 275972 total pagecache pages
> [=A0 485.482535] 0 pages in swap cache
> [=A0 485.482717] Swap cache stats: add 0, delete 0, find 0/0
> [=A0 485.482937] Free swap=A0 =3D 1976316kB
> [=A0 485.483118] Total swap =3D 1976316kB
> [=A0 485.483300] 524154 pages RAM
> [=A0 485.483492] 0 pages HighMem/MovableOnly
> [=A0 485.483711] 16206 pages reserved
> [=A0 485.483889] 0 pages hwpoisoned
>=20
> Regards,
>=20
> --=20
> Georgi Nikolov
>=20
> On 07/25/2018 10:42 PM, David Rientjes wrote:
> > On Wed, 25 Jul 2018, Georgi Nikolov wrote:
> >
> >> Hello,
> >>
> >> I posted a kernel bug https://bugzilla.kernel.org/show_bug.cgi?id=3D20=
0651 and
> >> i hope this is the correct place to discuss this.
> >>
> > Could you post the full allocation failure from the kernel log?  It's n=
ot=20
> > possible to vmalloc any additional memory due to the memory pressure, s=
o=20
> > this is expected to fail but I'm curious as to the actual allocation th=
at=20
> > is triggering it.
>=20

--=20
Michal Hocko
SUSE Labs
