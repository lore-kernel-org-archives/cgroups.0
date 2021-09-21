From: syzbot <syzbot+533f389d4026d86a2a95-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: [syzbot] general protection fault in percpu_ref_put
Date: Mon, 20 Sep 2021 19:55:16 -0700
Message-ID: <000000000000f8be2b05cc788686@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, dkadashev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org

Hello,

syzbot found the following issue on:

HEAD commit:    4357f03d6611 Merge tag 'pm-5.15-rc2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=173e2d27300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccfb8533b1cbe3b1
dashboard link: https://syzkaller.appspot.com/bug?extid=533f389d4026d86a2a95
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1395c6f1300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11568cad300000

The issue was bisected to:

commit 020250f31c4c75ac7687a673e29c00786582a5f4
Author: Dmitry Kadashev <dkadashev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Thu Jul 8 06:34:43 2021 +0000

    namei: make do_linkat() take struct filename

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137e8a4b300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fe8a4b300000
console output: https://syzkaller.appspot.com/x/log.txt?x=177e8a4b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+533f389d4026d86a2a95-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: 020250f31c4c ("namei: make do_linkat() take struct filename")

general protection fault, probably for non-canonical address 0xdffffc0000000182: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000c10-0x0000000000000c17]
CPU: 1 PID: 148 Comm: kworker/u4:2 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
RIP: 0010:percpu_ref_put_many include/linux/percpu-refcount.h:319 [inline]
RIP: 0010:percpu_ref_put+0x93/0x1d0 include/linux/percpu-refcount.h:338
Code: 01 48 c7 c7 40 58 52 8a be b1 02 00 00 48 c7 c2 80 58 52 8a e8 fe 18 e9 ff 49 bd 00 00 00 00 00 fc ff df 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 9e 73 52 00 48 8b 2b 48 89 ee 48
RSP: 0018:ffffc90000dc0b30 EFLAGS: 00010206
RAX: 0000000000000182 RBX: 0000000000000c10 RCX: ffff888016781c80
RDX: 0000000080000100 RSI: 0000000000000004 RDI: ffff8880b9d32508
RBP: 000000000000003f R08: dffffc0000000000 R09: ffffed10173a64a2
R10: ffffed10173a64a2 R11: 0000000000000000 R12: ffff88806df0a000
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f853d75b740 CR3: 00000000702e7000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 cgroup_bpf_put include/linux/cgroup.h:926 [inline]
 cgroup_sk_free+0x3c/0xa0 kernel/cgroup/cgroup.c:6613
 sk_prot_free net/core/sock.c:1852 [inline]
 __sk_destruct+0x541/0x820 net/core/sock.c:1943
 call_timer_fn+0xf6/0x210 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers+0x71a/0x910 kernel/time/timer.c:1734
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1747
 __do_softirq+0x392/0x7a3 kernel/softirq.c:558
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:lock_acquire+0x21f/0x4d0 kernel/locking/lockdep.c:5629
Code: 08 4c 89 f7 e8 c2 d1 69 00 f6 84 24 81 00 00 00 02 0f 85 13 02 00 00 41 f7 c4 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 04 2f 00 00 00 00 43 c7 44 2f 09 00 00 00 00 43 c7 44 2f 11
RSP: 0018:ffffc9000170f8e0 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 1ffff920002e1f2c RCX: ffff888016782670
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000170fa40 R08: dffffc0000000000 R09: fffffbfff1fa2fc1
R10: fffffbfff1fa2fc1 R11: 0000000000000000 R12: 0000000000000246
R13: 1ffff920002e1f24 R14: ffffc9000170f960 R15: dffffc0000000000
 rcu_lock_acquire+0x2a/0x30 include/linux/rcupdate.h:267
 rcu_read_lock include/linux/rcupdate.h:687 [inline]
 inet_twsk_purge+0x11b/0x890 net/ipv4/inet_timewait_sock.c:268
 ops_exit_list net/core/net_namespace.c:171 [inline]
 cleanup_net+0x7ec/0xc50 net/core/net_namespace.c:591
 process_one_work+0x853/0x1140 kernel/workqueue.c:2297
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2444
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30
Modules linked in:
---[ end trace 6ae4e3b5aac552a5 ]---
RIP: 0010:__ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
RIP: 0010:percpu_ref_put_many include/linux/percpu-refcount.h:319 [inline]
RIP: 0010:percpu_ref_put+0x93/0x1d0 include/linux/percpu-refcount.h:338
Code: 01 48 c7 c7 40 58 52 8a be b1 02 00 00 48 c7 c2 80 58 52 8a e8 fe 18 e9 ff 49 bd 00 00 00 00 00 fc ff df 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 9e 73 52 00 48 8b 2b 48 89 ee 48
RSP: 0018:ffffc90000dc0b30 EFLAGS: 00010206
RAX: 0000000000000182 RBX: 0000000000000c10 RCX: ffff888016781c80
RDX: 0000000080000100 RSI: 0000000000000004 RDI: ffff8880b9d32508
RBP: 000000000000003f R08: dffffc0000000000 R09: ffffed10173a64a2
R10: ffffed10173a64a2 R11: 0000000000000000 R12: ffff88806df0a000
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f853d75b740 CR3: 000000000c68e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	48 c7 c7 40 58 52 8a 	mov    $0xffffffff8a525840,%rdi
   7:	be b1 02 00 00       	mov    $0x2b1,%esi
   c:	48 c7 c2 80 58 52 8a 	mov    $0xffffffff8a525880,%rdx
  13:	e8 fe 18 e9 ff       	callq  0xffe91916
  18:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  1f:	fc ff df
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 9e 73 52 00       	callq  0x5273d6
  38:	48 8b 2b             	mov    (%rbx),%rbp
  3b:	48 89 ee             	mov    %rbp,%rsi
  3e:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
