From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: general protection fault on 3.15.6
Date: Mon, 21 Jul 2014 11:47:47 +0200
Message-ID: <20140721094747.GC10162@dhcp22.suse.cz>
References: <CAKbGBLjYWrooGZjZS_MaDe9kxacoaL9dHJM1oDe7_a-vQuhsJw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKbGBLjYWrooGZjZS_MaDe9kxacoaL9dHJM1oDe7_a-vQuhsJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Noonan <steven-Cunn4gMjHvbm+q05EWxUEA@public.gmane.org>
Cc: Linux Kernel mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Looks like cgroup related. CCing cgrroup ML.

On Sun 20-07-14 21:27:42, Steven Noonan wrote:
> My router/storage box suddenly stopped responding (originally noticed
> because dnsmasq wasn't responding) and I had to reboot it. I checked
> the systemd journal when it came back and these were the last thing in
> there for the previous boot. Any ideas about pinning down the cause?
> 
> general protection fault: 0000 [#1] SMP
> Modules linked in: zfs(PO) zunicode(PO) zavl(PO) zcommon(PO)
> znvpair(PO) spl(O) xt_nat sit tunnel4 ip_tunnel sch_sfq 8021q
> ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
> ipt_REJECT xt_tcpudp xt_LOG ip6t_rt xt_limit nf_conntrack_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc
> xt_conntrack nf_conntrack iptable_filter ip6table_filter ip6_tables
> ip_tables x_tables it87 hwmon_vid nls_cp437 vfat fat
> snd_hda_codec_hdmi snd_hda_codec_realtek iTCO_wdt
> snd_hda_codec_generic iTCO_vendor_support raid0 raid1 md_mod
> x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
> glue_helper ablk_helper cryptd snd_hda_intel snd_hda_controller
> snd_hda_codec microcode r8169 i2c_i801 snd_hwdep acpi_cpufreq
>  snd_pcm mii snd_timer thermal snd fan soundcore lpc_ich battery
> mfd_core evdev processor tun usbip_host(C) usbip_core(C) msr loop
> kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif
> crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel
> libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915
> video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp
> pps_core ipmi_poweroff ipmi_msghandler button
> CPU: 3 PID: 8881 Comm: systemd Tainted: P        WC O  3.15.6 #1
> Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
> task: ffff8802f473d880 ti: ffff8802f0abc000 task.ti: ffff8802f0abc000
> RIP: 0010:[<ffffffff811ad226>]  [<ffffffff811ad226>]
> __kmalloc_track_caller+0x86/0x260
> RSP: 0018:ffff8802f0abfc88  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff8802f0abfdae RCX: 00000000000016e8
> RDX: 00000000000016e7 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8802f0abfcc0 R08: 00000000000173c0 R09: ffffffff81a8e058
> R10: ffff88040e803e00 R11: ffffea00101e4c00 R12: ffff00736b736174
> R13: 00000000000000d0 R14: 0000000000000006 R15: ffff88040e803e00
> FS:  00007f47b62ac780(0000) GS:ffff88041f2c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f47b6ac3568 CR3: 0000000359fb0000 CR4: 00000000001407e0
> Stack:
>  ffff88040e803e00 ffffffff8123a4f4 ffff8802f0abfdae 0000000000000006
>  00000000000000d0 00000000000081a4 00000000000001a4 ffff8802f0abfce8
>  ffffffff8116fb11 ffff8802f0abfdae ffff880406631100 0000000000000002
> Call Trace:
>  [<ffffffff8123a4f4>] ? __kernfs_new_node+0x34/0xf0
>  [<ffffffff8116fb11>] kstrdup+0x31/0x60
>  [<ffffffff8123a4f4>] __kernfs_new_node+0x34/0xf0
>  [<ffffffff8123b386>] kernfs_new_node+0x26/0x50
>  [<ffffffff8123cc59>] __kernfs_create_file+0x39/0xa0
>  [<ffffffff810edb60>] cgroup_addrm_files+0x110/0x250
>  [<ffffffff810ee9ab>] cgroup_mkdir+0x21b/0x540
>  [<ffffffff8125ca36>] ? security_inode_notifysecctx+0x16/0x20
>  [<ffffffff8123b30a>] kernfs_iop_mkdir+0x5a/0x90
>  [<ffffffff811d3120>] vfs_mkdir+0xe0/0x180
>  [<ffffffff811d7bea>] SyS_mkdirat+0xaa/0xe0
>  [<ffffffff811d7c39>] SyS_mkdir+0x19/0x20
>  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
> Code: 25 88 dd 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 50 01 00 00
> 49 83 78 10 00 0f 84 45 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49>
> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 bb 49 63
> RIP  [<ffffffff811ad226>] __kmalloc_track_caller+0x86/0x260
>  RSP <ffff8802f0abfc88>
> general protection fault: 0000 [#2] SMP
> Modules linked in: zfs(PO) zunicode(PO) zavl(PO) zcommon(PO)
> znvpair(PO) spl(O) xt_nat sit tunnel4 ip_tunnel sch_sfq 8021q
> ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
> ipt_REJECT xt_tcpudp xt_LOG ip6t_rt xt_limit nf_conntrack_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc
> xt_conntrack nf_conntrack iptable_filter ip6table_filter ip6_tables
> ip_tables x_tables it87 hwmon_vid nls_cp437 vfat fat
> snd_hda_codec_hdmi snd_hda_codec_realtek iTCO_wdt
> snd_hda_codec_generic iTCO_vendor_support raid0 raid1 md_mod
> x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
> glue_helper ablk_helper cryptd snd_hda_intel snd_hda_controller
> snd_hda_codec microcode r8169 i2c_i801 snd_hwdep acpi_cpufreq
>  snd_pcm mii snd_timer thermal snd fan soundcore lpc_ich battery
> mfd_core evdev processor tun usbip_host(C) usbip_core(C) msr loop
> kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif
> crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel
> libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915
> video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp
> pps_core ipmi_poweroff ipmi_msghandler button
> CPU: 3 PID: 8881 Comm: systemd Tainted: P        WC O  3.15.6 #1
> Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
> task: ffff8802f473d880 ti: ffff8802f0abc000 task.ti: ffff8802f0abc000
> RIP: 0010:[<ffffffff811aa26a>]  [<ffffffff811aa26a>] __kmalloc+0x8a/0x280
> RSP: 0018:ffff8802f0abf718  EFLAGS: 00010086
> RAX: 0000000000000000 RBX: ffff8800373cb3c0 RCX: 00000000000016e8
> RDX: 00000000000016e7 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8802f0abf750 R08: 00000000000173c0 R09: ffff88040e803e00
> R10: ffffffff8132d81f R11: 0000000000000000 R12: ffff00736b736174
> sit: non-ECT from 95.208.229.33 with TOS=0x3
> R13: 0000000000008020 R14: 0000000000000008 R15: ffff88040e803e00
> FS:  00007f47b62ac780(0000) GS:ffff88041f2c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f47b6ac3568 CR3: 0000000359fb0000 CR4: 00000000001407e0
> Stack:
>  0000000000000000 ffff8802f0abf828 ffff8800373cb3c0 ffff8802f0abf7b8
>  ffff88040e8634b0 0000000000000000 0000000000000001 ffff8802f0abf7a0
>  ffffffff8132d81f ffffffffa00ccc59 ffffffffa00ccc59 0000000000000021
> Call Trace:
>  [<ffffffff8132d81f>] acpi_ns_internalize_name+0x68/0xad
>  [<ffffffff8132db3a>] acpi_ns_get_node+0x79/0xe2
>  [<ffffffff81336827>] ? acpi_ut_allocate_object_desc_dbg+0x3e/0x6a
>  [<ffffffff813368c2>] ? acpi_ut_create_internal_object_dbg+0x23/0x87
>  [<ffffffff8132b531>] acpi_ns_evaluate+0x51/0x24d
>  [<ffffffff8132b531>] ? acpi_ns_evaluate+0x51/0x24d
>  [<ffffffff8132e319>] acpi_evaluate_object+0x189/0x285
>  [<ffffffff8130f0bc>] acpi_execute_simple_method+0x43/0x45
>  [<ffffffffa00cb63e>] acpi_video_register+0x3c1/0x593 [video]
>  [<ffffffffa00cb789>] acpi_video_register+0x50c/0x593 [video]
>  [<ffffffff81302599>] fb_notifier_callback+0x109/0x130
>  [<ffffffff8150fc7d>] notifier_call_chain+0x4d/0x70
>  [<ffffffff8108f137>] __blocking_notifier_call_chain+0x47/0x60
>  [<ffffffff8108f166>] blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff81302f5b>] fb_notifier_call_chain+0x1b/0x20
>  [<ffffffff8130350e>] fb_blank+0x9e/0xc0
>  [<ffffffff812fa6e1>] fbcon_blank+0x1f1/0x300
>  [<ffffffff810c1044>] ? wake_up_klogd+0x34/0x50
>  [<ffffffff810c1259>] ? console_unlock+0x1f9/0x3d0
>  [<ffffffff81073c8b>] ? lock_timer_base.isra.26+0x2b/0x50
>  [<ffffffff8107219f>] ? internal_add_timer+0x2f/0x70
>  [<ffffffff81074415>] ? mod_timer+0x105/0x200
>  [<ffffffff8136d04a>] do_unblank_screen+0xba/0x1f0
>  [<ffffffff8136d190>] unblank_screen+0x10/0x20
>  [<ffffffff812ae8b9>] bust_spinlocks+0x19/0x40
>  [<ffffffff8150cb18>] oops_end+0x38/0x150
>  [<ffffffff8101639b>] die+0x4b/0x70
>  [<ffffffff8150c5fa>] do_general_protection+0xca/0x150
>  [<ffffffff8150bf68>] general_protection+0x28/0x30
>  [<ffffffff811ad226>] ? __kmalloc_track_caller+0x86/0x260
>  [<ffffffff811ad351>] ? __kmalloc_track_caller+0x1b1/0x260
>  [<ffffffff8123a4f4>] ? __kernfs_new_node+0x34/0xf0
>  [<ffffffff8116fb11>] kstrdup+0x31/0x60
>  [<ffffffff8123a4f4>] __kernfs_new_node+0x34/0xf0
>  [<ffffffff8123b386>] kernfs_new_node+0x26/0x50
>  [<ffffffff8123cc59>] __kernfs_create_file+0x39/0xa0
>  [<ffffffff810edb60>] cgroup_addrm_files+0x110/0x250
>  [<ffffffff810ee9ab>] cgroup_mkdir+0x21b/0x540
>  [<ffffffff8125ca36>] ? security_inode_notifysecctx+0x16/0x20
>  [<ffffffff8123b30a>] kernfs_iop_mkdir+0x5a/0x90
>  [<ffffffff811d3120>] vfs_mkdir+0xe0/0x180
>  [<ffffffff811d7bea>] SyS_mkdirat+0xaa/0xe0
>  [<ffffffff811d7c39>] SyS_mkdir+0x19/0x20
>  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
> Code: 25 88 dd 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 64 01 00 00
> 49 83 78 10 00 0f 84 59 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49>
> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 bb 49 63
> RIP  [<ffffffff811aa26a>] __kmalloc+0x8a/0x280
>  RSP <ffff8802f0abf718>
> ---[ end trace d11af9bda628c8d1 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
