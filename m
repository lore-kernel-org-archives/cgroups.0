From: syzbot <syzbot+3ba0493d523d007b3819@syzkaller.appspotmail.com>
Subject: Re: [syzbot] INFO: rcu detected stall in net_tx_action
Date: Tue, 26 Jul 2022 08:50:09 -0700
Message-ID: <0000000000004bee3605e4b74106@google.com>
References: <00000000000026864605c611cc51@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <00000000000026864605c611cc51@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, cgroups@vger.kernel.org, fweisbec@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ming.lei@redhat.com, mingo@kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org

syzbot suspects this issue was fixed by commit:

commit 0a9a25ca78437b39e691bcc3dc8240455b803d8d
Author: Ming Lei <ming.lei@redhat.com>
Date:   Fri Mar 18 13:01:43 2022 +0000

    block: let blkcg_gq grab request queue's refcnt

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1004f05a080000
start commit:   d6765985a42a Revert "be2net: disable bh with spin_lock in ..
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
dashboard link: https://syzkaller.appspot.com/bug?extid=3ba0493d523d007b3819
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c9edc8300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172463c8300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: block: let blkcg_gq grab request queue's refcnt

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
