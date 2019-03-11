From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: KASAN: null-ptr-deref Read in reclaim_high
Date: Mon, 11 Mar 2019 16:37:47 -0700
Message-ID: <20190311163747.f56cceebd9c2661e4519bdfc@linux-foundation.org>
References: <0000000000001fd5780583d1433f@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000001fd5780583d1433f@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, mhocko@suse.com, sfr@canb.auug.org.au, shakeelb@google.com, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On Mon, 11 Mar 2019 06:08:01 -0700 syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com> wrote:

> syzbot has bisected this bug to:
> 
> commit 29a4b8e275d1f10c51c7891362877ef6cffae9e7
> Author: Shakeel Butt <shakeelb@google.com>
> Date:   Wed Jan 9 22:02:21 2019 +0000
> 
>      memcg: schedule high reclaim for remote memcgs on high_work
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155bf5db200000
> start commit:   29a4b8e2 memcg: schedule high reclaim for remote memcgs on..
> git tree:       linux-next
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=175bf5db200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=135bf5db200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=611f89e5b6868db
> dashboard link: https://syzkaller.appspot.com/bug?extid=fa11f9da42b46cea3b4a
> userspace arch: amd64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14259017400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141630a0c00000
> 
> Reported-by: syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com
> Fixes: 29a4b8e2 ("memcg: schedule high reclaim for remote memcgs on  
> high_work")

The following patch
memcg-schedule-high-reclaim-for-remote-memcgs-on-high_work-v3.patch
might have fixed this.  Was it applied?
