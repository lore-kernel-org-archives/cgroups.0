From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [BUG in v3.18 ?] Seems to be triggered from cgroup code
Date: Thu, 05 Feb 2015 15:54:34 -0800
Message-ID: <54D402BA.2030307@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Tejun and all,

We observed a BUG (stack is end of the email) while trying do some
ceph testing. I looked at pidlist_free(), pidlist_array_load() for
any potential leak but those functions looked fine to me.
The BUG is not 100% reproducible either so though of reporting
to the list to get some more pointers.

Thanks in advance !!

Regards,
Santosh

  ------------[ cut here ]------------
  kernel BUG at mm/slub.c:3334!
  invalid opcode: 0000 [#1] SMP
  Modules linked in: nls_utf8 isofs loop xt_CHECKSUM iptable_mangle 
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT 
nf_reject_ipv4 iptable_filter ip_tables tun bridge stp llc drbd 
lru_cache intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul 
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt 
iTCO_vendor_support lrw gf128mul glue_helper ablk_helper cryptd 
i7core_edac lpc_ich ipmi_si i2c_i801 mfd_core edac_core ioatdma pcspkr 
shpchp ipmi_msghandler acpi_cpufreq binfmt_misc xfs libcrc32c ast 
syscopyarea sr_mod sysfillrect sysimgblt cdrom drm_kms_helper ixgbe mdio 
ttm ahci sd_mod igb uas libahci e1000e dca ptp libata drm usb_storage 
i2c_algo_bit megaraid_sas pps_core i2c_core dm_mirror
   dm_region_hash dm_log dm_mod
  CPU: 11 PID: 1 Comm: systemd Tainted: G        W 
3.18.4-5.el7uek.x86_64 #1
  Hardware name: Oracle Corporation SUN FIRE X4170 M2 SERVER 
/ASSY,MOTHERBOARD,X4170, BIOS 08120104 05/08/2012
  task: ffff88065d218000 ti: ffff88065d214000 task.ti: ffff88065d214000
  RIP: 0010:[<ffffffff811d1463>]  [<ffffffff811d1463>] kfree+0x133/0x140
  RSP: 0018:ffff88065d217cc8  EFLAGS: 00010246
  RAX: 002fffff80000000 RBX: ffff8806000009a3 RCX: ffff88065460fbe0
  RDX: 002fffff80000000 RSI: 0000000000000000 RDI: ffff8806000009a3
  RBP: ffff88065d217ce8 R08: 0000000000000000 R09: ffffffff8110a91f
  R10: ffffea0018000000 R11: 0000000000000246 R12: 0000000000000001
  R13: ffffffff81105c3a R14: ffff880654735070 R15: ffff880654671400
  FS:  00007f0e47f19880(0000) GS:ffff88067e960000(0000) 
knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f0e47f28000 CR3: 0000000655a40000 CR4: 00000000000007e0
   0000000000000000 ffff88065460fbc0 0000000000000001 0000000000000000
  Stack:
   ffff88065d217cf8 ffffffff81105c3a ffff88065d217d88 ffffffff8110a9ff
   ffff88065d217dc4 ffff88065ccdb390 ffff88065867fb50 0000000000000000
  Call Trace:
   [<ffffffff81105c3a>] pidlist_free+0x2a/0x40
   [<ffffffff8110a9ff>] pidlist_array_load+0x17f/0x350
   [<ffffffff811048fd>] cgroup_seqfile_start+0x1d/0x20
   [<ffffffff8110ad47>] cgroup_pidlist_start+0x177/0x1d0
   [<ffffffff81269e32>] kernfs_seq_start+0x52/0xa0
   [<ffffffff81215ce7>] seq_read+0x177/0x3a0
   [<ffffffff8126a4e5>] kernfs_fop_read+0xf5/0x160
   [<ffffffff811f139c>] vfs_read+0x9c/0x180
   [<ffffffff811f1f55>] SyS_read+0x55/0xd0
   [<ffffffff816bfb29>] system_call_fastpath+0x12/0x17
  Code: 49 8b 02 31 f6 f6 c4 40 74 04 41 8b 72 68 4c 89 d7 e8 f2 e5 fa 
ff eb 93 4c 8b 50 30 48 8b 10 80 e6 80 4c 0f 44 d0 e9 36 ff ff ff <0f> 
0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89
  RIP  [<ffffffff811d1463>] kfree+0x133/0x140
   RSP <ffff88065d217cc8>
