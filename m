From: Roman Gushchin <guro@fb.com>
Subject: Re: ptrace warning due to "cgroup: get rid of
 cgroup_freezer_frozen_exit()"
Date: Tue, 7 May 2019 21:37:58 +0000
Message-ID: <20190507213752.GA24308@tower.DHCP.thefacebook.com>
References: <1557259462.6132.20.camel@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RNN4LBOFtefrvAX1xBIexBu2lvT5Ch1nLeo0DJY36Kg=;
 b=kA1mQnQbrPfn4zDn9zZa+DDZu1oidG+gVk2c8cNGAZZtH8v61FkAtxSA1SKnLBzIix7/
 vnYTr+klcVwEdyWHo5788UxOfWRrLqeqg9WN/mgz39kaSpThEHyU/C31gZHG5oZvSGlW
 SsoG2LVHjz0pPV9rXu6rl8Qv47lSOoYckTk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNN4LBOFtefrvAX1xBIexBu2lvT5Ch1nLeo0DJY36Kg=;
 b=gA0dZ3TDJJlvRFHoOBGzBtyha+L5dsL3AzTK9N5PeJVc5M2BLYabUNsL99rBVr6EP7Z/jqD8BCI7txl+awd8M9guqvS0Oi21w0JEmpTNvle01O5NIbmt3i7KgjHruJ7DCwMTbWSOA3kKYYVNgK3ss4tZuj4nrgehxoAaAHwLhUU=
In-Reply-To: <1557259462.6132.20.camel@lca.pw>
Content-Language: en-US
Content-ID: <9B589E8022892A4FBFD8897D5CD8C2B1@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Qian Cai <cai@lca.pw>
Cc: "oleg@redhat.com" <oleg@redhat.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, May 07, 2019 at 04:04:22PM -0400, Qian Cai wrote:
> LTP ptrace01 test case triggers a warning below. Looks at ptrace_stop() c=
alls
> cgroup_enter_frozen() there in the cgroup v2 freezer.
>=20
> [ 8373.336330] WARNING: CPU: 56 PID: 67026 at kernel/cgroup/cgroup.c:6008
> cgroup_exit+0x2a9/0x2f0
> [ 8373.345001] Modules linked in: brd ext4 crc16 mbcache jbd2 overlay loo=
p
> nls_iso8859_1 nls_cp437 vfat fat kvm_amd kvm ses enclosure dax_pmem irqby=
pass
> dax_pmem_core efivars ip_tables x_tables xfs sd_mod smartpqi scsi_transpo=
rt_sas
> tg3 mlx5_core libphy firmware_class dm_mirror dm_region_hash dm_log dm_mo=
d
> efivarfs [last unloaded: dummy_del_mod]
> [ 8373.375561] CPU: 56 PID: 67026 Comm: ptrace01 Tainted:
> G=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0O=A0=A0=A0=A0=A0=A05.1.0-next-20190507+=
 #25
> [ 8373.384579] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen=
10,
> BIOS A40 01/25/2019
> [ 8373.393164] RIP: 0010:cgroup_exit+0x2a9/0x2f0
> [ 8373.397556] Code: 0d ff ff ff 4c 89 f7 e8 75 4b 1b 00 4c 8b ab 20 0f 0=
0 00 49
> 8d 7d 50 e8 65 4b 1b 00 49 8b 7d 50 e8 4c 56 00 00 e9 db fe ff ff <0f> 0b=
 e9 3a
> fe ff ff 48 01 f1 0f 82 3b ff ff ff 48 c7 c7 40 83 5b
> [ 8373.416443] RSP: 0018:ffff888bdc9ef9b8 EFLAGS: 00010002
> [ 8373.421709] RAX: 0000000000000000 RBX: ffff888e5cfcc040 RCX: ffffffffa=
b3a8e7d
> [ 8373.428897] RDX: 1ffff111cb9f9875 RSI: dffffc0000000000 RDI: ffff888e5=
cfcc3a8
> [ 8373.436080] RBP: ffff888bdc9efa50 R08: ffffed117b93df25 R09: ffffed117=
b93df24
> [ 8373.443266] R10: ffffed117b93df24 R11: 0000000000000003 R12: ffff888bd=
c9efa28
> [ 8373.450451] R13: ffff888f4c2346c8 R14: ffff888e5cfccf60 R15: ffff888e5=
cfccf68
> [ 8373.457637] FS:=A0=A000007ff1e2e3d5c0(0000) GS:ffff88902f800000(0000)
> knlGS:0000000000000000
> [ 8373.465781] CS:=A0=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 8373.471569] CR2: 00007ff1e286fe8a CR3: 000000092c412000 CR4: 000000000=
01406a0
> [ 8373.478750] Call Trace:
> [ 8373.481219]=A0=A0? cgroup_post_fork+0x350/0x350
> [ 8373.485435]=A0=A0? fpu__drop+0x5e/0x230
> [ 8373.488951]=A0=A0? exit_thread+0x10c/0x160
> [ 8373.492736]=A0=A0do_exit+0x5cb/0x1740
> [ 8373.496083]=A0=A0? check_chain_key+0x142/0x200
> [ 8373.500210]=A0=A0? mm_update_next_owner+0x360/0x360
> [ 8373.504775]=A0=A0? map_id_up+0x14c/0x1f0
> [ 8373.508380]=A0=A0? check_chain_key+0x142/0x200
> [ 8373.512512]=A0=A0? get_signal+0x5f1/0xde0
> [ 8373.516206]=A0=A0? lock_downgrade+0x300/0x300
> [ 8373.520246]=A0=A0? lock_downgrade+0x300/0x300
> [ 8373.524287]=A0=A0do_group_exit+0x78/0x160
> [ 8373.527978]=A0=A0get_signal+0x1e8/0xde0
> [ 8373.531498]=A0=A0do_signal+0x9c/0x9d0
> [ 8373.534841]=A0=A0? check_chain_key+0x142/0x200
> [ 8373.538970]=A0=A0? setup_sigcontext+0x280/0x280
> [ 8373.543185]=A0=A0? lock_downgrade+0x300/0x300
> [ 8373.547228]=A0=A0? kill_pid_info+0x2e/0xd0
> [ 8373.551006]=A0=A0? kill_pid_info+0xa4/0xd0
> [ 8373.554788]=A0=A0? __x64_sys_kill+0x262/0x350
> [ 8373.558830]=A0=A0exit_to_usermode_loop+0x9d/0xc0
> [ 8373.563131]=A0=A0do_syscall_64+0x470/0x5d8
> [ 8373.566910]=A0=A0? syscall_return_slowpath+0xf0/0xf0
> [ 8373.571565]=A0=A0? __do_page_fault+0x44d/0x5b0
> [ 8373.575698]=A0=A0entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 8373.580789] RIP: 0033:0x7ff1e2893c3b
> [ 8373.584402] Code: Bad RIP value.
> [ 8373.587653] RSP: 002b:00007ffd8e5efe78 EFLAGS: 00000206 ORIG_RAX:
> 000000000000003e
> [ 8373.595276] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007ff1e=
2893c3b
> [ 8373.602461] RDX: 0000000000000000 RSI: 000000000000000c RDI: 000000000=
00105d2
> [ 8373.609642] RBP: 0000000000000000 R08: 00000000ffffffff R09: 00007ff1e=
2e3d5c0
> [ 8373.616824] R10: fffffffffffff768 R11: 0000000000000206 R12: 00007ffd8=
e5efe98
> [ 8373.624005] R13: 00007ffd8e5f00c0 R14: 0000000000000000 R15: 000000000=
0000000
> [ 8373.631190] ---[ end trace a7169f3366f1d100 ]---

Hello, Qian!

Thank you for the report!

Can you, please, try if the following patch fixes the problem?

Thank you!

Roman

--

diff --git a/kernel/signal.c b/kernel/signal.c
index 16b72f4f14df..bf2f268f1386 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2484,9 +2484,6 @@ bool get_signal(struct ksignal *ksig)
                sigdelset(&current->pending.signal, SIGKILL);
                recalc_sigpending();
                current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
-               spin_unlock_irq(&sighand->siglock);
-               if (unlikely(cgroup_task_frozen(current)))
-                       cgroup_leave_frozen(true);
                goto fatal;
        }
=20
@@ -2608,8 +2605,10 @@ bool get_signal(struct ksignal *ksig)
                        continue;
                }
=20
-               spin_unlock_irq(&sighand->siglock);
        fatal:
+               spin_unlock_irq(&sighand->siglock);
+               if (unlikely(cgroup_task_frozen(current)))
+                       cgroup_leave_frozen(true);
=20
                /*
                 * Anything else is fatal, maybe with a core dump.
