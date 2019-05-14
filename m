From: Matteo Croce <mcroce@redhat.com>
Subject: WARNING: CPU: 1 PID: 228 at kernel/cgroup/cgroup.c:5929
Date: Tue, 14 May 2019 21:23:48 +0200
Message-ID: <CAGnkfhwMSNm4uSkcGtqaGmYanfNK9rx6m2a3TqJh08YitbGAUg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

Hi,

I have the following splat when a ptraced process exits:

root@debian64:~# strace true
execve("/bin/true", ["true"], 0x7ffd444fdfb0 /* 18 vars */) = 0
[..]
exit_group(0)                           = ?
[    5.394349] WARNING: CPU: 1 PID: 228 at kernel/cgroup/cgroup.c:5929 cgroup_exit+0xed/0x100
[    5.394606] CPU: 1 PID: 228 Comm: true Not tainted 5.1.0-rc3-kvm+ #86
[    5.394819] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-2.fc30 04/01/2014
[    5.395091] RIP: 0010:cgroup_exit+0xed/0x100
[    5.395269] Code: 04 89 c3 7e d5 48 83 c4 08 5b 5d c3 f0 ff 43 28 0f 88 8e 4d 34 00 eb a3 48 8b 85 78 06 00 00 48 8b 78 38 e8 e5 25 00 00 eb 82 <0f> 0b e9 5f ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 55 be 05
[    5.395827] RSP: 0018:ffffc9000037be38 EFLAGS: 00010002
[    5.396009] RAX: ffff88807be8bc40 RBX: ffff888078f62400 RCX: ffff888078f62468
[    5.396236] RDX: ffff888078f62448 RSI: ffff888078f62400 RDI: ffff888078f62408
[    5.396463] RBP: ffff888078f89580 R08: ffff888078f89c60 R09: 0000000000000000
[    5.396692] R10: ffff88807adc1100 R11: 0000000000000001 R12: ffff888078f89580
[    5.396919] R13: ffff888078f89b80 R14: 0000000000000000 R15: ffff888078ed4060
[    5.397169] FS:  0000000000000000(0000) GS:ffff88807da80000(0000) knlGS:0000000000000000
[    5.397425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.397614] CR2: 00007f017ea1d9a0 CR3: 0000000001a0c000 CR4: 00000000000006a0
[    5.397846] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.398097] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    5.398324] Call Trace:
[    5.398408]  do_exit+0x27f/0xa10
[    5.398550]  ? ptrace_do_notify+0x6c/0x80
[    5.398694]  do_group_exit+0x35/0xa0
[    5.398838]  __x64_sys_exit_group+0xf/0x10
[    5.398983]  do_syscall_64+0x48/0x340
[    5.399127]  ? __do_page_fault+0x1aa/0x3f0
[    5.399272]  ? __put_user_4+0x19/0x20
[    5.399418]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    5.399598] RIP: 0033:0x7f017ea1d9d6
[    5.399745] Code: Bad RIP value.
[    5.399885] RSP: 002b:00007ffc187f7aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[    5.400144] RAX: ffffffffffffffda RBX: 00007f017eb0e760 RCX: 00007f017ea1d9d6
[    5.400370] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[    5.400601] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff80
[    5.400858] R10: 00007ffc187f7974 R11: 0000000000000246 R12: 00007f017eb0e760
[    5.401105] R13: 0000000000000001 R14: 00007f017eb17428 R15: 0000000000000000
[    5.401337] ---[ end trace 6bf3ae0d5396cf27 ]---

I found the offending commit bisecting, and seems to be this one.

commit 96b9c592def5d7203bdad1337d9c92a2183de5cb
Author: Roman Gushchin <guro@fb.com>
Date:   Fri Apr 26 10:59:45 2019 -0700

    cgroup: get rid of cgroup_freezer_frozen_exit()


Regards,
-- 
Matteo Croce
per aspera ad upstream
