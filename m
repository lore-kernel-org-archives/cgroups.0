From: Dan Aloni <dan-HWkDggknmVpWk0Htik3J/w@public.gmane.org>
Subject: cgroups-related hard lockup in 4.14?
Date: Thu, 21 Dec 2017 00:59:23 +0200
Message-ID: <20171220225923.GA10374@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelim-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Bgze+/FXvGyvAYO4I55DtIJncIB/WVKfTnu1eCvhjWI=;
        b=U4+GYEwLTuAS981cjYv6I/pxNzs+fR5eM5cmVfZ3WHX2eiUQ97AnDW/sZj4C96jcz5
         dlmBax/Lh1he3lQsN6XikjL8ZnH3DN43lLNcl0n1Lw6eqGUuQn8NEKhhkqohDm97LnLO
         p4kAQ/1RzA8v2eM0E4o12UNpL2TbmL53t8vUWc0BnIRYRg5UqKiFGuB3mtNHxUrbc9r+
         9U/fVN/gtFy4D6wvE+Iz8h8eLM0x8u7dvlaYkztJH/FBIN5Bnt6ZorM4p5DpLwkNYA3F
         uROaON9/NB04767cDT7stK0aHSxqtJNqU3+d7FXFEZBh+IOJ+Z8f+zbYE/5tNVArVjCM
         yslQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux Kernel List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Using netconsole, I was able to capture a hard lockup that seems to be
related to cgroups, on a Fedora kernel based on v4.14.4.

By my analysis, from the 16 CPUs below, 14 are on css_set_lock, one is
inside css_task_iter_advance, and the last one stuck trying to send an
IPI, I guess because all other CPUs are spinning.

To add some context, I have been experiencing deadlocks on various
machines starting from 4.13 and it's the first time I was able to
capture one. It takes a few days to reproduce while idling or doing
random work, and I have not yet come up with precise steps that can
nail it.

I can try out patches in order to get more info on this issue.

---

[541705.333160] NMI watchdog: Watchdog detected hard LOCKUP on cpu 7
[541705.333161] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541705.333182]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541705.333203] CPU: 7 PID: 1851 Comm: gsd-media-keys Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541705.333203] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541705.333204] task: ffff881130f4cc00 task.stack: ffffaa5b086bc000
[541705.333208] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541705.333209] RSP: 0018:ffffaa5b086bfc98 EFLAGS: 00000046
[541705.333209] RAX: 0000000000000000 RBX: ffff881130c75400 RCX: ffff88115e9daf80
[541705.333210] RDX: 0000000000000009 RSI: 0000000000280101 RDI: ffffffff8622f3a0
[541705.333210] RBP: ffffaa5b086bfc98 R08: 0000000000200000 R09: 0000000000000000
[541705.333210] R10: 0000000000000000 R11: 0000000000000001 R12: ffff881130f4cc00
[541705.333211] R13: ffff881130f4cc01 R14: ffff881130f4cc00 R15: ffff8811512955f8
[541705.333211] FS:  0000000000000000(0000) GS:ffff88115e9c0000(0000) knlGS:0000000000000000
[541705.333212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541705.333212] CR2: 00007ffe30e37e38 CR3: 0000000948e09002 CR4: 00000000003626e0
[541705.333213] Call Trace:
[541705.333218]  _raw_spin_lock_irq+0x28/0x30
[541705.333220]  cgroup_exit+0x4e/0xf0
[541705.333222]  do_exit+0x2fc/0xba0
[541705.333223]  do_group_exit+0x47/0xb0
[541705.333226]  get_signal+0x27b/0x590
[541705.333229]  ? compat_poll_select_copy_remaining+0x120/0x120
[541705.333231]  do_signal+0x37/0x680
[541705.333233]  ? eventfd_read+0x55/0x90
[541705.333236]  ? __sys_recvmsg+0x80/0x90
[541705.333238]  exit_to_usermode_loop+0x6e/0xb0
[541705.333239]  syscall_return_slowpath+0xc6/0xd0
[541705.333240]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541705.333241] RIP: 0033:0x7fd21142ed2d
[541705.333241] RSP: 002b:00007fff27a90260 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541705.333242] RAX: 0000000000000002 RBX: 000055621189d690 RCX: 00007fd21142ed2d
[541705.333242] RDX: 00000000ffffffff RSI: 0000000000000006 RDI: 000055621191e590
[541705.333243] RBP: 0000000000000006 R08: 0000000000000006 R09: 00005562118fdc3c
[541705.333243] R10: 0000556211871800 R11: 0000000000000293 R12: 000055621191e590
[541705.333243] R13: 00000000ffffffff R14: 00007fd211c8db80 R15: 0000000000000006
[541705.333244] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541705.754643] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
[541705.754643] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541705.754658]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541705.754671] CPU: 2 PID: 3823 Comm: cleanup Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541705.754672] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541705.754672] task: ffff881104cd8000 task.stack: ffffaa5b0c01c000
[541705.754675] RIP: 0010:queued_spin_lock_slowpath+0x135/0x1a0
[541705.754676] RSP: 0018:ffffaa5b0c01fe70 EFLAGS: 00000002
[541705.754676] RAX: 0000000000200101 RBX: ffff880876c61200 RCX: 0000000000000001
[541705.754677] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffffffff8622f3a0
[541705.754677] RBP: ffffaa5b0c01fe70 R08: 0000000000000101 R09: 0000000000000000
[541705.754678] R10: 0000000000000000 R11: 0000000000000001 R12: ffff881104cd8000
[541705.754678] R13: 00007ffd33a43200 R14: ffff881104cd8000 R15: ffff881151df4878
[541705.754679] FS:  0000000000000000(0000) GS:ffff88115e880000(0000) knlGS:0000000000000000
[541705.754679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541705.754679] CR2: 000055c83b787018 CR3: 0000000948e09003 CR4: 00000000003626e0
[541705.754680] Call Trace:
[541705.754683]  _raw_spin_lock_irq+0x28/0x30
[541705.754685]  cgroup_exit+0x4e/0xf0
[541705.754686]  do_exit+0x2fc/0xba0
[541705.754688]  ? ____fput+0xe/0x10
[541705.754689]  SyS_exit+0x17/0x20
[541705.754690]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541705.754691] RIP: 0033:0x7f0145274426
[541705.754691] RSP: 002b:00007f013ade6d50 EFLAGS: 00000246 ORIG_RAX: 000000000000003c
[541705.754692] RAX: ffffffffffffffda RBX: 000055d81bf83d20 RCX: 00007f0145274426
[541705.754692] RDX: 000000000000003c RSI: 00000000007fb000 RDI: 0000000000000000
[541705.754692] RBP: 0000000000000000 R08: 00007f01300008c0 R09: 0000000000000120
[541705.754693] R10: 0000000000000010 R11: 0000000000000246 R12: 00007f013ade6cd8
[541705.754693] R13: 00007ffd33a43200 R14: 00007f013ade79c0 R15: 0000000000000000
[541705.754694] Code: 66 31 c0 41 39 c0 74 ea 4d 85 c9 c6 07 01 74 2d 41 c7 41 08 01 00 00 00 eb 96 83 fa 01 0f 84 f4 fe ff ff 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c 8b 09 
[541706.037278] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
[541706.037279] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541706.037289]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541706.037299] CPU: 4 PID: 3935 Comm: gmain Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541706.037300] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541706.037300] task: ffff8810fd2d8000 task.stack: ffffaa5b0c464000
[541706.037302] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541706.037302] RSP: 0018:ffffaa5b0c467c98 EFLAGS: 00000046
[541706.037303] RAX: 0000000000000000 RBX: ffff881101c52c00 RCX: ffff88115e91af80
[541706.037303] RDX: 000000000000000e RSI: 00000000003c0101 RDI: ffffffff8622f3a0
[541706.037304] RBP: ffffaa5b0c467c98 R08: 0000000000140000 R09: 0000000000000000
[541706.037304] R10: 0000000000000000 R11: 0000000000000321 R12: ffff8810fd2d8000
[541706.037304] R13: ffff8810fd2d8000 R14: ffff8810fd2d8000 R15: ffff881151268df8
[541706.037305] FS:  0000000000000000(0000) GS:ffff88115e900000(0000) knlGS:0000000000000000
[541706.037305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541706.037306] CR2: 0000562b4359ede8 CR3: 0000000948e09001 CR4: 00000000003626e0
[541706.037306] Call Trace:
[541706.037308]  _raw_spin_lock_irq+0x28/0x30
[541706.037309]  cgroup_exit+0x4e/0xf0
[541706.037310]  do_exit+0x2fc/0xba0
[541706.037311]  do_group_exit+0x47/0xb0
[541706.037313]  get_signal+0x27b/0x590
[541706.037314]  do_signal+0x37/0x680
[541706.037316]  ? strlcpy+0x32/0x50
[541706.037318]  ? __set_task_comm+0x54/0xa0
[541706.037320]  exit_to_usermode_loop+0x6e/0xb0
[541706.037321]  syscall_return_slowpath+0xc6/0xd0
[541706.037322]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541706.037322] RIP: 0033:0x7fe1e6ba2d2d
[541706.037323] RSP: 002b:00007fe1d8df9ca0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541706.037323] RAX: fffffffffffffdfc RBX: 0000556c4c83f0a0 RCX: 00007fe1e6ba2d2d
[541706.037324] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fe1d40008e0
[541706.037324] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000556c4c83f128
[541706.037324] R10: 0000556c4c83c100 R11: 0000000000000293 R12: 00007fe1d40008e0
[541706.037325] R13: 00000000ffffffff R14: 00007fe1e798db80 R15: 0000000000000001
[541706.037325] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541706.228230] NMI watchdog: Watchdog detected hard LOCKUP on cpu 8
[541706.228230] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541706.228241]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541706.228253] CPU: 8 PID: 3831 Comm: gmain Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541706.228253] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541706.228254] task: ffff881103df2600 task.stack: ffffaa5b0addc000
[541706.228255] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541706.228256] RSP: 0018:ffffaa5b0addfc98 EFLAGS: 00000046
[541706.228256] RAX: 0000000000000000 RBX: ffff881154cf4000 RCX: ffff88115ea1af80
[541706.228257] RDX: 000000000000000a RSI: 00000000002c0101 RDI: ffffffff8622f3a0
[541706.228257] RBP: ffffaa5b0addfc98 R08: 0000000000240000 R09: 0000000000000000
[541706.228258] R10: 0000000000000000 R11: 0000000000000376 R12: ffff881103df2600
[541706.228258] R13: ffff881103df2601 R14: ffff881103df2600 R15: ffff881152521b78
[541706.228258] FS:  0000000000000000(0000) GS:ffff88115ea00000(0000) knlGS:0000000000000000
[541706.228259] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541706.228259] CR2: 000001a09cc77f3f CR3: 0000000948e09006 CR4: 00000000003626e0
[541706.228260] Call Trace:
[541706.228262]  _raw_spin_lock_irq+0x28/0x30
[541706.228263]  cgroup_exit+0x4e/0xf0
[541706.228264]  do_exit+0x2fc/0xba0
[541706.228265]  do_group_exit+0x47/0xb0
[541706.228266]  get_signal+0x27b/0x590
[541706.228268]  do_signal+0x37/0x680
[541706.228270]  ? do_futex+0x4bf/0xae0
[541706.228271]  ? strlcpy+0x32/0x50
[541706.228273]  ? __set_task_comm+0x54/0xa0
[541706.228274]  exit_to_usermode_loop+0x6e/0xb0
[541706.228275]  syscall_return_slowpath+0xc6/0xd0
[541706.228276]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541706.228277] RIP: 0033:0x7fda84b25d2d
[541706.228277] RSP: 002b:00007fda7c4e0d20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541706.228278] RAX: fffffffffffffdfc RBX: 00005594c6360800 RCX: 00007fda84b25d2d
[541706.228278] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fda740008e0
[541706.228278] RBP: 0000000000000001 R08: 0000000000000001 R09: 00005594c6360888
[541706.228279] R10: 00005594c6348940 R11: 0000000000000293 R12: 00007fda740008e0
[541706.228279] R13: 00000000ffffffff R14: 00007fda85271b80 R15: 0000000000000001
[541706.228280] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541707.212692] NMI watchdog: Watchdog detected hard LOCKUP on cpu 6
[541707.212692] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541707.212703]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541707.212714] CPU: 6 PID: 1865 Comm: gdbus Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541707.212715] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541707.212715] task: ffff881151498000 task.stack: ffffaa5b0ac94000
[541707.212717] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541707.212717] RSP: 0018:ffffaa5b0ac97c98 EFLAGS: 00000046
[541707.212718] RAX: 0000000000000000 RBX: ffff881130c75400 RCX: ffff88115e99af80
[541707.212718] RDX: 0000000000000005 RSI: 0000000000180101 RDI: ffffffff8622f3a0
[541707.212719] RBP: ffffaa5b0ac97c98 R08: 00000000001c0000 R09: 0000000000000000
[541707.212719] R10: 0000000000000000 R11: 0000000000000325 R12: ffff881151498000
[541707.212719] R13: ffff881151498001 R14: ffff881151498000 R15: ffff8811517ff0f8
[541707.212720] FS:  00007f1955d29700(0000) GS:ffff88115e980000(0000) knlGS:0000000000000000
[541707.212720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541707.212721] CR2: 000056006f2ad110 CR3: 0000000948e09001 CR4: 00000000003626e0
[541707.212721] Call Trace:
[541707.212723]  _raw_spin_lock_irq+0x28/0x30
[541707.212724]  cgroup_exit+0x4e/0xf0
[541707.212725]  do_exit+0x2fc/0xba0
[541707.212727]  ? default_wake_function+0x12/0x20
[541707.212728]  do_group_exit+0x47/0xb0
[541707.212729]  get_signal+0x27b/0x590
[541707.212731]  do_signal+0x37/0x680
[541707.212733]  exit_to_usermode_loop+0x6e/0xb0
[541707.212734]  syscall_return_slowpath+0xc6/0xd0
[541707.212735]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541707.212735] RIP: 0033:0x7f19641b0d2d
[541707.212736] RSP: 002b:00007f1955d28b10 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541707.212736] RAX: fffffffffffffdfc RBX: 0000562b976fbef0 RCX: 00007f19641b0d2d
[541707.212737] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f19480010c0
[541707.212737] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000562b976fbf78
[541707.212738] R10: 0000562b976b6a20 R11: 0000000000000293 R12: 00007f19480010c0
[541707.212738] R13: 00000000ffffffff R14: 00007f1964a0fb80 R15: 0000000000000002
[541707.212739] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541707.789303] NMI watchdog: Watchdog detected hard LOCKUP on cpu 9
[541707.789304] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541707.789317]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541707.789330] CPU: 9 PID: 3906 Comm: obexd Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541707.789330] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541707.789331] task: ffff8810fd05cc00 task.stack: ffffaa5b0c2d4000
[541707.789333] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541707.789334] RSP: 0018:ffffaa5b0c2d7e40 EFLAGS: 00000046
[541707.789334] RAX: 0000000000000000 RBX: ffff881120e85800 RCX: ffff88115ea5af80
[541707.789335] RDX: 0000000000000006 RSI: 00000000001c0101 RDI: ffffffff8622f3a0
[541707.789335] RBP: ffffaa5b0c2d7e40 R08: 0000000000280000 R09: 0000000000000000
[541707.789336] R10: 0000000000000000 R11: 00000000000001d0 R12: ffff8810fd05cc00
[541707.789336] R13: ffff8810fd05cc01 R14: ffff8810fd05cc00 R15: ffff8811519243f8
[541707.789337] FS:  0000000000000000(0000) GS:ffff88115ea40000(0000) knlGS:0000000000000000
[541707.789337] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541707.789338] CR2: 00007ff55d63af40 CR3: 0000000948e09001 CR4: 00000000003626e0
[541707.789338] Call Trace:
[541707.789341]  _raw_spin_lock_irq+0x28/0x30
[541707.789342]  cgroup_exit+0x4e/0xf0
[541707.789343]  do_exit+0x2fc/0xba0
[541707.789345]  do_group_exit+0x47/0xb0
[541707.789346]  SyS_exit_group+0x14/0x20
[541707.789347]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541707.789348] RIP: 0033:0x7ff56092eff8
[541707.789348] RSP: 002b:00007ffe9c07c7b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[541707.789349] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff56092eff8
[541707.789349] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[541707.789350] RBP: 00007ffe9c07c7b0 R08: 00000000000000e7 R09: ffffffffffffff90
[541707.789350] R10: 00007ff55d31ab40 R11: 0000000000000246 R12: 00007ff562696000
[541707.789351] R13: 00007ff5625d1860 R14: 00007ffe9c07c728 R15: 00007ff55d83dc10
[541707.789352] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541708.196178] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1
[541708.196179] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541708.196188]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541708.196197] CPU: 1 PID: 1 Comm: systemd Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541708.196198] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541708.196198] task: ffff881157c7cc00 task.stack: ffffaa5b00078000
[541708.196199] RIP: 0010:css_task_iter_advance+0x4d/0x70
[541708.196199] RSP: 0018:ffffaa5b0007bce0 EFLAGS: 00000006
[541708.196200] RAX: ffff88105e5f8890 RBX: ffff8810537fe290 RCX: dead000000000200
[541708.196200] RDX: ffff88105e5f88a0 RSI: ffff88105e5f88a0 RDI: ffff88115123e1e0
[541708.196201] RBP: ffffaa5b0007bcf0 R08: ffff88105e5f88a0 R09: ffff88115123e180
[541708.196201] R10: ffff88115e406b80 R11: 0000000000002000 R12: ffff88115123e180
[541708.196201] R13: 0000000000000000 R14: 0000000000000003 R15: ffff880ffa165800
[541708.196202] FS:  00007fd9b0aeaa00(0000) GS:ffff88115e840000(0000) knlGS:0000000000000000
[541708.196202] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541708.196203] CR2: 00007fd9ac3dff0c CR3: 00000010553da003 CR4: 00000000003626e0
[541708.196203] Call Trace:
[541708.196204]  css_task_iter_next+0x53/0x70
[541708.196205]  __cgroup_procs_start.isra.32+0x6d/0xe0
[541708.196206]  cgroup_procs_start+0x5a/0x60
[541708.196208]  cgroup_seqfile_start+0x1a/0x20
[541708.196210]  kernfs_seq_start+0x4f/0x90
[541708.196212]  seq_read+0xa0/0x3f0
[541708.196215]  ? _copy_to_user+0x26/0x30
[541708.196216]  kernfs_fop_read+0x134/0x180
[541708.196219]  __vfs_read+0x37/0x160
[541708.196221]  ? security_file_permission+0x9b/0xc0
[541708.196222]  vfs_read+0x8e/0x130
[541708.196223]  SyS_read+0x55/0xc0
[541708.196224]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541708.196225] RIP: 0033:0x7fd9af16042d
[541708.196225] RSP: 002b:00007ffc5a240fc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
[541708.196225] RAX: ffffffffffffffda RBX: 00000000000000bc RCX: 00007fd9af16042d
[541708.196226] RDX: 0000000000001000 RSI: 0000556a8176f6b0 RDI: 00000000000000bc
[541708.196226] RBP: 00007ffc5a241960 R08: 0000556a8176f6b0 R09: 0000000000000000
[541708.196226] R10: 00007fd9af42fb38 R11: 0000000000000293 R12: 0000000000000000
[541708.196227] R13: 0000556a816cf680 R14: 0000000000000002 R15: 0000556a7fbda716
[541708.196227] Code: 24 08 01 49 89 5c 24 30 74 3b 49 8b 44 24 30 48 85 c0 74 31 8b 80 9c fb ff ff 85 c0 79 27 48 8b 1b 49 39 5c 24 38 49 8b 44 24 40 <75> cb 48 8b 18 48 39 d8 75 c8 4c 89 e7 e8 91 fd ff ff 41 f6 44 
[541708.415536] NMI watchdog: Watchdog detected hard LOCKUP on cpu 3
[541708.415537] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541708.415548]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541708.415559] CPU: 3 PID: 3405 Comm: systemd Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541708.415559] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541708.415559] task: ffff881111e5cc00 task.stack: ffffaa5b0e034000
[541708.415561] RIP: 0010:queued_spin_lock_slowpath+0xee/0x1a0
[541708.415562] RSP: 0018:ffffaa5b0e037cd0 EFLAGS: 00000002
[541708.415562] RAX: 0000000000000000 RBX: ffff8810efbaab00 RCX: ffff88115e8daf80
[541708.415563] RDX: 0000000000200101 RSI: 0000000000000101 RDI: ffffffff8622f3a0
[541708.415563] RBP: ffffaa5b0e037cd0 R08: 0000000000100000 R09: 0000000000000000
[541708.415564] R10: ffff88115e406b80 R11: 0000000000004000 R12: ffff88111784dc00
[541708.415564] R13: 0000000000000003 R14: 0000000000000003 R15: ffff88111784dc00
[541708.415565] FS:  00007fe40a8d0a00(0000) GS:ffff88115e8c0000(0000) knlGS:0000000000000000
[541708.415565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541708.415565] CR2: 0000557888dbbde8 CR3: 0000001010f78004 CR4: 00000000003626e0
[541708.415566] Call Trace:
[541708.415568]  _raw_spin_lock_irq+0x28/0x30
[541708.415569]  css_task_iter_start+0x58/0xc0
[541708.415570]  __cgroup_procs_start.isra.32+0xc9/0xe0
[541708.415571]  cgroup_procs_start+0x5a/0x60
[541708.415572]  cgroup_seqfile_start+0x1a/0x20
[541708.415574]  kernfs_seq_start+0x4f/0x90
[541708.415575]  seq_read+0xa0/0x3f0
[541708.415577]  ? _copy_to_user+0x26/0x30
[541708.415578]  kernfs_fop_read+0x134/0x180
[541708.415580]  __vfs_read+0x37/0x160
[541708.415582]  ? security_file_permission+0x9b/0xc0
[541708.415583]  vfs_read+0x8e/0x130
[541708.415583]  SyS_read+0x55/0xc0
[541708.415585]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541708.415585] RIP: 0033:0x7fe408f46410
[541708.415586] RSP: 002b:00007ffe9c113768 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[541708.415586] RAX: ffffffffffffffda RBX: 000000000000001b RCX: 00007fe408f46410
[541708.415587] RDX: 0000000000001000 RSI: 0000557888dabd80 RDI: 000000000000001b
[541708.415587] RBP: 00007ffe9c1140f0 R08: 0000557888dabd80 R09: 0000000000000077
[541708.415587] R10: 00007fe409215b38 R11: 0000000000000246 R12: 0000000000000000
[541708.415588] R13: 0000557888d7a070 R14: 000000000000000f R15: 0000557887cd2716
[541708.415588] Code: f3 90 8b 37 81 fe 00 01 00 00 74 f4 e9 5f ff ff ff 44 89 c0 c1 e8 10 66 87 47 02 89 c2 c1 e2 10 85 d2 75 6a 45 31 c9 eb 02 f3 90 <8b> 17 66 85 d2 75 f7 be 01 00 00 00 eb 0c 89 d0 f0 0f b1 37 39 
[541708.658095] NMI watchdog: Watchdog detected hard LOCKUP on cpu 5
[541708.658096] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541708.658107]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541708.658118] CPU: 5 PID: 1859 Comm: gmain Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541708.658118] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541708.658119] task: ffff88115253cc00 task.stack: ffffaa5b08024000
[541708.658121] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541708.658121] RSP: 0018:ffffaa5b08027c98 EFLAGS: 00000046
[541708.658122] RAX: 0000000000000000 RBX: ffff881130c75400 RCX: ffff88115e95af80
[541708.658122] RDX: 0000000000000000 RSI: 0000000000040101 RDI: ffffffff8622f3a0
[541708.658122] RBP: ffffaa5b08027c98 R08: 0000000000180000 R09: 0000000000000000
[541708.658123] R10: 0000000000000000 R11: 000000000000039b R12: ffff88115253cc00
[541708.658123] R13: ffff88115253cc01 R14: ffff88115253cc00 R15: ffff8811517fa8f8
[541708.658124] FS:  00007f202c0d1700(0000) GS:ffff88115e940000(0000) knlGS:0000000000000000
[541708.658124] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541708.658124] CR2: 00007f9b1d0f6308 CR3: 0000000948e09005 CR4: 00000000003626e0
[541708.658125] Call Trace:
[541708.658127]  _raw_spin_lock_irq+0x28/0x30
[541708.658128]  cgroup_exit+0x4e/0xf0
[541708.658129]  do_exit+0x2fc/0xba0
[541708.658130]  do_group_exit+0x47/0xb0
[541708.658131]  get_signal+0x27b/0x590
[541708.658132]  do_signal+0x37/0x680
[541708.658134]  ? strlcpy+0x32/0x50
[541708.658135]  ? __set_task_comm+0x54/0xa0
[541708.658136]  exit_to_usermode_loop+0x6e/0xb0
[541708.658137]  syscall_return_slowpath+0xc6/0xd0
[541708.658138]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541708.658139] RIP: 0033:0x7f203a27dd2d
[541708.658139] RSP: 002b:00007f202c0d0b20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541708.658140] RAX: fffffffffffffdfc RBX: 0000556f2649fe60 RCX: 00007f203a27dd2d
[541708.658140] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f20240008e0
[541708.658141] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000556f2649fee8
[541708.658141] R10: 0000556f264662c0 R11: 0000000000000293 R12: 00007f20240008e0
[541708.658141] R13: 00000000ffffffff R14: 00007f203a9d5b80 R15: 0000000000000001
[541708.658142] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541709.778576] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
[541709.778576] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541709.778586]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541709.778595] CPU: 15 PID: 1877 Comm: gmain Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541709.778603]  do_exit+0x2fc/0xba0
[541709.778604]  do_group_exit+0x47/0xb0
[541709.778605]  get_signal+0x27b/0x590
[541709.778606]  do_signal+0x37/0x680
[541709.778608]  ? strlcpy+0x32/0x50
[541709.778609]  ? __set_task_comm+0x54/0xa0
[541709.778610]  exit_to_usermode_loop+0x6e/0xb0
[541709.778611]  syscall_return_slowpath+0xc6/0xd0
[541709.778612]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541709.778612] RIP: 0033:0x7fd21142ed2d
[541709.778612] RSP: 002b:00007fd200cb7b20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541709.778613] RAX: fffffffffffffdfc RBX: 00005562118ccff0 RCX: 00007fd21142ed2d
[541709.778613] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fd1fc0008e0
[541709.778614] RBP: 0000000000000001 R08: 0000000000000001 R09: 00005562118cd078
[541709.778614] R10: 00005562118a1ca0 R11: 0000000000000293 R12: 00007fd1fc0008e0
[541709.778614] R13: 00000000ffffffff R14: 00007fd211c8db80 R15: 0000000000000001
[541709.778615] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541709.924530] NMI watchdog: Watchdog detected hard LOCKUP on cpu 11
[541709.924530] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541709.924540]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541709.924548] CPU: 11 PID: 1855 Comm: gmain Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541709.924549] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541709.924549] task: ffff881151c00000 task.stack: ffffaa5b08794000
[541709.924550] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541709.924550] RSP: 0018:ffffaa5b08797c98 EFLAGS: 00000046
[541709.924551] RAX: 0000000000000000 RBX: ffff881130c75400 RCX: ffff88115eadaf80
[541709.924551] RDX: 000000000000000d RSI: 0000000000380101 RDI: ffffffff8622f3a0
[541709.924552] RBP: ffffaa5b08797c98 R08: 0000000000300000 R09: 0000000000000000
[541709.924552] R10: 0000000000000000 R11: 0000000000000001 R12: ffff881151c00000
[541709.924552] R13: ffff881151c00000 R14: ffff881151c00000 R15: ffff881151921278
[541709.924553] FS:  0000000000000000(0000) GS:ffff88115eac0000(0000) knlGS:0000000000000000
[541709.924553] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541709.924554] CR2: 0000008b5986c2b8 CR3: 0000000948e09003 CR4: 00000000003626e0
[541709.924554] Call Trace:
[541709.924555]  _raw_spin_lock_irq+0x28/0x30
[541709.924556]  cgroup_exit+0x4e/0xf0
[541709.924557]  do_exit+0x2fc/0xba0
[541709.924558]  do_group_exit+0x47/0xb0
[541709.924559]  get_signal+0x27b/0x590
[541709.924560]  ? eventfd_ctx_read+0x67/0x230
[541709.924562]  do_signal+0x37/0x680
[541709.924562]  ? eventfd_read+0x55/0x90
[541709.924564]  exit_to_usermode_loop+0x6e/0xb0
[541709.924565]  syscall_return_slowpath+0xc6/0xd0
[541709.924566]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541709.924566] RIP: 0033:0x7f6ef605cd2d
[541709.924567] RSP: 002b:00007f6ee83a4b20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541709.924567] RAX: fffffffffffffdfc RBX: 0000557f3bad8e60 RCX: 00007f6ef605cd2d
[541709.924568] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f6ee00008e0
[541709.924568] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000557f3bb039e0
[541709.924568] R10: 0000557f3bb03d40 R11: 0000000000000293 R12: 00007f6ee00008e0
[541709.924569] R13: 00000000ffffffff R14: 00007f6ef68e3b80 R15: 0000000000000002
[541709.924569] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541710.536876] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
[541710.536877] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541710.536886]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541710.536895] CPU: 0 PID: 1782 Comm: threaded-ml Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541710.536895] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541710.536895] task: ffff8811242c0000 task.stack: ffffaa5b08b3c000
[541710.536897] RIP: 0010:queued_spin_lock_slowpath+0x17b/0x1a0
[541710.536897] RSP: 0018:ffffaa5b08b3fc98 EFLAGS: 00000046
[541710.536897] RAX: 0000000000000000 RBX: ffff881130c75400 RCX: ffff88115e81af80
[541710.536898] RDX: 0000000000000004 RSI: 0000000000140101 RDI: ffffffff8622f3a0
[541710.536898] RBP: ffffaa5b08b3fc98 R08: 0000000000040000 R09: 0000000000000000
[541710.536898] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8811242c0000
[541713.064737] RBP: ffffaa5b0c0b7c98 R08: 00000000002c0000 R09: 0000000000000000
[541713.064737] R10: 0000000000000000 R11: 0000000000000011 R12: ffff881117940000
[541713.064738] R13: ffff881117940001 R14: ffff881117940000 R15: ffff881151ff1278
[541713.064738] FS:  0000000000000000(0000) GS:ffff88115ea80000(0000) knlGS:0000000000000000
[541713.064739] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541713.064739] CR2: 00007fb62243e9d0 CR3: 0000000948e09005 CR4: 00000000003626e0
[541713.064739] Call Trace:
[541713.064740]  _raw_spin_lock_irq+0x28/0x30
[541713.064741]  cgroup_exit+0x4e/0xf0
[541713.064742]  do_exit+0x2fc/0xba0
[541713.064743]  do_group_exit+0x47/0xb0
[541713.064744]  get_signal+0x27b/0x590
[541713.064745]  do_signal+0x37/0x680
[541713.064747]  ? strlcpy+0x32/0x50
[541713.064748]  ? __set_task_comm+0x54/0xa0
[541713.064749]  exit_to_usermode_loop+0x6e/0xb0
[541713.064750]  syscall_return_slowpath+0xc6/0xd0
[541713.064751]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[541713.064751] RIP: 0033:0x7f7525074d2d
[541713.064752] RSP: 002b:00007f751c5e0d20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[541713.064752] RAX: fffffffffffffdfc RBX: 000055abf4f69000 RCX: 00007f7525074d2d
[541713.064753] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f75140008e0
[541713.064753] RBP: 0000000000000001 R08: 0000000000000001 R09: 000055abf4f69088
[541713.064753] R10: 000055abf4f2d940 R11: 0000000000000293 R12: 00007f75140008e0
[541713.064754] R13: 00000000ffffffff R14: 00007f75257c0b80 R15: 0000000000000001
[541713.064754] Code: c9 c1 ea 12 83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 af 01 00 48 03 04 d5 c0 13 d4 85 48 89 08 8b 41 08 85 c0 75 09 f3 90 <8b> 41 08 85 c0 74 f7 4c 8b 09 4d 85 c9 0f 84 59 ff ff ff 41 0f 
[541722.376038] watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [CPU 1/KVM:13060]
[541722.376693] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541722.376709]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541722.376724] CPU: 12 PID: 13060 Comm: CPU 1/KVM Tainted: P         C OE   4.14.4-200.fc26.x86_64 #1
[541722.376725] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541722.376726] task: ffff881046640000 task.stack: ffffaa5b0c214000
[541722.376729] RIP: 0010:smp_call_function_single+0xdc/0x100
[541722.376730] RSP: 0018:ffffaa5b0c217a40 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
[541722.376731] RAX: 0000000000000000 RBX: ffff881032728000 RCX: 0000000000000000
[541722.376733] RDX: 0000000000000001 RSI: 00000000000000fb RDI: 0000000000000202
[541722.376734] RBP: ffffaa5b0c217a90 R08: ffffaa5b0c070000 R09: 0000000000001888
[541722.376736] R10: ffffaa5b0c217ac0 R11: 00000000000002b4 R12: 000000000000000c
[541722.376737] R13: ffff8810eead8000 R14: 000000000000000c R15: 000000000000000b
[541722.376738] FS:  00007f6a9772c700(0000) GS:ffff88115eb00000(0000) knlGS:0000000000000000
[541722.376739] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541722.376740] CR2: 00007f359cca9000 CR3: 0000000f64637003 CR4: 00000000003626e0
[541722.376741] Call Trace:
[541722.376747]  ? hardware_enable+0x190/0x190 [kvm_intel]
[541722.376750]  vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541722.376752]  ? vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541722.376756]  ? hrtimer_try_to_cancel+0x2a/0x110
[541722.376757]  ? timerqueue_add+0x57/0x80
[541722.376760]  ? update_load_avg+0x429/0x590
[541722.376762]  ? update_curr+0x159/0x1b0
[541722.376763]  ? update_curr+0x7a/0x1b0
[541722.376781]  kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541722.376789]  ? kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541722.376796]  kvm_sched_in+0x39/0x40 [kvm]
[541722.376801]  ? kvm_sched_in+0x39/0x40 [kvm]
[541722.376804]  finish_task_switch+0x157/0x240
[541722.376806]  __schedule+0x241/0x860
[541722.376815]  ? kvm_apic_has_interrupt+0x45/0x90 [kvm]
[541722.376816]  schedule+0x2c/0x80
[541722.376823]  kvm_vcpu_block+0x8a/0x2f0 [kvm]
[541722.376831]  kvm_arch_vcpu_ioctl_run+0x13c/0x1650 [kvm]
[541722.376838]  kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541722.376844]  ? kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541722.376846]  do_vfs_ioctl+0xa5/0x600
[541722.376848]  SyS_ioctl+0x79/0x90
[541722.376850]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541722.376851] RIP: 0033:0x7f6aa7f80847
[541722.376853] RSP: 002b:00007f6a9772b7c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[541722.376855] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f6aa7f80847
[541722.376856] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000017
[541722.376857] RBP: 000055c7159bc8e0 R08: 000055c7159d7e30 R09: 00000000000000ff
[541722.376858] R10: 000055c71b04e0e0 R11: 0000000000000246 R12: 000055c718c1e0a6
[541722.376859] R13: 0000000000000000 R14: 00007f6ab180f000 R15: 000055c718c1e000
[541722.376860] Code: 28 00 00 00 75 40 48 83 c4 48 41 5a 5d 49 8d 62 f8 c3 48 89 d1 48 89 f2 48 8d 75 b0 e8 7e fe ff ff 8b 55 c8 83 e2 01 74 0a f3 90 <8b> 55 c8 83 e2 01 75 f6 eb c2 8b 05 f4 fa 0a 01 85 c0 75 81 0f 
[541749.256510] watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [CPU 1/KVM:13060]
[541749.256512] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541749.256527]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541749.256542] CPU: 12 PID: 13060 Comm: CPU 1/KVM Tainted: P         C OEL  4.14.4-200.fc26.x86_64 #1
[541749.256543] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541749.256545] task: ffff881046640000 task.stack: ffffaa5b0c214000
[541749.256547] RIP: 0010:smp_call_function_single+0xda/0x100
[541749.256548] RSP: 0018:ffffaa5b0c217a40 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
[541749.256549] RAX: 0000000000000000 RBX: ffff881032728000 RCX: 0000000000000000
[541749.256550] RDX: 0000000000000001 RSI: 00000000000000fb RDI: 0000000000000202
[541749.256551] RBP: ffffaa5b0c217a90 R08: ffffaa5b0c070000 R09: 0000000000001888
[541749.256552] R10: ffffaa5b0c217ac0 R11: 00000000000002b4 R12: 000000000000000c
[541749.256553] R13: ffff8810eead8000 R14: 000000000000000c R15: 000000000000000b
[541749.256554] FS:  00007f6a9772c700(0000) GS:ffff88115eb00000(0000) knlGS:0000000000000000
[541749.256556] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541749.256557] CR2: 00007f359cca9000 CR3: 0000000f64637003 CR4: 00000000003626e0
[541749.256558] Call Trace:
[541749.256562]  ? hardware_enable+0x190/0x190 [kvm_intel]
[541749.256564]  vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541749.256566]  ? vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541749.256569]  ? hrtimer_try_to_cancel+0x2a/0x110
[541749.256570]  ? timerqueue_add+0x57/0x80
[541749.256573]  ? update_load_avg+0x429/0x590
[541749.256574]  ? update_curr+0x159/0x1b0
[541749.256575]  ? update_curr+0x7a/0x1b0
[541749.256587]  kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541749.256595]  ? kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541749.256602]  kvm_sched_in+0x39/0x40 [kvm]
[541749.256608]  ? kvm_sched_in+0x39/0x40 [kvm]
[541749.256610]  finish_task_switch+0x157/0x240
[541749.256611]  __schedule+0x241/0x860
[541749.256620]  ? kvm_apic_has_interrupt+0x45/0x90 [kvm]
[541749.256622]  schedule+0x2c/0x80
[541749.256628]  kvm_vcpu_block+0x8a/0x2f0 [kvm]
[541749.256636]  kvm_arch_vcpu_ioctl_run+0x13c/0x1650 [kvm]
[541749.256643]  kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541749.256649]  ? kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541749.256651]  do_vfs_ioctl+0xa5/0x600
[541749.256653]  SyS_ioctl+0x79/0x90
[541749.256655]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541749.256656] RIP: 0033:0x7f6aa7f80847
[541749.256657] RSP: 002b:00007f6a9772b7c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[541749.256658] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f6aa7f80847
[541749.256659] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000017
[541749.256660] RBP: 000055c7159bc8e0 R08: 000055c7159d7e30 R09: 00000000000000ff
[541749.256661] R10: 000055c71b04e0e0 R11: 0000000000000246 R12: 000055c718c1e0a6
[541749.256662] R13: 0000000000000000 R14: 00007f6ab180f000 R15: 000055c718c1e000
[541749.256664] Code: 3c 25 28 00 00 00 75 40 48 83 c4 48 41 5a 5d 49 8d 62 f8 c3 48 89 d1 48 89 f2 48 8d 75 b0 e8 7e fe ff ff 8b 55 c8 83 e2 01 74 0a <f3> 90 8b 55 c8 83 e2 01 75 f6 eb c2 8b 05 f4 fa 0a 01 85 c0 75 
[541776.136981] watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [CPU 1/KVM:13060]
[541776.136982] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541776.136997]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541776.137011] CPU: 12 PID: 13060 Comm: CPU 1/KVM Tainted: P         C OEL  4.14.4-200.fc26.x86_64 #1
[541776.137012] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541776.137014] task: ffff881046640000 task.stack: ffffaa5b0c214000
[541776.137016] RIP: 0010:smp_call_function_single+0xdf/0x100
[541776.137017] RSP: 0018:ffffaa5b0c217a40 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
[541776.137018] RAX: 0000000000000000 RBX: ffff881032728000 RCX: 0000000000000000
[541776.137019] RDX: 0000000000000003 RSI: 00000000000000fb RDI: 0000000000000202
[541776.137020] RBP: ffffaa5b0c217a90 R08: ffffaa5b0c070000 R09: 0000000000001888
[541776.137021] R10: ffffaa5b0c217ac0 R11: 00000000000002b4 R12: 000000000000000c
[541776.137022] R13: ffff8810eead8000 R14: 000000000000000c R15: 000000000000000b
[541776.137023] FS:  00007f6a9772c700(0000) GS:ffff88115eb00000(0000) knlGS:0000000000000000
[541776.137024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541776.137026] CR2: 00007f359cca9000 CR3: 0000000f64637003 CR4: 00000000003626e0
[541776.137027] Call Trace:
[541776.137030]  ? hardware_enable+0x190/0x190 [kvm_intel]
[541776.137032]  vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541776.137034]  ? vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541776.137036]  ? hrtimer_try_to_cancel+0x2a/0x110
[541776.137038]  ? timerqueue_add+0x57/0x80
[541776.137039]  ? update_load_avg+0x429/0x590
[541776.137041]  ? update_curr+0x159/0x1b0
[541776.137043]  ? update_curr+0x7a/0x1b0
[541776.137051]  kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541776.137058]  ? kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541776.137064]  kvm_sched_in+0x39/0x40 [kvm]
[541776.137070]  ? kvm_sched_in+0x39/0x40 [kvm]
[541776.137072]  finish_task_switch+0x157/0x240
[541776.137074]  __schedule+0x241/0x860
[541776.137083]  ? kvm_apic_has_interrupt+0x45/0x90 [kvm]
[541776.137084]  schedule+0x2c/0x80
[541776.137091]  kvm_vcpu_block+0x8a/0x2f0 [kvm]
[541776.137099]  kvm_arch_vcpu_ioctl_run+0x13c/0x1650 [kvm]
[541776.137106]  kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541776.137112]  ? kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541776.137114]  do_vfs_ioctl+0xa5/0x600
[541776.137117]  SyS_ioctl+0x79/0x90
[541776.137119]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541776.137120] RIP: 0033:0x7f6aa7f80847
[541776.137121] RSP: 002b:00007f6a9772b7c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[541776.137123] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f6aa7f80847
[541776.137124] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000017
[541776.137125] RBP: 000055c7159bc8e0 R08: 000055c7159d7e30 R09: 00000000000000ff
[541776.137126] R10: 000055c71b04e0e0 R11: 0000000000000246 R12: 000055c718c1e0a6
[541776.137127] R13: 0000000000000000 R14: 00007f6ab180f000 R15: 000055c718c1e000
[541776.137129] Code: 00 75 40 48 83 c4 48 41 5a 5d 49 8d 62 f8 c3 48 89 d1 48 89 f2 48 8d 75 b0 e8 7e fe ff ff 8b 55 c8 83 e2 01 74 0a f3 90 8b 55 c8 <83> e2 01 75 f6 eb c2 8b 05 f4 fa 0a 01 85 c0 75 81 0f ff e9 7a 
[541803.017453] watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [CPU 1/KVM:13060]
[541803.017454] Modules linked in: netlink_diag rpcsec_gss_krb5 vhost_net vhost tap fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun netconsole nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw bridge stp llc iptable_security ebtable_filter ebtables ip6table_filter ip6_tables bnep vfat fat nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE) snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel r8822be(C) kvm snd_hda_
 codec_realtek
[541803.017469]  snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel intel_cstate snd_hda_codec mac80211 snd_hda_core snd_hwdep snd_seq btusb snd_seq_device btrtl drm_kms_helper btbcm snd_pcm intel_uncore eeepc_wmi iTCO_wdt asus_wmi iTCO_vendor_support btintel sparse_keymap intel_rapl_perf bluetooth cfg80211 video drm wmi_bmof snd_timer snd tpm_tis ioatdma tpm_tis_core ecdh_generic mei_me joydev i2c_i801 soundcore rfkill shpchp mei dca tpm intel_lpss_acpi intel_lpss nfsd auth_rpcgss binfmt_misc nfs_acl lockd grace sunrpc e1000e mxm_wmi ptp crc32c_intel pps_core wmi
[541803.017482] CPU: 12 PID: 13060 Comm: CPU 1/KVM Tainted: P         C OEL  4.14.4-200.fc26.x86_64 #1
[541803.017483] Hardware name: System manufacturer System Product Name/ROG STRIX X299-E GAMING, BIOS 1004 11/14/2017
[541803.017485] task: ffff881046640000 task.stack: ffffaa5b0c214000
[541803.017486] RIP: 0010:smp_call_function_single+0xdc/0x100
[541803.017488] RSP: 0018:ffffaa5b0c217a40 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
[541803.017489] RAX: 0000000000000000 RBX: ffff881032728000 RCX: 0000000000000000
[541803.017491] RDX: 0000000000000001 RSI: 00000000000000fb RDI: 0000000000000202
[541803.017492] RBP: ffffaa5b0c217a90 R08: ffffaa5b0c070000 R09: 0000000000001888
[541803.017493] R10: ffffaa5b0c217ac0 R11: 00000000000002b4 R12: 000000000000000c
[541803.017495] R13: ffff8810eead8000 R14: 000000000000000c R15: 000000000000000b
[541803.017496] FS:  00007f6a9772c700(0000) GS:ffff88115eb00000(0000) knlGS:0000000000000000
[541803.017497] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[541803.017498] CR2: 00007f359cca9000 CR3: 0000000f64637003 CR4: 00000000003626e0
[541803.017499] Call Trace:
[541803.017501]  ? hardware_enable+0x190/0x190 [kvm_intel]
[541803.017504]  vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541803.017506]  ? vmx_vcpu_load+0x30d/0x360 [kvm_intel]
[541803.017508]  ? hrtimer_try_to_cancel+0x2a/0x110
[541803.017509]  ? timerqueue_add+0x57/0x80
[541803.017512]  ? update_load_avg+0x429/0x590
[541803.017513]  ? update_curr+0x159/0x1b0
[541803.017514]  ? update_curr+0x7a/0x1b0
[541803.017522]  kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541803.017529]  ? kvm_arch_vcpu_load+0x69/0x240 [kvm]
[541803.017535]  kvm_sched_in+0x39/0x40 [kvm]
[541803.017542]  ? kvm_sched_in+0x39/0x40 [kvm]
[541803.017544]  finish_task_switch+0x157/0x240
[541803.017545]  __schedule+0x241/0x860
[541803.017553]  ? kvm_apic_has_interrupt+0x45/0x90 [kvm]
[541803.017555]  schedule+0x2c/0x80
[541803.017562]  kvm_vcpu_block+0x8a/0x2f0 [kvm]
[541803.017569]  kvm_arch_vcpu_ioctl_run+0x13c/0x1650 [kvm]
[541803.017576]  kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541803.017582]  ? kvm_vcpu_ioctl+0x2a6/0x620 [kvm]
[541803.017584]  do_vfs_ioctl+0xa5/0x600
[541803.017586]  SyS_ioctl+0x79/0x90
[541803.017588]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[541803.017589] RIP: 0033:0x7f6aa7f80847
[541803.017590] RSP: 002b:00007f6a9772b7c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[541803.017592] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f6aa7f80847
[541803.017593] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000017
[541803.017594] RBP: 000055c7159bc8e0 R08: 000055c7159d7e30 R09: 00000000000000ff
[541803.017595] R10: 000055c71b04e0e0 R11: 0000000000000246 R12: 000055c718c1e0a6
[541803.017596] R13: 0000000000000000 R14: 00007f6ab180f000 R15: 000055c718c1e000
[541803.017597] Code: 28 00 00 00 75 40 48 83 c4 48 41 5a 5d 49 8d 62 f8 c3 48 89 d1 48 89 f2 48 8d 75 b0 e8 7e fe ff ff 8b 55 c8 83 e2 01 74 0a f3 90 <8b> 55 c8 83 e2 01 75 f6 eb c2 8b 05 f4 fa 0a 01 85 c0 75 81 0f 

-- 
Dan Aloni
