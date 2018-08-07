From: Michal Hocko <mhocko@kernel.org>
Subject: Re: WARNING in try_charge
Date: Tue, 7 Aug 2018 13:25:22 +0200
Message-ID: <20180807112522.GA10003@dhcp22.suse.cz>
References: <20180806181339.GD10003@dhcp22.suse.cz>
 <0000000000002ec4580572c85e46@google.com>
 <20180806185554.GG10003@dhcp22.suse.cz>
 <CACT4Y+Zg3DhAnKWBAyJ-Y-3XVL+jCQy1U2iWR8mdraX6w23X_Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Zg3DhAnKWBAyJ-Y-3XVL+jCQy1U2iWR8mdraX6w23X_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Tue 07-08-18 13:18:00, Dmitry Vyukov wrote:
[...]
> Great we are making progress here!
> 
> So if it's something to fix in kernel we just leave WARN alone. It
> served its intended purpose of notifying kernel developers about
> something to fix in kernel.

Yes, agreed! And the way how your syzbot automation works made it so
much easier so thanks a lot!

The patch has been posted http://lkml.kernel.org/r/20180807072553.14941-1-mhocko@kernel.org
-- 
Michal Hocko
SUSE Labs
