From: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>
Subject: Re: WARNING in try_charge
Date: Mon, 06 Aug 2018 04:00:02 -0700
Message-ID: <000000000000dfe4710572c22d67@google.com>
References: <CACT4Y+ZEAoPWxEJ2yAf6b5cSjAm+MPx1yrk70BWHRrnDYdyb_A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+ZEAoPWxEJ2yAf6b5cSjAm+MPx1yrk70BWHRrnDYdyb_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com

Tested on:

commit:         1ffaddd029c8 Linux 4.18-rc8
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bdb367561cb7285
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=146f9830400000

Note: testing is done by a robot and is best-effort only.
