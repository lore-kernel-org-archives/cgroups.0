From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in get_mem_cgroup_from_mm
Date: Mon, 4 Mar 2019 15:11:13 +0100
Message-ID: <CACT4Y+agwaszODNGJHCqn4fSk4Le9exn3Cau0nornJ0RaTpDJw@mail.gmail.com>
References: <00000000000006457e057c341ff8@google.com> <5C7BFE94.6070500@huawei.com>
 <CACT4Y+Z+CH0UTdSz-w_woMPrBwg-GuobV1Su4qd9ReffTkyfVg@mail.gmail.com> <5C7D2F82.40907@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqxJghP918UPMYvFNBhGMvF0VxjxcsMTEAmWEQ5o17E=;
        b=l1xFb9c2QlxGXGkf9K60t3GcMhuKxCPgZHcvgYn9Y8q6Av/jL+4ez91RQ+CCRCD457
         K6G3x+kYiL3TanU8A2R51RIZjVB5Qgaawv9skR2tuIWWvMcH9nOfmgWEeHf4pGQWd1kR
         4dqd1XUf4lxJBfXtT+CBltGtw9lFHevF1Eu0dzjOuZH6/c/6CsooOuQkN7Q9XZ5FPIbk
         93qZJVMs8pV9/QeNUZgK2nbGKynBNkPiPxy+WABbzWF9OieUu6dtYQYx2RHlAk4JiOJu
         dX4W1Dw4iDsgocLShOweRDEg8GEcLbOYX6sMWwUlGGv9ZSHNq1m5gdh5JbmYwnrg9GUB
         M3Iw==
In-Reply-To: <5C7D2F82.40907@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhong jiang <zhongjiang@huawei.com>
Cc: syzbot <syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com>, Michal Hocko <mhocko@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>

On Mon, Mar 4, 2019 at 3:00 PM zhong jiang <zhongjiang@huawei.com> wrote:
>
> On 2019/3/4 15:40, Dmitry Vyukov wrote:
> > On Sun, Mar 3, 2019 at 5:19 PM zhong jiang <zhongjiang@huawei.com> wrote:
> >> Hi, guys
> >>
> >> I also hit the following issue. but it fails to reproduce the issue by the log.
> >>
> >> it seems to the case that we access the mm->owner and deference it will result in the UAF.
> >> But it should not be possible that we specify the incomplete process to be the mm->owner.
> >>
> >> Any thoughts?
> > FWIW syzbot was able to reproduce this with this reproducer.
> > This looks like a very subtle race (threaded reproducer that runs
> > repeatedly in multiple processes), so most likely we are looking for
> > something like few instructions inconsistency window.
> >
>
> I has a little doubtful about the instrustions inconsistency window.
>
> I guess that you mean some smb barriers should be taken into account.:-)
>
> Because IMO, It should not be the lock case to result in the issue.


Since the crash was triggered on x86 _most likley_ this is not a
missed barrier. What I meant is that one thread needs to executed some
code, while another thread is stopped within few instructions.



> Thanks,
> zhong jinag
> >> Thanks,
> >> zhong jiang
> >>
> >> On 2018/12/4 23:43, syzbot wrote:
> >>> syzbot has found a reproducer for the following crash on:
> >>>
> >>> HEAD commit:    0072a0c14d5b Merge tag 'media/v4.20-4' of git://git.kernel..
> >>> git tree:       upstream
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=11c885a3400000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b9cc5a440391cbfd
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=cbb52e396df3e565ab02
> >>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12835e25400000
> >>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172fa5a3400000
> >>>
> >>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >>> Reported-by: syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com
> >>>
> >>> cgroup: fork rejected by pids controller in /syz2
> >>> ==================================================================
> >>> BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:182 [inline]
> >>> BUG: KASAN: use-after-free in task_css include/linux/cgroup.h:477 [inline]
> >>> BUG: KASAN: use-after-free in mem_cgroup_from_task mm/memcontrol.c:815 [inline]
> >>> BUG: KASAN: use-after-free in get_mem_cgroup_from_mm.part.62+0x6d7/0x880 mm/memcontrol.c:844
> >>> Read of size 8 at addr ffff8881b72af310 by task syz-executor198/9332
> >>>
> >>> CPU: 0 PID: 9332 Comm: syz-executor198 Not tainted 4.20.0-rc5+ #142
> >>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >>> Call Trace:
> >>>  __dump_stack lib/dump_stack.c:77 [inline]
> >>>  dump_stack+0x244/0x39d lib/dump_stack.c:113
> >>>  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
> >>>  kasan_report_error mm/kasan/report.c:354 [inline]
> >>>  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
> >>>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> >>>  __read_once_size include/linux/compiler.h:182 [inline]
> >>>  task_css include/linux/cgroup.h:477 [inline]
> >>>  mem_cgroup_from_task mm/memcontrol.c:815 [inline]
> >>>  get_mem_cgroup_from_mm.part.62+0x6d7/0x880 mm/memcontrol.c:844
> >>>  get_mem_cgroup_from_mm mm/memcontrol.c:834 [inline]
> >>>  mem_cgroup_try_charge+0x608/0xe20 mm/memcontrol.c:5888
> >>>  mcopy_atomic_pte mm/userfaultfd.c:71 [inline]
> >>>  mfill_atomic_pte mm/userfaultfd.c:418 [inline]
> >>>  __mcopy_atomic mm/userfaultfd.c:559 [inline]
> >>>  mcopy_atomic+0xb08/0x2c70 mm/userfaultfd.c:609
> >>>  userfaultfd_copy fs/userfaultfd.c:1705 [inline]
> >>>  userfaultfd_ioctl+0x29fb/0x5610 fs/userfaultfd.c:1851
> >>>  vfs_ioctl fs/ioctl.c:46 [inline]
> >>>  file_ioctl fs/ioctl.c:509 [inline]
> >>>  do_vfs_ioctl+0x1de/0x1790 fs/ioctl.c:696
> >>>  ksys_ioctl+0xa9/0xd0 fs/ioctl.c:713
> >>>  __do_sys_ioctl fs/ioctl.c:720 [inline]
> >>>  __se_sys_ioctl fs/ioctl.c:718 [inline]
> >>>  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> >>>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>> RIP: 0033:0x44c7e9
> >>> Code: 5d c5 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b c5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> >>> RSP: 002b:00007f906b69fdb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> >>> RAX: ffffffffffffffda RBX: 00000000006e4a08 RCX: 000000000044c7e9
> >>> RDX: 0000000020000100 RSI: 00000000c028aa03 RDI: 0000000000000004
> >>> RBP: 00000000006e4a00 R08: 0000000000000000 R09: 0000000000000000
> >>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e4a0c
> >>> R13: 00007ffdfd47813f R14: 00007f906b6a09c0 R15: 000000000000002d
> >>>
> >>> Allocated by task 9325:
> >>>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
> >>>  set_track mm/kasan/kasan.c:460 [inline]
> >>>  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
> >>>  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
> >>>  kmem_cache_alloc_node+0x144/0x730 mm/slab.c:3644
> >>>  alloc_task_struct_node kernel/fork.c:158 [inline]
> >>>  dup_task_struct kernel/fork.c:843 [inline]
> >>>  copy_process+0x2026/0x87a0 kernel/fork.c:1751
> >>>  _do_fork+0x1cb/0x11d0 kernel/fork.c:2216
> >>>  __do_sys_clone kernel/fork.c:2323 [inline]
> >>>  __se_sys_clone kernel/fork.c:2317 [inline]
> >>>  __x64_sys_clone+0xbf/0x150 kernel/fork.c:2317
> >>>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>>
> >>> Freed by task 9325:
> >>>  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
> >>>  set_track mm/kasan/kasan.c:460 [inline]
> >>>  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
> >>>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
> >>>  __cache_free mm/slab.c:3498 [inline]
> >>>  kmem_cache_free+0x83/0x290 mm/slab.c:3760
> >>>  free_task_struct kernel/fork.c:163 [inline]
> >>>  free_task+0x16e/0x1f0 kernel/fork.c:457
> >>>  copy_process+0x1dcc/0x87a0 kernel/fork.c:2148
> >>>  _do_fork+0x1cb/0x11d0 kernel/fork.c:2216
> >>>  __do_sys_clone kernel/fork.c:2323 [inline]
> >>>  __se_sys_clone kernel/fork.c:2317 [inline]
> >>>  __x64_sys_clone+0xbf/0x150 kernel/fork.c:2317
> >>>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>>
> >>> The buggy address belongs to the object at ffff8881b72ae240
> >>>  which belongs to the cache task_struct(81:syz2) of size 6080
> >>> The buggy address is located 4304 bytes inside of
> >>>  6080-byte region [ffff8881b72ae240, ffff8881b72afa00)
> >>> The buggy address belongs to the page:
> >>> page:ffffea0006dcab80 count:1 mapcount:0 mapping:ffff8881d2dce0c0 index:0x0 compound_mapcount: 0
> >>> flags: 0x2fffc0000010200(slab|head)
> >>> raw: 02fffc0000010200 ffffea00074a1f88 ffffea0006ebbb88 ffff8881d2dce0c0
> >>> raw: 0000000000000000 ffff8881b72ae240 0000000100000001 ffff8881d87fe580
> >>> page dumped because: kasan: bad access detected
> >>> page->mem_cgroup:ffff8881d87fe580
> >>>
> >>> Memory state around the buggy address:
> >>>  ffff8881b72af200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >>>  ffff8881b72af280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >>>> ffff8881b72af300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >>>                          ^
> >>>  ffff8881b72af380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >>>  ffff8881b72af400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >>> ==================================================================
> >>>
> >>>
> >>> .
> >>>
> >>
> >> --
> >> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> >> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> >> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/5C7BFE94.6070500%40huawei.com.
> >> For more options, visit https://groups.google.com/d/optout.
> > .
> >
>
>
