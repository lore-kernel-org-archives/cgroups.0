From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: rcu detected stall in __bitmap_set
Date: Sun, 1 Apr 2018 19:14:38 +0200
Message-ID: <CACT4Y+YbnyOckSDRF2_10jNGX2acdiZ8kdopF5Uc6rjfXdnm=g@mail.gmail.com>
References: <001a113eba28c654440568cc9604@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=KJtwQT26EzxIyS0nfAvclGiuzqK+zIfCuiQ9B4a4Zi4=;
        b=oYE7v50jA45jOyZAHMtM/QFj+4Y0SgoI69NDm0qQJqk0Tbf8HBcqffKqNCpHqnCDZJ
         fJRkQTXgCc5EHN7omx9sRHjvjeJporzSxwpP0uSNp6th4+mE0Krh5hWqbbSDxbiJUM5X
         sMgvdKFeNdJkIxZaRuiTBzCrWnh9hv2T5LkpzivZZE7nROE4+Ov4NVf6o1b9Ub78wJg/
         FPTYdE0qP0/meZTvrd4yaEfo87SgVDkC1fX9E6Ih2W6JKu/W6x0Gu1tQrFouPLDQMjtE
         0th736lBCvbMewgghFAbz2R52QPKa1vZm90kUlUbGFsW/xY1A83BI9MUrSWFsxefThzl
         s0kw==
In-Reply-To: <001a113eba28c654440568cc9604@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+c479aeac880b090ceeb2@syzkaller.appspotmail.com>, cgroups@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Philippe Ombredanne <pombredanne@nexb.com>, syzkaller-bugs@googlegroups.com, Victor Chibotaru <tchibo@google.com>, Thomas Gleixner <tglx@linutronix.de>

On Sun, Apr 1, 2018 at 7:13 PM, syzbot
<syzbot+c479aeac880b090ceeb2@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on upstream commit
> cb6416592bc2a8b731dabcec0d63cda270764fc6 (Sun Mar 25 17:45:10 2018 +0000)
> Merge tag 'dmaengine-fix-4.16-rc7' of
> git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/slave-dma
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=c479aeac880b090ceeb2
>
> So far this crash happened 3 times on upstream.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=5205501092560896
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=-5034017172441945317
> compiler: gcc (GCC) 7.1.1 20170620
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c479aeac880b090ceeb2@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.

#syz dup: INFO: rcu detected stall in bitmap_parselist

> INFO: rcu_sched self-detected stall on CPU
>         1-....: (124999 ticks this GP) idle=1ca/1/4611686018427387906
> softirq=17365/17365 fqs=31238
>          (t=125000 jiffies g=7965 c=7964 q=402)
> NMI backtrace for cpu 1
> CPU: 1 PID: 6633 Comm: syz-executor6 Not tainted 4.16.0-rc6+ #366
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
> RIP: 0010:__read_once_size include/linux/compiler.h:188 [inline]
> RIP: 0010:__sanitizer_cov_trace_pc+0x3b/0x50 kernel/kcov.c:106
> RSP: 0018:ffff8801ce8ef680 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff12
> RAX: 0000000000010000 RBX: ffffffffffffff80 RCX: ffffffff825ae73d
> RDX: 000000000000ffff RSI: ffffc90004a0d000 RDI: ffff8801d1a15660
> RBP: ffff8801ce8ef680 R08: ffffed003a342acd R09: ffff8801d1a15660
> R10: 0000000000000001 R11: ffffed003a342acc R12: ffffffffffffffff
> R13: 0000000000000000 R14: ffff8801d1a15660 R15: 0000000000000000
>  __bitmap_set+0xdd/0x110 lib/bitmap.c:274
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
> RIP: 0033:0x454879
> RSP: 002b:00007fd0e0f38c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fd0e0f396d4 RCX: 0000000000454879
> RDX: 0000000000000008 RSI: 0000000020000080 RDI: 0000000000000015
> RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 000000000000067c R14: 00000000006fac40 R15: 0000000000000000
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
