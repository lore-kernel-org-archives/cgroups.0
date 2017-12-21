From: Dan Aloni <dan-HWkDggknmVpWk0Htik3J/w@public.gmane.org>
Subject: Re: cgroups-related hard lockup in 4.14?
Date: Thu, 21 Dec 2017 09:30:17 +0200
Message-ID: <20171221073017.GA28208@gmail.com>
References: <20171220225923.GA10374@gmail.com>
 <20171220232409.GA1084507@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelim-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H7ZrptOtNci2PimXCmlv5W5Wdke7Hx/a56cV9ux8kUw=;
        b=Rs4bR8zapI6Z4yT9v7gMKmH51XEM4pOS7rAVVDtk5VVXZluBhW4CIftXRtEHYqqgfF
         iJXjdYeU+iZeWPFGO6En9jYeUPwkLHeLDU35w63bAOtcBBozoWbJwRsoe9fVxJpeVPbE
         6mb459li1I8vwDvhk+5Lddw67Vxh1oYorggQ1bhbKM+RV0iHLoKcUf/7G/RpuVa3G7J2
         GVJjUkWzhbrM3QNcqvJF5vPcFO38ZFGxct6b5a+ODYqG3ULHFuetYH29CUVNELiMUeci
         Q/f9eHImYL/e53n12d00gTq6SgFjiXMPNxC3+Z9EvHQKiiAj3AIjeu3tGYzLaQh8hUtn
         OylA==
Content-Disposition: inline
In-Reply-To: <20171220232409.GA1084507-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, r@gmail.com
Cc: Linux Kernel List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 20, 2017 at 03:24:09PM -0800, Tejun Heo wrote:
> On Thu, Dec 21, 2017 at 12:59:23AM +0200, Dan Aloni wrote:
> > Hi,
> > 
> > Using netconsole, I was able to capture a hard lockup that seems to be
> > related to cgroups, on a Fedora kernel based on v4.14.4.
> > 
> > By my analysis, from the 16 CPUs below, 14 are on css_set_lock, one is
> > inside css_task_iter_advance, and the last one stuck trying to send an
> > IPI, I guess because all other CPUs are spinning.
> > 
> > To add some context, I have been experiencing deadlocks on various
> > machines starting from 4.13 and it's the first time I was able to
> > capture one. It takes a few days to reproduce while idling or doing
> > random work, and I have not yet come up with precise steps that can
> > nail it.
> > 
> > I can try out patches in order to get more info on this issue.
> 
> Can you please try the following patch?
> 
>  https://marc.info/?l=linux-cgroups&m=151378281708793&q=raw

Sure, I'll try.

While building the kernel with the patch, in the meanwhile, I've
had another lockup with the same kernel, with a different set of
stack traces, but also cgroups-related because it's a BUG_ON()
triggered in mem_cgroup_update_lru_size.


[39229.630404] mem_cgroup_update_lru_size(ffff8e45de412000, 2, -1): lru_size -1
[39229.630420] ------------[ cut here ]------------
[39229.630427] WARNING: CPU: 4 PID: 32431 at mm/memcontrol.c:1017 mem_cgroup_update_lru_size+0x80/0x90
[39229.630428] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39229.630452]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39229.630474] CPU: 4 PID: 32431 Comm: ld Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[39229.630476] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39229.630477] task: ffff8e4172372600 task.stack: ffffb24960c94000
[39229.630480] RIP: 0010:mem_cgroup_update_lru_size+0x80/0x90
[39229.630481] RSP: 0018:ffffb24960c97c08 EFLAGS: 00010086
[39229.630482] RAX: 0000000000000040 RBX: ffffb24960c97dc0 RCX: 0000000000000000
[39229.630483] RDX: 0000000000000000 RSI: ffff8e45de90e138 RDI: ffff8e45de90e138
[39229.630484] RBP: ffffb24960c97c08 R08: 00000000000004f8 R09: ffff8e45cfa2c8c0
[39229.630485] R10: ffffffffffffffff R11: 0000001013521602 R12: ffffd3f8b7db3c80
[39229.630486] R13: 0000000000000006 R14: ffffffff93f76720 R15: 0000000000000009
[39229.630488] FS:  00007f736e0dcb40(0000) GS:ffff8e45de900000(0000) knlGS:0000000000000000
[39229.630489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39229.630491] CR2: 000055a970be67d8 CR3: 0000000f8477d004 CR4: 00000000003606e0
[39229.630492] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39229.630493] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39229.630494] Call Trace:
[39229.630500]  release_pages+0x3a4/0x470
[39229.630502]  __pagevec_release+0x2e/0x40
[39229.630504]  truncate_inode_pages_range+0x321/0x920
[39229.630507]  truncate_inode_pages_final+0x41/0x50
[39229.630510]  ext4_evict_inode+0x107/0x5b0
[39229.630513]  evict+0xcc/0x190
[39229.630514]  iput+0x147/0x210
[39229.630516]  do_unlinkat+0x1a7/0x2f0
[39229.630518]  SyS_unlink+0x16/0x20
[39229.630521]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[39229.630523] RIP: 0033:0x7f736d68de47
[39229.630524] RSP: 002b:00007fff7aba44e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
[39229.630525] RAX: ffffffffffffffda RBX: 00007f736d95bb38 RCX: 00007f736d68de47
[39229.630526] RDX: 0000000000000001 RSI: 00007fff7aba44f0 RDI: 000055a970be67e0
[39229.630527] RBP: 00007f736d95bae0 R08: 0000000000000007 R09: 00007fff7aba4570
[39229.630528] R10: 00007fff7aba4570 R11: 0000000000000246 R12: 000000000000000d
[39229.630529] R13: 0000000000000ff0 R14: 00007f736d95bb38 R15: 0000000000002710
[39229.630530] Code: 47 9d cb 00 00 74 02 0f 0b 41 89 c8 48 89 fa 89 f1 48 c7 c7 64 29 ca 93 48 c7 c6 90 af a2 93 c6 05 26 9d cb 00 01 e8 61 4b e9 ff <0f> ff eb d8 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
[39229.630544] ---[ end trace acf20909354c52c9 ]---
[39229.630547] ------------[ cut here ]------------
[39229.630548] kernel BUG at mm/memcontrol.c:1018!
[39229.630552] invalid opcode: 0000 [#1] SMP
[39229.630553] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39229.630565]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39229.630577] CPU: 4 PID: 32431 Comm: ld Tainted: P        WC OE   4.14.4-200.fc26.x86_64 #1
[39229.630578] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39229.630579] task: ffff8e4172372600 task.stack: ffffb24960c94000
[39229.630581] RIP: 0010:mem_cgroup_update_lru_size+0x5c/0x90
[39229.630582] RSP: 0018:ffffb24960c97c08 EFLAGS: 00010086
[39229.630583] RAX: 0000000000000040 RBX: ffffb24960c97dc0 RCX: 0000000000000000
[39229.630584] RDX: 0000000000000000 RSI: ffff8e45de90e138 RDI: ffff8e45de90e138
[39229.630585] RBP: ffffb24960c97c08 R08: 00000000000004f8 R09: ffff8e45cfa2c8c0
[39229.630586] R10: ffffffffffffffff R11: 0000001013521602 R12: ffffd3f8b7db3c80
[39229.630587] R13: 0000000000000006 R14: ffffffff93f76720 R15: 0000000000000009
[39229.630588] FS:  00007f736e0dcb40(0000) GS:ffff8e45de900000(0000) knlGS:0000000000000000
[39229.630589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39229.630590] CR2: 000055a970be67d8 CR3: 0000000f8477d004 CR4: 00000000003606e0
[39229.630591] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39229.630592] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39229.630593] Call Trace:
[39229.630595]  release_pages+0x3a4/0x470
[39229.630597]  __pagevec_release+0x2e/0x40
[39229.630599]  truncate_inode_pages_range+0x321/0x920
[39229.630601]  truncate_inode_pages_final+0x41/0x50
[39229.630603]  ext4_evict_inode+0x107/0x5b0
[39229.630605]  evict+0xcc/0x190
[39229.630606]  iput+0x147/0x210
[39229.630608]  do_unlinkat+0x1a7/0x2f0
[39229.630609]  SyS_unlink+0x16/0x20
[39229.630611]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[39229.630612] RIP: 0033:0x7f736d68de47
[39229.630613] RSP: 002b:00007fff7aba44e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
[39229.630614] RAX: ffffffffffffffda RBX: 00007f736d95bb38 RCX: 00007f736d68de47
[39229.630615] RDX: 0000000000000001 RSI: 00007fff7aba44f0 RDI: 000055a970be67e0
[39229.630616] RBP: 00007f736d95bae0 R08: 0000000000000007 R09: 00007fff7aba4570
[39229.630617] R10: 00007fff7aba4570 R11: 0000000000000246 R12: 000000000000000d
[39229.630618] R13: 0000000000000ff0 R14: 00007f736d95bb38 R15: 0000000000002710
[39229.630619] Code: 0d 48 63 c9 4c 01 c9 48 89 88 90 00 00 00 5d c3 48 63 d1 49 01 d1 4d 85 c9 4c 89 88 90 00 00 00 79 db 80 3d 47 9d cb 00 00 74 02 <0f> 0b 41 89 c8 48 89 fa 89 f1 48 c7 c7 64 29 ca 93 48 c7 c6 90 
[39229.630634] RIP: mem_cgroup_update_lru_size+0x5c/0x90 RSP: ffffb24960c97c08
[39229.630635] ---[ end trace acf20909354c52ca ]---
[39241.112951] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
[39241.112952] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39241.112965]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39241.112977] CPU: 2 PID: 6073 Comm: chrome Tainted: P      D WC OE   4.14.4-200.fc26.x86_64 #1
[39241.112977] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39241.112978] task: ffff8e453f594c00 task.stack: ffffb2494c4cc000
[39241.112982] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[39241.112982] RSP: 0000:ffffb2494c4cfd10 EFLAGS: 00000046
[39241.112983] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8e45de89af80
[39241.112983] RDX: 000000000000000d RSI: 0000000000380101 RDI: ffff8e461fffe180
[39241.112983] RBP: ffffb2494c4cfd10 R08: 00000000000c0000 R09: 0000000000000000
[39241.112984] R10: 00000000010a0000 R11: 0000000000000000 R12: ffff8e45de894960
[39241.112984] R13: 0000000000000000 R14: ffffd3f8b8620580 R15: ffff8e461ffd4000
[39241.112984] FS:  00007f2e94c04ac0(0000) GS:ffff8e45de880000(0000) knlGS:0000000000000000
[39241.112985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39241.112985] CR2: 0000141e905f9000 CR3: 0000000f98435001 CR4: 00000000003606e0
[39241.112986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39241.112986] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39241.112986] Call Trace:
[39241.112989]  _raw_spin_lock_irqsave+0x37/0x40
[39241.112991]  pagevec_lru_move_fn+0x72/0xf0
[39241.112992]  ? get_kernel_page+0x60/0x60
[39241.112993]  __lru_cache_add+0x5f/0x80
[39241.112994]  lru_cache_add+0x3a/0x80
[39241.112995]  lru_cache_add_active_or_unevictable+0x4c/0xf0
[39241.112997]  __handle_mm_fault+0xafc/0x12f0
[39241.112998]  handle_mm_fault+0xb1/0x200
[39241.112999]  __do_page_fault+0x257/0x4d0
[39241.113002]  ? syscall_trace_enter+0xda/0x2d0
[39241.113003]  do_page_fault+0x38/0x120
[39241.113004]  page_fault+0x22/0x30
[39241.113005] RIP: 0033:0x1d011408af1d
[39241.113005] RSP: 002b:00007ffff3c88708 EFLAGS: 00010206
[39241.113005] RAX: 0000000000000027 RBX: 0000141e905f8fb1 RCX: 0000141e905f8fe1
[39241.113006] RDX: 000000000000002a RSI: 000000000000001f RDI: 0000000000000072
[39241.113006] RBP: 00007ffff3c88778 R08: 0000000000000008 R09: 0000141e905f9008
[39241.113006] R10: 0000000000000048 R11: 0000000000000000 R12: 0000000d00000000
[39241.113006] R13: 0000195ba7cca0c8 R14: 0000000000000000 R15: 0000000000000000
[39241.113007] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 93 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[39242.383811] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
[39242.383812] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39242.383822]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39242.383831] CPU: 15 PID: 32433 Comm: gpg-agent Tainted: P      D WC OE   4.14.4-200.fc26.x86_64 #1
[39242.383831] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39242.383832] task: ffff8e44f2672600 task.stack: ffffb2496ce9c000
[39242.383834] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[39242.383834] RSP: 0018:ffffb2496ce9fd30 EFLAGS: 00000046
[39242.383835] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8e45debdaf80
[39242.383835] RDX: 0000000000000002 RSI: 00000000000c0101 RDI: ffff8e461fffe180
[39242.383835] RBP: ffffb2496ce9fd30 R08: 0000000000400000 R09: 0000000000000050
[39242.383836] R10: 00007f7ed150f000 R11: ffff8e44f2672600 R12: ffff8e45debd4960
[39242.383836] R13: 0000000000000000 R14: ffffd3f8ba5e2dc0 R15: ffff8e461ffd4000
[39242.383837] FS:  00007f7ed1d0e700(0000) GS:ffff8e45debc0000(0000) knlGS:0000000000000000
[39242.383837] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39242.383837] CR2: 00007f0848e5f020 CR3: 0000000fc413c002 CR4: 00000000003606e0
[39242.383838] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39242.383838] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39242.383838] Call Trace:
[39242.383840]  _raw_spin_lock_irqsave+0x37/0x40
[39242.383841]  pagevec_lru_move_fn+0x72/0xf0
[39242.383842]  ? get_kernel_page+0x60/0x60
[39242.383843]  lru_add_drain_cpu+0xec/0x100
[39242.383844]  lru_add_drain+0x15/0x20
[39242.383846]  zap_page_range+0x39/0x160
[39242.383848]  ? kernel_wait4+0x94/0x130
[39242.383849]  ? task_stopped_code+0x50/0x50
[39242.383849]  ? find_vma+0x68/0x70
[39242.383851]  SyS_madvise+0x663/0x940
[39242.383853]  ? ____fput+0xe/0x10
[39242.383854]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[39242.383855] RIP: 0033:0x7f7ed91bab17
[39242.383855] RSP: 002b:00007f7ed1d0df48 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
[39242.383856] RAX: ffffffffffffffda RBX: 00007f7ec40008c0 RCX: 00007f7ed91bab17
[39242.383856] RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007f7ed150e000
[39242.383856] RBP: 0000000000000000 R08: 0000555dc4750610 R09: 0000000000000050
[39242.383856] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f7ec4000a10
[39242.383857] R13: 00007ffcbf213730 R14: 0000555dc4750760 R15: 000000000000000f
[39242.383857]  ? entry_SYSCALL_64_fastpath+0x1a/0xa5
[39242.383858] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 93 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[39244.875349] NMI watchdog: Watchdog detected hard LOCKUP on cpu 13
[39244.875349] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39244.875359]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39244.875367] CPU: 13 PID: 71347 Comm: TaskSchedulerFo Tainted: P      D WC OE   4.14.4-200.fc26.x86_64 #1
[39244.875367] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39244.875367] task: ffff8e452cfd4c00 task.stack: ffffb2494c3fc000
[39244.875369] RIP: 0010:queued_spin_lock_slowpath+0xee/0x1a0
[39244.875370] RSP: 0018:ffffb2494c3ffd30 EFLAGS: 00000002
[39244.875370] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8e45deb5af80
[39244.875370] RDX: 00000000003c0101 RSI: 0000000000000101 RDI: ffff8e461fffe180
[39244.875371] RBP: ffffb2494c3ffd30 R08: 0000000000380000 R09: 0000000000000000
[39244.875371] R10: 00007fcab59d2000 R11: ffff8e452cfd4c00 R12: ffff8e45deb54960
[39244.875371] R13: 0000000000000000 R14: ffffd3f8b91c0240 R15: ffff8e461ffd4000
[39244.875372] FS:  00007fcab61d1700(0000) GS:ffff8e45deb40000(0000) knlGS:0000000000000000
[39244.875372] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39244.875372] CR2: 00007fcab61ce308 CR3: 0000000fb68ea001 CR4: 00000000003606e0
[39244.875373] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39244.875373] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39244.875373] Call Trace:
[39244.875375]  _raw_spin_lock_irqsave+0x37/0x40
[39244.875376]  pagevec_lru_move_fn+0x72/0xf0
[39244.875377]  ? get_kernel_page+0x60/0x60
[39244.875378]  lru_add_drain_cpu+0xec/0x100
[39244.875379]  lru_add_drain+0x15/0x20
[39244.875380]  zap_page_range+0x39/0x160
[39244.875381]  ? find_vma+0x68/0x70
[39244.875382]  SyS_madvise+0x663/0x940
[39244.875384]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[39244.875384] RIP: 0033:0x7fcaf2de8b17
[39244.875385] RSP: 002b:00007fcab61d0b88 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
[39244.875385] RAX: ffffffffffffffda RBX: 00007fcab61d1a88 RCX: 00007fcaf2de8b17
[39244.875385] RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007fcab59d1000
[39244.875385] RBP: 00000ad996670000 R08: 0000000000000000 R09: 000055cc95d18570
[39244.875386] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000020
[39244.875386] R13: 00007fcaf92e90a0 R14: 00007fcaf92e92a0 R15: 00007fcab61cfb10
[39244.875387]  ? entry_SYSCALL_64_fastpath+0x1a/0xa5
[39244.875387] Code: f3 90 8b 37 81 fe 00 01 00 00 74 f4 e9 5f ff ff ff 44 89 c0 c1 e8 10 66 87 47 02 89 c2 c1 e2 10 85 d2 75 6a 45 31 c9 eb 02 f3 90 <8b> 17 66 85 d2 75 f7 be 01 00 00 00 eb 0c 89 d0 f0 0f b1 37 39 
[39244.967075] NMI watchdog: Watchdog detected hard LOCKUP on cpu 14
[39244.967075] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39244.967084]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39244.967092] CPU: 14 PID: 32434 Comm: automount Tainted: P      D WC OE   4.14.4-200.fc26.x86_64 #1
[39244.967092] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39244.967093] task: ffff8e450a8f8000 task.stack: ffffb24960c9c000
[39244.967094] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[39244.967095] RSP: 0018:ffffb24960c9fd30 EFLAGS: 00000046
[39244.967095] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8e45deb9af80
[39244.967095] RDX: 000000000000000f RSI: 0000000000400101 RDI: ffff8e461fffe180
[39244.967096] RBP: ffffb24960c9fd30 R08: 00000000003c0000 R09: 000055e747c15ae0
[39244.967096] R10: 00007fc3a8167000 R11: ffff8e450a8f8000 R12: ffff8e45deb94960
[39244.967096] R13: 0000000000000000 R14: ffffd3f8aec572c0 R15: ffff8e461ffd4000
[39244.967097] FS:  00007fc3a8266700(0000) GS:ffff8e45deb80000(0000) knlGS:0000000000000000
[39244.967097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39244.967097] CR2: 00007fa919b6f000 CR3: 00000010118d6001 CR4: 00000000003606e0
[39244.967098] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39244.967098] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39244.967098] Call Trace:
[39244.967100]  _raw_spin_lock_irqsave+0x37/0x40
[39244.967101]  pagevec_lru_move_fn+0x72/0xf0
[39244.967102]  ? get_kernel_page+0x60/0x60
[39244.967103]  lru_add_drain_cpu+0xec/0x100
[39244.967104]  lru_add_drain+0x15/0x20
[39244.967105]  zap_page_range+0x39/0x160
[39244.967108]  ? do_futex+0x4bf/0xae0
[39244.967110]  ? lockref_put_or_lock+0x60/0x80
[39244.967111]  ? find_vma+0x68/0x70
[39244.967112]  SyS_madvise+0x663/0x940
[39244.967113]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[39244.967113] RIP: 0033:0x7fc3ab274b17
[39244.967114] RSP: 002b:00007fc3a8265e08 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
[39244.967114] RAX: ffffffffffffffda RBX: 00007fc38c000920 RCX: 00007fc3ab274b17
[39244.967115] RDX: 0000000000000004 RSI: 00000000000fb000 RDI: 00007fc3a8166000
[39244.967115] RBP: 00007fc3ab535400 R08: 0000000000000000 R09: 000055e747c15ae0
[39244.967115] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
[39244.967115] R13: 00007fc3a8262c1a R14: 00007fc394000a90 R15: 00007fc3a8265cac
[39244.967116]  ? entry_SYSCALL_64_fastpath+0x1a/0xa5
[39244.967117] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 93 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[39246.911358] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
[39246.911359] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39246.911367]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39246.911374] CPU: 4 PID: 32431 Comm: ld Tainted: P      D WC OE   4.14.4-200.fc26.x86_64 #1
[39246.911374] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39246.911375] task: ffff8e4172372600 task.stack: ffffb24960c94000
[39246.911377] RIP: 0010:queued_spin_lock_slowpath+0x135/0x1a0
[39246.911377] RSP: 0018:ffffb24960c97cb0 EFLAGS: 00000002
[39246.911377] RAX: 00000000003c0101 RBX: 0000000000000246 RCX: 0000000000000001
[39246.911378] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff8e461fffe180
[39246.911378] RBP: ffffb24960c97cb0 R08: 0000000000000101 R09: 0000000000000000
[39246.911378] R10: 00000000010a0000 R11: 00000000ffffff80 R12: ffffd3f8b1807900
[39246.911379] R13: 0000000000000000 R14: ffffffff93f76720 R15: 0000000000000000
[39246.911379] FS:  0000000000000000(0000) GS:ffff8e45de900000(0000) knlGS:0000000000000000
[39246.911379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39246.911380] CR2: 000055a970be67d8 CR3: 0000000421e09001 CR4: 00000000003606e0
[39246.911380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39246.911380] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39246.911380] Call Trace:
[39246.911382]  _raw_spin_lock_irqsave+0x37/0x40
[39246.911383]  release_pages+0x252/0x470
[39246.911385]  ? ___pud_free_tlb+0x7a/0x90
[39246.911386]  free_pages_and_swap_cache+0xba/0xd0
[39246.911387]  tlb_flush_mmu_free+0x36/0x60
[39246.911388]  arch_tlb_finish_mmu+0x47/0x80
[39246.911388]  tlb_finish_mmu+0x23/0x30
[39246.911389]  exit_mmap+0xea/0x190
[39246.911392]  mmput+0x66/0x140
[39246.911393]  do_exit+0x285/0xba0
[39246.911394]  rewind_stack_do_exit+0x17/0x20
[39246.911394] RIP: 0033:0x7f736d68de47
[39246.911394] RSP: 002b:00007fff7aba44e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
[39246.911395] RAX: ffffffffffffffda RBX: 00007f736d95bb38 RCX: 00007f736d68de47
[39246.911395] RDX: 0000000000000001 RSI: 00007fff7aba44f0 RDI: 000055a970be67e0
[39246.911395] RBP: 00007f736d95bae0 R08: 0000000000000007 R09: 00007fff7aba4570
[39246.911396] R10: 00007fff7aba4570 R11: 0000000000000246 R12: 000000000000000d
[39246.911396] R13: 0000000000000ff0 R14: 00007f736d95bb38 R15: 0000000000002710
[39246.911397] Code: 66 31 c0 41 39 c0 74 ea 4d 85 c9 c6 07 01 74 2d 41 c7 41 08 01 00 00 00 eb 96 83 fa 01 0f 84 f4 fe ff ff 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c 8b 09 
[39253.452016] watchdog: BUG: soft lockup - CPU#11 stuck for 21s! [TaskSchedulerFo:37695]
[39253.452154] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39253.452169]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39253.452183] CPU: 11 PID: 37695 Comm: TaskSchedulerFo Tainted: P      D WC OE   4.14.4-200.fc26.x86_64 #1
[39253.452184] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39253.452185] task: ffff8e428bb4cc00 task.stack: ffffb24968344000
[39253.452188] RIP: 0010:smp_call_function_single+0xdf/0x100
[39253.452189] RSP: 0018:ffffb24968347ca0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
[39253.452191] RAX: 0000000000000000 RBX: 000000000000000b RCX: 0000000000000000
[39253.452193] RDX: 0000000000000003 RSI: 00000000000000fb RDI: 0000000000000202
[39253.452194] RBP: ffffb24968347cf0 R08: 000000000000000d R09: 0000000000002800
[39253.452195] R10: ffffb24968347d10 R11: ffff8e428bb4cc00 R12: ffff8e45d1805910
[39253.452196] R13: 000000000000000b R14: ffffffff9306ecd0 R15: ffffb24968347d88
[39253.452197] FS:  00007fcad8ec9700(0000) GS:ffff8e45deac0000(0000) knlGS:0000000000000000
[39253.452199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39253.452270] CR2: 00007fede9748a40 CR3: 0000000fb68ea001 CR4: 00000000003606e0
[39253.452272] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39253.452273] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39253.452274] Call Trace:
[39253.452277]  ? flush_tlb_func_common.constprop.9+0x260/0x260
[39253.452280]  smp_call_function_many+0x1cc/0x250
[39253.452281]  ? smp_call_function_many+0x1cc/0x250
[39253.452283]  native_flush_tlb_others+0xd4/0x130
[39253.452285]  flush_tlb_mm_range+0xae/0x120
[39253.452287]  zap_page_range+0xda/0x160
[39253.452289]  ? find_vma+0x68/0x70
[39253.452291]  SyS_madvise+0x663/0x940
[39253.452294]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[39253.452295] RIP: 0033:0x7fcaf2de8b17
[39253.452296] RSP: 002b:00007fcad8ec8958 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
[39253.452298] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fcaf2de8b17
[39253.452299] RDX: 0000000000000004 RSI: 0000000000003000 RDI: 00000ad999bc4000
[39253.452300] RBP: 00007fcad8ec8710 R08: 0000000000000000 R09: 0000000000000000
[39253.452301] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000101
[39253.452303] R13: 000000000000000a R14: 00000ad998b395c0 R15: 00007fcad8ec81a8
[39253.452304]  ? entry_SYSCALL_64_fastpath+0x1a/0xa5
[39253.452306] Code: 00 75 40 48 83 c4 48 41 5a 5d 49 8d 62 f8 c3 48 89 d1 48 89 f2 48 8d 75 b0 e8 7e fe ff ff 8b 55 c8 83 e2 01 74 0a f3 90 8b 55 c8 <83> e2 01 75 f6 eb c2 8b 05 f4 fa 0a 01 85 c0 75 81 0f ff e9 7a 
[39255.936049] NMI watchdog: Watchdog detected hard LOCKUP on cpu 9
[39255.936049] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39255.936060]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39255.936071] CPU: 9 PID: 6083 Comm: chrome Tainted: P      D WC OEL  4.14.4-200.fc26.x86_64 #1
[39255.936071] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39255.936072] task: ffff8e453f590000 task.stack: ffffb2494c834000
[39255.936073] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[39255.936074] RSP: 0018:ffffb2494c837d00 EFLAGS: 00000046
[39255.936074] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8e45dea5af80
[39255.936075] RDX: 000000000000000e RSI: 00000000003c0101 RDI: ffff8e461fffe180
[39255.936075] RBP: ffffb2494c837d00 R08: 0000000000280000 R09: 0000000000000001
[39255.936075] R10: 0000398851b35000 R11: ffff8e453f590000 R12: ffff8e45dea54960
[39255.936076] R13: 0000000000000000 R14: ffffd3f8b9882440 R15: ffff8e461ffd4000
[39255.936076] FS:  00007f2e94c04ac0(0000) GS:ffff8e45dea40000(0000) knlGS:0000000000000000
[39255.936077] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39255.936077] CR2: 0000398851b34000 CR3: 0000000f8f2a5006 CR4: 00000000003606e0
[39255.936078] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39255.936078] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39255.936078] Call Trace:
[39255.936080]  _raw_spin_lock_irqsave+0x37/0x40
[39255.936082]  pagevec_lru_move_fn+0x72/0xf0
[39255.936083]  ? get_kernel_page+0x60/0x60
[39255.936084]  lru_add_drain_cpu+0xec/0x100
[39255.936085]  lru_add_drain+0x15/0x20
[39255.936086]  zap_page_range+0x39/0x160
[39255.936088]  ? __seccomp_filter+0x49/0x580
[39255.936089]  ? find_vma+0x1b/0x70
[39255.936090]  SyS_madvise+0x663/0x940
[39255.936091]  ? __secure_computing+0x3f/0xe0
[39255.936093]  do_syscall_64+0x67/0x180
[39255.936094]  ? do_syscall_64+0x67/0x180
[39255.936095]  entry_SYSCALL64_slow_path+0x25/0x25
[39255.936095] RIP: 0033:0x7f2e8e5c4b17
[39255.936096] RSP: 002b:00007ffff3c896a8 EFLAGS: 00000202 ORIG_RAX: 000000000000001c
[39255.936096] RAX: ffffffffffffffda RBX: 0000398851b34000 RCX: 00007f2e8e5c4b17
[39255.936097] RDX: 0000000000000004 RSI: 0000000000001000 RDI: 0000398851b34000
[39255.936097] RBP: 0000000000000000 R08: 0000398851a019a0 R09: 0000000000000001
[39255.936097] R10: 00007ffff3c89750 R11: 0000000000000202 R12: 0000000000001000
[39255.936098] R13: 0000000000001c00 R14: 0000000000001000 R15: 0000398851b34000
[39255.936098] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 93 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[39262.939951] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1
[39262.939952] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi arc4 intel_rapl r8822be(C) x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_generic kvm_intel kvm mac80211 snd_h
 da_intel snd_hda_codec
[39262.939961]  irqbypass crct10dif_pclmul snd_hda_core btusb crc32_pclmul drm_kms_helper snd_hwdep btrtl btbcm snd_seq ghash_clmulni_intel cfg80211 btintel iTCO_wdt intel_cstate snd_seq_device iTCO_vendor_support drm snd_pcm bluetooth intel_uncore eeepc_wmi asus_wmi intel_rapl_perf sparse_keymap snd_timer mei_me ecdh_generic video joydev wmi_bmof rfkill mei snd shpchp i2c_i801 soundcore ioatdma tpm_tis tpm_tis_core dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[39262.939969] CPU: 1 PID: 32435 Comm: systemd-journal Tainted: P      D WC OEL  4.14.4-200.fc26.x86_64 #1
[39262.939969] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[39262.939970] task: ffff8e450f278000 task.stack: ffffb24960c1c000
[39262.939971] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[39262.939971] RSP: 0018:ffffb24960c1fa48 EFLAGS: 00000046
[39262.939972] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8e45de85af80
[39262.939972] RDX: 0000000000000009 RSI: 0000000000280101 RDI: ffff8e461fffe180
[39262.939973] RBP: ffffb24960c1fa48 R08: 0000000000080000 R09: 0000000000fa0000
[39262.939973] R10: ffffb24960c1f8f0 R11: 0000000000000000 R12: ffff8e45de854960
[39262.939973] R13: 0000000000000000 R14: ffffd3f8ae28c180 R15: ffff8e461ffd4000
[39262.939974] FS:  00007fa9196ec700(0000) GS:ffff8e45de840000(0000) knlGS:0000000000000000
[39262.939974] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39262.939975] CR2: 00001e486d610000 CR3: 0000001051d10003 CR4: 00000000003606e0
[39262.939975] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39262.939975] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[39262.939976] Call Trace:
[39262.939977]  _raw_spin_lock_irqsave+0x37/0x40
[39262.939978]  pagevec_lru_move_fn+0x72/0xf0
[39262.939979]  ? get_kernel_page+0x60/0x60
[39262.939980]  lru_add_drain_cpu+0xec/0x100
[39262.939981]  __pagevec_release+0x19/0x40
[39262.939983]  mpage_prepare_extent_to_map+0x30e/0x320
[39262.939984]  ext4_writepages+0x45d/0xf30
[39262.939986]  ? check_preempt_curr+0x7d/0x90
[39262.939987]  do_writepages+0x48/0xe0
[39262.939988]  ? do_writepages+0x48/0xe0
[39262.939989]  ? seccomp_run_filters+0x57/0xc0
[39262.939991]  __filemap_fdatawrite_range+0xc1/0x100
[39262.939992]  ? __filemap_fdatawrite_range+0xc1/0x100
[39262.939994]  file_write_and_wait_range+0x5a/0xb0
[39262.939996]  ext4_sync_file+0x10a/0x3b0
[39262.939998]  vfs_fsync_range+0x49/0xa0
[39262.939999]  do_fsync+0x3d/0x70
[39262.940000]  SyS_fsync+0x10/0x20
[39262.940001]  do_syscall_64+0x67/0x180
[39262.940002]  entry_SYSCALL64_slow_path+0x25/0x25
[39262.940002] RIP: 0033:0x7fa91fbc682d
[39262.940002] RSP: 002b:00007fa9196ebc50 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[39262.940003] RAX: ffffffffffffffda RBX: 000055cd2a054810 RCX: 00007fa91fbc682d
[39262.940003] RDX: d6a4b17516e1ee38 RSI: 0000000000000000 RDI: 0000000000000011
[39262.940004] RBP: 00007fa920585c8c R08: 00007fa9196ec700 R09: 00007fa9196ec700
[39262.940004] R10: 00007fa9196ec9d0 R11: 0000000000000293 R12: 0000000000000002
[39262.940004] R13: 00007ffc291c2b60 R14: 000055cd2a055c10 R15: 0000000000000015
[39262.940005] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 93 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 

-- 
Dan Aloni
