From: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>
Subject: Re: WARNING in try_charge
Date: Mon, 06 Aug 2018 04:27:02 -0700
Message-ID: <00000000000070698b0572c28ebc@google.com>
References: <884de816-671a-44d4-a6a1-2ad7eff53715@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <884de816-671a-44d4-a6a1-2ad7eff53715@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com

Tested on:

commit:         8c8399e0a3fb Add linux-next specific files for 20180806
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=1b6bc1781e49e93e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14fe18e2400000

Note: testing is done by a robot and is best-effort only.
