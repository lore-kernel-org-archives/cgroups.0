From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroups/netfilter : kernel NULL pointer BUG at 00000038
Date: Mon, 15 Sep 2014 09:06:01 +0800
Message-ID: <54163B79.90803@huawei.com>
References: <54131D1D.1030904@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54131D1D.1030904-Mmb7MZpHnFY@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I think this is the same bug as the one you reported recently, which
has been fixed in mainline.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Da4189487da1b4f8260c6006b9dc47c3c4107a5ae

On 2014/9/13 0:19, Toralf F=C3=B6rster wrote:
> Today I observed within a 32 bit KVM machine (stable Gentoo x86 Linux=
) the following :
>=20
> Sep 12 18:14:37 n22kvmclone kernel: [   37.964900] ip_tables: (C) 200=
0-2006 Netfilter Core Team
> Sep 12 18:14:38 n22kvmclone kernel: [   38.412110] nf_conntrack versi=
on 0.5.0 (16384 buckets, 65536 max)
> Sep 12 18:14:38 n22kvmclone kernel: [   39.032978] ------------[ cut =
here ]------------
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033009] WARNING: CPU: 0 PI=
D: 1632 at kernel/cgroup.c:1034 cgroup_get+0x91/0xb0()
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033013] Modules linked in:=
 xt_NFLOG xt_limit ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_recen=
t xt_conntrack nf_conntrack iptable_filter ip_tables af_packet dm_crypt=
 dm_mod usbhid mousedev uhci_hcd ehci_pci microcode psmouse ehci_hcd ev=
dev usbcore atkbd usb_common virtio_console processor button
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033104] CPU: 0 PID: 1632 C=
omm: runscript.sh Not tainted 3.17.0-rc4 #18
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033107] Hardware name: QEM=
U Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602=
_164612-nilsson.home.kraxel.org 04/01/2014
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033110]  00000000 00000000=
 f4b33e54 cc04b292 00000000 f4b33e84 cbc46d64 cc18f11c
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033119]  00000000 00000660=
 cc19bcc5 0000040a cbcb5841 cbcb5841 f56de400 f4963688
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033128]  f4983cb8 f4b33e94=
 cbc46da2 00000009 00000000 f4b33eb0 cbcb5841 cbe59246
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033137] Call Trace:
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033163]  [<cc04b292>] dump=
_stack+0x41/0x52
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033179]  [<cbc46d64>] warn=
_slowpath_common+0x84/0xa0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033186]  [<cbcb5841>] ? cg=
roup_get+0x91/0xb0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033191]  [<cbcb5841>] ? cg=
roup_get+0x91/0xb0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033197]  [<cbc46da2>] warn=
_slowpath_null+0x22/0x30
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033202]  [<cbcb5841>] cgro=
up_get+0x91/0xb0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033223]  [<cbe59246>] ? ks=
trtoll+0x16/0x70
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033230]  [<cbcb5d3d>] cgro=
up_kn_lock_live+0x2d/0x70
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033235]  [<cbcb8386>] __cg=
roup_procs_write.isra.26+0x56/0x240
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033240]  [<cbcb8570>] ? __=
cgroup_procs_write.isra.26+0x240/0x240
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033245]  [<cbcb8587>] cgro=
up_tasks_write+0x17/0x20
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033250]  [<cbcb5645>] cgro=
up_file_write+0x45/0x140
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033256]  [<cbcb5600>] ? ki=
ll_css+0xd0/0xd0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033275]  [<cbda8d21>] kern=
fs_fop_write+0xd1/0x160
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033281]  [<cbda8c50>] ? ke=
rnfs_vma_page_mkwrite+0x90/0x90
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033291]  [<cbd49bbd>] vfs_=
write+0x9d/0x1e0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033297]  [<cbda8c50>] ? ke=
rnfs_vma_page_mkwrite+0x90/0x90
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033306]  [<cbd64522>] ? __=
fdget+0x12/0x20
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033311]  [<cbd4a0b2>] SyS_=
write+0x52/0xa0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033321]  [<cc0522ab>] syse=
nter_do_call+0x12/0x12
> Sep 12 18:14:38 n22kvmclone kernel: [   39.033325] ---[ end trace f35=
13225d53cf0f3 ]---
> Sep 12 18:14:38 n22kvmclone kernel: [   39.036277] BUG: unable to han=
dle kernel NULL pointer dereference at 00000038
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] IP: [<cbcb5c2c>] c=
group_put+0xc/0x90
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] *pde =3D 00000000
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] Oops: 0000 [#1] SM=
P
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] Modules linked in:=
 xt_NFLOG xt_limit ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_recen=
t xt_conntrack nf_conntrack iptable_filter ip_tables af_packet dm_crypt=
 dm_mod usbhid mousedev uhci_hcd ehci_pci microcode psmouse ehci_hcd ev=
dev usbcore atkbd usb_common virtio_console processor button
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] CPU: 0 PID: 1632 C=
omm: runscript.sh Tainted: G        W      3.17.0-rc4 #18
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] Hardware name: QEM=
U Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602=
_164612-nilsson.home.kraxel.org 04/01/2014
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] task: f6216390 ti:=
 f4b32000 task.ti: f4b32000
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] EIP: 0060:[<cbcb5c=
2c>] EFLAGS: 00010282 CPU: 0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] EIP is at cgroup_p=
ut+0xc/0x90
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] EAX: 00000000 EBX:=
 f4963688 ECX: 0042621a EDX: 00000008
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] ESI: 00000000 EDI:=
 f4983cb8 EBP: f4b33ea0 ESP: f4b33e8c
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  DS: 007b ES: 007b=
 FS: 00d8 GS: 00e0 SS: 0068
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] CR0: 8005003b CR2:=
 00000038 CR3: 35610000 CR4: 000006c0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] Stack:
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  cbda848d 00000000=
 00000001 00000000 f4963688 f4b33eb0 cbcb5cee 00000000
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  f4963688 f4b33ec0=
 cbcb5d79 f6216390 00000000 f4b33efc cbcb8386 00000246
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  00000000 f62168fc=
 f62168f0 00000002 00000000 f611c880 f611c000 f4b33f1c
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] Call Trace:
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbda848d>] ? ke=
rnfs_unbreak_active_protection+0x4d/0x50
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb5cee>] cgro=
up_kn_unlock+0x3e/0x60
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb5d79>] cgro=
up_kn_lock_live+0x69/0x70
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb8386>] __cg=
roup_procs_write.isra.26+0x56/0x240
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb8570>] ? __=
cgroup_procs_write.isra.26+0x240/0x240
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb8587>] cgro=
up_tasks_write+0x17/0x20
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb5645>] cgro=
up_file_write+0x45/0x140
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbcb5600>] ? ki=
ll_css+0xd0/0xd0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbda8d21>] kern=
fs_fop_write+0xd1/0x160
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbda8c50>] ? ke=
rnfs_vma_page_mkwrite+0x90/0x90
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbd49bbd>] vfs_=
write+0x9d/0x1e0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbda8c50>] ? ke=
rnfs_vma_page_mkwrite+0x90/0x90
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbd64522>] ? __=
fdget+0x12/0x20
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cbd4a0b2>] SyS_=
write+0x52/0xa0
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026]  [<cc0522ab>] syse=
nter_do_call+0x12/0x12
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] Code: ff c7 04 24 =
e8 2f 19 cc e8 45 35 39 00 e9 76 ff ff ff 8d b6 00 00 00 00 8d bc 27 00=
 00 00 00 55 89 e5 53 83 ec 10 3e 8d 74 26 00 <f6> 40 38 01 89 c3 74 0c=
 83 c4 10 5b 5d c3 8d b6 00 00 00 00 31
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] EIP: [<cbcb5c2c>] =
cgroup_put+0xc/0x90 SS:ESP 0068:f4b33e8c
> Sep 12 18:14:38 n22kvmclone kernel: [   39.037026] CR2: 0000000000000=
038
> Sep 12 18:14:38 n22kvmclone kernel: [   39.092883] ---[ end trace f35=
13225d53cf0f4 ]---
>=20
>=20
