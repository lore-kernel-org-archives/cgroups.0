From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: 3.10.16 cgroup css_set_lock deadlock
Date: Thu, 14 Nov 2013 17:25:29 -0600
Message-ID: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=UPC+ZbcWRxolzmAl7CVZ77rFjG4MxDyuS4IMB7fbNZQ=;
        b=EQWgVJ82UcWcVhGnORJR1u42fNfja80wrC7hNG1hptCKfHyrBjplM6ThaUwdAnGK5M
         a42YFBo9gKluGV46vMowZdssD75OU+w6b9pqOJhg25nBoZjESnJiWgVFOb23CJcARRmn
         FO0vGv+SvDGPz8MKNZOwv6nnDndRn3xkFYtoz2EiJZwm+nXws8xQ1nL6T+eJxmB3wd6m
         J/nroR4/t3XiSYW3YiU4LwTZi5qA+Pry+3ZpckezuOJ0UY0q7vGyoeaFk9mxDojfAbS/
         KhX8C0hke2251lhrusMPzIOtkqJxkPootio9k3Rr5nANB4D0szcUGW4SpruJuTAQnIom
         5vBA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, tj@kernel.org

In trying to reproduce the cgroup_mutex deadlock I reported earlier
in https://lkml.org/lkml/2013/11/11/574 I believe I encountered a
different issue that I'm also unable to understand. This machine
started out reporting some soft lockups that look to me like they are
on a read_lock(css_set_lock):

Nov 14 08:36:13 berbox9 kernel: [2503229.370025] BUG: soft lockup - CPU#4 stuck for 23s! [python:10334]
Nov 14 08:36:13 berbox9 kernel: [2503229.371441] Modules linked in: mpt2sas scsi_transport_sas raid_class mptctl mptbase dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr iw_cxgb3 iTCO_wdt iTCO_vendor_support joydev mlx4_ib ib_sa ib_mad ib_core mlx4_en ext4 jbd2 mbcache fuse cxgb3 mlx4_core bnx2 coretemp ses enclosure hwmon mdio freq_table mperf microcode lpc_ich mfd_core dcdbas ehci_pci ehci_hcd serio_raw wmi sunrpc ipv6 autofs4 crc32c_intel megaraid_sas uhci_hcd dm_mirror dm_region_hash dm_log dm_mod
Nov 14 08:36:13 berbox9 kernel: [2503229.385531] CPU: 4 PID: 10334 Comm: python Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 14 08:36:13 berbox9 kernel: [2503229.387592] Hardware name: Dell Inc. PowerEdge R610/0XDN97, BIOS 6.3.0 07/24/2012
Nov 14 08:36:13 berbox9 kernel: [2503229.389545] task: ffff88065d1be9f0 ti: ffff8805b07a4000 task.ti: ffff8805b07a4000
Nov 14 08:36:13 berbox9 kernel: [2503229.391242] RIP: 0010:[<ffffffff8109253c>]  [<ffffffff8109253c>] cgroup_attach_task+0xdc/0x7a0
Nov 14 08:36:13 berbox9 kernel: [2503229.393232] RSP: 0018:ffff8805b07a5d08  EFLAGS: 00000286
Nov 14 08:36:13 berbox9 kernel: [2503229.394447] RAX: ffff880662422600 RBX: ffff880c0514fa48 RCX: ffff880c0514fa48
Nov 14 08:36:13 berbox9 kernel: [2503229.396067] RDX: ffff880c5cf42440 RSI: ffff880c5cf42758 RDI: ffffffff81a41800
Nov 14 08:36:13 berbox9 kernel: [2503229.398079] RBP: ffff8805b07a5de8 R08: ffff880c7fc959a0 R09: ffff880a0878e000
Nov 14 08:36:13 berbox9 kernel: [2503229.399833] R10: 5070000000000000 R11: 0001f96f596c0a0e R12: ffff880c7fc959a0
Nov 14 08:36:13 berbox9 kernel: [2503229.401750] R13: ffff880a0878e000 R14: 5070000000000000 R15: 0001f96f596c0a0e
Nov 14 08:36:13 berbox9 kernel: [2503229.403537] FS:  00007f8879523700(0000) GS:ffff880c7fc80000(0000) knlGS:0000000000000000
Nov 14 08:36:13 berbox9 kernel: [2503229.405650] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 14 08:36:13 berbox9 kernel: [2503229.407289] CR2: 00007f8879545000 CR3: 0000000a08443000 CR4: 00000000000007e0
Nov 14 08:36:13 berbox9 kernel: [2503229.409552] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 14 08:36:13 berbox9 kernel: [2503229.411805] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 14 08:36:13 berbox9 kernel: [2503229.413560] Stack:
Nov 14 08:36:13 berbox9 kernel: [2503229.414042]  ffff8805b07a5d88 ffffffff814b982d ffffea002e048f70 00000000f84d9fb8
Nov 14 08:36:13 berbox9 kernel: [2503229.415872]  ffff880663850000 dead000000100100 ffff880a0878e000 ffff88065d1be900
Nov 14 08:36:13 berbox9 kernel: [2503229.418203]  ffff880b00000000 ffff8805b07a5d58 0000000000000000 0000000000000000
Nov 14 08:36:13 berbox9 kernel: [2503229.420044] Call Trace:
Nov 14 08:36:13 berbox9 kernel: [2503229.420627]  [<ffffffff814b982d>] ? rwsem_down_write_failed+0x11d/0x1a0
Nov 14 08:36:13 berbox9 kernel: [2503229.422133]  [<ffffffff81092e87>] attach_task_by_pid+0x167/0x1a0
Nov 14 08:36:13 berbox9 kernel: [2503229.423503]  [<ffffffff81092ef3>] cgroup_tasks_write+0x13/0x20
Nov 14 08:36:13 berbox9 kernel: [2503229.424836]  [<ffffffff8108fe13>] cgroup_file_write+0x143/0x2e0
Nov 14 08:36:13 berbox9 kernel: [2503229.426190]  [<ffffffff8113a113>] ? __sb_start_write+0x53/0x110
Nov 14 08:36:13 berbox9 kernel: [2503229.427969]  [<ffffffff810f910d>] ? vm_mmap_pgoff+0x7d/0xb0
Nov 14 08:36:13 berbox9 kernel: [2503229.429691]  [<ffffffff8113820e>] vfs_write+0xce/0x1e0
Nov 14 08:36:13 berbox9 kernel: [2503229.431247]  [<ffffffff811386f2>] SyS_write+0x52/0xa0
Nov 14 08:36:13 berbox9 kernel: [2503229.432599]  [<ffffffff814bda2e>] ? do_page_fault+0xe/0x10
Nov 14 08:36:13 berbox9 kernel: [2503229.434265]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 14 08:36:13 berbox9 kernel: [2503229.436084] Code: ed 4d 89 f4 0f 1f 00 41 f6 44 24 14 04 75 52 45 39 fd 0f 8d 88 06 00 00 48 8b b5 40 ff ff ff 4c 89 e7 4c 89 65 a0 e8 74 e4 ff ff <48> 39 c3 48 89 45 a8 74 2d 48 8b bd 50 ff ff ff b9 20 00 00 00
Nov 14 08:36:28 berbox9 sshd[10924]: Accepted publickey for hbi from 10.8.8.20 port 54749 ssh2
Nov 14 08:36:28 berbox9 systemd-logind[2138]: New session c20952 of user hbi.
Nov 14 08:36:44 berbox9 kernel: [2503257.371600] BUG: soft lockup - CPU#4 stuck for 23s! [python:10334]
Nov 14 08:36:44 berbox9 kernel: [2503257.373008] Modules linked in: mpt2sas scsi_transport_sas raid_class mptctl mptbase dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr iw_cxgb3 iTCO_wdt iTCO_vendor_support joydev mlx4_ib ib_sa ib_mad ib_core mlx4_en ext4 jbd2 mbcache fuse cxgb3 mlx4_core bnx2 coretemp ses enclosure hwmon mdio freq_table mperf microcode lpc_ich mfd_core dcdbas ehci_pci ehci_hcd serio_raw wmi sunrpc ipv6 autofs4 crc32c_intel megaraid_sas uhci_hcd dm_mirror dm_region_hash dm_log dm_mod
Nov 14 08:36:44 berbox9 kernel: [2503257.387094] CPU: 4 PID: 10334 Comm: python Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 14 08:36:44 berbox9 kernel: [2503257.389007] Hardware name: Dell Inc. PowerEdge R610/0XDN97, BIOS 6.3.0 07/24/2012
Nov 14 08:36:44 berbox9 kernel: [2503257.391117] task: ffff88065d1be9f0 ti: ffff8805b07a4000 task.ti: ffff8805b07a4000
Nov 14 08:36:44 berbox9 kernel: [2503257.392814] RIP: 0010:[<ffffffff814b9a9c>]  [<ffffffff814b9a9c>] _raw_read_lock+0xc/0x20
Nov 14 08:36:44 berbox9 kernel: [2503257.394684] RSP: 0018:ffff8805b07a5cd8  EFLAGS: 00000216
Nov 14 08:36:44 berbox9 kernel: [2503257.395898] RAX: 00000000fffffffe RBX: 5070000000000000 RCX: ffff880c0514fa48
Nov 14 08:36:44 berbox9 kernel: [2503257.397518] RDX: ffff880c5cf42440 RSI: ffff880663850000 RDI: ffffffff81a41800
Nov 14 08:36:44 berbox9 kernel: [2503257.399442] RBP: ffff8805b07a5cd8 R08: ffff880c7fc959a0 R09: ffff880a0878e000
Nov 14 08:36:44 berbox9 kernel: [2503257.401261] R10: 5070000000000000 R11: 0001f96f596c0a0e R12: 0000000000000040
Nov 14 08:36:44 berbox9 kernel: [2503257.402881] R13: ffff8805b07a5cc8 R14: ffff8806624a0700 R15: ffff880c7fc92c80
Nov 14 08:36:44 berbox9 kernel: [2503257.404501] FS:  00007f8879523700(0000) GS:ffff880c7fc80000(0000) knlGS:0000000000000000
Nov 14 08:36:44 berbox9 kernel: [2503257.506036] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 14 08:36:44 berbox9 kernel: [2503257.611323] CR2: 00007f8879545000 CR3: 0000000a08443000 CR4: 00000000000007e0
Nov 14 08:36:44 berbox9 kernel: [2503257.709797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 14 08:36:44 berbox9 kernel: [2503257.808300] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 14 08:36:44 berbox9 kernel: [2503257.906280] Stack:
Nov 14 08:36:44 berbox9 kernel: [2503258.003478]  ffff8805b07a5cf8 ffffffff810909d9 ffff880662422600 ffff8809f93f2a60
Nov 14 08:36:44 berbox9 kernel: [2503258.104951]  ffff8805b07a5de8 ffffffff8109253c ffff8805b07a5d88 ffffffff814b982d
Nov 14 08:36:44 berbox9 kernel: [2503258.199289]  ffffea002e048f70 00000000f84d9fb8 ffff880663850000 dead000000100100
Nov 14 08:36:44 berbox9 kernel: [2503258.293653] Call Trace:
Nov 14 08:36:44 berbox9 kernel: [2503258.385066]  [<ffffffff810909d9>] task_cgroup_from_root+0x29/0x90
Nov 14 08:36:44 berbox9 kernel: [2503258.475459]  [<ffffffff8109253c>] cgroup_attach_task+0xdc/0x7a0
Nov 14 08:36:44 berbox9 kernel: [2503258.571866]  [<ffffffff814b982d>] ? rwsem_down_write_failed+0x11d/0x1a0
Nov 14 08:36:44 berbox9 kernel: [2503258.661360]  [<ffffffff81092e87>] attach_task_by_pid+0x167/0x1a0
Nov 14 08:36:44 berbox9 kernel: [2503258.747426]  [<ffffffff81092ef3>] cgroup_tasks_write+0x13/0x20
Nov 14 08:36:44 berbox9 kernel: [2503258.831453]  [<ffffffff8108fe13>] cgroup_file_write+0x143/0x2e0
Nov 14 08:36:44 berbox9 kernel: [2503258.912436]  [<ffffffff8113a113>] ? __sb_start_write+0x53/0x110
Nov 14 08:36:44 berbox9 kernel: [2503258.992151]  [<ffffffff810f910d>] ? vm_mmap_pgoff+0x7d/0xb0
Nov 14 08:36:44 berbox9 kernel: [2503259.074226]  [<ffffffff8113820e>] vfs_write+0xce/0x1e0
Nov 14 08:36:44 berbox9 kernel: [2503259.152890]  [<ffffffff811386f2>] SyS_write+0x52/0xa0
Nov 14 08:36:44 berbox9 kernel: [2503259.229777]  [<ffffffff814bda2e>] ? do_page_fault+0xe/0x10
Nov 14 08:36:44 berbox9 kernel: [2503259.306133]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 14 08:36:44 berbox9 kernel: [2503259.382437] Code: 17 83 ea 01 b8 01 00 00 00 78 04 5d c3 66 90 f0 ff 07 30 c0 5d c3 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 f0 ff 0f <79> 05 e8 3d 18 db ff 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 66

Nearly an hour later that task was still stuck so we triggered a kdump
of the machine so I could investigate the image.  If I understand
correctly this css_set_lock is a reader/writer spin lock, which means
if I'm stuck here in the read_lock() there should be another running
thread holding the write_lock() correct?  Looking at the kdump the
only running tasks were this task, the bash sysrq+c, and kworker/1:1

PID: 27481  TASK: ffff8806565062e0  CPU: 1   COMMAND: "kworker/1:1"
 #0 [ffff880667c06e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667c06e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667c06ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667c06ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: cfb_imageblit+720]
    RIP: ffffffff812b44d0  RSP: ffff88027840dab8  RFLAGS: 00000046
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000046
    RDX: ffff88027840dab8  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff812b44d0   R8: ffffffff812b44d0   R9: 0000000000000018
    R10: ffff88027840dab8  R11: 0000000000000046  R12: ffffffffffffffff
    R13: 0000000000aaaaaa  R14: 0000000000000001  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff88027840dab8] cfb_imageblit at ffffffff812b44d0
 #5 [ffff88027840db40] bit_putcs at ffffffff812ae105
 #6 [ffff88027840dc80] fbcon_putcs at ffffffff812a996d
 #7 [ffff88027840dcf0] vt_console_print at ffffffff8130a844
 #8 [ffff88027840dd50] call_console_drivers.constprop.10 at ffffffff8103cd93
 #9 [ffff88027840dd90] console_unlock at ffffffff8103d30d
#10 [ffff88027840ddd0] console_callback at ffffffff8130ce2a
#11 [ffff88027840ddf0] process_one_work at ffffffff81057c54
#12 [ffff88027840de50] worker_thread at ffffffff81058d0c
#13 [ffff88027840dec0] kthread at ffffffff8105f0b0
#14 [ffff88027840df50] ret_from_fork at ffffffff814c20dc

Thinking this means the task may have blocked while holding
the write_lock I've also dumpped the stacks of all processes on the
system, and attached them below.  I've looked through them and don't
see anything that looks like it would be holding the css_set_lock but
perhaps I've missed it.  As I mentioned I do have a kdump of this
system so I can possibly extract more useful information if someone
tells me where to look.  For example perhaps it is possible to
determine who is holding the css_set_lock?

PID: 0      TASK: ffffffff81a10440  CPU: 0   COMMAND: "swapper/0"
 #0 [ffff880c7fc06e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fc06e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fc06ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fc06ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffffffff81a01ea8  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffffffff81a01ea8  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffffffff81a01ea8  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fc0d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffffffff81a01ea8] default_idle at ffffffff8100a300
 #5 [ffffffff81a01ed0] arch_cpu_idle at ffffffff8100aace
 #6 [ffffffff81a01ee0] cpu_startup_entry at ffffffff810754be
 #7 [ffffffff81a01f50] rest_init at ffffffff814ac087
 #8 [ffffffff81a01f60] start_kernel at ffffffff81adae53
 #9 [ffffffff81a01fb0] x86_64_start_reservations at ffffffff81ada5a8
#10 [ffffffff81a01fc0] x86_64_start_kernel at ffffffff81ada68f

PID: 0      TASK: ffff880c63c94db0  CPU: 1   COMMAND: "swapper/1"
 #0 [ffff880c63d27e18] __schedule at ffffffff814b7fc0
 #1 [ffff880c63d27ea0] schedule at ffffffff814b8eb9
 #2 [ffff880c63d27eb0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c63d27ec0] cpu_startup_entry at ffffffff8107563a
 #4 [ffff880c63d27f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63c954c0  CPU: 2   COMMAND: "swapper/2"
 #0 [ffff880c7fc46e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fc46e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fc46ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fc46ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d29e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d29e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d29e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fc4d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d29e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d29eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d29ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d29f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63c95bd0  CPU: 3   COMMAND: "swapper/3"
 #0 [ffff880667c46e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667c46e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667c46ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667c46ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d2be88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d2be88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d2be88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880667c4d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d2be88] default_idle at ffffffff8100a300
 #5 [ffff880c63d2beb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d2bec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d2bf30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63c962e0  CPU: 4   COMMAND: "swapper/4"
 #0 [ffff880c63d2de18] __schedule at ffffffff814b7fc0
 #1 [ffff880c63d2dea0] schedule at ffffffff814b8eb9
 #2 [ffff880c63d2deb0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c63d2dec0] cpu_startup_entry at ffffffff8107563a
 #4 [ffff880c63d2df30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63c969f0  CPU: 5   COMMAND: "swapper/5"
 #0 [ffff880667c86e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667c86e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667c86ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667c86ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d2fe88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d2fe88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d2fe88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880667c8d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d2fe88] default_idle at ffffffff8100a300
 #5 [ffff880c63d2feb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d2fec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d2ff30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63c97100  CPU: 6   COMMAND: "swapper/6"
 #0 [ffff880c7fcc6e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fcc6e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fcc6ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fcc6ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d31e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d31e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d31e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fccd620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d31e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d31eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d31ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d31f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63c97810  CPU: 7   COMMAND: "swapper/7"
 #0 [ffff880667cc6e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667cc6e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667cc6ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667cc6ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d33e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d33e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d33e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880667ccd620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d33e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d33eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d33ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d33f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d40000  CPU: 8   COMMAND: "swapper/8"
 #0 [ffff880c7fd06e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fd06e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fd06ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fd06ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d35e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d35e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d35e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fd0d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d35e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d35eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d35ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d35f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d40710  CPU: 9   COMMAND: "swapper/9"
 #0 [ffff880667d06e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667d06e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667d06ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667d06ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d37e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d37e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d37e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880667d0d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d37e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d37eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d37ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d37f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d40e20  CPU: 10  COMMAND: "swapper/10"
 #0 [ffff880c7fd46e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fd46e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fd46ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fd46ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d49e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d49e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d49e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fd4d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d49e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d49eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d49ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d49f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d41530  CPU: 11  COMMAND: "swapper/11"
 #0 [ffff880c63d4be18] __schedule at ffffffff814b7fc0
 #1 [ffff880c63d4bea0] schedule at ffffffff814b8eb9
 #2 [ffff880c63d4beb0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c63d4bec0] cpu_startup_entry at ffffffff8107563a
 #4 [ffff880c63d4bf30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d41c40  CPU: 12  COMMAND: "swapper/12"
 #0 [ffff880c7fd86e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fd86e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fd86ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fd86ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d4de88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d4de88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d4de88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fd8d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d4de88] default_idle at ffffffff8100a300
 #5 [ffff880c63d4deb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d4dec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d4df30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d42350  CPU: 13  COMMAND: "swapper/13"
 #0 [ffff880667d86e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667d86e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667d86ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667d86ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d4fe88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d4fe88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d4fe88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880667d8d620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d4fe88] default_idle at ffffffff8100a300
 #5 [ffff880c63d4feb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d4fec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d4ff30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d42a60  CPU: 14  COMMAND: "swapper/14"
 #0 [ffff880c7fdc6e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fdc6e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fdc6ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fdc6ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d59e88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d59e88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d59e88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880c7fdcd620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d59e88] default_idle at ffffffff8100a300
 #5 [ffff880c63d59eb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d59ec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d59f30] start_secondary at ffffffff81b21e1d

PID: 0      TASK: ffff880c63d43170  CPU: 15  COMMAND: "swapper/15"
 #0 [ffff880667dc6e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667dc6e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667dc6ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667dc6ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: default_idle+32]
    RIP: ffffffff8100a300  RSP: ffff880c63d5be88  RFLAGS: 00000286
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000286
    RDX: ffff880c63d5be88  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff8100a300   R8: ffffffff8100a300   R9: 0000000000000018
    R10: ffff880c63d5be88  R11: 0000000000000286  R12: ffffffffffffffff
    R13: ffff880667dcd620  R14: 0140000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff880c63d5be88] default_idle at ffffffff8100a300
 #5 [ffff880c63d5beb0] arch_cpu_idle at ffffffff8100aace
 #6 [ffff880c63d5bec0] cpu_startup_entry at ffffffff810754be
 #7 [ffff880c63d5bf30] start_secondary at ffffffff81b21e1d

PID: 1      TASK: ffff880c63c90000  CPU: 5   COMMAND: "systemd"
 #0 [ffff880c63c99cf8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63c99d80] schedule at ffffffff814b8eb9
 #2 [ffff880c63c99d90] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c63c99da0] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880c63c99e10] mutex_lock at ffffffff814b742a
 #5 [ffff880c63c99e30] proc_cgroup_show at ffffffff81095b77
 #6 [ffff880c63c99e80] seq_read at ffffffff8115925b
 #7 [ffff880c63c99f00] vfs_read at ffffffff811383d0
 #8 [ffff880c63c99f30] sys_read at ffffffff81138652
 #9 [ffff880c63c99f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae43e0  RSP: 00007fffab1d7d78  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000400  RSI: 00007f75b749c000  RDI: 0000000000000020
    RBP: 00000000000007ff   R8: 00000000ffffffff   R9: 0000000000000000
    R10: 0000000000000022  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 000000000000000a  R15: 00000000023ab550
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

PID: 2      TASK: ffff880c63c90710  CPU: 6   COMMAND: "kthreadd"
 #0 [ffff880c63c9be28] __schedule at ffffffff814b7fc0
 #1 [ffff880c63c9beb0] schedule at ffffffff814b8eb9
 #2 [ffff880c63c9bec0] kthreadd at ffffffff8105f3fa
 #3 [ffff880c63c9bf50] ret_from_fork at ffffffff814c20dc

PID: 3      TASK: ffff880c63c90e20  CPU: 0   COMMAND: "ksoftirqd/0"
 #0 [ffff880c63ca9de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ca9e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63ca9e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63ca9ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ca9f50] ret_from_fork at ffffffff814c20dc

PID: 5      TASK: ffff880c63c91c40  CPU: 0   COMMAND: "kworker/0:0H"
 #0 [ffff880c63caddb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63cade40] schedule at ffffffff814b8eb9
 #2 [ffff880c63cade50] worker_thread at ffffffff81058daf
 #3 [ffff880c63cadec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63cadf50] ret_from_fork at ffffffff814c20dc

PID: 6      TASK: ffff880c63c92350  CPU: 6   COMMAND: "kworker/u32:0"
 #0 [ffff880c63cafdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63cafe40] schedule at ffffffff814b8eb9
 #2 [ffff880c63cafe50] worker_thread at ffffffff81058daf
 #3 [ffff880c63cafec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63caff50] ret_from_fork at ffffffff814c20dc

PID: 8      TASK: ffff880c63c93170  CPU: 0   COMMAND: "migration/0"
 #0 [ffff880c63cbbde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63cbbe70] schedule at ffffffff814b8eb9
 #2 [ffff880c63cbbe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63cbbec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63cbbf50] ret_from_fork at ffffffff814c20dc

PID: 9      TASK: ffff880c63c93880  CPU: 0   COMMAND: "rcu_bh"
 #0 [ffff880c63cbdd88] __schedule at ffffffff814b7fc0
 #1 [ffff880c63cbde10] schedule at ffffffff814b8eb9
 #2 [ffff880c63cbde20] rcu_gp_kthread at ffffffff810a3c31
 #3 [ffff880c63cbdec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63cbdf50] ret_from_fork at ffffffff814c20dc

PID: 10     TASK: ffff880c63c93f90  CPU: 2   COMMAND: "rcu_sched"
 #0 [ffff880c63cbfcf8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63cbfd80] schedule at ffffffff814b8eb9
 #2 [ffff880c63cbfd90] schedule_timeout at ffffffff814b6cde
 #3 [ffff880c63cbfe20] rcu_gp_kthread at ffffffff810a3e7e
 #4 [ffff880c63cbfec0] kthread at ffffffff8105f0b0
 #5 [ffff880c63cbff50] ret_from_fork at ffffffff814c20dc

PID: 11     TASK: ffff880c63c946a0  CPU: 0   COMMAND: "watchdog/0"
 #0 [ffff880c63d25de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63d25e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63d25e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63d25ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63d25f50] ret_from_fork at ffffffff814c20dc

PID: 12     TASK: ffff8806648a0000  CPU: 1   COMMAND: "watchdog/1"
 #0 [ffff88066489dde8] __schedule at ffffffff814b7fc0
 #1 [ffff88066489de70] schedule at ffffffff814b8eb9
 #2 [ffff88066489de80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff88066489dec0] kthread at ffffffff8105f0b0
 #4 [ffff88066489df50] ret_from_fork at ffffffff814c20dc

PID: 13     TASK: ffff8806648a0710  CPU: 1   COMMAND: "migration/1"
 #0 [ffff88066489fde8] __schedule at ffffffff814b7fc0
 #1 [ffff88066489fe70] schedule at ffffffff814b8eb9
 #2 [ffff88066489fe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff88066489fec0] kthread at ffffffff8105f0b0
 #4 [ffff88066489ff50] ret_from_fork at ffffffff814c20dc

PID: 14     TASK: ffff8806648a0e20  CPU: 1   COMMAND: "ksoftirqd/1"
 #0 [ffff880664931de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664931e70] schedule at ffffffff814b8eb9
 #2 [ffff880664931e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664931ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664931f50] ret_from_fork at ffffffff814c20dc

PID: 16     TASK: ffff8806648a1c40  CPU: 1   COMMAND: "kworker/1:0H"
 #0 [ffff880664937db8] __schedule at ffffffff814b7fc0
 #1 [ffff880664937e40] schedule at ffffffff814b8eb9
 #2 [ffff880664937e50] worker_thread at ffffffff81058daf
 #3 [ffff880664937ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664937f50] ret_from_fork at ffffffff814c20dc

PID: 18     TASK: ffff880c63d47810  CPU: 2   COMMAND: "watchdog/2"
 #0 [ffff880c63d5dde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63d5de70] schedule at ffffffff814b8eb9
 #2 [ffff880c63d5de80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63d5dec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63d5df50] ret_from_fork at ffffffff814c20dc

PID: 19     TASK: ffff880c63d47100  CPU: 2   COMMAND: "migration/2"
 #0 [ffff880c63d5fde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63d5fe70] schedule at ffffffff814b8eb9
 #2 [ffff880c63d5fe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63d5fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63d5ff50] ret_from_fork at ffffffff814c20dc

PID: 20     TASK: ffff880c63d469f0  CPU: 2   COMMAND: "ksoftirqd/2"
 #0 [ffff880c63df1de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63df1e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63df1e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63df1ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63df1f50] ret_from_fork at ffffffff814c20dc

PID: 22     TASK: ffff880c63d45bd0  CPU: 2   COMMAND: "kworker/2:0H"
 #0 [ffff880c63df5db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63df5e40] schedule at ffffffff814b8eb9
 #2 [ffff880c63df5e50] worker_thread at ffffffff81058daf
 #3 [ffff880c63df5ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63df5f50] ret_from_fork at ffffffff814c20dc

PID: 23     TASK: ffff8806648a7810  CPU: 3   COMMAND: "watchdog/3"
 #0 [ffff880664953de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664953e70] schedule at ffffffff814b8eb9
 #2 [ffff880664953e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664953ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664953f50] ret_from_fork at ffffffff814c20dc

PID: 24     TASK: ffff8806648a7100  CPU: 3   COMMAND: "migration/3"
 #0 [ffff880664955de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664955e70] schedule at ffffffff814b8eb9
 #2 [ffff880664955e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664955ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664955f50] ret_from_fork at ffffffff814c20dc

PID: 25     TASK: ffff8806648a69f0  CPU: 3   COMMAND: "ksoftirqd/3"
 #0 [ffff880664957de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664957e70] schedule at ffffffff814b8eb9
 #2 [ffff880664957e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664957ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664957f50] ret_from_fork at ffffffff814c20dc

PID: 27     TASK: ffff8806648a5bd0  CPU: 3   COMMAND: "kworker/3:0H"
 #0 [ffff88066495bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff88066495be40] schedule at ffffffff814b8eb9
 #2 [ffff88066495be50] worker_thread at ffffffff81058daf
 #3 [ffff88066495bec0] kthread at ffffffff8105f0b0
 #4 [ffff88066495bf50] ret_from_fork at ffffffff814c20dc

PID: 28     TASK: ffff880c63d43880  CPU: 4   COMMAND: "watchdog/4"
 #0 [ffff880c63dffde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63dffe70] schedule at ffffffff814b8eb9
 #2 [ffff880c63dffe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63dffec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63dfff50] ret_from_fork at ffffffff814c20dc

PID: 29     TASK: ffff880c63d43f90  CPU: 4   COMMAND: "migration/4"
 #0 [ffff880c63e11de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e11e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e11e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e11ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e11f50] ret_from_fork at ffffffff814c20dc

PID: 30     TASK: ffff880c63d446a0  CPU: 4   COMMAND: "ksoftirqd/4"
 #0 [ffff880c63e13de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e13e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e13e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e13ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e13f50] ret_from_fork at ffffffff814c20dc

PID: 32     TASK: ffff880c63d454c0  CPU: 4   COMMAND: "kworker/4:0H"
 #0 [ffff880c63e17db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e17e40] schedule at ffffffff814b8eb9
 #2 [ffff880c63e17e50] worker_thread at ffffffff81058daf
 #3 [ffff880c63e17ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e17f50] ret_from_fork at ffffffff814c20dc

PID: 33     TASK: ffff8806648a2a60  CPU: 5   COMMAND: "watchdog/5"
 #0 [ffff880664973de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664973e70] schedule at ffffffff814b8eb9
 #2 [ffff880664973e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664973ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664973f50] ret_from_fork at ffffffff814c20dc

PID: 34     TASK: ffff8806648a3170  CPU: 5   COMMAND: "migration/5"
 #0 [ffff880664975de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664975e70] schedule at ffffffff814b8eb9
 #2 [ffff880664975e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664975ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664975f50] ret_from_fork at ffffffff814c20dc

PID: 35     TASK: ffff8806648a3880  CPU: 5   COMMAND: "ksoftirqd/5"
 #0 [ffff880664977de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664977e70] schedule at ffffffff814b8eb9
 #2 [ffff880664977e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664977ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664977f50] ret_from_fork at ffffffff814c20dc

PID: 37     TASK: ffff8806648a46a0  CPU: 5   COMMAND: "kworker/5:0H"
 #0 [ffff88066497bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff88066497be40] schedule at ffffffff814b8eb9
 #2 [ffff88066497be50] worker_thread at ffffffff81058daf
 #3 [ffff88066497bec0] kthread at ffffffff8105f0b0
 #4 [ffff88066497bf50] ret_from_fork at ffffffff814c20dc

PID: 38     TASK: ffff880c63e48000  CPU: 6   COMMAND: "watchdog/6"
 #0 [ffff880c63e27de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e27e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e27e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e27ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e27f50] ret_from_fork at ffffffff814c20dc

PID: 39     TASK: ffff880c63e48710  CPU: 6   COMMAND: "migration/6"
 #0 [ffff880c63e51de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e51e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e51e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e51ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e51f50] ret_from_fork at ffffffff814c20dc

PID: 40     TASK: ffff880c63e48e20  CPU: 6   COMMAND: "ksoftirqd/6"
 #0 [ffff880c63e53de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e53e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e53e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e53ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e53f50] ret_from_fork at ffffffff814c20dc

PID: 42     TASK: ffff880c63e49c40  CPU: 6   COMMAND: "kworker/6:0H"
 #0 [ffff880c63e57db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e57e40] schedule at ffffffff814b8eb9
 #2 [ffff880c63e57e50] worker_thread at ffffffff81058daf
 #3 [ffff880c63e57ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e57f50] ret_from_fork at ffffffff814c20dc

PID: 43     TASK: ffff8806648a54c0  CPU: 7   COMMAND: "watchdog/7"
 #0 [ffff880664993de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664993e70] schedule at ffffffff814b8eb9
 #2 [ffff880664993e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664993ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664993f50] ret_from_fork at ffffffff814c20dc

PID: 44     TASK: ffff8806648a4db0  CPU: 7   COMMAND: "migration/7"
 #0 [ffff880664995de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664995e70] schedule at ffffffff814b8eb9
 #2 [ffff880664995e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664995ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664995f50] ret_from_fork at ffffffff814c20dc

PID: 45     TASK: ffff880664998000  CPU: 7   COMMAND: "ksoftirqd/7"
 #0 [ffff880664997de8] __schedule at ffffffff814b7fc0
 #1 [ffff880664997e70] schedule at ffffffff814b8eb9
 #2 [ffff880664997e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664997ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664997f50] ret_from_fork at ffffffff814c20dc

PID: 47     TASK: ffff880664998e20  CPU: 7   COMMAND: "kworker/7:0H"
 #0 [ffff8806649a3db8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649a3e40] schedule at ffffffff814b8eb9
 #2 [ffff8806649a3e50] worker_thread at ffffffff81058daf
 #3 [ffff8806649a3ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649a3f50] ret_from_fork at ffffffff814c20dc

PID: 48     TASK: ffff880c63e4f810  CPU: 8   COMMAND: "watchdog/8"
 #0 [ffff880c63e5fde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e5fe70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e5fe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e5fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e5ff50] ret_from_fork at ffffffff814c20dc

PID: 49     TASK: ffff880c63e4f100  CPU: 8   COMMAND: "migration/8"
 #0 [ffff880c63e79de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e79e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e79e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e79ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e79f50] ret_from_fork at ffffffff814c20dc

PID: 50     TASK: ffff880c63e4e9f0  CPU: 8   COMMAND: "ksoftirqd/8"
 #0 [ffff880c63e7bde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e7be70] schedule at ffffffff814b8eb9
 #2 [ffff880c63e7be80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63e7bec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e7bf50] ret_from_fork at ffffffff814c20dc

PID: 52     TASK: ffff880c63e4dbd0  CPU: 8   COMMAND: "kworker/8:0H"
 #0 [ffff880c63e7fdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63e7fe40] schedule at ffffffff814b8eb9
 #2 [ffff880c63e7fe50] worker_thread at ffffffff81058daf
 #3 [ffff880c63e7fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63e7ff50] ret_from_fork at ffffffff814c20dc

PID: 53     TASK: ffff88066499f810  CPU: 9   COMMAND: "watchdog/9"
 #0 [ffff8806649bbde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649bbe70] schedule at ffffffff814b8eb9
 #2 [ffff8806649bbe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649bbec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649bbf50] ret_from_fork at ffffffff814c20dc

PID: 54     TASK: ffff88066499f100  CPU: 9   COMMAND: "migration/9"
 #0 [ffff8806649bdde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649bde70] schedule at ffffffff814b8eb9
 #2 [ffff8806649bde80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649bdec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649bdf50] ret_from_fork at ffffffff814c20dc

PID: 55     TASK: ffff88066499e9f0  CPU: 9   COMMAND: "ksoftirqd/9"
 #0 [ffff8806649bfde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649bfe70] schedule at ffffffff814b8eb9
 #2 [ffff8806649bfe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649bfec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649bff50] ret_from_fork at ffffffff814c20dc

PID: 57     TASK: ffff88066499dbd0  CPU: 9   COMMAND: "kworker/9:0H"
 #0 [ffff8806649c3db8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649c3e40] schedule at ffffffff814b8eb9
 #2 [ffff8806649c3e50] worker_thread at ffffffff81058daf
 #3 [ffff8806649c3ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649c3f50] ret_from_fork at ffffffff814c20dc

PID: 58     TASK: ffff880c63e4a350  CPU: 10  COMMAND: "watchdog/10"
 #0 [ffff880c63eb5de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63eb5e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63eb5e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63eb5ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63eb5f50] ret_from_fork at ffffffff814c20dc

PID: 59     TASK: ffff880c63e4aa60  CPU: 10  COMMAND: "migration/10"
 #0 [ffff880c63eb7de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63eb7e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63eb7e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63eb7ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63eb7f50] ret_from_fork at ffffffff814c20dc

PID: 60     TASK: ffff880c63e4b170  CPU: 10  COMMAND: "ksoftirqd/10"
 #0 [ffff880c63eb9de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63eb9e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63eb9e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63eb9ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63eb9f50] ret_from_fork at ffffffff814c20dc

PID: 62     TASK: ffff880c63e4bf90  CPU: 10  COMMAND: "kworker/10:0H"
 #0 [ffff880c63ebddb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ebde40] schedule at ffffffff814b8eb9
 #2 [ffff880c63ebde50] worker_thread at ffffffff81058daf
 #3 [ffff880c63ebdec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ebdf50] ret_from_fork at ffffffff814c20dc

PID: 63     TASK: ffff880664999530  CPU: 11  COMMAND: "watchdog/11"
 #0 [ffff8806649dbde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649dbe70] schedule at ffffffff814b8eb9
 #2 [ffff8806649dbe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649dbec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649dbf50] ret_from_fork at ffffffff814c20dc

PID: 64     TASK: ffff880664999c40  CPU: 11  COMMAND: "migration/11"
 #0 [ffff8806649ddde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649dde70] schedule at ffffffff814b8eb9
 #2 [ffff8806649dde80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649ddec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649ddf50] ret_from_fork at ffffffff814c20dc

PID: 65     TASK: ffff88066499a350  CPU: 11  COMMAND: "ksoftirqd/11"
 #0 [ffff8806649dfde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649dfe70] schedule at ffffffff814b8eb9
 #2 [ffff8806649dfe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649dfec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649dff50] ret_from_fork at ffffffff814c20dc

PID: 67     TASK: ffff88066499b170  CPU: 11  COMMAND: "kworker/11:0H"
 #0 [ffff8806649e3db8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649e3e40] schedule at ffffffff814b8eb9
 #2 [ffff8806649e3e50] worker_thread at ffffffff81058daf
 #3 [ffff8806649e3ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649e3f50] ret_from_fork at ffffffff814c20dc

PID: 68     TASK: ffff880c63e4d4c0  CPU: 12  COMMAND: "watchdog/12"
 #0 [ffff880c63ecdde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ecde70] schedule at ffffffff814b8eb9
 #2 [ffff880c63ecde80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63ecdec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ecdf50] ret_from_fork at ffffffff814c20dc

PID: 69     TASK: ffff880c63e4cdb0  CPU: 12  COMMAND: "migration/12"
 #0 [ffff880c63ecfde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ecfe70] schedule at ffffffff814b8eb9
 #2 [ffff880c63ecfe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63ecfec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ecff50] ret_from_fork at ffffffff814c20dc

PID: 70     TASK: ffff880c63e4c6a0  CPU: 12  COMMAND: "ksoftirqd/12"
 #0 [ffff880c63ee9de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ee9e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63ee9e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63ee9ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ee9f50] ret_from_fork at ffffffff814c20dc

PID: 72     TASK: ffff880c63ef0710  CPU: 12  COMMAND: "kworker/12:0H"
 #0 [ffff880c63eeddb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63eede40] schedule at ffffffff814b8eb9
 #2 [ffff880c63eede50] worker_thread at ffffffff81058daf
 #3 [ffff880c63eedec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63eedf50] ret_from_fork at ffffffff814c20dc

PID: 73     TASK: ffff88066499d4c0  CPU: 13  COMMAND: "watchdog/13"
 #0 [ffff8806649fbde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649fbe70] schedule at ffffffff814b8eb9
 #2 [ffff8806649fbe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649fbec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649fbf50] ret_from_fork at ffffffff814c20dc

PID: 74     TASK: ffff88066499cdb0  CPU: 13  COMMAND: "migration/13"
 #0 [ffff8806649fdde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649fde70] schedule at ffffffff814b8eb9
 #2 [ffff8806649fde80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649fdec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649fdf50] ret_from_fork at ffffffff814c20dc

PID: 75     TASK: ffff88066499c6a0  CPU: 13  COMMAND: "ksoftirqd/13"
 #0 [ffff8806649ffde8] __schedule at ffffffff814b7fc0
 #1 [ffff8806649ffe70] schedule at ffffffff814b8eb9
 #2 [ffff8806649ffe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff8806649ffec0] kthread at ffffffff8105f0b0
 #4 [ffff8806649fff50] ret_from_fork at ffffffff814c20dc

PID: 77     TASK: ffff88066499b880  CPU: 13  COMMAND: "kworker/13:0H"
 #0 [ffff880664a03db8] __schedule at ffffffff814b7fc0
 #1 [ffff880664a03e40] schedule at ffffffff814b8eb9
 #2 [ffff880664a03e50] worker_thread at ffffffff81058daf
 #3 [ffff880664a03ec0] kthread at ffffffff8105f0b0
 #4 [ffff880664a03f50] ret_from_fork at ffffffff814c20dc

PID: 78     TASK: ffff880c63ef7810  CPU: 14  COMMAND: "watchdog/14"
 #0 [ffff880c63efdde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63efde70] schedule at ffffffff814b8eb9
 #2 [ffff880c63efde80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63efdec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63efdf50] ret_from_fork at ffffffff814c20dc

PID: 79     TASK: ffff880c63ef7100  CPU: 14  COMMAND: "migration/14"
 #0 [ffff880c63effde8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63effe70] schedule at ffffffff814b8eb9
 #2 [ffff880c63effe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63effec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63efff50] ret_from_fork at ffffffff814c20dc

PID: 80     TASK: ffff880c63ef69f0  CPU: 14  COMMAND: "ksoftirqd/14"
 #0 [ffff880c63f21de8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63f21e70] schedule at ffffffff814b8eb9
 #2 [ffff880c63f21e80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880c63f21ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63f21f50] ret_from_fork at ffffffff814c20dc

PID: 82     TASK: ffff880c63ef5bd0  CPU: 14  COMMAND: "kworker/14:0H"
 #0 [ffff880c63f25db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63f25e40] schedule at ffffffff814b8eb9
 #2 [ffff880c63f25e50] worker_thread at ffffffff81058daf
 #3 [ffff880c63f25ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63f25f50] ret_from_fork at ffffffff814c20dc

PID: 83     TASK: ffff880664a20000  CPU: 15  COMMAND: "watchdog/15"
 #0 [ffff880664a1bde8] __schedule at ffffffff814b7fc0
 #1 [ffff880664a1be70] schedule at ffffffff814b8eb9
 #2 [ffff880664a1be80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664a1bec0] kthread at ffffffff8105f0b0
 #4 [ffff880664a1bf50] ret_from_fork at ffffffff814c20dc

PID: 84     TASK: ffff880664a20710  CPU: 15  COMMAND: "migration/15"
 #0 [ffff880664a1dde8] __schedule at ffffffff814b7fc0
 #1 [ffff880664a1de70] schedule at ffffffff814b8eb9
 #2 [ffff880664a1de80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664a1dec0] kthread at ffffffff8105f0b0
 #4 [ffff880664a1df50] ret_from_fork at ffffffff814c20dc

PID: 85     TASK: ffff880664a20e20  CPU: 15  COMMAND: "ksoftirqd/15"
 #0 [ffff880664a1fde8] __schedule at ffffffff814b7fc0
 #1 [ffff880664a1fe70] schedule at ffffffff814b8eb9
 #2 [ffff880664a1fe80] smpboot_thread_fn at ffffffff810668e5
 #3 [ffff880664a1fec0] kthread at ffffffff8105f0b0
 #4 [ffff880664a1ff50] ret_from_fork at ffffffff814c20dc

PID: 87     TASK: ffff880664a21c40  CPU: 15  COMMAND: "kworker/15:0H"
 #0 [ffff880664a2bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880664a2be40] schedule at ffffffff814b8eb9
 #2 [ffff880664a2be50] worker_thread at ffffffff81058daf
 #3 [ffff880664a2bec0] kthread at ffffffff8105f0b0
 #4 [ffff880664a2bf50] ret_from_fork at ffffffff814c20dc

PID: 88     TASK: ffff880c63ef0e20  CPU: 11  COMMAND: "khelper"
 #0 [ffff880c63f2fd98] __schedule at ffffffff814b7fc0
 #1 [ffff880c63f2fe20] schedule at ffffffff814b8eb9
 #2 [ffff880c63f2fe30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c63f2fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63f2ff50] ret_from_fork at ffffffff814c20dc

PID: 89     TASK: ffff880c63ef1530  CPU: 5   COMMAND: "kdevtmpfs"
 #0 [ffff880c63f75dd8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63f75e60] schedule at ffffffff814b8eb9
 #2 [ffff880c63f75e70] devtmpfsd at ffffffff8133b01d
 #3 [ffff880c63f75ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63f75f50] ret_from_fork at ffffffff814c20dc

PID: 90     TASK: ffff880c63fc0000  CPU: 11  COMMAND: "writeback"
 #0 [ffff880c63fbfd98] __schedule at ffffffff814b7fc0
 #1 [ffff880c63fbfe20] schedule at ffffffff814b8eb9
 #2 [ffff880c63fbfe30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c63fbfec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63fbff50] ret_from_fork at ffffffff814c20dc

PID: 91     TASK: ffff880c63fc0710  CPU: 11  COMMAND: "kintegrityd"
 #0 [ffff880c63fe7d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c63fe7e20] schedule at ffffffff814b8eb9
 #2 [ffff880c63fe7e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c63fe7ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63fe7f50] ret_from_fork at ffffffff814c20dc

PID: 92     TASK: ffff880c63fc0e20  CPU: 11  COMMAND: "bioset"
 #0 [ffff880c63ff1d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ff1e20] schedule at ffffffff814b8eb9
 #2 [ffff880c63ff1e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c63ff1ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ff1f50] ret_from_fork at ffffffff814c20dc

PID: 93     TASK: ffff880c63fc1530  CPU: 5   COMMAND: "kblockd"
 #0 [ffff880c63ff3d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c63ff3e20] schedule at ffffffff814b8eb9
 #2 [ffff880c63ff3e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c63ff3ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63ff3f50] ret_from_fork at ffffffff814c20dc

PID: 94     TASK: ffff880c63fc1c40  CPU: 14  COMMAND: "khubd"
 #0 [ffff880c63817ce8] __schedule at ffffffff814b7fc0
 #1 [ffff880c63817d70] schedule at ffffffff814b8eb9
 #2 [ffff880c63817d80] hub_thread at ffffffff8137a68a
 #3 [ffff880c63817ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63817f50] ret_from_fork at ffffffff814c20dc

PID: 95     TASK: ffff880c63fc2350  CPU: 11  COMMAND: "md"
 #0 [ffff880c63835d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c63835e20] schedule at ffffffff814b8eb9
 #2 [ffff880c63835e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c63835ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c63835f50] ret_from_fork at ffffffff814c20dc

PID: 112    TASK: ffff880c63ef1c40  CPU: 5   COMMAND: "khungtaskd"
 #0 [ffff880c61c01d18] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c01da0] schedule at ffffffff814b8eb9
 #2 [ffff880c61c01db0] schedule_timeout at ffffffff814b6cde
 #3 [ffff880c61c01e40] schedule_timeout_interruptible at ffffffff814b6e1e
 #4 [ffff880c61c01e50] watchdog at ffffffff8109a132
 #5 [ffff880c61c01ec0] kthread at ffffffff8105f0b0
 #6 [ffff880c61c01f50] ret_from_fork at ffffffff814c20dc

PID: 113    TASK: ffff880c63ef2350  CPU: 0   COMMAND: "kswapd0"
 #0 [ffff880c61c03cf8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c03d80] schedule at ffffffff814b8eb9
 #2 [ffff880c61c03d90] kswapd at ffffffff810f2b93
 #3 [ffff880c61c03ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c03f50] ret_from_fork at ffffffff814c20dc

PID: 114    TASK: ffff880c63ef2a60  CPU: 11  COMMAND: "kswapd1"
 #0 [ffff880c61c05cf8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c05d80] schedule at ffffffff814b8eb9
 #2 [ffff880c61c05d90] kswapd at ffffffff810f2b93
 #3 [ffff880c61c05ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c05f50] ret_from_fork at ffffffff814c20dc

PID: 115    TASK: ffff880c63ef3170  CPU: 11  COMMAND: "ksmd"
 #0 [ffff880c61c29d58] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c29de0] schedule at ffffffff814b8eb9
 #2 [ffff880c61c29df0] ksm_scan_thread at ffffffff8112562b
 #3 [ffff880c61c29ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c29f50] ret_from_fork at ffffffff814c20dc

PID: 116    TASK: ffff880c63ef3880  CPU: 3   COMMAND: "khugepaged"
 #0 [ffff880c61c2bc58] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c2bce0] schedule at ffffffff814b8eb9
 #2 [ffff880c61c2bcf0] schedule_timeout at ffffffff814b6cde
 #3 [ffff880c61c2bd80] khugepaged at ffffffff81130832
 #4 [ffff880c61c2bec0] kthread at ffffffff8105f0b0
 #5 [ffff880c61c2bf50] ret_from_fork at ffffffff814c20dc

PID: 117    TASK: ffff880c63ef3f90  CPU: 5   COMMAND: "fsnotify_mark"
 #0 [ffff880c61c2dda8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c2de30] schedule at ffffffff814b8eb9
 #2 [ffff880c61c2de40] fsnotify_mark_destroy at ffffffff81177012
 #3 [ffff880c61c2dec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c2df50] ret_from_fork at ffffffff814c20dc

PID: 118    TASK: ffff880c63ef46a0  CPU: 11  COMMAND: "xfsalloc"
 #0 [ffff880c61c4fd98] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c4fe20] schedule at ffffffff814b8eb9
 #2 [ffff880c61c4fe30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c61c4fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c4ff50] ret_from_fork at ffffffff814c20dc

PID: 119    TASK: ffff880c63ef4db0  CPU: 11  COMMAND: "xfs_mru_cache"
 #0 [ffff880c61c51d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c51e20] schedule at ffffffff814b8eb9
 #2 [ffff880c61c51e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c61c51ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c51f50] ret_from_fork at ffffffff814c20dc

PID: 120    TASK: ffff880c63ef54c0  CPU: 11  COMMAND: "xfslogd"
 #0 [ffff880c61c53d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c53e20] schedule at ffffffff814b8eb9
 #2 [ffff880c61c53e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c61c53ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c53f50] ret_from_fork at ffffffff814c20dc

PID: 121    TASK: ffff880c63fc46a0  CPU: 11  COMMAND: "crypto"
 #0 [ffff880c61c55d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c61c55e20] schedule at ffffffff814b8eb9
 #2 [ffff880c61c55e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c61c55ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61c55f50] ret_from_fork at ffffffff814c20dc

PID: 128    TASK: ffff880664b28e20  CPU: 11  COMMAND: "kpsmoused"
 #0 [ffff880c61ca9d98] __schedule at ffffffff814b7fc0
 #1 [ffff880c61ca9e20] schedule at ffffffff814b8eb9
 #2 [ffff880c61ca9e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c61ca9ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61ca9f50] ret_from_fork at ffffffff814c20dc

PID: 130    TASK: ffff880c61cb0710  CPU: 11  COMMAND: "deferwq"
 #0 [ffff880c61cedd98] __schedule at ffffffff814b7fc0
 #1 [ffff880c61cede20] schedule at ffffffff814b8eb9
 #2 [ffff880c61cede30] rescuer_thread at ffffffff810581e3
 #3 [ffff880c61cedec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61cedf50] ret_from_fork at ffffffff814c20dc

PID: 315    TASK: ffff880661900000  CPU: 13  COMMAND: "scsi_eh_0"
 #0 [ffff880661909d88] __schedule at ffffffff814b7fc0
 #1 [ffff880661909e10] schedule at ffffffff814b8eb9
 #2 [ffff880661909e20] scsi_error_handler at ffffffff81351b4c
 #3 [ffff880661909ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661909f50] ret_from_fork at ffffffff814c20dc

PID: 390    TASK: ffff880c61718000  CPU: 0   COMMAND: "kworker/0:1H"
 #0 [ffff880c61721db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61721e40] schedule at ffffffff814b8eb9
 #2 [ffff880c61721e50] worker_thread at ffffffff81058daf
 #3 [ffff880c61721ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61721f50] ret_from_fork at ffffffff814c20dc

PID: 397    TASK: ffff880662797100  CPU: 13  COMMAND: "kworker/13:1H"
 #0 [ffff880661435db8] __schedule at ffffffff814b7fc0
 #1 [ffff880661435e40] schedule at ffffffff814b8eb9
 #2 [ffff880661435e50] worker_thread at ffffffff81058daf
 #3 [ffff880661435ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661435f50] ret_from_fork at ffffffff814c20dc

PID: 398    TASK: ffff880661440000  CPU: 9   COMMAND: "kworker/9:1H"
 #0 [ffff880661437db8] __schedule at ffffffff814b7fc0
 #1 [ffff880661437e40] schedule at ffffffff814b8eb9
 #2 [ffff880661437e50] worker_thread at ffffffff81058daf
 #3 [ffff880661437ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661437f50] ret_from_fork at ffffffff814c20dc

PID: 399    TASK: ffff880664a262e0  CPU: 15  COMMAND: "kworker/15:1H"
 #0 [ffff880661467db8] __schedule at ffffffff814b7fc0
 #1 [ffff880661467e40] schedule at ffffffff814b8eb9
 #2 [ffff880661467e50] worker_thread at ffffffff81058daf
 #3 [ffff880661467ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661467f50] ret_from_fork at ffffffff814c20dc

PID: 430    TASK: ffff880664a254c0  CPU: 11  COMMAND: "kworker/11:1H"
 #0 [ffff88066147ddb8] __schedule at ffffffff814b7fc0
 #1 [ffff88066147de40] schedule at ffffffff814b8eb9
 #2 [ffff88066147de50] worker_thread at ffffffff81058daf
 #3 [ffff88066147dec0] kthread at ffffffff8105f0b0
 #4 [ffff88066147df50] ret_from_fork at ffffffff814c20dc

PID: 431    TASK: ffff880664a23f90  CPU: 5   COMMAND: "kworker/5:1H"
 #0 [ffff880661869db8] __schedule at ffffffff814b7fc0
 #1 [ffff880661869e40] schedule at ffffffff814b8eb9
 #2 [ffff880661869e50] worker_thread at ffffffff81058daf
 #3 [ffff880661869ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661869f50] ret_from_fork at ffffffff814c20dc

PID: 433    TASK: ffff880664a246a0  CPU: 7   COMMAND: "kworker/7:1H"
 #0 [ffff880662543db8] __schedule at ffffffff814b7fc0
 #1 [ffff880662543e40] schedule at ffffffff814b8eb9
 #2 [ffff880662543e50] worker_thread at ffffffff81058daf
 #3 [ffff880662543ec0] kthread at ffffffff8105f0b0
 #4 [ffff880662543f50] ret_from_fork at ffffffff814c20dc

PID: 434    TASK: ffff880662749530  CPU: 1   COMMAND: "kworker/1:1H"
 #0 [ffff8806627f9db8] __schedule at ffffffff814b7fc0
 #1 [ffff8806627f9e40] schedule at ffffffff814b8eb9
 #2 [ffff8806627f9e50] worker_thread at ffffffff81058daf
 #3 [ffff8806627f9ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806627f9f50] ret_from_fork at ffffffff814c20dc

PID: 435    TASK: ffff88066247cdb0  CPU: 3   COMMAND: "kworker/3:1H"
 #0 [ffff8806627ffdb8] __schedule at ffffffff814b7fc0
 #1 [ffff8806627ffe40] schedule at ffffffff814b8eb9
 #2 [ffff8806627ffe50] worker_thread at ffffffff81058daf
 #3 [ffff8806627ffec0] kthread at ffffffff8105f0b0
 #4 [ffff8806627fff50] ret_from_fork at ffffffff814c20dc

PID: 461    TASK: ffff88066247aa60  CPU: 10  COMMAND: "xfs-data/sda2"
 #0 [ffff880662653d98] __schedule at ffffffff814b7fc0
 #1 [ffff880662653e20] schedule at ffffffff814b8eb9
 #2 [ffff880662653e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880662653ec0] kthread at ffffffff8105f0b0
 #4 [ffff880662653f50] ret_from_fork at ffffffff814c20dc

PID: 462    TASK: ffff880662478000  CPU: 10  COMMAND: "xfs-conv/sda2"
 #0 [ffff8806625d9d98] __schedule at ffffffff814b7fc0
 #1 [ffff8806625d9e20] schedule at ffffffff814b8eb9
 #2 [ffff8806625d9e30] rescuer_thread at ffffffff810581e3
 #3 [ffff8806625d9ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806625d9f50] ret_from_fork at ffffffff814c20dc

PID: 463    TASK: ffff880662478710  CPU: 10  COMMAND: "xfs-cil/sda2"
 #0 [ffff880662691d98] __schedule at ffffffff814b7fc0
 #1 [ffff880662691e20] schedule at ffffffff814b8eb9
 #2 [ffff880662691e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880662691ec0] kthread at ffffffff8105f0b0
 #4 [ffff880662691f50] ret_from_fork at ffffffff814c20dc

PID: 464    TASK: ffff88066247b880  CPU: 5   COMMAND: "xfsaild/sda2"
 #0 [ffff880662613d48] __schedule at ffffffff814b7fc0
 #1 [ffff880662613dd0] schedule at ffffffff814b8eb9
 #2 [ffff880662613de0] xfsaild at ffffffff8121c160
 #3 [ffff880662613ec0] kthread at ffffffff8105f0b0
 #4 [ffff880662613f50] ret_from_fork at ffffffff814c20dc

PID: 498    TASK: ffff88066254bf90  CPU: 9   COMMAND: "rpciod"
 #0 [ffff88066242fd98] __schedule at ffffffff814b7fc0
 #1 [ffff88066242fe20] schedule at ffffffff814b8eb9
 #2 [ffff88066242fe30] rescuer_thread at ffffffff810581e3
 #3 [ffff88066242fec0] kthread at ffffffff8105f0b0
 #4 [ffff88066242ff50] ret_from_fork at ffffffff814c20dc

PID: 512    TASK: ffff880c61c654c0  CPU: 0   COMMAND: "udevd"
 #0 [ffff880c61debd88] __schedule at ffffffff814b7fc0
 #1 [ffff880c61debe10] schedule at ffffffff814b8eb9
 #2 [ffff880c61debe20] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c61debea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c61debeb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880c61debf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f0970176763  RSP: 00007fffe9090b50  RFLAGS: 00010246
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: 0000000000000007
    RDX: 0000000000000008  RSI: 00007fffe9091a60  RDI: 000000000000000a
    RBP: 00000000ffffffff   R8: 0000000000000006   R9: 0000000000000001
    R10: 00000000ffffffff  R11: 0000000000000246  R12: 0000000000000018
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 824    TASK: ffff880c6171f810  CPU: 14  COMMAND: "kworker/14:1H"
 #0 [ffff880c61567db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61567e40] schedule at ffffffff814b8eb9
 #2 [ffff880c61567e50] worker_thread at ffffffff81058daf
 #3 [ffff880c61567ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c61567f50] ret_from_fork at ffffffff814c20dc

PID: 863    TASK: ffff880c627e0000  CPU: 6   COMMAND: "kworker/6:1H"
 #0 [ffff880c615f7db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c615f7e40] schedule at ffffffff814b8eb9
 #2 [ffff880c615f7e50] worker_thread at ffffffff81058daf
 #3 [ffff880c615f7ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c615f7f50] ret_from_fork at ffffffff814c20dc

PID: 996    TASK: ffff880c61e78000  CPU: 4   COMMAND: "kworker/4:1H"
 #0 [ffff880c6164ddb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c6164de40] schedule at ffffffff814b8eb9
 #2 [ffff880c6164de50] worker_thread at ffffffff81058daf
 #3 [ffff880c6164dec0] kthread at ffffffff8105f0b0
 #4 [ffff880c6164df50] ret_from_fork at ffffffff814c20dc

PID: 1177   TASK: ffff880c62668000  CPU: 2   COMMAND: "kworker/2:1H"
 #0 [ffff880c6262fdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c6262fe40] schedule at ffffffff814b8eb9
 #2 [ffff880c6262fe50] worker_thread at ffffffff81058daf
 #3 [ffff880c6262fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c6262ff50] ret_from_fork at ffffffff814c20dc

PID: 1431   TASK: ffff88066362d4c0  CPU: 7   COMMAND: "mlx4"
 #0 [ffff88065d687d98] __schedule at ffffffff814b7fc0
 #1 [ffff88065d687e20] schedule at ffffffff814b8eb9
 #2 [ffff88065d687e30] rescuer_thread at ffffffff810581e3
 #3 [ffff88065d687ec0] kthread at ffffffff8105f0b0
 #4 [ffff88065d687f50] ret_from_fork at ffffffff814c20dc

PID: 1433   TASK: ffff88066362dbd0  CPU: 12  COMMAND: "cxgb3"
 #0 [ffff88066377dd98] __schedule at ffffffff814b7fc0
 #1 [ffff88066377de20] schedule at ffffffff814b8eb9
 #2 [ffff88066377de30] rescuer_thread at ffffffff810581e3
 #3 [ffff88066377dec0] kthread at ffffffff8105f0b0
 #4 [ffff88066377df50] ret_from_fork at ffffffff814c20dc

PID: 1437   TASK: ffff880c62530000  CPU: 12  COMMAND: "kworker/12:1H"
 #0 [ffff880c60cb7db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c60cb7e40] schedule at ffffffff814b8eb9
 #2 [ffff880c60cb7e50] worker_thread at ffffffff81058daf
 #3 [ffff880c60cb7ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c60cb7f50] ret_from_fork at ffffffff814c20dc

PID: 1502   TASK: ffff880c630e1c40  CPU: 5   COMMAND: "systemd-stdout-"
 #0 [ffff880c62143d88] __schedule at ffffffff814b7fc0
 #1 [ffff880c62143e10] schedule at ffffffff814b8eb9
 #2 [ffff880c62143e20] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c62143ea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c62143eb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880c62143f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af1763  RSP: 00007fffad1536c8  RFLAGS: 00010246
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: 00000031c5ae43e0
    RDX: 0000000000000001  RSI: 00007fffad153730  RDI: 0000000000000005
    RBP: 00000000020b5c05   R8: 00007fffad153700   R9: 0000000000405c67
    R10: 00000000ffffffff  R11: 0000000000000246  R12: 0004eb24c211a0c1
    R13: 00007fffad153700  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 1530   TASK: ffff88066362b170  CPU: 11  COMMAND: "jbd2/sda4-8"
 #0 [ffff880663fedda8] __schedule at ffffffff814b7fc0
 #1 [ffff880663fede30] schedule at ffffffff814b8eb9
 #2 [ffff880663fede40] kjournald2 at ffffffffa05312f6 [jbd2]
 #3 [ffff880663fedec0] kthread at ffffffff8105f0b0
 #4 [ffff880663fedf50] ret_from_fork at ffffffff814c20dc

PID: 1531   TASK: ffff880663629530  CPU: 10  COMMAND: "ext4-dio-unwrit"
 #0 [ffff88066358bd98] __schedule at ffffffff814b7fc0
 #1 [ffff88066358be20] schedule at ffffffff814b8eb9
 #2 [ffff88066358be30] rescuer_thread at ffffffff810581e3
 #3 [ffff88066358bec0] kthread at ffffffff8105f0b0
 #4 [ffff88066358bf50] ret_from_fork at ffffffff814c20dc

PID: 1534   TASK: ffff8806630b3f90  CPU: 11  COMMAND: "xfs-data/sda5"
 #0 [ffff880661ae7d98] __schedule at ffffffff814b7fc0
 #1 [ffff880661ae7e20] schedule at ffffffff814b8eb9
 #2 [ffff880661ae7e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880661ae7ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661ae7f50] ret_from_fork at ffffffff814c20dc

PID: 1535   TASK: ffff8806630b46a0  CPU: 10  COMMAND: "xfs-conv/sda5"
 #0 [ffff880663b93d98] __schedule at ffffffff814b7fc0
 #1 [ffff880663b93e20] schedule at ffffffff814b8eb9
 #2 [ffff880663b93e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880663b93ec0] kthread at ffffffff8105f0b0
 #4 [ffff880663b93f50] ret_from_fork at ffffffff814c20dc

PID: 1536   TASK: ffff8806630b4db0  CPU: 11  COMMAND: "xfs-cil/sda5"
 #0 [ffff880662e75d98] __schedule at ffffffff814b7fc0
 #1 [ffff880662e75e20] schedule at ffffffff814b8eb9
 #2 [ffff880662e75e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880662e75ec0] kthread at ffffffff8105f0b0
 #4 [ffff880662e75f50] ret_from_fork at ffffffff814c20dc

PID: 1537   TASK: ffff88065d1baa60  CPU: 2   COMMAND: "xfsaild/sda5"
 #0 [ffff88066116bd48] __schedule at ffffffff814b7fc0
 #1 [ffff88066116bdd0] schedule at ffffffff814b8eb9
 #2 [ffff88066116bde0] xfsaild at ffffffff8121c160
 #3 [ffff88066116bec0] kthread at ffffffff8105f0b0
 #4 [ffff88066116bf50] ret_from_fork at ffffffff814c20dc

PID: 1553   TASK: ffff88065d1b9c40  CPU: 13  COMMAND: "mlx4_en"
 #0 [ffff880659a0dd98] __schedule at ffffffff814b7fc0
 #1 [ffff880659a0de20] schedule at ffffffff814b8eb9
 #2 [ffff880659a0de30] rescuer_thread at ffffffff810581e3
 #3 [ffff880659a0dec0] kthread at ffffffff8105f0b0
 #4 [ffff880659a0df50] ret_from_fork at ffffffff814c20dc

PID: 1555   TASK: ffff88065d6abf90  CPU: 15  COMMAND: "ib_mcast"
 #0 [ffff88066302bd98] __schedule at ffffffff814b7fc0
 #1 [ffff88066302be20] schedule at ffffffff814b8eb9
 #2 [ffff88066302be30] rescuer_thread at ffffffff810581e3
 #3 [ffff88066302bec0] kthread at ffffffff8105f0b0
 #4 [ffff88066302bf50] ret_from_fork at ffffffff814c20dc

PID: 1556   TASK: ffff88065d6a9530  CPU: 15  COMMAND: "mlx4_ib"
 #0 [ffff88065d5a7d98] __schedule at ffffffff814b7fc0
 #1 [ffff88065d5a7e20] schedule at ffffffff814b8eb9
 #2 [ffff88065d5a7e30] rescuer_thread at ffffffff810581e3
 #3 [ffff88065d5a7ec0] kthread at ffffffff8105f0b0
 #4 [ffff88065d5a7f50] ret_from_fork at ffffffff814c20dc

PID: 1557   TASK: ffff88065d6ac6a0  CPU: 15  COMMAND: "mlx4_ib_mcg"
 #0 [ffff88065d29dd98] __schedule at ffffffff814b7fc0
 #1 [ffff88065d29de20] schedule at ffffffff814b8eb9
 #2 [ffff88065d29de30] rescuer_thread at ffffffff810581e3
 #3 [ffff88065d29dec0] kthread at ffffffff8105f0b0
 #4 [ffff88065d29df50] ret_from_fork at ffffffff814c20dc

PID: 1558   TASK: ffff88065d6acdb0  CPU: 15  COMMAND: "ib_mad1"
 #0 [ffff880663661d98] __schedule at ffffffff814b7fc0
 #1 [ffff880663661e20] schedule at ffffffff814b8eb9
 #2 [ffff880663661e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880663661ec0] kthread at ffffffff8105f0b0
 #4 [ffff880663661f50] ret_from_fork at ffffffff814c20dc

PID: 1559   TASK: ffff88065d6aaa60  CPU: 15  COMMAND: "ib_mad2"
 #0 [ffff8806615e3d98] __schedule at ffffffff814b7fc0
 #1 [ffff8806615e3e20] schedule at ffffffff814b8eb9
 #2 [ffff8806615e3e30] rescuer_thread at ffffffff810581e3
 #3 [ffff8806615e3ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806615e3f50] ret_from_fork at ffffffff814c20dc

PID: 1938   TASK: ffff880662548000  CPU: 10  COMMAND: "iw_cxgb3"
 #0 [ffff880661449d98] __schedule at ffffffff814b7fc0
 #1 [ffff880661449e20] schedule at ffffffff814b8eb9
 #2 [ffff880661449e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880661449ec0] kthread at ffffffff8105f0b0
 #4 [ffff880661449f50] ret_from_fork at ffffffff814c20dc

PID: 1956   TASK: ffff880c630e1530  CPU: 2   COMMAND: "crond"
 #0 [ffff880c5cdf9df8] __schedule at ffffffff814b7fc0
 #1 [ffff880c5cdf9e80] schedule at ffffffff814b8eb9
 #2 [ffff880c5cdf9e90] do_nanosleep at ffffffff814b76ec
 #3 [ffff880c5cdf9ed0] hrtimer_nanosleep at ffffffff81063090
 #4 [ffff880c5cdf9f50] sys_nanosleep at ffffffff810631b6
 #5 [ffff880c5cdf9f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd9e0  RSP: 00007fff1438cc28  RFLAGS: 00000246
    RAX: 0000000000000023  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00007fff1438cdd0  RDI: 00007fff1438cdd0
    RBP: 00000000ffffffff   R8: 00007fff1438cc30   R9: 000000000000003c
    R10: 0000000000000008  R11: 0000000000000246  R12: ffffffffffffaba0
    R13: 00007fff1438ccd0  R14: 0000000000000000  R15: 0000000000000023
    ORIG_RAX: 0000000000000023  CS: 0033  SS: 002b

PID: 1957   TASK: ffff880c61b51530  CPU: 8   COMMAND: "kworker/8:1H"
 #0 [ffff880c62f47db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c62f47e40] schedule at ffffffff814b8eb9
 #2 [ffff880c62f47e50] worker_thread at ffffffff81058daf
 #3 [ffff880c62f47ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c62f47f50] ret_from_fork at ffffffff814c20dc

PID: 1958   TASK: ffff880c61b554c0  CPU: 7   COMMAND: "ib_addr"
 #0 [ffff88065942dd98] __schedule at ffffffff814b7fc0
 #1 [ffff88065942de20] schedule at ffffffff814b8eb9
 #2 [ffff88065942de30] rescuer_thread at ffffffff810581e3
 #3 [ffff88065942dec0] kthread at ffffffff8105f0b0
 #4 [ffff88065942df50] ret_from_fork at ffffffff814c20dc

PID: 1962   TASK: ffff8806630b54c0  CPU: 11  COMMAND: "iw_cm_wq"
 #0 [ffff880659433d98] __schedule at ffffffff814b7fc0
 #1 [ffff880659433e20] schedule at ffffffff814b8eb9
 #2 [ffff880659433e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880659433ec0] kthread at ffffffff8105f0b0
 #4 [ffff880659433f50] ret_from_fork at ffffffff814c20dc

PID: 1970   TASK: ffff8806630b69f0  CPU: 12  COMMAND: "ib_cm"
 #0 [ffff880659475d98] __schedule at ffffffff814b7fc0
 #1 [ffff880659475e20] schedule at ffffffff814b8eb9
 #2 [ffff880659475e30] rescuer_thread at ffffffff810581e3
 #3 [ffff880659475ec0] kthread at ffffffff8105f0b0
 #4 [ffff880659475f50] ret_from_fork at ffffffff814c20dc

PID: 1975   TASK: ffff8806630b3170  CPU: 10  COMMAND: "rdma_cm"
 #0 [ffff8806635dbd98] __schedule at ffffffff814b7fc0
 #1 [ffff8806635dbe20] schedule at ffffffff814b8eb9
 #2 [ffff8806635dbe30] rescuer_thread at ffffffff810581e3
 #3 [ffff8806635dbec0] kthread at ffffffff8105f0b0
 #4 [ffff8806635dbf50] ret_from_fork at ffffffff814c20dc

PID: 1998   TASK: ffff88065d1be2e0  CPU: 10  COMMAND: "ipoib"
 #0 [ffff880659a9bd98] __schedule at ffffffff814b7fc0
 #1 [ffff880659a9be20] schedule at ffffffff814b8eb9
 #2 [ffff880659a9be30] rescuer_thread at ffffffff810581e3
 #3 [ffff880659a9bec0] kthread at ffffffff8105f0b0
 #4 [ffff880659a9bf50] ret_from_fork at ffffffff814c20dc

PID: 2026   TASK: ffff880c62537810  CPU: 1   COMMAND: "acpid"
 #0 [ffff880c5b663898] __schedule at ffffffff814b7fc0
 #1 [ffff880c5b663920] schedule at ffffffff814b8eb9
 #2 [ffff880c5b663930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c5b6639b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c5b6639c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c5b6639f0] do_select at ffffffff8114a899
 #6 [ffff880c5b663d70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c5b663f10] sys_select at ffffffff8114ad71
 #8 [ffff880c5b663f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f6cd1366623  RSP: 00007fff63d7ee98  RFLAGS: 00010207
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 00007fff63d7f0a0  RDI: 0000000000000009
    RBP: 0000000000000005   R8: 0000000000000000   R9: 00007f6cd1c77950
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000001  R14: 00007f6cd1a75140  R15: 0000000000000000
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 2032   TASK: ffff880c630e46a0  CPU: 1   COMMAND: "igmp-leave-thro"
 #0 [ffff880c5cecbbe8] __schedule at ffffffff814b7fc0
 #1 [ffff880c5cecbc70] schedule at ffffffff814b8eb9
 #2 [ffff880c5cecbc80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff880c5cecbcd0] futex_wait at ffffffff8107f809
 #4 [ffff880c5cecbe00] do_futex at ffffffff81081564
 #5 [ffff880c5cecbef0] sys_futex at ffffffff81081e87
 #6 [ffff880c5cecbf80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620bae5  RSP: 00007fffb26d9470  RFLAGS: 00010202
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: 0000000000b1ca90
    RDX: 0000000000000001  RSI: 0000000000000080  RDI: 00000000006585c4
    RBP: 00000000006585c0   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fffb26d9620
    R13: 0000000000b1ca08  R14: 0000000000000000  R15: 0000000000b1d740
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 2136   TASK: ffff880c630e0000  CPU: 5   COMMAND: "irqbalance"
 #0 [ffff880c5cf2ddf8] __schedule at ffffffff814b7fc0
 #1 [ffff880c5cf2de80] schedule at ffffffff814b8eb9
 #2 [ffff880c5cf2de90] do_nanosleep at ffffffff814b76ec
 #3 [ffff880c5cf2ded0] hrtimer_nanosleep at ffffffff81063090
 #4 [ffff880c5cf2df50] sys_nanosleep at ffffffff810631b6
 #5 [ffff880c5cf2df80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd9e0  RSP: 00007fff823d2aa8  RFLAGS: 00000246
    RAX: 0000000000000023  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000009  RSI: 0000000000000000  RDI: 00007fff823d2b00
    RBP: 0000000000000004   R8: 0000000000000001   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffffffffffff
    R13: 0000000000000008  R14: 000000003b94d690  R15: 0000000000000009
    ORIG_RAX: 0000000000000023  CS: 0033  SS: 002b

PID: 2138   TASK: ffff880c630e5bd0  CPU: 2   COMMAND: "systemd-logind"
 #0 [ffff880c61f55d08] __schedule at ffffffff814b7fc0
 #1 [ffff880c61f55d90] schedule at ffffffff814b8eb9
 #2 [ffff880c61f55da0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c61f55db0] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880c61f55e20] mutex_lock at ffffffff814b742a
 #5 [ffff880c61f55e40] cgroup_lock_live_group at ffffffff8108fa6d
 #6 [ffff880c61f55e60] cgroup_mkdir at ffffffff810946c8
 #7 [ffff880c61f55ee0] vfs_mkdir at ffffffff81145ea4
 #8 [ffff880c61f55f10] sys_mkdirat at ffffffff8114791e
 #9 [ffff880c61f55f70] sys_mkdir at ffffffff811479b9
#10 [ffff880c61f55f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae4187  RSP: 00007fff874ea138  RFLAGS: 00000212
    RAX: 0000000000000053  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00000000000001ed  RDI: 0000000001c30570
    RBP: 000000000041e7e8   R8: 6962682f72657375   R9: 0000000000000010
    R10: 0000000000000020  R11: 0000000000000246  R12: ffffffff811479b9
    R13: ffff880c61f55f78  R14: 0000000000000000  R15: 00007fff874ea5f0
    ORIG_RAX: 0000000000000053  CS: 0033  SS: 002b

PID: 2246   TASK: ffff88066274aa60  CPU: 11  COMMAND: "igmp-leave-thro"
 #0 [ffff8806614c1d88] __schedule at ffffffff814b7fc0
 #1 [ffff8806614c1e10] schedule at ffffffff814b8eb9
 #2 [ffff8806614c1e20] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff8806614c1ea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff8806614c1eb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff8806614c1f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af1783  RSP: 00007fbb85d62db0  RFLAGS: 00010206
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000003e8  RSI: 0000000000b18a50  RDI: 0000000000000005
    RBP: 0000000000000000   R8: 0000000000656568   R9: 00000000000008c6
    R10: 00000000ffffffff  R11: 0000000000000293  R12: 0000000000000003
    R13: 0000000000000000  R14: 00007fbb85d639c0  R15: 00000031c6211040
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 2247   TASK: ffff88066274cdb0  CPU: 0   COMMAND: "igmp-leave-thro"
 #0 [ffff880662c1fc38] __schedule at ffffffff814b7fc0
 #1 [ffff880662c1fcc0] schedule at ffffffff814b8eb9
 #2 [ffff880662c1fcd0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880662c1fce0] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880662c1fd50] mutex_lock at ffffffff814b742a
 #5 [ffff880662c1fd70] rtnl_lock at ffffffff81419295
 #6 [ffff880662c1fd80] dev_ioctl at ffffffff8141f775
 #7 [ffff880662c1fe40] sock_do_ioctl.constprop.12 at ffffffff813f4669
 #8 [ffff880662c1fe60] sock_ioctl at ffffffff813f4f94
 #9 [ffff880662c1fe90] do_vfs_ioctl at ffffffff811490e6
#10 [ffff880662c1ff20] sys_ioctl at ffffffff811495f0
#11 [ffff880662c1ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae9f27  RSP: 00007fbb85561ac8  RFLAGS: 00000246
    RAX: 0000000000000010  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 00007fbb85561c90  RSI: 0000000000008912  RDI: 000000000000000c
    RBP: 00007fffb26d9620   R8: 0000000000000000   R9: 0000000000100000
    R10: 0000000000000000  R11: 0000000000000246  R12: 000000000040e810
    R13: 00007fffb26d9680  R14: 0000000000000000  R15: 000000000000000c
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

PID: 2250   TASK: ffff880c630e3f90  CPU: 13  COMMAND: "mcelog"
 #0 [ffff880c6185f998] __schedule at ffffffff814b7fc0
 #1 [ffff880c6185fa20] schedule at ffffffff814b8eb9
 #2 [ffff880c6185fa30] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c6185fab0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c6185fac0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c6185faf0] do_sys_poll at ffffffff8114b3df
 #6 [ffff880c6185ff00] sys_ppoll at ffffffff8114b6f4
 #7 [ffff880c6185ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae888f  RSP: 00007fff13e02168  RFLAGS: 00010246
    RAX: 000000000000010f  RBX: ffffffff814c2182  RCX: 0000000000616c00
    RDX: 0000000000000000  RSI: 0000000000000002  RDI: 0000000000616aa0
    RBP: 00007fff13e022a8   R8: 0000000000000008   R9: 0000000000000001
    R10: 0000000000616c00  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 00007fff13e022a0  R15: 0000000000000004
    ORIG_RAX: 000000000000010f  CS: 0033  SS: 002b

PID: 2254   TASK: ffff880c630e2350  CPU: 7   COMMAND: "dbus-daemon"
 #0 [ffff880c61b139d8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61b13a60] schedule at ffffffff814b8eb9
 #2 [ffff880c61b13a70] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c61b13af0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c61b13b00] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c61b13b30] do_sys_poll at ffffffff8114b3df
 #6 [ffff880c61b13f40] sys_poll at ffffffff8114b57b
 #7 [ffff880c61b13f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae87c8  RSP: 00007fff8e0681b8  RFLAGS: 00000246
    RAX: 0000000000000007  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: ffffffffffffffff  RSI: 0000000000000008  RDI: 00007fff8e068380
    RBP: 0000000000000001   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000008
    R13: 00007fff8e068580  R14: 0000000000fab1b0  R15: 00007fff8e067f30
    ORIG_RAX: 0000000000000007  CS: 0033  SS: 002b

PID: 2256   TASK: ffff880c630e2a60  CPU: 3   COMMAND: "rsyslogd"
 #0 [ffff880c6197b898] __schedule at ffffffff814b7fc0
 #1 [ffff880c6197b920] schedule at ffffffff814b8eb9
 #2 [ffff880c6197b930] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff880c6197b9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c6197b9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c6197b9f0] do_select at ffffffff8114a899
 #6 [ffff880c6197bd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c6197bf10] sys_select at ffffffff8114ad71
 #8 [ffff880c6197bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f6e7e0b5643  RSP: 00007fff2236bfb0  RFLAGS: 00000297
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000001
    RBP: 0000000000000000   R8: 00007fff2236c880   R9: 00000000000008d0
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000000000000
    R13: 00007f6e7f03f7c0  R14: 0000000000000001  R15: 00007f6e7f25b1f8
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 2257   TASK: ffff880661447810  CPU: 6   COMMAND: "rs:main Q:Reg"
 #0 [ffff88066109bbe8] __schedule at ffffffff814b7fc0
 #1 [ffff88066109bc70] schedule at ffffffff814b8eb9
 #2 [ffff88066109bc80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff88066109bcd0] futex_wait at ffffffff8107f809
 #4 [ffff88066109be00] do_futex at ffffffff81081564
 #5 [ffff88066109bef0] sys_futex at ffffffff81081e87
 #6 [ffff88066109bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f6e7e9afae5  RSP: 00007f6e7d3351c0  RFLAGS: 00000206
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 00000000001d585d  RSI: 0000000000000080  RDI: 00007f6e800d20c4
    RBP: 00007f6e7f25b1f8   R8: 0000000000000000   R9: 00000000000eac2e
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000003
    R13: 00007f6e7f040a97  R14: 0000000000000000  R15: 00007f6e800c9320
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 2258   TASK: ffff8806614446a0  CPU: 1   COMMAND: "rsyslogd"
 #0 [ffff88066109d898] __schedule at ffffffff814b7fc0
 #1 [ffff88066109d920] schedule at ffffffff814b8eb9
 #2 [ffff88066109d930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff88066109d9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff88066109d9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff88066109d9f0] do_select at ffffffff8114a899
 #6 [ffff88066109dd70] core_sys_select at ffffffff8114ab72
 #7 [ffff88066109df10] sys_select at ffffffff8114ad71
 #8 [ffff88066109df80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f6e7e0b5643  RSP: 00007f6e7cb33508  RFLAGS: 00010206
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000018
    RDX: 0000000000000000  RSI: 00007f6e6c0008c0  RDI: 0000000000000004
    RBP: 00007f6e7d791b10   R8: 0000000000000000   R9: 0101010101010101
    R10: 0000000000000000  R11: 0000000000000293  R12: 00007f6e7d791b00
    R13: 00007f6e7f25b1f8  R14: 0000000000000004  R15: 0000000000000001
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 2259   TASK: ffff880661441530  CPU: 7   COMMAND: "rsyslogd"
 #0 [ffff88066145dda8] __schedule at ffffffff814b7fc0
 #1 [ffff88066145de30] schedule at ffffffff814b8eb9
 #2 [ffff88066145de40] do_syslog at ffffffff8103e301
 #3 [ffff88066145dec0] kmsg_read at ffffffff8119fee6
 #4 [ffff88066145dee0] proc_reg_read at ffffffff81193733
 #5 [ffff88066145df00] vfs_read at ffffffff811383d0
 #6 [ffff88066145df30] sys_read at ffffffff81138652
 #7 [ffff88066145df80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f6e7e9b262d  RSP: 00007f6e7c333d68  RFLAGS: 00000202
    RAX: 0000000000000000  RBX: ffffffff814c2182  RCX: 0000000000000009
    RDX: 0000000000000fff  RSI: 00007f6e7d53d380  RDI: 0000000000000004
    RBP: 0000000000000000   R8: 00007f6e800d20c0   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000000000000
    R13: 00007f6e7c3349c0  R14: 00007f6e7f25b1a0  R15: 00007f6e800e7ba0
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

PID: 3040   TASK: ffff88066274bf90  CPU: 2   COMMAND: "svscan"
 #0 [ffff8806626c7df8] __schedule at ffffffff814b7fc0
 #1 [ffff8806626c7e80] schedule at ffffffff814b8eb9
 #2 [ffff8806626c7e90] do_nanosleep at ffffffff814b76ec
 #3 [ffff8806626c7ed0] hrtimer_nanosleep at ffffffff81063090
 #4 [ffff8806626c7f50] sys_nanosleep at ffffffff810631b6
 #5 [ffff8806626c7f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd9e0  RSP: 00007fff13871c78  RFLAGS: 00000202
    RAX: 0000000000000023  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00007fff13871c80  RDI: 00007fff13871c80
    RBP: 00000000ffffffff   R8: 00007fff13871ae0   R9: 0000000000000001
    R10: 0000000000000008  R11: 0000000000000246  R12: 00000000004008d0
    R13: 00007fff13871b80  R14: 0000000000000000  R15: 0000000000000005
    ORIG_RAX: 0000000000000023  CS: 0033  SS: 002b

PID: 3041   TASK: ffff880c62530710  CPU: 3   COMMAND: "sshd"
 #0 [ffff880c055b7898] __schedule at ffffffff814b7fc0
 #1 [ffff880c055b7920] schedule at ffffffff814b8eb9
 #2 [ffff880c055b7930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c055b79b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c055b79c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c055b79f0] do_select at ffffffff8114a899
 #6 [ffff880c055b7d70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c055b7f10] sys_select at ffffffff8114ad71
 #8 [ffff880c055b7f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f8ebfec0623  RSP: 00007fffe149cdb8  RFLAGS: 00000217
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 00007f8ec0187708
    RDX: 0000000000000000  RSI: 00007f8ec3b86830  RDI: 000000000000000a
    RBP: 00007f8ec3063900   R8: 0000000000000000   R9: 0101010101010101
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f8ec3061f08
    R13: 00007f8ec3b86830  R14: 00007f8ec30638f0  R15: 0000000000000320
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3043   TASK: ffff880c61f3bf90  CPU: 11  COMMAND: "rpc.idmapd"
 #0 [ffff880c61d23d88] __schedule at ffffffff814b7fc0
 #1 [ffff880c61d23e10] schedule at ffffffff814b8eb9
 #2 [ffff880c61d23e20] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c61d23ea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c61d23eb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880c61d23f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f9593679763  RSP: 00007fff5e083158  RFLAGS: 00000206
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000020  RSI: 00007f95961bf720  RDI: 0000000000000003
    RBP: 00007f95961bf720   R8: 0000000000000000   R9: 0000000000000000
    R10: 00000000ffffffff  R11: 0000000000000246  R12: 00007f95961bf590
    R13: 0000000000000001  R14: 00007f95961bf5b8  R15: 00007f95961bf490
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 3044   TASK: ffff880c61f3c6a0  CPU: 10  COMMAND: "snmpd"
 #0 [ffff880c055b3c38] __schedule at ffffffff814b7fc0
 #1 [ffff880c055b3cc0] schedule at ffffffff814b8eb9
 #2 [ffff880c055b3cd0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c055b3ce0] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880c055b3d50] mutex_lock at ffffffff814b742a
 #5 [ffff880c055b3d70] rtnl_lock at ffffffff81419295
 #6 [ffff880c055b3d80] dev_ioctl at ffffffff8141f775
 #7 [ffff880c055b3e40] sock_do_ioctl.constprop.12 at ffffffff813f4669
 #8 [ffff880c055b3e60] sock_ioctl at ffffffff813f4f94
 #9 [ffff880c055b3e90] do_vfs_ioctl at ffffffff811490e6
#10 [ffff880c055b3f20] sys_ioctl at ffffffff811495f0
#11 [ffff880c055b3f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f511b3acf27  RSP: 00007fff5b91c148  RFLAGS: 00000246
    RAX: 0000000000000010  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 00007fff5b91be40  RSI: 0000000000008912  RDI: 000000000000000c
    RBP: 00007fff5b91be40   R8: 0000000000000048   R9: 0000000000100000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f511d6c6480
    R13: 00007fff5b91c490  R14: 000000000000000c  R15: 0000000000000000
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

PID: 3046   TASK: ffff88065d5246a0  CPU: 6   COMMAND: "rpcbind"
 #0 [ffff8806627c99d8] __schedule at ffffffff814b7fc0
 #1 [ffff8806627c9a60] schedule at ffffffff814b8eb9
 #2 [ffff8806627c9a70] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff8806627c9af0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff8806627c9b00] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff8806627c9b30] do_sys_poll at ffffffff8114b3df
 #6 [ffff8806627c9f40] sys_poll at ffffffff8114b57b
 #7 [ffff8806627c9f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fcae90827c8  RSP: 00007fff46134650  RFLAGS: 00000207
    RAX: 0000000000000007  RBX: ffffffff814c2182  RCX: 00007fcae90827c8
    RDX: 0000000000007530  RSI: 0000000000000007  RDI: 00007fff46134690
    RBP: 00007fcae9f20050   R8: 000000000000000c   R9: 0000000000000000
    R10: 00007fcae999f0ec  R11: 0000000000000246  R12: 00007fff46134690
    R13: 00007fcae999f360  R14: 0000000000000007  R15: 0000000000000000
    ORIG_RAX: 0000000000000007  CS: 0033  SS: 002b

PID: 3066   TASK: ffff880c61f39c40  CPU: 7   COMMAND: "rpc.statd"
 #0 [ffff880c62c2b898] __schedule at ffffffff814b7fc0
 #1 [ffff880c62c2b920] schedule at ffffffff814b8eb9
 #2 [ffff880c62c2b930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c62c2b9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c62c2b9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c62c2b9f0] do_select at ffffffff8114a899
 #6 [ffff880c62c2bd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c62c2bf10] sys_select at ffffffff8114ad71
 #8 [ffff880c62c2bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fbb0e60a623  RSP: 00007fffea621488  RFLAGS: 00010206
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 00007fffea621490  RDI: 0000000000000400
    RBP: 0000000000000001   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 00000000ffffffff  R14: 0000000000000000  R15: 00007fbb0f3477d8
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3086   TASK: ffff880c63350710  CPU: 11  COMMAND: "udevd"
 #0 [ffff880c055add88] __schedule at ffffffff814b7fc0
 #1 [ffff880c055ade10] schedule at ffffffff814b8eb9
 #2 [ffff880c055ade20] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c055adea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c055adeb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880c055adf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f0970176763  RSP: 00007fffe908c4b8  RFLAGS: 00000246
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000004  RSI: 00007fffe90917b8  RDI: 0000000000000004
    RBP: 00007f09713a9d50   R8: 0000000000000000   R9: 0000000000000001
    R10: 00000000ffffffff  R11: 0000000000000246  R12: 000000000000000c
    R13: 0000000000000000  R14: 00007f09713a9a40  R15: 00007f09713a9cc0
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 3088   TASK: ffff880c61f3a350  CPU: 11  COMMAND: "lldpd"
 #0 [ffff880c05751ab8] __schedule at ffffffff814b7fc0
 #1 [ffff880c05751b40] schedule at ffffffff814b8eb9
 #2 [ffff880c05751b50] schedule_timeout at ffffffff814b6d65
 #3 [ffff880c05751be0] __skb_recv_datagram at ffffffff81402b00
 #4 [ffff880c05751ca0] unix_dgram_recvmsg at ffffffff8149b659
 #5 [ffff880c05751d60] sock_aio_read.part.0 at ffffffff813f3f56
 #6 [ffff880c05751e10] sock_aio_read at ffffffff813f3fa3
 #7 [ffff880c05751e20] do_sync_read at ffffffff8113753a
 #8 [ffff880c05751f00] vfs_read at ffffffff81138485
 #9 [ffff880c05751f30] sys_read at ffffffff81138652
#10 [ffff880c05751f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae43e0  RSP: 00007fff754829c0  RFLAGS: 00000217
    RAX: 0000000000000000  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000004  RSI: 00007fff7548438c  RDI: 0000000000000006
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: 00000000000003e0
    R13: 0000000000000004  R14: 0000000000000006  R15: ffffffffff9c2340
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

PID: 3100   TASK: ffff880c63351c40  CPU: 8   COMMAND: "lldpd"
 #0 [ffff880c0566d9c8] __schedule at ffffffff814b7fc0
 #1 [ffff880c0566da50] schedule at ffffffff814b8eb9
 #2 [ffff880c0566da60] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c0566da70] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880c0566dae0] mutex_lock at ffffffff814b742a
 #5 [ffff880c0566db00] rtnl_lock at ffffffff81419295
 #6 [ffff880c0566db10] rtnetlink_rcv at ffffffff814192b6
 #7 [ffff880c0566db30] netlink_unicast at ffffffff8143792f
 #8 [ffff880c0566db80] netlink_sendmsg at ffffffff81437c6c
 #9 [ffff880c0566dc30] sock_sendmsg at ffffffff813f35d6
#10 [ffff880c0566dd60] ___sys_sendmsg at ffffffff813f578c
#11 [ffff880c0566df00] __sys_sendmsg at ffffffff813f6d79
#12 [ffff880c0566df70] sys_sendmsg at ffffffff813f6dd9
#13 [ffff880c0566df80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2200  RSP: 00007fff75484228  RFLAGS: 00010202
    RAX: 000000000000002e  RBX: ffffffff814c2182  RCX: 00000031c5af2083
    RDX: 0000000000000000  RSI: 00007fff75483eb0  RDI: 000000000000000e
    RBP: 0000000000000011   R8: 0000000000000004   R9: 0000000000000003
    R10: 00000000017f4b20  R11: 0000000000000246  R12: ffffffff813f6dd9
    R13: ffff880c0566df78  R14: 00000000017f38a0  R15: 0000000000000001
    ORIG_RAX: 000000000000002e  CS: 0033  SS: 002b

PID: 3101   TASK: ffff880c61f3e9f0  CPU: 0   COMMAND: "kipmi0"
 #0 [ffff880c05791d38] __schedule at ffffffff814b7fc0
 #1 [ffff880c05791dc0] schedule at ffffffff814b8eb9
 #2 [ffff880c05791dd0] schedule_timeout at ffffffff814b6cde
 #3 [ffff880c05791e60] schedule_timeout_interruptible at ffffffff814b6e1e
 #4 [ffff880c05791e70] ipmi_thread at ffffffffa07573c2 [ipmi_si]
 #5 [ffff880c05791ec0] kthread at ffffffff8105f0b0
 #6 [ffff880c05791f50] ret_from_fork at ffffffff814c20dc

PID: 3190   TASK: ffff880c62531530  CPU: 0   COMMAND: "master"
 #0 [ffff880c055dbd88] __schedule at ffffffff814b7fc0
 #1 [ffff880c055dbe10] schedule at ffffffff814b8eb9
 #2 [ffff880c055dbe20] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff880c055dbea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c055dbeb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880c055dbf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f706fbb4763  RSP: 00007fff597041a8  RFLAGS: 00000246
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000064  RSI: 00007fff59704240  RDI: 000000000000000d
    RBP: 00007f70720b0690   R8: 00007fff59704220   R9: 0000000000000001
    R10: 0000000000003e80  R11: 0000000000000246  R12: 00007f70720b19b0
    R13: 00007f70720b06cc  R14: 00000000000001f4  R15: 00007f70720b06cc
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 3193   TASK: ffff88065d1bdbd0  CPU: 2   COMMAND: "qmgr"
 #0 [ffff880659431d88] __schedule at ffffffff814b7fc0
 #1 [ffff880659431e10] schedule at ffffffff814b8eb9
 #2 [ffff880659431e20] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff880659431ea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880659431eb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880659431f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fa4d7bcd763  RSP: 00007fff6ac41d68  RFLAGS: 00000206
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000064  RSI: 00007fff6ac41930  RDI: 0000000000000008
    RBP: 00007fa4da0f19c0   R8: 0000000000000018   R9: 0101010101010101
    R10: 000000000001d4c0  R11: 0000000000000246  R12: 00007fa4d9eac090
    R13: 00007fa4d9eac210  R14: 00000000ffffffff  R15: 00007fa4da0f19f4
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 3194   TASK: ffff88065d521530  CPU: 2   COMMAND: "atd"
 #0 [ffff880661315ec8] __schedule at ffffffff814b7fc0
 #1 [ffff880661315f50] schedule at ffffffff814b8eb9
 #2 [ffff880661315f60] sys_pause at ffffffff81050614
 #3 [ffff880661315f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f3ea7ba7980  RSP: 00007fffb9c7b348  RFLAGS: 00000202
    RAX: 0000000000000022  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 00007f3ea8b05c40  RSI: 0000000000000001  RDI: 0000000000000000
    RBP: 0000000000000002   R8: 00007f3eaa216f78   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fffb9c7b648
    R13: 00007f3ea8b05c20  R14: ffffffff81050614  R15: ffff880661315f78
    ORIG_RAX: 0000000000000022  CS: 0033  SS: 002b

PID: 3201   TASK: ffff880c61f38710  CPU: 10  COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880c05727be8] __schedule at ffffffff814b7fc0
 #1 [ffff880c05727c70] schedule at ffffffff814b8eb9
 #2 [ffff880c05727c80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff880c05727cd0] futex_wait at ffffffff8107f809
 #4 [ffff880c05727e00] do_futex at ffffffff81081564
 #5 [ffff880c05727ef0] sys_futex at ffffffff81081e87
 #6 [ffff880c05727f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620bae5  RSP: 00007fffa0442660  RFLAGS: 00000246
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000001  RSI: 0000000000000080  RDI: 0000000002454424
    RBP: 0000000002454450   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fffa0442e20
    R13: 00000031c94f45a0  R14: 0000000000000000  R15: 00000000ffffffff
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 3202   TASK: ffff880c633562e0  CPU: 12  COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880c5cdb9be8] __schedule at ffffffff814b7fc0
 #1 [ffff880c5cdb9c70] schedule at ffffffff814b8eb9
 #2 [ffff880c5cdb9c80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff880c5cdb9cd0] futex_wait at ffffffff8107f809
 #4 [ffff880c5cdb9e00] do_futex at ffffffff81081564
 #5 [ffff880c5cdb9ef0] sys_futex at ffffffff81081e87
 #6 [ffff880c5cdb9f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620bae5  RSP: 00007f263e580b18  RFLAGS: 00010246
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 0000000000000080  RDI: 00007f2638003964
    RBP: 00007f2638003990   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00000000fffffffc
    R13: 00007f263e580be0  R14: 0000000000000000  R15: 00000000ffffffff
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 3204   TASK: ffff880c632ec6a0  CPU: 14  COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880c057f9be8] __schedule at ffffffff814b7fc0
 #1 [ffff880c057f9c70] schedule at ffffffff814b8eb9
 #2 [ffff880c057f9c80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff880c057f9cd0] futex_wait at ffffffff8107f809
 #4 [ffff880c057f9e00] do_futex at ffffffff81081564
 #5 [ffff880c057f9ef0] sys_futex at ffffffff81081e87
 #6 [ffff880c057f9f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620bae5  RSP: 00007f263d57e920  RFLAGS: 00010202
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: 0000000000000960
    RDX: 0000000000000001  RSI: 0000000000000080  RDI: 0000000002452104
    RBP: 00007f263d57edc0   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f263d57edc0
    R13: 00000000024521b0  R14: 00007f263d57ed30  R15: 00007f263d57eda0
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 3207   TASK: ffff880c632e9c40  CPU: 2   COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880c057ff898] __schedule at ffffffff814b7fc0
 #1 [ffff880c057ff920] schedule at ffffffff814b8eb9
 #2 [ffff880c057ff930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c057ff9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c057ff9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c057ff9f0] do_select at ffffffff8114a899
 #6 [ffff880c057ffd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c057fff10] sys_select at ffffffff8114ad71
 #8 [ffff880c057fff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f263cd7dc18  RFLAGS: 00000202
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00007f263cd7db20  RDI: 0000000000000400
    RBP: 00007f2638003250   R8: 0000000000000000   R9: 0000000000000c87
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f263cd7dce8
    R13: 00007f263cd7dce0  R14: 00007f263cd7ddc0  R15: 00007f263cd7dba0
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3208   TASK: ffff880c632e8000  CPU: 14  COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880c05001be8] __schedule at ffffffff814b7fc0
 #1 [ffff880c05001c70] schedule at ffffffff814b8eb9
 #2 [ffff880c05001c80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff880c05001cd0] futex_wait at ffffffff8107f809
 #4 [ffff880c05001e00] do_futex at ffffffff81081564
 #5 [ffff880c05001ef0] sys_futex at ffffffff81081e87
 #6 [ffff880c05001f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620bae5  RSP: 00007f2637ffefb0  RFLAGS: 00000202
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000001  RSI: 0000000000000080  RDI: 0000000002454484
    RBP: 00000000024544b0   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000003
    R13: 0000000000000000  R14: 0000000000000000  R15: 00000000ffffffff
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 3209   TASK: ffff880c632ee9f0  CPU: 14  COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880c05003be8] __schedule at ffffffff814b7fc0
 #1 [ffff880c05003c70] schedule at ffffffff814b8eb9
 #2 [ffff880c05003c80] futex_wait_queue_me at ffffffff8107ed54
 #3 [ffff880c05003cd0] futex_wait at ffffffff8107f809
 #4 [ffff880c05003e00] do_futex at ffffffff81081564
 #5 [ffff880c05003ef0] sys_futex at ffffffff81081e87
 #6 [ffff880c05003f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620bae5  RSP: 00007f26377fdfb0  RFLAGS: 00000202
    RAX: 00000000000000ca  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000001  RSI: 0000000000000080  RDI: 00000000024544e4
    RBP: 0000000002454510   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000003
    R13: 0000000000000000  R14: 0000000000000000  R15: 00000000ffffffff
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

PID: 3210   TASK: ffff880c61f3e2e0  CPU: 1   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c05007d18] __schedule at ffffffff814b7fc0
 #1 [ffff880c05007da0] schedule at ffffffff814b8eb9
 #2 [ffff880c05007db0] schedule_timeout at ffffffff814b6d65
 #3 [ffff880c05007e40] schedule_timeout_interruptible at ffffffff814b6e1e
 #4 [ffff880c05007e50] do_sigtimedwait at ffffffff8104f98b
 #5 [ffff880c05007ea0] SYSC_rt_sigtimedwait at ffffffff8104fa73
 #6 [ffff880c05007f70] sys_rt_sigtimedwait at ffffffff8104fade
 #7 [ffff880c05007f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620f247  RSP: 00007fff4ff70ec8  RFLAGS: 00000246
    RAX: 0000000000000080  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 00007fff4ff71030
    RBP: 0000000000c745c0   R8: 00007fff4ff71030   R9: 0000000000000080
    R10: 0000000000000008  R11: 0000000000000246  R12: ffffffff8104fade
    R13: ffff880c05007f78  R14: 00007fff4ff70f18  R15: 00007fff4ff71030
    ORIG_RAX: 0000000000000080  CS: 0033  SS: 002b

PID: 3223   TASK: ffff880c61f3f810  CPU: 10  COMMAND: "kworker/10:1H"
 #0 [ffff880c0503fdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c0503fe40] schedule at ffffffff814b8eb9
 #2 [ffff880c0503fe50] worker_thread at ffffffff81058daf
 #3 [ffff880c0503fec0] kthread at ffffffff8105f0b0
 #4 [ffff880c0503ff50] ret_from_fork at ffffffff814c20dc

PID: 3224   TASK: ffff88065d1bbf90  CPU: 7   COMMAND: "dsm_om_shrsvcd"
 #0 [ffff880661765898] __schedule at ffffffff814b7fc0
 #1 [ffff880661765920] schedule at ffffffff814b8eb9
 #2 [ffff880661765930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff8806617659b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff8806617659c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff8806617659f0] do_select at ffffffff8114a899
 #6 [ffff880661765d70] core_sys_select at ffffffff8114ab72
 #7 [ffff880661765f10] sys_select at ffffffff8114ad71
 #8 [ffff880661765f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f2636ffc1a0  RFLAGS: 00010246
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000078
    RDX: 0000000000000000  RSI: 00007f2636ffc980  RDI: 0000000000000400
    RBP: 00007f262c000920   R8: 0000000000000000   R9: 0000000000000020
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f2636ffcb48
    R13: 00007f2636ffcb40  R14: 00007f2636ffcdb0  R15: 00007f2636ffca00
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3507   TASK: ffff880c61b562e0  CPU: 8   COMMAND: "udevd"
 #0 [ffff880c0572bd88] __schedule at ffffffff814b7fc0
 #1 [ffff880c0572be10] schedule at ffffffff814b8eb9
 #2 [ffff880c0572be20] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c0572bea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c0572beb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff880c0572bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f0970176763  RSP: 00007fffe9091708  RFLAGS: 00010246
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: fffffffffffffef0
    RDX: 0000000000000004  RSI: 00007fffe90917b8  RDI: 0000000000000004
    RBP: 00007f097139eed0   R8: 0000000000000000   R9: 0000000000000001
    R10: 00000000ffffffff  R11: 0000000000000246  R12: 000000000000000c
    R13: 0000000000000000  R14: 00007f097139ea30  R15: 00007f09713a1440
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 3530   TASK: ffff880c61f3b170  CPU: 2   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c622b1c58] __schedule at ffffffff814b7fc0
 #1 [ffff880c622b1ce0] schedule at ffffffff814b8eb9
 #2 [ffff880c622b1cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff880c622b1f60] sys_semtimedop at ffffffff812274be
 #4 [ffff880c622b1f70] sys_semop at ffffffff812274d0
 #5 [ffff880c622b1f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f1923139958  RFLAGS: 00000217
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: 0000000000000001
    RDX: 0000000000000001  RSI: 00007f192313ce10  RDI: 0000000000710005
    RBP: 00007f192313ce10   R8: 00007f18f0000078   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff880c622b1f78  R14: ffffffff812274be  R15: ffff880c622b1f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3531   TASK: ffff880c61cb2a60  CPU: 0   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c622b3c58] __schedule at ffffffff814b7fc0
 #1 [ffff880c622b3ce0] schedule at ffffffff814b8eb9
 #2 [ffff880c622b3cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff880c622b3f60] sys_semtimedop at ffffffff812274be
 #4 [ffff880c622b3f70] sys_semop at ffffffff812274d0
 #5 [ffff880c622b3f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f192293bac0  RFLAGS: 00000246
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: 00007f192293bb2c
    RDX: 0000000000000001  RSI: 00007f192293bd90  RDI: 00000000006f8007
    RBP: 00007f192293bd90   R8: 00007f1914000ba0   R9: 0000000000000dcb
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff880c622b3f78  R14: ffffffff812274be  R15: ffff880c622b3f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3532   TASK: ffff880c62423170  CPU: 7   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c62545bd8] __schedule at ffffffff814b7fc0
 #1 [ffff880c62545c60] schedule at ffffffff814b8eb9
 #2 [ffff880c62545c70] schedule_timeout at ffffffff814b6cde
 #3 [ffff880c62545d00] SYSC_semtimedop at ffffffff81226411
 #4 [ffff880c62545f70] sys_semtimedop at ffffffff812274be
 #5 [ffff880c62545f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2d8a  RSP: 00007f192213ae08  RFLAGS: 00000246
    RAX: 00000000000000dc  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 00007f192213ae20  RDI: 00000000006f0006
    RBP: 00007f192213ae20   R8: 0000000000000001   R9: 0000000000000dcc
    R10: 00007f192213ae10  R11: 0000000000000202  R12: ffffffff812274be
    R13: ffff880c62545f78  R14: 20c49ba5e353f7cf  R15: 00007f192213aeac
    ORIG_RAX: 00000000000000dc  CS: 0033  SS: 002b

PID: 3537   TASK: ffff880c61f3cdb0  CPU: 15  COMMAND: "login"
 #0 [ffff880c056a9dd8] __schedule at ffffffff814b7fc0
 #1 [ffff880c056a9e60] schedule at ffffffff814b8eb9
 #2 [ffff880c056a9e70] do_wait at ffffffff810403b4
 #3 [ffff880c056a9ee0] sys_wait4 at ffffffff810412a3
 #4 [ffff880c056a9f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd574  RSP: 00007fff33ffb010  RFLAGS: 00010206
    RAX: 000000000000003d  RBX: ffffffff814c2182  RCX: 00000031c5ae4380
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: ffffffffffffffff
    RBP: 00007fff33ffb100   R8: 0000000000000000   R9: 00007fe9d879a7c0
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fff33ffb428
    R13: 0000000000000000  R14: 0000000000000008  R15: 0000000000000000
    ORIG_RAX: 000000000000003d  CS: 0033  SS: 002b

PID: 3538   TASK: ffff88066274a350  CPU: 1   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff88065d021c58] __schedule at ffffffff814b7fc0
 #1 [ffff88065d021ce0] schedule at ffffffff814b8eb9
 #2 [ffff88065d021cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff88065d021f60] sys_semtimedop at ffffffff812274be
 #4 [ffff88065d021f70] sys_semop at ffffffff812274d0
 #5 [ffff88065d021f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f192019de50  RFLAGS: 00000293
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000001  RSI: 00007f192019de40  RDI: 0000000000758011
    RBP: 00007f192019de40   R8: 0000000000c70b70   R9: 0000000000000dd2
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff88065d021f78  R14: ffffffff812274be  R15: ffff88065d021f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3539   TASK: ffff880662748e20  CPU: 4   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff88065d4d3898] __schedule at ffffffff814b7fc0
 #1 [ffff88065d4d3920] schedule at ffffffff814b8eb9
 #2 [ffff88065d4d3930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff88065d4d39b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff88065d4d39c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff88065d4d39f0] do_select at ffffffff8114a899
 #6 [ffff88065d4d3d70] core_sys_select at ffffffff8114ab72
 #7 [ffff88065d4d3f10] sys_select at ffffffff8114ad71
 #8 [ffff88065d4d3f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f192017cd38  RFLAGS: 00000206
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00007f192017cdb0  RDI: 0000000000000013
    RBP: 00007f1924eee538   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000000000003
    R13: 0000000000000000  R14: 0000000000040000  R15: 00007f192017cea8
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3540   TASK: ffff88066274b170  CPU: 3   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff8806613e1c58] __schedule at ffffffff814b7fc0
 #1 [ffff8806613e1ce0] schedule at ffffffff814b8eb9
 #2 [ffff8806613e1cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff8806613e1f60] sys_semtimedop at ffffffff812274be
 #4 [ffff8806613e1f70] sys_semop at ffffffff812274d0
 #5 [ffff8806613e1f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f192015bde8  RFLAGS: 00000246
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: 00007f1910000038
    RDX: 0000000000000001  RSI: 00007f192015be10  RDI: 000000000074800f
    RBP: 00007f192015be10   R8: 0000000000c70530   R9: 0000000000000dd4
    R10: 00007f1924a98e70  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff8806613e1f78  R14: ffffffff812274be  R15: ffff8806613e1f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3541   TASK: ffff88066274f810  CPU: 6   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880663b81df8] __schedule at ffffffff814b7fc0
 #1 [ffff880663b81e80] schedule at ffffffff814b8eb9
 #2 [ffff880663b81e90] do_nanosleep at ffffffff814b76ec
 #3 [ffff880663b81ed0] hrtimer_nanosleep at ffffffff81063090
 #4 [ffff880663b81f50] sys_nanosleep at ffffffff810631b6
 #5 [ffff880663b81f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd9fd  RSP: 00007f192013aca8  RFLAGS: 00000202
    RAX: 0000000000000023  RBX: ffffffff814c2182  RCX: 0000000000000003
    RDX: 00000000000f4240  RSI: 0000000000000000  RDI: 00007f192013ae90
    RBP: 0000000000000000   R8: 0000000000918be0   R9: 0000000000000dd5
    R10: 0000000000000000  R11: 0000000000000293  R12: 00007fff4ff70e70
    R13: 0000000000a38240  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 0000000000000023  CS: 0033  SS: 002b

PID: 3542   TASK: ffff880662748710  CPU: 10  COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880659435c58] __schedule at ffffffff814b7fc0
 #1 [ffff880659435ce0] schedule at ffffffff814b8eb9
 #2 [ffff880659435cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff880659435f60] sys_semtimedop at ffffffff812274be
 #4 [ffff880659435f70] sys_semop at ffffffff812274d0
 #5 [ffff880659435f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f1920119ff0  RFLAGS: 00000206
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000001  RSI: 00007f1920119e70  RDI: 0000000000698001
    RBP: 0000000000000000   R8: 0000000000918be0   R9: 0000000000000dd6
    R10: 00007f1920119c00  R11: 0000000000000202  R12: ffffffff812274d0
    R13: ffff880659435f78  R14: ffffffff812274be  R15: ffff880659435f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3544   TASK: ffff88066274dbd0  CPU: 6   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880662c4d898] __schedule at ffffffff814b7fc0
 #1 [ffff880662c4d920] schedule at ffffffff814b8eb9
 #2 [ffff880662c4d930] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff880662c4d9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880662c4d9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880662c4d9f0] do_select at ffffffff8114a899
 #6 [ffff880662c4dd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880662c4df10] sys_select at ffffffff8114ad71
 #8 [ffff880662c4df80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f19200f8e10  RFLAGS: 00000246
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 00000031c5aea643
    RDX: 0000000000000000  RSI: 00007f19200f8e10  RDI: 0000000000000005
    RBP: 00007f19200f8e90   R8: 00007f19200f8e90   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000293  R12: 00007f19200f8eaf
    R13: 0000000000000010  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3545   TASK: ffff880c61cb7100  CPU: 2   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c050d5c58] __schedule at ffffffff814b7fc0
 #1 [ffff880c050d5ce0] schedule at ffffffff814b8eb9
 #2 [ffff880c050d5cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff880c050d5f60] sys_semtimedop at ffffffff812274be
 #4 [ffff880c050d5f70] sys_semop at ffffffff812274d0
 #5 [ffff880c050d5f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f191b7fde18  RFLAGS: 00010202
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: 00007f191b7fdd9f
    RDX: 0000000000000001  RSI: 00007f191b7fddb0  RDI: 00000000006a0002
    RBP: 00007f191b7fddb0   R8: 0000000000c70530   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff880c050d5f78  R14: ffffffff812274be  R15: ffff880c050d5f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3547   TASK: ffff880662a1d4c0  CPU: 1   COMMAND: "dsm_sa_eventmgr"
 #0 [ffff8806615f7d18] __schedule at ffffffff814b7fc0
 #1 [ffff8806615f7da0] schedule at ffffffff814b8eb9
 #2 [ffff8806615f7db0] schedule_timeout at ffffffff814b6d65
 #3 [ffff8806615f7e40] schedule_timeout_interruptible at ffffffff814b6e1e
 #4 [ffff8806615f7e50] do_sigtimedwait at ffffffff8104f98b
 #5 [ffff8806615f7ea0] SYSC_rt_sigtimedwait at ffffffff8104fa73
 #6 [ffff8806615f7f70] sys_rt_sigtimedwait at ffffffff8104fade
 #7 [ffff8806615f7f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620f247  RSP: 00007fff06877ee8  RFLAGS: 00010206
    RAX: 0000000000000080  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 00007fff06878020
    RBP: 00000000025c1120   R8: 00007fff06878020   R9: 0000000000000080
    R10: 0000000000000008  R11: 0000000000000246  R12: ffffffff8104fade
    R13: ffff8806615f7f78  R14: 00007fff06877f08  R15: 00007fff06878020
    ORIG_RAX: 0000000000000080  CS: 0033  SS: 002b

PID: 3548   TASK: ffff880c61c61530  CPU: 6   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c056ff898] __schedule at ffffffff814b7fc0
 #1 [ffff880c056ff920] schedule at ffffffff814b8eb9
 #2 [ffff880c056ff930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c056ff9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c056ff9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c056ff9f0] do_select at ffffffff8114a899
 #6 [ffff880c056ffd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c056fff10] sys_select at ffffffff8114ad71
 #8 [ffff880c056fff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f19200d7d68  RFLAGS: 00010283
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 00007f19200d7dd0  RDI: 0000000000000015
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000ddc
    R10: 0000000000000000  R11: 0000000000000293  R12: 00007f1908000958
    R13: 00007f19200d7dd0  R14: 00000000ffffffff  R15: 00007f19080008c0
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3549   TASK: ffff8806614462e0  CPU: 5   COMMAND: "dsm_sa_eventmgr"
 #0 [ffff880662c4b898] __schedule at ffffffff814b7fc0
 #1 [ffff880662c4b920] schedule at ffffffff814b8eb9
 #2 [ffff880662c4b930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880662c4b9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880662c4b9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880662c4b9f0] do_select at ffffffff8114a899
 #6 [ffff880662c4bd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880662c4bf10] sys_select at ffffffff8114ad71
 #8 [ffff880662c4bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f2171ac0e68  RFLAGS: 00010287
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 00007f2164000038
    RDX: 0000000000000000  RSI: 00007f2171ac0dd0  RDI: 0000000000000006
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000ddd
    R10: 0000000000000000  R11: 0000000000000293  R12: 00000000025c1468
    R13: 00007f2171ac0dd0  R14: 00000000ffffffff  R15: 00000000025bfc90
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3550   TASK: ffff88065d520000  CPU: 6   COMMAND: "dsm_sa_eventmgr"
 #0 [ffff880662c43c58] __schedule at ffffffff814b7fc0
 #1 [ffff880662c43ce0] schedule at ffffffff814b8eb9
 #2 [ffff880662c43cf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff880662c43f60] sys_semtimedop at ffffffff812274be
 #4 [ffff880662c43f70] sys_semop at ffffffff812274d0
 #5 [ffff880662c43f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f2171a9fdc0  RFLAGS: 00000246
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: 00007f2164000038
    RDX: 0000000000000001  RSI: 00007f2171a9fd60  RDI: 0000000000770014
    RBP: 00007f2171a9fd60   R8: 00000000025bfbb0   R9: 0000000000000dde
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff880662c43f78  R14: ffffffff812274be  R15: ffff880662c43f68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3552   TASK: ffff880662a1e9f0  CPU: 2   COMMAND: "dsm_sa_snmpd"
 #0 [ffff88065d63bd18] __schedule at ffffffff814b7fc0
 #1 [ffff88065d63bda0] schedule at ffffffff814b8eb9
 #2 [ffff88065d63bdb0] schedule_timeout at ffffffff814b6d65
 #3 [ffff88065d63be40] schedule_timeout_interruptible at ffffffff814b6e1e
 #4 [ffff88065d63be50] do_sigtimedwait at ffffffff8104f98b
 #5 [ffff88065d63bea0] SYSC_rt_sigtimedwait at ffffffff8104fa73
 #6 [ffff88065d63bf70] sys_rt_sigtimedwait at ffffffff8104fade
 #7 [ffff88065d63bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c620f247  RSP: 00007fff2b12f638  RFLAGS: 00010202
    RAX: 0000000000000080  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 00007fff2b12f770
    RBP: 0000000001a54460   R8: 00007fff2b12f770   R9: 0000000000000080
    R10: 0000000000000008  R11: 0000000000000246  R12: ffffffff8104fade
    R13: ffff88065d63bf78  R14: 00007fff2b12f658  R15: 00007fff2b12f770
    ORIG_RAX: 0000000000000080  CS: 0033  SS: 002b

PID: 3553   TASK: ffff880c61f3b880  CPU: 5   COMMAND: "dsm_sa_snmpd"
 #0 [ffff880c05537898] __schedule at ffffffff814b7fc0
 #1 [ffff880c05537920] schedule at ffffffff814b8eb9
 #2 [ffff880c05537930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c055379b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c055379c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c055379f0] do_select at ffffffff8114a899
 #6 [ffff880c05537d70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c05537f10] sys_select at ffffffff8114ad71
 #8 [ffff880c05537f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f903b305ca8  RFLAGS: 00010287
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 00007f9028000040
    RDX: 0000000000000000  RSI: 00007f903b305de0  RDI: 0000000000000006
    RBP: 0000000000613ae8   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000000000000
    R13: 0000000000000001  R14: 00007f903b305e60  R15: 0000000000613ae2
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3554   TASK: ffff880c61f38000  CPU: 2   COMMAND: "dsm_sa_snmpd"
 #0 [ffff880c61893bd8] __schedule at ffffffff814b7fc0
 #1 [ffff880c61893c60] schedule at ffffffff814b8eb9
 #2 [ffff880c61893c70] schedule_timeout at ffffffff814b6cde
 #3 [ffff880c61893d00] SYSC_semtimedop at ffffffff81226411
 #4 [ffff880c61893f70] sys_semtimedop at ffffffff812274be
 #5 [ffff880c61893f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2d8a  RSP: 00007f903b2e4e48  RFLAGS: 00000246
    RAX: 00000000000000dc  RBX: ffffffff814c2182  RCX: 000000000000003c
    RDX: 0000000000000001  RSI: 00007f903b2e4e00  RDI: 0000000000780016
    RBP: 00007f903b2e4e00   R8: 0000000000000001   R9: 0000000000000001
    R10: 00007f903b2e4df0  R11: 0000000000000202  R12: ffffffff812274be
    R13: ffff880c61893f78  R14: 20c49ba5e353f7cf  R15: 00007f903ce01ecc
    ORIG_RAX: 00000000000000dc  CS: 0033  SS: 002b

PID: 3555   TASK: ffff880c61f3f100  CPU: 14  COMMAND: "dsm_sa_snmpd"
 #0 [ffff880c618efdf8] __schedule at ffffffff814b7fc0
 #1 [ffff880c618efe80] schedule at ffffffff814b8eb9
 #2 [ffff880c618efe90] do_nanosleep at ffffffff814b76ec
 #3 [ffff880c618efed0] hrtimer_nanosleep at ffffffff81063090
 #4 [ffff880c618eff50] sys_nanosleep at ffffffff810631b6
 #5 [ffff880c618eff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd9fd  RSP: 00007f903b2c2be8  RFLAGS: 00010287
    RAX: 0000000000000023  RBX: ffffffff814c2182  RCX: 00000031c5af2d5a
    RDX: 00000000000f4240  RSI: 0000000000000000  RDI: 00007f903b2c3c70
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000de3
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000000000000
    R13: 0000000000000936  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 0000000000000023  CS: 0033  SS: 002b

PID: 3556   TASK: ffff880c61c60e20  CPU: 0   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c055ef898] __schedule at ffffffff814b7fc0
 #1 [ffff880c055ef920] schedule at ffffffff814b8eb9
 #2 [ffff880c055ef930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c055ef9b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c055ef9c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c055ef9f0] do_select at ffffffff8114a899
 #6 [ffff880c055efd70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c055eff10] sys_select at ffffffff8114ad71
 #8 [ffff880c055eff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f19200b6d68  RFLAGS: 00010206
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 00007f19200b6dd0  RDI: 0000000000000016
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000de4
    R10: 0000000000000000  R11: 0000000000000293  R12: 00007f1908002c38
    R13: 00007f19200b6dd0  R14: 00000000ffffffff  R15: 00007f1908002ba0
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3557   TASK: ffff880c61f3d4c0  CPU: 2   COMMAND: "dsm_sa_snmpd"
 #0 [ffff880c61839898] __schedule at ffffffff814b7fc0
 #1 [ffff880c61839920] schedule at ffffffff814b8eb9
 #2 [ffff880c61839930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c618399b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c618399c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c618399f0] do_select at ffffffff8114a899
 #6 [ffff880c61839d70] core_sys_select at ffffffff8114ab72
 #7 [ffff880c61839f10] sys_select at ffffffff8114ad71
 #8 [ffff880c61839f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea643  RSP: 00007f903b2a2e78  RFLAGS: 00010287
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: 0000000000000030
    RDX: 0000000000000000  RSI: 00007f903b2a2dd0  RDI: 000000000000000a
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000de5
    R10: 0000000000000000  R11: 0000000000000293  R12: 0000000001a4ff58
    R13: 00007f903b2a2dd0  R14: 00000000ffffffff  R15: 0000000001a4fe40
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 3558   TASK: ffff880c61f38e20  CPU: 9   COMMAND: "dsm_sa_snmpd"
 #0 [ffff880c050bfc58] __schedule at ffffffff814b7fc0
 #1 [ffff880c050bfce0] schedule at ffffffff814b8eb9
 #2 [ffff880c050bfcf0] SYSC_semtimedop at ffffffff812265d5
 #3 [ffff880c050bff60] sys_semtimedop at ffffffff812274be
 #4 [ffff880c050bff70] sys_semop at ffffffff812274d0
 #5 [ffff880c050bff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5af2cf7  RSP: 00007f903b281e10  RFLAGS: 00000202
    RAX: 0000000000000041  RBX: ffffffff814c2182  RCX: 00000000fffff803
    RDX: 0000000000000001  RSI: 00007f903b281d60  RDI: 00000000007b001c
    RBP: 00007f903b281d60   R8: 0000000001a4fd60   R9: 0000000000000de6
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff812274d0
    R13: ffff880c050bff78  R14: ffffffff812274be  R15: ffff880c050bff68
    ORIG_RAX: 0000000000000041  CS: 0033  SS: 002b

PID: 3559   TASK: ffff880c62423880  CPU: 0   COMMAND: "dsm_sa_datamgrd"
 #0 [ffff880c633a79d8] __schedule at ffffffff814b7fc0
 #1 [ffff880c633a7a60] schedule at ffffffff814b8eb9
 #2 [ffff880c633a7a70] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff880c633a7af0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff880c633a7b00] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff880c633a7b30] do_sys_poll at ffffffff8114b3df
 #6 [ffff880c633a7f40] sys_poll at ffffffff8114b57b
 #7 [ffff880c633a7f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae8803  RSP: 00007f191affc4e8  RFLAGS: 00010206
    RAX: 0000000000000007  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: ffffffffffffffff  RSI: 0000000000000001  RDI: 00007f1914001da8
    RBP: 0000000000000000   R8: 0000000000000000   R9: 6e69737365636f72
    R10: 6569727465522067  R11: 0000000000000293  R12: 00007f191affd9c0
    R13: 00000031c6211040  R14: 0000000000000001  R15: 0000000000000001
    ORIG_RAX: 0000000000000007  CS: 0033  SS: 002b

PID: 4280   TASK: ffff88082394dbd0  CPU: 12  COMMAND: "kworker/12:1"
 #0 [ffff880a0868ddb8] __schedule at ffffffff814b7fc0
 #1 [ffff880a0868de40] schedule at ffffffff814b8eb9
 #2 [ffff880a0868de50] worker_thread at ffffffff81058daf
 #3 [ffff880a0868dec0] kthread at ffffffff8105f0b0
 #4 [ffff880a0868df50] ret_from_fork at ffffffff814c20dc

PID: 4898   TASK: ffff880663b4c6a0  CPU: 2   COMMAND: "polkitd"
 #0 [ffff88063e71f9d8] __schedule at ffffffff814b7fc0
 #1 [ffff88063e71fa60] schedule at ffffffff814b8eb9
 #2 [ffff88063e71fa70] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff88063e71faf0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff88063e71fb00] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff88063e71fb30] do_sys_poll at ffffffff8114b3df
 #6 [ffff88063e71ff40] sys_poll at ffffffff8114b57b
 #7 [ffff88063e71ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae8803  RSP: 00007fffe336d978  RFLAGS: 00010202
    RAX: 0000000000000007  RBX: ffffffff814c2182  RCX: 00000031c5db1708
    RDX: 0000000000000f9c  RSI: 0000000000000003  RDI: 0000000000e05770
    RBP: 0000000000e05770   R8: 0000000000000000   R9: 0000000000001322
    R10: 0000000000000001  R11: 0000000000000293  R12: 00000031c8120020
    R13: 00000031c7e53860  R14: 0000000000dffd20  R15: 0000000000000000
    ORIG_RAX: 0000000000000007  CS: 0033  SS: 002b

PID: 4900   TASK: ffff880663b4aa60  CPU: 3   COMMAND: "polkitd"
 #0 [ffff88063e73f9d8] __schedule at ffffffff814b7fc0
 #1 [ffff88063e73fa60] schedule at ffffffff814b8eb9
 #2 [ffff88063e73fa70] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff88063e73faf0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff88063e73fb00] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff88063e73fb30] do_sys_poll at ffffffff8114b3df
 #6 [ffff88063e73ff40] sys_poll at ffffffff8114b57b
 #7 [ffff88063e73ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae8803  RSP: 00007f3cbfffec00  RFLAGS: 00000293
    RAX: 0000000000000007  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: ffffffffffffffff  RSI: 0000000000000003  RDI: 00007f3cb8001110
    RBP: 00007f3cb8001110   R8: 0000000000000000   R9: 0000000000001324
    R10: 0000000000000001  R11: 0000000000000293  R12: 00000031c8120020
    R13: 00000031c7e53860  R14: 00007f3cc000bf70  R15: 0000000000dffd20
    ORIG_RAX: 0000000000000007  CS: 0033  SS: 002b

PID: 5832   TASK: ffff880651f2cdb0  CPU: 5   COMMAND: "kworker/5:1"
 #0 [ffff880530cd1db8] __schedule at ffffffff814b7fc0
 #1 [ffff880530cd1e40] schedule at ffffffff814b8eb9
 #2 [ffff880530cd1e50] worker_thread at ffffffff81058daf
 #3 [ffff880530cd1ec0] kthread at ffffffff8105f0b0
 #4 [ffff880530cd1f50] ret_from_fork at ffffffff814c20dc

PID: 6839   TASK: ffff880654770e20  CPU: 5   COMMAND: "kworker/5:0"
 #0 [ffff88062d58bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff88062d58be40] schedule at ffffffff814b8eb9
 #2 [ffff88062d58be50] worker_thread at ffffffff81058daf
 #3 [ffff88062d58bec0] kthread at ffffffff8105f0b0
 #4 [ffff88062d58bf50] ret_from_fork at ffffffff814c20dc

PID: 7021   TASK: ffff880c61c65bd0  CPU: 8   COMMAND: "kworker/8:1"
 #0 [ffff880979537db8] __schedule at ffffffff814b7fc0
 #1 [ffff880979537e40] schedule at ffffffff814b8eb9
 #2 [ffff880979537e50] worker_thread at ffffffff81058daf
 #3 [ffff880979537ec0] kthread at ffffffff8105f0b0
 #4 [ffff880979537f50] ret_from_fork at ffffffff814c20dc

PID: 7848   TASK: ffff8809f45aaa60  CPU: 12  COMMAND: "kworker/12:2"
 #0 [ffff880b6e62fc78] __schedule at ffffffff814b7fc0
 #1 [ffff880b6e62fd00] schedule at ffffffff814b8eb9
 #2 [ffff880b6e62fd10] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880b6e62fd20] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880b6e62fd90] mutex_lock at ffffffff814b742a
 #5 [ffff880b6e62fdb0] cgroup_free_fn at ffffffff810930ec
 #6 [ffff880b6e62fdf0] process_one_work at ffffffff81057c54
 #7 [ffff880b6e62fe50] worker_thread at ffffffff81058d0c
 #8 [ffff880b6e62fec0] kthread at ffffffff8105f0b0
 #9 [ffff880b6e62ff50] ret_from_fork at ffffffff814c20dc

PID: 7896   TASK: ffff880c61c60000  CPU: 2   COMMAND: "kworker/2:1"
 #0 [ffff8809f44bddb8] __schedule at ffffffff814b7fc0
 #1 [ffff8809f44bde40] schedule at ffffffff814b8eb9
 #2 [ffff8809f44bde50] worker_thread at ffffffff81058daf
 #3 [ffff8809f44bdec0] kthread at ffffffff8105f0b0
 #4 [ffff8809f44bdf50] ret_from_fork at ffffffff814c20dc

PID: 8761   TASK: ffff8808246df810  CPU: 6   COMMAND: "kworker/6:1"
 #0 [ffff880a0437bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880a0437be40] schedule at ffffffff814b8eb9
 #2 [ffff880a0437be50] worker_thread at ffffffff81058daf
 #3 [ffff880a0437bec0] kthread at ffffffff8105f0b0
 #4 [ffff880a0437bf50] ret_from_fork at ffffffff814c20dc

PID: 10025  TASK: ffff880c63354db0  CPU: 0   COMMAND: "kworker/0:2"
 #0 [ffff880be4c9fdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880be4c9fe40] schedule at ffffffff814b8eb9
 #2 [ffff880be4c9fe50] worker_thread at ffffffff81058daf
 #3 [ffff880be4c9fec0] kthread at ffffffff8105f0b0
 #4 [ffff880be4c9ff50] ret_from_fork at ffffffff814c20dc

PID: 10334  TASK: ffff88065d1be9f0  CPU: 4   COMMAND: "python"
 #0 [ffff880c7fc86e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880c7fc86e70] nmi_handle at ffffffff814baea9
 #2 [ffff880c7fc86ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880c7fc86ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: _raw_read_lock+12]
    RIP: ffffffff814b9a9c  RSP: ffff8805b07a5cd8  RFLAGS: 00000216
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000216
    RDX: ffff8805b07a5cd8  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff814b9a9c   R8: ffffffff814b9a9c   R9: 0000000000000018
    R10: ffff8805b07a5cd8  R11: 0000000000000216  R12: ffffffffffffffff
    R13: ffffffff81a41800  R14: ffff880663850000  R15: ffff880c5cf42440
    ORIG_RAX: ffff880c5cf42440  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff8805b07a5cd8] _raw_read_lock at ffffffff814b9a9c
 #5 [ffff8805b07a5ce0] task_cgroup_from_root at ffffffff810909d9
 #6 [ffff8805b07a5d00] cgroup_attach_task at ffffffff8109253c
 #7 [ffff8805b07a5df0] attach_task_by_pid at ffffffff81092e87
 #8 [ffff8805b07a5e40] cgroup_tasks_write at ffffffff81092ef3
 #9 [ffff8805b07a5e50] cgroup_file_write at ffffffff8108fe13
#10 [ffff8805b07a5ef0] vfs_write at ffffffff8113820e
#11 [ffff8805b07a5f30] sys_write at ffffffff811386f2
#12 [ffff8805b07a5f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae4440  RSP: 00007fff4ae79d50  RFLAGS: 00010246
    RAX: 0000000000000001  RBX: ffffffff814c2182  RCX: 0000000000000004
    RDX: 0000000000000005  RSI: 00007f8879545000  RDI: 0000000000000003
    RBP: 00007f8879545000   R8: 00007f8879523700   R9: 0000000000000000
    R10: 00000000ffffffff  R11: 0000000000000246  R12: 0000000000b06dc0
    R13: 0000000000000005  R14: 0000000000b06dc0  R15: 0000000000000005
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

PID: 10690  TASK: ffff880c61e7cdb0  CPU: 10  COMMAND: "mkdir"
 #0 [ffff880b09a51d08] __schedule at ffffffff814b7fc0
 #1 [ffff880b09a51d90] schedule at ffffffff814b8eb9
 #2 [ffff880b09a51da0] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880b09a51db0] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880b09a51e20] mutex_lock at ffffffff814b742a
 #5 [ffff880b09a51e40] cgroup_lock_live_group at ffffffff8108fa6d
 #6 [ffff880b09a51e60] cgroup_mkdir at ffffffff810946c8
 #7 [ffff880b09a51ee0] vfs_mkdir at ffffffff81145ea4
 #8 [ffff880b09a51f10] sys_mkdirat at ffffffff8114791e
 #9 [ffff880b09a51f70] sys_mkdir at ffffffff811479b9
#10 [ffff880b09a51f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae4187  RSP: 00007fff5a396930  RFLAGS: 00010216
    RAX: 0000000000000053  RBX: ffffffff814c2182  RCX: 00007fff5a396af0
    RDX: 00000000000001ff  RSI: 00000000000001ff  RDI: 00007fff5a3987f3
    RBP: 00007fff5a396a90   R8: 0000000000000001   R9: 0000000000401d50
    R10: 00000031c5a89c70  R11: 0000000000000206  R12: ffffffff811479b9
    R13: ffff880b09a51f78  R14: 0000000000000001  R15: 00000000000001ff
    ORIG_RAX: 0000000000000053  CS: 0033  SS: 002b

PID: 10708  TASK: ffff880c61c62a60  CPU: 10  COMMAND: "kworker/10:4"
 #0 [ffff8809f8559db8] __schedule at ffffffff814b7fc0
 #1 [ffff8809f8559e40] schedule at ffffffff814b8eb9
 #2 [ffff8809f8559e50] worker_thread at ffffffff81058daf
 #3 [ffff8809f8559ec0] kthread at ffffffff8105f0b0
 #4 [ffff8809f8559f50] ret_from_fork at ffffffff814c20dc

PID: 10892  TASK: ffff8806630b62e0  CPU: 15  COMMAND: "smwrap"
 #0 [ffff88034e535e28] __schedule at ffffffff814b7fc0
 #1 [ffff88034e535eb0] schedule at ffffffff814b8eb9
 #2 [ffff88034e535ec0] do_exit at ffffffff81040ae5
 #3 [ffff88034e535f40] do_group_exit at ffffffff81040fa2
 #4 [ffff88034e535f70] sys_exit_group at ffffffff81041017
 #5 [ffff88034e535f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffdb587410  RFLAGS: 00010246
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 00007fc3bd836598
    RDX: 0000000000000000  RSI: 000000000000003c  RDI: 0000000000000000
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffffa0
    R10: 00000031c5db3b60  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff88034e535f78  R14: 0000000000e5fff0  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 10899  TASK: ffff88066254f810  CPU: 11  COMMAND: "sshd"
 #0 [ffff8805ae96de28] __schedule at ffffffff814b7fc0
 #1 [ffff8805ae96deb0] schedule at ffffffff814b8eb9
 #2 [ffff8805ae96dec0] do_exit at ffffffff81040ae5
 #3 [ffff8805ae96df40] do_group_exit at ffffffff81040fa2
 #4 [ffff8805ae96df70] sys_exit_group at ffffffff81041017
 #5 [ffff8805ae96df80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f9b871d8dc8  RSP: 00007fff5ca0a9d8  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff8805ae96df78  R14: 00007fff5ca0aaf4  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 10906  TASK: ffff88097972f100  CPU: 10  COMMAND: "kworker/10:1"
 #0 [ffff880c03ddbc78] __schedule at ffffffff814b7fc0
 #1 [ffff880c03ddbd00] schedule at ffffffff814b8eb9
 #2 [ffff880c03ddbd10] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880c03ddbd20] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880c03ddbd90] mutex_lock at ffffffff814b742a
 #5 [ffff880c03ddbdb0] cgroup_free_fn at ffffffff810930ec
 #6 [ffff880c03ddbdf0] process_one_work at ffffffff81057c54
 #7 [ffff880c03ddbe50] worker_thread at ffffffff81058d0c
 #8 [ffff880c03ddbec0] kthread at ffffffff8105f0b0
 #9 [ffff880c03ddbf50] ret_from_fork at ffffffff814c20dc

PID: 10946  TASK: ffff8805b034f810  CPU: 5   COMMAND: "sshd"
 #0 [ffff88034e683e28] __schedule at ffffffff814b7fc0
 #1 [ffff88034e683eb0] schedule at ffffffff814b8eb9
 #2 [ffff88034e683ec0] do_exit at ffffffff81040ae5
 #3 [ffff88034e683f40] do_group_exit at ffffffff81040fa2
 #4 [ffff88034e683f70] sys_exit_group at ffffffff81041017
 #5 [ffff88034e683f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f811c1d6dc8  RSP: 00007fff8f8f1c48  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88034e683f78  R14: 00007fff8f8f1d64  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 10988  TASK: ffff880c61b51c40  CPU: 6   COMMAND: "kworker/6:2"
 #0 [ffff880c03b8ddb8] __schedule at ffffffff814b7fc0
 #1 [ffff880c03b8de40] schedule at ffffffff814b8eb9
 #2 [ffff880c03b8de50] worker_thread at ffffffff81058daf
 #3 [ffff880c03b8dec0] kthread at ffffffff8105f0b0
 #4 [ffff880c03b8df50] ret_from_fork at ffffffff814c20dc

PID: 11198  TASK: ffff880653c22a60  CPU: 5   COMMAND: "sshd"
 #0 [ffff88062acbbe28] __schedule at ffffffff814b7fc0
 #1 [ffff88062acbbeb0] schedule at ffffffff814b8eb9
 #2 [ffff88062acbbec0] do_exit at ffffffff81040ae5
 #3 [ffff88062acbbf40] do_group_exit at ffffffff81040fa2
 #4 [ffff88062acbbf70] sys_exit_group at ffffffff81041017
 #5 [ffff88062acbbf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f377b202dc8  RSP: 00007fff374cf578  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88062acbbf78  R14: 00007fff374cf694  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 11480  TASK: ffff8805b117f100  CPU: 11  COMMAND: "sshd"
 #0 [ffff880530e97e28] __schedule at ffffffff814b7fc0
 #1 [ffff880530e97eb0] schedule at ffffffff814b8eb9
 #2 [ffff880530e97ec0] do_exit at ffffffff81040ae5
 #3 [ffff880530e97f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880530e97f70] sys_exit_group at ffffffff81041017
 #5 [ffff880530e97f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f604087edc8  RSP: 00007fff3f5aa028  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880530e97f78  R14: 00007fff3f5aa144  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 11765  TASK: ffff880642f2aa60  CPU: 1   COMMAND: "sshd"
 #0 [ffff88038a1c7e28] __schedule at ffffffff814b7fc0
 #1 [ffff88038a1c7eb0] schedule at ffffffff814b8eb9
 #2 [ffff88038a1c7ec0] do_exit at ffffffff81040ae5
 #3 [ffff88038a1c7f40] do_group_exit at ffffffff81040fa2
 #4 [ffff88038a1c7f70] sys_exit_group at ffffffff81041017
 #5 [ffff88038a1c7f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007ff5bc651dc8  RSP: 00007fff85c02e18  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88038a1c7f78  R14: 00007fff85c02f34  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 12031  TASK: ffff8809f919c6a0  CPU: 2   COMMAND: "sshd"
 #0 [ffff880c03bcfe28] __schedule at ffffffff814b7fc0
 #1 [ffff880c03bcfeb0] schedule at ffffffff814b8eb9
 #2 [ffff880c03bcfec0] do_exit at ffffffff81040ae5
 #3 [ffff880c03bcff40] do_group_exit at ffffffff81040fa2
 #4 [ffff880c03bcff70] sys_exit_group at ffffffff81041017
 #5 [ffff880c03bcff80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f5b242b0dc8  RSP: 00007fffdf1a9f58  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880c03bcff78  R14: 00007fffdf1aa074  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 12274  TASK: ffff880651ed7100  CPU: 5   COMMAND: "sshd"
 #0 [ffff88038a081e28] __schedule at ffffffff814b7fc0
 #1 [ffff88038a081eb0] schedule at ffffffff814b8eb9
 #2 [ffff88038a081ec0] do_exit at ffffffff81040ae5
 #3 [ffff88038a081f40] do_group_exit at ffffffff81040fa2
 #4 [ffff88038a081f70] sys_exit_group at ffffffff81041017
 #5 [ffff88038a081f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fad3e288dc8  RSP: 00007fff3ec74698  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88038a081f78  R14: 00007fff3ec747b4  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 12316  TASK: ffff880c61b50710  CPU: 2   COMMAND: "sshd"
 #0 [ffff8809ff73be28] __schedule at ffffffff814b7fc0
 #1 [ffff8809ff73beb0] schedule at ffffffff814b8eb9
 #2 [ffff8809ff73bec0] do_exit at ffffffff81040ae5
 #3 [ffff8809ff73bf40] do_group_exit at ffffffff81040fa2
 #4 [ffff8809ff73bf70] sys_exit_group at ffffffff81041017
 #5 [ffff8809ff73bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f06a1508dc8  RSP: 00007fff97989488  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff8809ff73bf78  R14: 00007fff979895a4  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 12564  TASK: ffff88034e729c40  CPU: 11  COMMAND: "sshd"
 #0 [ffff880389ffde28] __schedule at ffffffff814b7fc0
 #1 [ffff880389ffdeb0] schedule at ffffffff814b8eb9
 #2 [ffff880389ffdec0] do_exit at ffffffff81040ae5
 #3 [ffff880389ffdf40] do_group_exit at ffffffff81040fa2
 #4 [ffff880389ffdf70] sys_exit_group at ffffffff81041017
 #5 [ffff880389ffdf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f84c7b85dc8  RSP: 00007fff354886c8  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880389ffdf78  R14: 00007fff354887e4  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 12963  TASK: ffff880c627e46a0  CPU: 11  COMMAND: "sshd"
 #0 [ffff880be4d65e28] __schedule at ffffffff814b7fc0
 #1 [ffff880be4d65eb0] schedule at ffffffff814b8eb9
 #2 [ffff880be4d65ec0] do_exit at ffffffff81040ae5
 #3 [ffff880be4d65f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880be4d65f70] sys_exit_group at ffffffff81041017
 #5 [ffff880be4d65f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fce6e62edc8  RSP: 00007fff412e02e8  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880be4d65f78  R14: 00007fff412e0404  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 13022  TASK: ffff880c61b53f90  CPU: 0   COMMAND: "sshd"
 #0 [ffff8809ff453e28] __schedule at ffffffff814b7fc0
 #1 [ffff8809ff453eb0] schedule at ffffffff814b8eb9
 #2 [ffff8809ff453ec0] do_exit at ffffffff81040ae5
 #3 [ffff8809ff453f40] do_group_exit at ffffffff81040fa2
 #4 [ffff8809ff453f70] sys_exit_group at ffffffff81041017
 #5 [ffff8809ff453f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f658937edc8  RSP: 00007fff329f9148  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff8809ff453f78  R14: 00007fff329f9264  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 13290  TASK: ffff88016645b170  CPU: 11  COMMAND: "sshd"
 #0 [ffff880166879e28] __schedule at ffffffff814b7fc0
 #1 [ffff880166879eb0] schedule at ffffffff814b8eb9
 #2 [ffff880166879ec0] do_exit at ffffffff81040ae5
 #3 [ffff880166879f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880166879f70] sys_exit_group at ffffffff81041017
 #5 [ffff880166879f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007ff2a8e35dc8  RSP: 00007fff72a70e68  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880166879f78  R14: 00007fff72a70f84  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 13456  TASK: ffff880a0413e9f0  CPU: 2   COMMAND: "kworker/2:2"
 #0 [ffff880c03567db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c03567e40] schedule at ffffffff814b8eb9
 #2 [ffff880c03567e50] worker_thread at ffffffff81058daf
 #3 [ffff880c03567ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c03567f50] ret_from_fork at ffffffff814c20dc

PID: 13539  TASK: ffff88016645b880  CPU: 1   COMMAND: "sshd"
 #0 [ffff880166be1e28] __schedule at ffffffff814b7fc0
 #1 [ffff880166be1eb0] schedule at ffffffff814b8eb9
 #2 [ffff880166be1ec0] do_exit at ffffffff81040ae5
 #3 [ffff880166be1f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880166be1f70] sys_exit_group at ffffffff81041017
 #5 [ffff880166be1f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fed8f8f5dc8  RSP: 00007fff27c88828  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880166be1f78  R14: 00007fff27c88944  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 13562  TASK: ffff880166b54db0  CPU: 11  COMMAND: "sshd"
 #0 [ffff880166c75e28] __schedule at ffffffff814b7fc0
 #1 [ffff880166c75eb0] schedule at ffffffff814b8eb9
 #2 [ffff880166c75ec0] do_exit at ffffffff81040ae5
 #3 [ffff880166c75f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880166c75f70] sys_exit_group at ffffffff81041017
 #5 [ffff880166c75f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fc030facdc8  RSP: 00007fff94369a68  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff880166c75f78  R14: 00007fff94369b84  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 13745  TASK: ffff880662478e20  CPU: 13  COMMAND: "kworker/13:4"
 #0 [ffff88046f9ebdb8] __schedule at ffffffff814b7fc0
 #1 [ffff88046f9ebe40] schedule at ffffffff814b8eb9
 #2 [ffff88046f9ebe50] worker_thread at ffffffff81058daf
 #3 [ffff88046f9ebec0] kthread at ffffffff8105f0b0
 #4 [ffff88046f9ebf50] ret_from_fork at ffffffff814c20dc

PID: 13812  TASK: ffff880166cab880  CPU: 1   COMMAND: "sshd"
 #0 [ffff88065185fe28] __schedule at ffffffff814b7fc0
 #1 [ffff88065185feb0] schedule at ffffffff814b8eb9
 #2 [ffff88065185fec0] do_exit at ffffffff81040ae5
 #3 [ffff88065185ff40] do_group_exit at ffffffff81040fa2
 #4 [ffff88065185ff70] sys_exit_group at ffffffff81041017
 #5 [ffff88065185ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00007fe1502f7dc8  RSP: 00007fff8671a698  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88065185ff78  R14: 00007fff8671a7b4  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 14060  TASK: ffff88016e6d3170  CPU: 15  COMMAND: "sshd"
 #0 [ffff88016e7b1e28] __schedule at ffffffff814b7fc0
 #1 [ffff88016e7b1eb0] schedule at ffffffff814b8eb9
 #2 [ffff88016e7b1ec0] do_exit at ffffffff81040ae5
 #3 [ffff88016e7b1f40] do_group_exit at ffffffff81040fa2
 #4 [ffff88016e7b1f70] sys_exit_group at ffffffff81041017
 #5 [ffff88016e7b1f80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f1cb0765dc8  RSP: 00007fff64433818  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88016e7b1f78  R14: 00007fff64433934  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 14076  TASK: ffff880661441c40  CPU: 3   COMMAND: "kworker/3:1"
 #0 [ffff88065174fdb8] __schedule at ffffffff814b7fc0
 #1 [ffff88065174fe40] schedule at ffffffff814b8eb9
 #2 [ffff88065174fe50] worker_thread at ffffffff81058daf
 #3 [ffff88065174fec0] kthread at ffffffff8105f0b0
 #4 [ffff88065174ff50] ret_from_fork at ffffffff814c20dc

PID: 14083  TASK: ffff880be9368000  CPU: 13  COMMAND: "pickup"
 #0 [ffff88096254bd88] __schedule at ffffffff814b7fc0
 #1 [ffff88096254be10] schedule at ffffffff814b8eb9
 #2 [ffff88096254be20] schedule_hrtimeout_range_clock at ffffffff814b788c
 #3 [ffff88096254bea0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff88096254beb0] sys_epoll_wait at ffffffff8117b040
 #5 [ffff88096254bf80] system_call_fastpath at ffffffff814c2182
    RIP: 00007effc5751763  RSP: 00007fff6be5e308  RFLAGS: 00000202
    RAX: 00000000000000e8  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000064  RSI: 00007fff6be5e8b0  RDI: 0000000000000008
    RBP: 00007effc7c63940   R8: 0000000000000018   R9: 0000000000000064
    R10: 00000000000186a0  R11: 0000000000000246  R12: 00007effc7a2e940
    R13: 0000000000000000  R14: 00000000ffffffff  R15: 00007effc7c63974
    ORIG_RAX: 00000000000000e8  CS: 0033  SS: 002b

PID: 14106  TASK: ffff880643938000  CPU: 3   COMMAND: "kworker/u34:2"
 #0 [ffff880170599db8] __schedule at ffffffff814b7fc0
 #1 [ffff880170599e40] schedule at ffffffff814b8eb9
 #2 [ffff880170599e50] worker_thread at ffffffff81058daf
 #3 [ffff880170599ec0] kthread at ffffffff8105f0b0
 #4 [ffff880170599f50] ret_from_fork at ffffffff814c20dc

PID: 14109  TASK: ffff88016e6d3880  CPU: 6   COMMAND: "sshd"
 #0 [ffff88017063fe28] __schedule at ffffffff814b7fc0
 #1 [ffff88017063feb0] schedule at ffffffff814b8eb9
 #2 [ffff88017063fec0] do_exit at ffffffff81040ae5
 #3 [ffff88017063ff40] do_group_exit at ffffffff81040fa2
 #4 [ffff88017063ff70] sys_exit_group at ffffffff81041017
 #5 [ffff88017063ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00007f84076d4dc8  RSP: 00007fff7fe07eb8  RFLAGS: 00010206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000000000ff  RSI: 000000000000003c  RDI: 00000000000000ff
    RBP: 00000000000000ff   R8: 00000000000000e7   R9: fffffffffffffed0
    R10: 0000000000000000  R11: 0000000000000202  R12: ffffffff81041017
    R13: ffff88017063ff78  R14: 00007fff7fe07fd4  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 14139  TASK: ffff88034e5f8000  CPU: 1   COMMAND: "kworker/1:0"
 #0 [ffff8801706d1db8] __schedule at ffffffff814b7fc0
 #1 [ffff8801706d1e40] schedule at ffffffff814b8eb9
 #2 [ffff8801706d1e50] worker_thread at ffffffff81058daf
 #3 [ffff8801706d1ec0] kthread at ffffffff8105f0b0
 #4 [ffff8801706d1f50] ret_from_fork at ffffffff814c20dc

PID: 14158  TASK: ffff8809f919e9f0  CPU: 14  COMMAND: "kworker/14:3"
 #0 [ffff880bcd071db8] __schedule at ffffffff814b7fc0
 #1 [ffff880bcd071e40] schedule at ffffffff814b8eb9
 #2 [ffff880bcd071e50] worker_thread at ffffffff81058daf
 #3 [ffff880bcd071ec0] kthread at ffffffff8105f0b0
 #4 [ffff880bcd071f50] ret_from_fork at ffffffff814c20dc

PID: 14290  TASK: ffff880656500e20  CPU: 3   COMMAND: "atop"
 #0 [ffff8805ae813ec8] __schedule at ffffffff814b7fc0
 #1 [ffff8805ae813f50] schedule at ffffffff814b8eb9
 #2 [ffff8805ae813f60] sys_pause at ffffffff81050614
 #3 [ffff8805ae813f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd980  RSP: 00007fffbf056220  RFLAGS: 00000206
    RAX: 0000000000000022  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 00000000ffffffff  RSI: 0000000000000000  RDI: 00000031c5db1700
    RBP: 0000000002432740   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 000000005284ec7a  R14: ffffffff81050614  R15: ffff8805ae813f78
    ORIG_RAX: 0000000000000022  CS: 0033  SS: 002b

PID: 14473  TASK: ffff88065d6af100  CPU: 3   COMMAND: "kworker/3:2"
 #0 [ffff8803d943ddb8] __schedule at ffffffff814b7fc0
 #1 [ffff8803d943de40] schedule at ffffffff814b8eb9
 #2 [ffff8803d943de50] worker_thread at ffffffff81058daf
 #3 [ffff8803d943dec0] kthread at ffffffff8105f0b0
 #4 [ffff8803d943df50] ret_from_fork at ffffffff814c20dc

PID: 14590  TASK: ffff88034e5f8710  CPU: 15  COMMAND: "kworker/15:1"
 #0 [ffff8803a2761db8] __schedule at ffffffff814b7fc0
 #1 [ffff8803a2761e40] schedule at ffffffff814b8eb9
 #2 [ffff8803a2761e50] worker_thread at ffffffff81058daf
 #3 [ffff8803a2761ec0] kthread at ffffffff8105f0b0
 #4 [ffff8803a2761f50] ret_from_fork at ffffffff814c20dc

PID: 14591  TASK: ffff880c03a62a60  CPU: 10  COMMAND: "kworker/u33:1"
 #0 [ffff8809f8785db8] __schedule at ffffffff814b7fc0
 #1 [ffff8809f8785e40] schedule at ffffffff814b8eb9
 #2 [ffff8809f8785e50] worker_thread at ffffffff81058daf
 #3 [ffff8809f8785ec0] kthread at ffffffff8105f0b0
 #4 [ffff8809f8785f50] ret_from_fork at ffffffff814c20dc

PID: 14603  TASK: ffff880be936cdb0  CPU: 8   COMMAND: "kworker/u33:0"
 #0 [ffff880be4c01db8] __schedule at ffffffff814b7fc0
 #1 [ffff880be4c01e40] schedule at ffffffff814b8eb9
 #2 [ffff880be4c01e50] worker_thread at ffffffff81058daf
 #3 [ffff880be4c01ec0] kthread at ffffffff8105f0b0
 #4 [ffff880be4c01f50] ret_from_fork at ffffffff814c20dc

PID: 14620  TASK: ffff880be936c6a0  CPU: 10  COMMAND: "kworker/u33:2"
 #0 [ffff880b0981bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880b0981be40] schedule at ffffffff814b8eb9
 #2 [ffff880b0981be50] worker_thread at ffffffff81058daf
 #3 [ffff880b0981bec0] kthread at ffffffff8105f0b0
 #4 [ffff880b0981bf50] ret_from_fork at ffffffff814c20dc

PID: 14621  TASK: ffff880be936bf90  CPU: 0   COMMAND: "kworker/0:1"
 #0 [ffff880c62f91db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c62f91e40] schedule at ffffffff814b8eb9
 #2 [ffff880c62f91e50] worker_thread at ffffffff81058daf
 #3 [ffff880c62f91ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c62f91f50] ret_from_fork at ffffffff814c20dc

PID: 14622  TASK: ffff88034e5ff810  CPU: 1   COMMAND: "kworker/1:2"
 #0 [ffff8801671e5db8] __schedule at ffffffff814b7fc0
 #1 [ffff8801671e5e40] schedule at ffffffff814b8eb9
 #2 [ffff8801671e5e50] worker_thread at ffffffff81058daf
 #3 [ffff8801671e5ec0] kthread at ffffffff8105f0b0
 #4 [ffff8801671e5f50] ret_from_fork at ffffffff814c20dc

PID: 14624  TASK: ffff88016f353f90  CPU: 13  COMMAND: "fprintd"
 #0 [ffff88016720fe28] __schedule at ffffffff814b7fc0
 #1 [ffff88016720feb0] schedule at ffffffff814b8eb9
 #2 [ffff88016720fec0] do_exit at ffffffff81040ae5
 #3 [ffff88016720ff40] do_group_exit at ffffffff81040fa2
 #4 [ffff88016720ff70] sys_exit_group at ffffffff81041017
 #5 [ffff88016720ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff32514d20  RFLAGS: 00010202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000019
    RDX: 0000000000000000  RSI: 000000000000003c  RDI: 0000000000000000
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffffa0
    R10: 00000031c5db5008  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff88016720ff78  R14: 00000031c811f630  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 14640  TASK: ffff88016f3546a0  CPU: 11  COMMAND: "bash"
 #0 [ffff8801672eba40] machine_kexec at ffffffff81029c72
 #1 [ffff8801672eba90] crash_kexec at ffffffff8108cf98
 #2 [ffff8801672ebb60] oops_end at ffffffff814bad28
 #3 [ffff8801672ebb90] no_context at ffffffff814b08dd
 #4 [ffff8801672ebbf0] __bad_area_nosemaphore at ffffffff814b0abe
 #5 [ffff8801672ebc50] bad_area at ffffffff814b0b37
 #6 [ffff8801672ebc80] __do_page_fault at ffffffff814bd9e1
 #7 [ffff8801672ebd90] do_page_fault at ffffffff814bda2e
 #8 [ffff8801672ebda0] page_fault at ffffffff814ba232
    [exception RIP: sysrq_handle_crash+22]
    RIP: ffffffff812fff56  RSP: ffff8801672ebe58  RFLAGS: 00010092
    RAX: 000000000000000f  RBX: 0000000000000063  RCX: ffff880667d4e9e0
    RDX: 0000000000000000  RSI: ffff880667d4ce68  RDI: 0000000000000063
    RBP: ffff8801672ebe58   R8: 0000000000000000   R9: 0000000000000100
    R10: 0000000000005dc1  R11: 0000000000005dc0  R12: ffffffff81a7d7e0
    R13: 0000000000000282  R14: 0000000000000007  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff8801672ebe60] __handle_sysrq at ffffffff81300741
#10 [ffff8801672ebea0] write_sysrq_trigger at ffffffff813007fa
#11 [ffff8801672ebed0] proc_reg_write at ffffffff811936c3
#12 [ffff8801672ebef0] vfs_write at ffffffff8113820e
#13 [ffff8801672ebf30] sys_write at ffffffff811386f2
#14 [ffff8801672ebf80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5ae4440  RSP: 00007fff1ce6a640  RFLAGS: 00010206
    RAX: 0000000000000001  RBX: ffffffff814c2182  RCX: 0000000000000400
    RDX: 0000000000000002  RSI: 00007f00a0279000  RDI: 0000000000000001
    RBP: 00007f00a0279000   R8: 000000000000000a   R9: 00007f00a0258700
    R10: 0000000000000022  R11: 0000000000000246  R12: 00000000018e0920
    R13: 0000000000000002  R14: 00000031c5db2240  R15: 0000000000000002
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

PID: 17426  TASK: ffff8809fb10c6a0  CPU: 8   COMMAND: "kworker/8:0"
 #0 [ffff8809f46f1db8] __schedule at ffffffff814b7fc0
 #1 [ffff8809f46f1e40] schedule at ffffffff814b8eb9
 #2 [ffff8809f46f1e50] worker_thread at ffffffff81058daf
 #3 [ffff8809f46f1ec0] kthread at ffffffff8105f0b0
 #4 [ffff8809f46f1f50] ret_from_fork at ffffffff814c20dc

PID: 17607  TASK: ffff880a0413f810  CPU: 12  COMMAND: "kworker/12:0"
 #0 [ffff880a008f1db8] __schedule at ffffffff814b7fc0
 #1 [ffff880a008f1e40] schedule at ffffffff814b8eb9
 #2 [ffff880a008f1e50] worker_thread at ffffffff81058daf
 #3 [ffff880a008f1ec0] kthread at ffffffff8105f0b0
 #4 [ffff880a008f1f50] ret_from_fork at ffffffff814c20dc

PID: 20135  TASK: ffff880c62420e20  CPU: 14  COMMAND: "kworker/14:1"
 #0 [ffff880a06573c78] __schedule at ffffffff814b7fc0
 #1 [ffff880a06573d00] schedule at ffffffff814b8eb9
 #2 [ffff880a06573d10] schedule_preempt_disabled at ffffffff814b918e
 #3 [ffff880a06573d20] __mutex_lock_slowpath at ffffffff814b75b2
 #4 [ffff880a06573d90] mutex_lock at ffffffff814b742a
 #5 [ffff880a06573db0] cgroup_free_fn at ffffffff810930ec
 #6 [ffff880a06573df0] process_one_work at ffffffff81057c54
 #7 [ffff880a06573e50] worker_thread at ffffffff81058d0c
 #8 [ffff880a06573ec0] kthread at ffffffff8105f0b0
 #9 [ffff880a06573f50] ret_from_fork at ffffffff814c20dc

PID: 21274  TASK: ffff880663628710  CPU: 13  COMMAND: "kworker/13:1"
 #0 [ffff880651fc1db8] __schedule at ffffffff814b7fc0
 #1 [ffff880651fc1e40] schedule at ffffffff814b8eb9
 #2 [ffff880651fc1e50] worker_thread at ffffffff81058daf
 #3 [ffff880651fc1ec0] kthread at ffffffff8105f0b0
 #4 [ffff880651fc1f50] ret_from_fork at ffffffff814c20dc

PID: 21439  TASK: ffff8805af46bf90  CPU: 7   COMMAND: "kworker/u34:0"
 #0 [ffff880651a31db8] __schedule at ffffffff814b7fc0
 #1 [ffff880651a31e40] schedule at ffffffff814b8eb9
 #2 [ffff880651a31e50] worker_thread at ffffffff81058daf
 #3 [ffff880651a31ec0] kthread at ffffffff8105f0b0
 #4 [ffff880651a31f50] ret_from_fork at ffffffff814c20dc

PID: 22712  TASK: ffff880656504db0  CPU: 11  COMMAND: "kworker/11:1"
 #0 [ffff88034e7a3db8] __schedule at ffffffff814b7fc0
 #1 [ffff88034e7a3e40] schedule at ffffffff814b8eb9
 #2 [ffff88034e7a3e50] worker_thread at ffffffff81058daf
 #3 [ffff88034e7a3ec0] kthread at ffffffff8105f0b0
 #4 [ffff88034e7a3f50] ret_from_fork at ffffffff814c20dc

PID: 24584  TASK: ffff880651f28e20  CPU: 7   COMMAND: "kworker/7:0"
 #0 [ffff880654c9fdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880654c9fe40] schedule at ffffffff814b8eb9
 #2 [ffff880654c9fe50] worker_thread at ffffffff81058daf
 #3 [ffff880654c9fec0] kthread at ffffffff8105f0b0
 #4 [ffff880654c9ff50] ret_from_fork at ffffffff814c20dc

PID: 24632  TASK: ffff880662749c40  CPU: 15  COMMAND: "kworker/15:0"
 #0 [ffff8806530e9db8] __schedule at ffffffff814b7fc0
 #1 [ffff8806530e9e40] schedule at ffffffff814b8eb9
 #2 [ffff8806530e9e50] worker_thread at ffffffff81058daf
 #3 [ffff8806530e9ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806530e9f50] ret_from_fork at ffffffff814c20dc

PID: 24634  TASK: ffff8808237d0710  CPU: 10  COMMAND: "kworker/10:0"
 #0 [ffff880a00a83db8] __schedule at ffffffff814b7fc0
 #1 [ffff880a00a83e40] schedule at ffffffff814b8eb9
 #2 [ffff880a00a83e50] worker_thread at ffffffff81058daf
 #3 [ffff880a00a83ec0] kthread at ffffffff8105f0b0
 #4 [ffff880a00a83f50] ret_from_fork at ffffffff814c20dc

PID: 25668  TASK: ffff8806619046a0  CPU: 15  COMMAND: "kworker/15:3"
 #0 [ffff880656e0fab8] __schedule at ffffffff814b7fc0
 #1 [ffff880656e0fb40] schedule at ffffffff814b8eb9
 #2 [ffff880656e0fb50] schedule_timeout at ffffffff814b6d65
 #3 [ffff880656e0fbe0] wait_for_completion at ffffffff814b8715
 #4 [ffff880656e0fc40] __stop_cpus at ffffffff81099976
 #5 [ffff880656e0fca0] try_stop_cpus at ffffffff81099afa
 #6 [ffff880656e0fcd0] synchronize_sched_expedited at ffffffff810a2c45
 #7 [ffff880656e0fd00] synchronize_rcu_expedited at ffffffff810a2d4e
 #8 [ffff880656e0fd10] synchronize_net at ffffffff814078dd
 #9 [ffff880656e0fd20] dev_deactivate_many at ffffffff8142bf4c
#10 [ffff880656e0fd70] dev_deactivate at ffffffff8142bf8d
#11 [ffff880656e0fd90] linkwatch_do_dev at ffffffff8141d764
#12 [ffff880656e0fdb0] __linkwatch_run_queue at ffffffff8141da4d
#13 [ffff880656e0fde0] linkwatch_event at ffffffff8141db55
#14 [ffff880656e0fdf0] process_one_work at ffffffff81057c54
#15 [ffff880656e0fe50] worker_thread at ffffffff81058d0c
#16 [ffff880656e0fec0] kthread at ffffffff8105f0b0
#17 [ffff880656e0ff50] ret_from_fork at ffffffff814c20dc

PID: 26382  TASK: ffff880c624269f0  CPU: 1   COMMAND: "cgroup_mutex_re"
 #0 [ffff880c053b3dd8] __schedule at ffffffff814b7fc0
 #1 [ffff880c053b3e60] schedule at ffffffff814b8eb9
 #2 [ffff880c053b3e70] do_wait at ffffffff810403b4
 #3 [ffff880c053b3ee0] sys_wait4 at ffffffff810412a3
 #4 [ffff880c053b3f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd5fe  RSP: 00007fff6dc68d00  RFLAGS: 00010246
    RAX: 000000000000003d  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 00007fff6dc68e98  RDI: ffffffffffffffff
    RBP: 000000000247f900   R8: 000000000247f9f0   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00000000024d5e10
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 000000000000003d  CS: 0033  SS: 002b

PID: 26666  TASK: ffff880c61b54db0  CPU: 0   COMMAND: "kworker/0:0"
 #0 [ffff880c5b3a3db8] __schedule at ffffffff814b7fc0
 #1 [ffff880c5b3a3e40] schedule at ffffffff814b8eb9
 #2 [ffff880c5b3a3e50] worker_thread at ffffffff81058daf
 #3 [ffff880c5b3a3ec0] kthread at ffffffff8105f0b0
 #4 [ffff880c5b3a3f50] ret_from_fork at ffffffff814c20dc

PID: 26975  TASK: ffff88082394b170  CPU: 4   COMMAND: "kworker/4:3"
 #0 [ffff8809fb173db8] __schedule at ffffffff814b7fc0
 #1 [ffff8809fb173e40] schedule at ffffffff814b8eb9
 #2 [ffff8809fb173e50] worker_thread at ffffffff81058daf
 #3 [ffff8809fb173ec0] kthread at ffffffff8105f0b0
 #4 [ffff8809fb173f50] ret_from_fork at ffffffff814c20dc

PID: 27322  TASK: ffff880962787100  CPU: 1   COMMAND: "md_connector"
 #0 [ffff880c6246fe28] __schedule at ffffffff814b7fc0
 #1 [ffff880c6246feb0] schedule at ffffffff814b8eb9
 #2 [ffff880c6246fec0] do_exit at ffffffff81040ae5
 #3 [ffff880c6246ff40] do_group_exit at ffffffff81040fa2
 #4 [ffff880c6246ff70] sys_exit_group at ffffffff81041017
 #5 [ffff880c6246ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffa4bb9790  RFLAGS: 00000202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff880c6246ff78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 27481  TASK: ffff8806565062e0  CPU: 1   COMMAND: "kworker/1:1"
 #0 [ffff880667c06e60] crash_nmi_callback at ffffffff81023237
 #1 [ffff880667c06e70] nmi_handle at ffffffff814baea9
 #2 [ffff880667c06ec0] do_nmi at ffffffff814bafb7
 #3 [ffff880667c06ef0] end_repeat_nmi at ffffffff814ba537
    [exception RIP: cfb_imageblit+720]
    RIP: ffffffff812b44d0  RSP: ffff88027840dab8  RFLAGS: 00000046
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000046
    RDX: ffff88027840dab8  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff812b44d0   R8: ffffffff812b44d0   R9: 0000000000000018
    R10: ffff88027840dab8  R11: 0000000000000046  R12: ffffffffffffffff
    R13: 0000000000aaaaaa  R14: 0000000000000001  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff88027840dab8] cfb_imageblit at ffffffff812b44d0
 #5 [ffff88027840db40] bit_putcs at ffffffff812ae105
 #6 [ffff88027840dc80] fbcon_putcs at ffffffff812a996d
 #7 [ffff88027840dcf0] vt_console_print at ffffffff8130a844
 #8 [ffff88027840dd50] call_console_drivers.constprop.10 at ffffffff8103cd93
 #9 [ffff88027840dd90] console_unlock at ffffffff8103d30d
#10 [ffff88027840ddd0] console_callback at ffffffff8130ce2a
#11 [ffff88027840ddf0] process_one_work at ffffffff81057c54
#12 [ffff88027840de50] worker_thread at ffffffff81058d0c
#13 [ffff88027840dec0] kthread at ffffffff8105f0b0
#14 [ffff88027840df50] ret_from_fork at ffffffff814c20dc

PID: 27547  TASK: ffff880c61c63f90  CPU: 6   COMMAND: "md_connector"
 #0 [ffff880b82325e28] __schedule at ffffffff814b7fc0
 #1 [ffff880b82325eb0] schedule at ffffffff814b8eb9
 #2 [ffff880b82325ec0] do_exit at ffffffff81040ae5
 #3 [ffff880b82325f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880b82325f70] sys_exit_group at ffffffff81041017
 #5 [ffff880b82325f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffee927b70  RFLAGS: 00000206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 00000031c6802d48
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff880b82325f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 27791  TASK: ffff8806648a62e0  CPU: 7   COMMAND: "kworker/7:1"
 #0 [ffff880653d9bdb8] __schedule at ffffffff814b7fc0
 #1 [ffff880653d9be40] schedule at ffffffff814b8eb9
 #2 [ffff880653d9be50] worker_thread at ffffffff81058daf
 #3 [ffff880653d9bec0] kthread at ffffffff8105f0b0
 #4 [ffff880653d9bf50] ret_from_fork at ffffffff814c20dc

PID: 28573  TASK: ffff88065d6ad4c0  CPU: 1   COMMAND: "md_connector"
 #0 [ffff8802777fbe28] __schedule at ffffffff814b7fc0
 #1 [ffff8802777fbeb0] schedule at ffffffff814b8eb9
 #2 [ffff8802777fbec0] do_exit at ffffffff81040ae5
 #3 [ffff8802777fbf40] do_group_exit at ffffffff81040fa2
 #4 [ffff8802777fbf70] sys_exit_group at ffffffff81041017
 #5 [ffff8802777fbf80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff27298df0  RFLAGS: 00000206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff8802777fbf78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 28638  TASK: ffff8809f93f0e20  CPU: 12  COMMAND: "md_connector"
 #0 [ffff88082247fe28] __schedule at ffffffff814b7fc0
 #1 [ffff88082247feb0] schedule at ffffffff814b8eb9
 #2 [ffff88082247fec0] do_exit at ffffffff81040ae5
 #3 [ffff88082247ff40] do_group_exit at ffffffff81040fa2
 #4 [ffff88082247ff70] sys_exit_group at ffffffff81041017
 #5 [ffff88082247ff80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffd8ee5e10  RFLAGS: 00000216
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 00000031c6802d48
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff88082247ff78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 28744  TASK: ffff880656502350  CPU: 11  COMMAND: "kworker/11:2"
 #0 [ffff8805ae557db8] __schedule at ffffffff814b7fc0
 #1 [ffff8805ae557e40] schedule at ffffffff814b8eb9
 #2 [ffff8805ae557e50] worker_thread at ffffffff81058daf
 #3 [ffff8805ae557ec0] kthread at ffffffff8105f0b0
 #4 [ffff8805ae557f50] ret_from_fork at ffffffff814c20dc

PID: 28996  TASK: ffff8806630b3880  CPU: 13  COMMAND: "md_connector"
 #0 [ffff88057e7a1e28] __schedule at ffffffff814b7fc0
 #1 [ffff88057e7a1eb0] schedule at ffffffff814b8eb9
 #2 [ffff88057e7a1ec0] do_exit at ffffffff81040ae5
 #3 [ffff88057e7a1f40] do_group_exit at ffffffff81040fa2
 #4 [ffff88057e7a1f70] sys_exit_group at ffffffff81041017
 #5 [ffff88057e7a1f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff3907f008  RFLAGS: 00010202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 00000031c781dcd8
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff88057e7a1f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 30108  TASK: ffff880c61cb3f90  CPU: 4   COMMAND: "kworker/4:0"
 #0 [ffff880be9361db8] __schedule at ffffffff814b7fc0
 #1 [ffff880be9361e40] schedule at ffffffff814b8eb9
 #2 [ffff880be9361e50] worker_thread at ffffffff81058daf
 #3 [ffff880be9361ec0] kthread at ffffffff8105f0b0
 #4 [ffff880be9361f50] ret_from_fork at ffffffff814c20dc

PID: 30326  TASK: ffff880c62534db0  CPU: 10  COMMAND: "md_connector"
 #0 [ffff8809f875de28] __schedule at ffffffff814b7fc0
 #1 [ffff8809f875deb0] schedule at ffffffff814b8eb9
 #2 [ffff8809f875dec0] do_exit at ffffffff81040ae5
 #3 [ffff8809f875df40] do_group_exit at ffffffff81040fa2
 #4 [ffff8809f875df70] sys_exit_group at ffffffff81041017
 #5 [ffff8809f875df80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff5f133388  RFLAGS: 00010202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 00000031c781dcd8
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff8809f875df78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 30431  TASK: ffff880c61b57810  CPU: 4   COMMAND: "kworker/4:1"
 #0 [ffff880b09b75db8] __schedule at ffffffff814b7fc0
 #1 [ffff880b09b75e40] schedule at ffffffff814b8eb9
 #2 [ffff880b09b75e50] worker_thread at ffffffff81058daf
 #3 [ffff880b09b75ec0] kthread at ffffffff8105f0b0
 #4 [ffff880b09b75f50] ret_from_fork at ffffffff814c20dc

PID: 30432  TASK: ffff880661440710  CPU: 10  COMMAND: "ptpd"
 #0 [ffff880278641898] __schedule at ffffffff814b7fc0
 #1 [ffff880278641920] schedule at ffffffff814b8eb9
 #2 [ffff880278641930] schedule_hrtimeout_range_clock at ffffffff814b78b5
 #3 [ffff8802786419b0] schedule_hrtimeout_range at ffffffff814b78e3
 #4 [ffff8802786419c0] poll_schedule_timeout at ffffffff81149f09
 #5 [ffff8802786419f0] do_select at ffffffff8114a899
 #6 [ffff880278641d70] core_sys_select at ffffffff8114ab72
 #7 [ffff880278641f10] sys_select at ffffffff8114ad71
 #8 [ffff880278641f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5aea623  RSP: 00007fff63791a58  RFLAGS: 00000246
    RAX: 0000000000000017  RBX: ffffffff814c2182  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 00007fff63791aa0  RDI: 0000000000000008
    RBP: 00007fff63791b40   R8: 0000000000000000   R9: 000000000040f5b8
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 00007fff63791de0  R15: 00000000004015d0
    ORIG_RAX: 0000000000000017  CS: 0033  SS: 002b

PID: 30679  TASK: ffff88065416bf90  CPU: 0   COMMAND: "cgroup_mutex_cg"
 #0 [ffff8805b1183dd8] __schedule at ffffffff814b7fc0
 #1 [ffff8805b1183e60] schedule at ffffffff814b8eb9
 #2 [ffff8805b1183e70] do_wait at ffffffff810403b4
 #3 [ffff8805b1183ee0] sys_wait4 at ffffffff810412a3
 #4 [ffff8805b1183f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abd5fe  RSP: 00007fff1d66ad40  RFLAGS: 00010293
    RAX: 000000000000003d  RBX: ffffffff814c2182  RCX: 0000000032303263
    RDX: 0000000000000000  RSI: 00007fff1d66ae38  RDI: ffffffffffffffff
    RBP: 00000000012ca200   R8: 00000000012ca2a0   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00000000012b3640
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 000000000000003d  CS: 0033  SS: 002b

PID: 30958  TASK: ffff880a0413cdb0  CPU: 9   COMMAND: "md_connector"
 #0 [ffff8809f9263e28] __schedule at ffffffff814b7fc0
 #1 [ffff8809f9263eb0] schedule at ffffffff814b8eb9
 #2 [ffff8809f9263ec0] do_exit at ffffffff81040ae5
 #3 [ffff8809f9263f40] do_group_exit at ffffffff81040fa2
 #4 [ffff8809f9263f70] sys_exit_group at ffffffff81041017
 #5 [ffff8809f9263f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff70a721e0  RFLAGS: 00000212
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff8809f9263f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 31022  TASK: ffff880651f28000  CPU: 9   COMMAND: "kworker/9:3"
 #0 [ffff8805af3f5db8] __schedule at ffffffff814b7fc0
 #1 [ffff8805af3f5e40] schedule at ffffffff814b8eb9
 #2 [ffff8805af3f5e50] worker_thread at ffffffff81058daf
 #3 [ffff8805af3f5ec0] kthread at ffffffff8105f0b0
 #4 [ffff8805af3f5f50] ret_from_fork at ffffffff814c20dc

PID: 31030  TASK: ffff8809f93f2a60  CPU: 8   COMMAND: "md_connector"
 #0 [ffff880b822a3d30] __schedule at ffffffff814b7fc0
 #1 [ffff880b822a3db8] schedule at ffffffff814b8eb9
 #2 [ffff880b822a3dc8] rwsem_down_read_failed at ffffffff814b994d
 #3 [ffff880b822a3e18] call_rwsem_down_read_failed at ffffffff8126b314
 #4 [ffff880b822a3e80] exit_signals at ffffffff8104f074
 #5 [ffff880b822a3ec0] do_exit at ffffffff810404e7
 #6 [ffff880b822a3f40] do_group_exit at ffffffff81040fa2
 #7 [ffff880b822a3f70] sys_exit_group at ffffffff81041017
 #8 [ffff880b822a3f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffe9f46728  RFLAGS: 00010202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 00000031c781dcd8
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff880b822a3f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 31085  TASK: ffff8809f45af100  CPU: 1   COMMAND: "md_connector"
 #0 [ffff880979691e28] __schedule at ffffffff814b7fc0
 #1 [ffff880979691eb0] schedule at ffffffff814b8eb9
 #2 [ffff880979691ec0] do_exit at ffffffff81040ae5
 #3 [ffff880979691f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880979691f70] sys_exit_group at ffffffff81041017
 #5 [ffff880979691f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffe13a1890  RFLAGS: 00000202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff880979691f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 31133  TASK: ffff8806610b62e0  CPU: 13  COMMAND: "md_connector"
 #0 [ffff8806439fbe28] __schedule at ffffffff814b7fc0
 #1 [ffff8806439fbeb0] schedule at ffffffff814b8eb9
 #2 [ffff8806439fbec0] do_exit at ffffffff81040ae5
 #3 [ffff8806439fbf40] do_group_exit at ffffffff81040fa2
 #4 [ffff8806439fbf70] sys_exit_group at ffffffff81041017
 #5 [ffff8806439fbf80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fffa8108e80  RFLAGS: 00000206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff8806439fbf78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 31158  TASK: ffff880a0413dbd0  CPU: 7   COMMAND: "md_connector"
 #0 [ffff880c03a59e28] __schedule at ffffffff814b7fc0
 #1 [ffff880c03a59eb0] schedule at ffffffff814b8eb9
 #2 [ffff880c03a59ec0] do_exit at ffffffff81040ae5
 #3 [ffff880c03a59f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880c03a59f70] sys_exit_group at ffffffff81041017
 #5 [ffff880c03a59f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff53fa4f90  RFLAGS: 00000202
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff880c03a59f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 31160  TASK: ffff88057e5b4db0  CPU: 15  COMMAND: "md_connector"
 #0 [ffff880653db5e28] __schedule at ffffffff814b7fc0
 #1 [ffff880653db5eb0] schedule at ffffffff814b8eb9
 #2 [ffff880653db5ec0] do_exit at ffffffff81040ae5
 #3 [ffff880653db5f40] do_group_exit at ffffffff81040fa2
 #4 [ffff880653db5f70] sys_exit_group at ffffffff81041017
 #5 [ffff880653db5f80] system_call_fastpath at ffffffff814c2182
    RIP: 00000031c5abddc8  RSP: 00007fff1cb60cf0  RFLAGS: 00000206
    RAX: 00000000000000e7  RBX: ffffffff814c2182  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 000000000000003c  RDI: 0000000000000001
    RBP: 00000031c5dad808   R8: 00000000000000e7   R9: ffffffffffffff40
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff81041017
    R13: ffff880653db5f78  R14: 0000000000000000  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

PID: 31261  TASK: ffff880c61719530  CPU: 14  COMMAND: "kworker/14:4"
 #0 [ffff8809f92f3db8] __schedule at ffffffff814b7fc0
 #1 [ffff8809f92f3e40] schedule at ffffffff814b8eb9
 #2 [ffff8809f92f3e50] worker_thread at ffffffff81058daf
 #3 [ffff8809f92f3ec0] kthread at ffffffff8105f0b0
 #4 [ffff8809f92f3f50] ret_from_fork at ffffffff814c20dc

PID: 31391  TASK: ffff880656700000  CPU: 9   COMMAND: "kworker/9:2"
 #0 [ffff8806563b1db8] __schedule at ffffffff814b7fc0
 #1 [ffff8806563b1e40] schedule at ffffffff814b8eb9
 #2 [ffff8806563b1e50] worker_thread at ffffffff81058daf
 #3 [ffff8806563b1ec0] kthread at ffffffff8105f0b0
 #4 [ffff8806563b1f50] ret_from_fork at ffffffff814c20dc


