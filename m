From: syzbot <syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in css_task_iter_advance
Date: Tue, 04 Jun 2019 23:47:00 -0700
Message-ID: <000000000000e878a9058a8df684@google.com>
References: <00000000000097025d058a7fd785@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <00000000000097025d058a7fd785@google.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit
To: ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com, linux-kernel@vger.kernel.org, lizefan@huawei.com, netdev@vger.kernel.org, oleg@redhat.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, tj@kernel.org, yhs@fb.com

syzbot has bisected this bug to:

commit b636fd38dc40113f853337a7d2a6885ad23b8811
Author: Tejun Heo <tj@kernel.org>
Date:   Fri May 31 17:38:58 2019 +0000

     cgroup: Implement css_task_iter_skip()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1256fcd2a00000
start commit:   56b697c6 Add linux-next specific files for 20190604
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1156fcd2a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1656fcd2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4248d6bc70076f7d
dashboard link: https://syzkaller.appspot.com/bug?extid=9343b7623bc03dc680c1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102ab292a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f0e27ca00000

Reported-by: syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com
Fixes: b636fd38dc40 ("cgroup: Implement css_task_iter_skip()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
