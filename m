From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: rcu detected stall in __bitmap_parselist
Date: Sun, 1 Apr 2018 19:14:54 +0200
Message-ID: <CACT4Y+aTY4x39ZRSQJ=VHrhd8uPr1tByjNyaWR4p3bpHDirBBA@mail.gmail.com>
References: <0000000000004752520568cc978d@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=uEwIRLgGhGJ/GMxe8JSFIoUXFVtIMKuI10ZXu+AQKRc=;
        b=BKaZP/k8A4cyT8kCWGFDAdDL5Zq9r6YIhSRUjns+fjsLQHV3yAq0Kxp3l5nOZq8CGa
         jM0uJhQov1cE4HWj2GPzIaMJKi9XlE36sG6OjCHSEyWwmQiuEC/oueMIQzt02jWznPSy
         T9eWKOd2O1lAd52gGXwzVaUVULkuZ5MSzaGa7b7R9U+JYNlh2mlr1XNpckgRnnQh5szh
         rhaTLSrnyBA2baLVn2xI4MMbg4GT2ZV/2ZYWKxjw41zaf/t8idVDV76dfTSeA798wPyn
         Cdh9TcRczvUjUy0zGRKzL92XHMmWAqkyNUmhE9HZObE71HbozaP/cVavPhWvr64Dk1Bl
         EYuQ==
In-Reply-To: <0000000000004752520568cc978d@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+1c6aab3af348855fd824@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Zefan Li <lizefan@huawei.com>, syzkaller-bugs@googlegroups.com

On Sun, Apr 1, 2018 at 7:13 PM, syzbot
<syzbot+1c6aab3af348855fd824@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on upstream commit
> 10b84daddbec72c6b440216a69de9a9605127f7a (Sat Mar 31 17:59:00 2018 +0000)
> Merge branch 'perf-urgent-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=1c6aab3af348855fd824
>
> So far this crash happened 8 times on upstream.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=4789350973833216
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=-2760467897697295172
> compiler: gcc (GCC) 7.1.1 20170620
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1c6aab3af348855fd824@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.

#syz dup: INFO: rcu detected stall in bitmap_parselist

> INFO: rcu_sched self-detected stall on CPU
>         1-....: (124999 ticks this GP) idle=99a/1/4611686018427387906
> softirq=145926/145926 fqs=31223
>          (t=125000 jiffies g=76485 c=76484 q=1326)
> NMI backtrace for cpu 1
> CPU: 1 PID: 600 Comm: syz-executor3 Not tainted 4.16.0-rc7+ #374
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  nmi_cpu_backtrace+0x1d2/0x210 lib/nmi_backtrace.c:103
>  nmi_trigger_cpumask_backtrace+0x123/0x180 lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_single_cpu_backtrace include/linux/nmi.h:156 [inline]
>  rcu_dump_cpu_stacks+0x186/0x1de kernel/rcu/tree.c:1375
>  print_cpu_stall kernel/rcu/tree.c:1524 [inline]
>  check_cpu_stall.isra.61+0xbb8/0x15b0 kernel/rcu/tree.c:1592
>  __rcu_pending kernel/rcu/tree.c:3361 [inline]
>  rcu_pending kernel/rcu/tree.c:3423 [inline]
>  rcu_check_callbacks+0x238/0xd20 kernel/rcu/tree.c:2763
>  update_process_times+0x30/0x60 kernel/time/timer.c:1636
>  tick_sched_handle+0x85/0x160 kernel/time/tick-sched.c:162
>  tick_sched_timer+0x42/0x120 kernel/time/tick-sched.c:1194
>  __run_hrtimer kernel/time/hrtimer.c:1349 [inline]
>  __hrtimer_run_queues+0x39c/0xec0 kernel/time/hrtimer.c:1411
>  hrtimer_interrupt+0x2a5/0x6f0 kernel/time/hrtimer.c:1469
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
>  smp_apic_timer_interrupt+0x14a/0x700 arch/x86/kernel/apic/apic.c:1050
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:857
>  </IRQ>
> RIP: 0010:__bitmap_set+0x49/0x110 lib/bitmap.c:261
> RSP: 0018:ffff88018b6a7690 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff12
> RAX: 00000000ffffffc0 RBX: ffffffffffffffff RCX: 0000000000000000
> RDX: 0000000000040000 RSI: 0000000000000000 RDI: ffff8801ac9306a0
> RBP: ffff88018b6a76c8 R08: ffffed00359260d5 R09: ffff8801ac9306a0
> R10: 0000000000000001 R11: ffffed00359260d4 R12: ffffffffffffffff
> R13: 0000000000000000 R14: ffff8801ac9306a0 R15: 0000000000000000
>  bitmap_set include/linux/bitmap.h:365 [inline]
>  __bitmap_parselist+0x310/0x4b0 lib/bitmap.c:616
>  bitmap_parselist+0x3a/0x50 lib/bitmap.c:628
>  cpulist_parse include/linux/cpumask.h:639 [inline]
>  update_cpumask kernel/cgroup/cpuset.c:974 [inline]
>  cpuset_write_resmask+0x1694/0x2850 kernel/cgroup/cpuset.c:1724
>  cgroup_file_write+0x2ae/0x710 kernel/cgroup/cgroup.c:3429
>  kernfs_fop_write+0x2bc/0x440 fs/kernfs/file.c:316
>  __vfs_write+0xef/0x970 fs/read_write.c:480
>  vfs_write+0x189/0x510 fs/read_write.c:544
>  SYSC_write fs/read_write.c:589 [inline]
>  SyS_write+0xef/0x220 fs/read_write.c:581
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x454e79
> RSP: 002b:00007ff0e19eec68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007ff0e19ef6d4 RCX: 0000000000454e79
> RDX: 0000000000000003 RSI: 00000000200000c0 RDI: 0000000000000014
> RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000006b0 R14: 00000000006fc120 R15: 0000000000000000
>
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/0000000000004752520568cc978d%40google.com.
> For more options, visit https://groups.google.com/d/optout.
