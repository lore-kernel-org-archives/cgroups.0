From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: PROBLEM: NULL pointer dereference in kernel 4.14.6
Date: Sun, 17 Dec 2017 10:25:47 -0800
Message-ID: <54a16e07-70e6-adda-ebdb-06349b4f8e86@infradead.org>
References: <1513512885.3653140.1207725096.395A9CCC@webmail.messagingengine.com>
 <eccdc57d-d5ea-ddc5-9f07-269e4a6786ae@incorrekt.com>
 <08995310-d853-ee77-ed1f-26cc336a4a30@incorrekt.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:Cc:References:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AH2kwMLK1fz5wmHCIZIqIuWJSIBias9OJZ0nziRBmoE=; b=WHbo16yhOH/tL6d4F1P4/sMNj0
        LyNT7HOgh94x3FPHx/r63l4l975BONpDpSrnui8rA18z31lUvsuNoTNjgRJf+O7p0zQ2/+a53fQTi
        YAG2Btsw8nPUpIxheSmudE07Nm2FZVd/tELLw9M7Tn/eswdg5FRu3H410xlYfyxwVBTZhjwZoqLrG
        HYq86yMiqoIOMbYhL/QSmNlXf9hi04EF4ud2wr9/Pycqy4/mpGWfnX48OMM/bQjbGfmU1AiJS3vLG
        kxqaWgIae5rf3CIJdKaR7xByC4OXj6r0iOhzYy+73bDO5FPHoxl7U2HAOGqf7smmc+VajDWoMDESX
      
In-Reply-To: <08995310-d853-ee77-ed1f-26cc336a4a30-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/17/2017 09:49 AM, Bronek Kozicki wrote:
> I just upgraded to 4.14.7 and tried to reproduce this error, this time under strace. As you can see this happens when systemctl tries to read a specific entry under /sys/fs . In case this matters, the entry is for a small virtual machine running under qemu/kvm and managed by libvirt.
> 
> open("/sys/fs/cgroup/unified/machine.slice", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 5
> fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
> getdents(5, /* 12 entries */, 32768)    = 464
> openat(AT_FDCWD, "/sys/fs/cgroup/unified/machine.slice/machine-qemu\\x2d1\\x2dkartuzy\\x2dspice.scope/cgroup.procs", O_RDONLY|O_CLOEXEC) = 8
> fstat(8, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> read(8,  <unfinished ...>)              = ?
> +++ killed by SIGKILL +++
> [1]    12078 killed     strace -- systemctl status
> 
> 
> B.
> 

Hi,

Can you reproduce this without using (loading) the XFS modules?
They cause the kernel to be tainted.

Adding cgroups mailing list also.

> 
> [ 1889.226051] ================================================================================
> [ 1889.235286] UBSAN: Undefined behaviour in kernel/cgroup/pids.c:67:9
> [ 1889.241563] member access within null pointer of type 'struct pids_cgroup'
> [ 1889.249920] ================================================================================
> [ 1889.259698] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
> [ 1889.267524] IP: pids_free+0x28/0xb0
> [ 1889.272394] PGD 0 P4D 0
> [ 1889.274925] Oops: 0000 [#1] SMP
> [ 1889.278061] Modules linked in: ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter devlink joydev hid_logitech_hidpp mxm_wmi intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmu
> l crc32c_intel ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd ext4 intel_cstate crc16 mbcache jbd2 fscrypto nls_iso8859_1 nls_cp437 evdev input_leds led_class vfat fat intel_rapl_perf mac_hid pcspkr hid_logitech_dj igb ptp mei_me pps_
> core i2c_i801 i2c_algo_bit mei lpc_ich ioatdma tpm_tis tpm_tis_core dca shpchp tpm wmi button sch_fq_codel sg ip_tables x_tables usbhid hid zfs(PO) zunicode(PO) zavl(PO) icp(PO) sd_mod serio_raw atkbd libps2 isci ahci libsas libahci xhci_pci ehci_pci mpt3sas xhci_hc
> d ehci_hcd raid_class libata
> [ 1889.349864]  scsi_transport_sas usbcore scsi_mod usb_common i8042 serio zcommon(PO) znvpair(PO) spl(O) nvme nvme_core bridge stp llc vhost_net tun tap vhost vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio
> [ 1889.368439] CPU: 1 PID: 12084 Comm: systemctl Tainted: P        W  O    4.14.7-1-ARCH #1
> [ 1889.376525] Hardware name: Supermicro X9DA7/E/X9DA7/E, BIOS 3.0a 07/02/2014
> [ 1889.383474] task: ffff93149aaec140 task.stack: ffffa88c3836c000
> [ 1889.389387] RIP: 0010:pids_free+0x28/0xb0
> [ 1889.393388] RSP: 0018:ffffa88c3836fcc8 EFLAGS: 00010282
> [ 1889.398605] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
> [ 1889.405731] RDX: 0000000000000000 RSI: 0000000000000202 RDI: 0000000000000202
> [ 1889.412854] RBP: ffff931499ab2d58 R08: 000000000000079a R09: 0000000000000000
> [ 1889.419979] R10: 00000000001f5954 R11: 000000000003d040 R12: 0000000056e21a48
> [ 1889.427102] R13: ffffffffa91de5c0 R14: ffff93247b0598c0 R15: ffffffffa91cd0a0
> [ 1889.434227] FS:  00007f18eee6b8c0(0000) GS:ffff931ebfa40000(0000) knlGS:0000000000000000
> [ 1889.442302] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1889.448041] CR2: 00000000000000b0 CR3: 0000000611019003 CR4: 00000000001626e0
> [ 1889.455164] Call Trace:
> [ 1889.457610]  cgroup_free+0xaa/0x190
> [ 1889.461095]  __put_task_struct+0x68/0x230
> [ 1889.465105]  ? seq_printf+0x4e/0x70
> [ 1889.468591]  css_task_iter_next+0x74/0x90
> [ 1889.472594]  kernfs_seq_next+0x58/0x110
> [ 1889.476424]  seq_read+0x36c/0x620
> [ 1889.479735]  __vfs_read+0x54/0x2e0
> [ 1889.483134]  vfs_read+0x9d/0x200
> [ 1889.486358]  SyS_read+0x52/0xc0
> [ 1889.489494]  do_syscall_64+0x69/0x1e0
> [ 1889.493152]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 1889.497771] RIP: 0033:0x7f18ee784a11
> [ 1889.501341] RSP: 002b:00007ffd56942618 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [ 1889.508897] RAX: ffffffffffffffda RBX: 0000559a9ae6d260 RCX: 00007f18ee784a11
> [ 1889.516022] RDX: 0000000000001000 RSI: 0000559a9ae80f70 RDI: 0000000000000008
> [ 1889.523145] RBP: 0000000000000d68 R08: 0000000000000003 R09: ffffffffffffffb0
> [ 1889.530270] R10: 0000000000001000 R11: 0000000000000246 R12: 00007f18eea4b700
> [ 1889.537395] R13: 00007f18eea4c240 R14: 0000559a9ae6d260 R15: 0000000000000000
> [ 1889.544518] Code: 44 00 00 0f 1f 44 00 00 48 81 ff c8 f7 ff ff 55 53 48 89 fb 74 4c 48 8b 9b 38 08 00 00 48 85 db 74 7c 48 8b 5b 50 48 85 db 74 63 <48> 83 bb b0 00 00 00 00 74 2a 48 c7 c5 60 2e 1e a9 48 89 df e8
> [ 1889.563368] RIP: pids_free+0x28/0xb0 RSP: ffffa88c3836fcc8
> [ 1889.568846] CR2: 00000000000000b0
> [ 1889.572175] ---[ end trace eab2ed000b4d5c66 ]---
> 


-- 
~Randy
