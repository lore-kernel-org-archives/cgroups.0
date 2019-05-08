From: syzbot <syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com>
Subject: Re: WARNING in cgroup_exit
Date: Wed, 08 May 2019 09:52:00 -0700
Message-ID: <000000000000fe103805886326ea@google.com>
References: <000000000000a573da058858083c@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <000000000000a573da058858083c@google.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit
To: alexander.h.duyck@intel.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, dmitry.torokhov@gmail.com, f.fainelli@gmail.com, guro@fb.com, hannes@cmpxchg.org, idosch@mellanox.com, kafai@fb.com, linux-kernel@vger.kernel.org, lizefan@huawei.com, netdev@vger.kernel.org, sfr@canb.auug.org.au, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, tj@kernel.org, tyhicks@canonical.com, wanghai26@huawei.com, yhs@fb.com, yuehaibing@huawei.com

syzbot has bisected this bug to:

commit e42940e8559c8bbffa8286cc78067c75eb42b374
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue May 7 01:03:30 2019 +0000

     Merge remote-tracking branch 'rdma/for-next'

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1746b4e8a00000
start commit:   00c3bc00 Add linux-next specific files for 20190507
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14c6b4e8a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c6b4e8a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63cd766601c6c9fc
dashboard link: https://syzkaller.appspot.com/bug?extid=f14868630901fc6151d3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fcf758a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1202ffa4a00000

Reported-by: syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com
Fixes: e42940e8559c ("Merge remote-tracking branch 'rdma/for-next'")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
