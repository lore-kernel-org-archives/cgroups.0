From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: null-ptr-deref Read in reclaim_high
Date: Tue, 12 Mar 2019 07:08:38 +0100
Message-ID: <CACT4Y+byKQSOCte3JS9XOnyr+aVSEFtBvLxG2-HUrZX3-82Hcg@mail.gmail.com>
References: <0000000000001fd5780583d1433f@google.com> <20190311163747.f56cceebd9c2661e4519bdfc@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1JiQ1cf1uHp+tMakySvUAuKGEi8FGoygCN9wkQMXqw=;
        b=hqE6AUsrdIaw8AqgtLspHLAVKb5SxCwC13bRoQ+Z0wXsi36QiN13hYYns2oMwfN6qO
         Pc8GSslcZrTFHx+8t2295LkvYl28Oia+4xOaj0EUqW0xLreRAVcsNOiyvls9FHg5Hitw
         5PARefocPhP7I/YbPrPyxPfC518gAUgj23ET9aaCDOrZxUaVlesbZWpGxRwxd7jaE+5J
         wC0ypf6VGxVCc5XixFadnCaB1n5jJQu6rdgO5eE/wMwWsjUgKM7XGZMcg/8ZXv41k5Oo
         d8WmszRQ+rfKrZay/cpoqmTHKNlZjsJe0pTj6SN32Dv98bDzjmMIkX6VW08aG7bJB3XT
         xLWQ==
In-Reply-To: <20190311163747.f56cceebd9c2661e4519bdfc@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Tue, Mar 12, 2019 at 12:37 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 11 Mar 2019 06:08:01 -0700 syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com> wrote:
>
> > syzbot has bisected this bug to:
> >
> > commit 29a4b8e275d1f10c51c7891362877ef6cffae9e7
> > Author: Shakeel Butt <shakeelb@google.com>
> > Date:   Wed Jan 9 22:02:21 2019 +0000
> >
> >      memcg: schedule high reclaim for remote memcgs on high_work
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155bf5db200000
> > start commit:   29a4b8e2 memcg: schedule high reclaim for remote memcgs on..
> > git tree:       linux-next
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=175bf5db200000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=135bf5db200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=611f89e5b6868db
> > dashboard link: https://syzkaller.appspot.com/bug?extid=fa11f9da42b46cea3b4a
> > userspace arch: amd64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14259017400000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141630a0c00000
> >
> > Reported-by: syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com
> > Fixes: 29a4b8e2 ("memcg: schedule high reclaim for remote memcgs on
> > high_work")
>
> The following patch
> memcg-schedule-high-reclaim-for-remote-memcgs-on-high_work-v3.patch
> might have fixed this.  Was it applied?

Hi Andrew,

You mean if the patch was applied during the bisection?
No, it wasn't. Bisection is very specifically done on the same tree
where the bug was hit. There are already too many factors that make
the result flaky/wrong/inconclusive without changing the tree state.
Now, if syzbot would know about any pending fix for this bug, then it
would not do the bisection at all. But it have not seen any patch in
upstream/linux-next with the Reported-by tag, nor it received any syz
fix commands for this bugs. Should have been it aware of the fix? How?

Thanks
