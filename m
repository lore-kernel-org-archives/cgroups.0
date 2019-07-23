From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] mm/backing-dev: show state of all bdi_writeback in debugfs
Date: Wed, 24 Jul 2019 00:24:41 +0300
Message-ID: <CALYGNiMw_9MKxfCxq9QsXi3PbwQMwKmLufQqUnhYdt8C+sR2rA@mail.gmail.com>
References: <156388617236.3608.2194886130557491278.stgit@buzz> <20190723130729.522976a1f075d748fc946ff6@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M6w3AQT/kAXXnbql10OE6lR9hDAhCRnli8EPorWLJVk=;
        b=QGJNkRZsxv5Zuf3BgPCZSqKQFZGj+62TufloKtPG2MZHXVGH1Gd0Lp6K2ETJIbCSjh
         9H8asFqfqbKMBBxMrqWl9WTuBXgxsHM7Hvujxd7Mwzg0TCSP+fQqr1kIT1Sb984JAHC3
         KFRtHdL8Nomx/M8Jrwx69IAiJJZKW1vawnwm6x6dcOqS/ZUdTMSZsXPw0d+5Z9j5hIlq
         rVAmZv0JRn+cBmfh4L4vnMcFIHHYgRJg/C2jixIYFE5ZqVpGxI5UgWCGqmddrraX8EbC
         V9YLC2jwBhDTpcvB8SfLT3PTMul+gIi/+9fKTr0YhWbOURJVhIsrLU0TaeW1+B7rgdxl
         DK5Q==
In-Reply-To: <20190723130729.522976a1f075d748fc946ff6@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>

On Tue, Jul 23, 2019 at 11:07 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 23 Jul 2019 15:49:32 +0300 Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:
>
> > Currently /sys/kernel/debug/bdi/$maj:$min/stats shows only root bdi wb.
> > With CONFIG_CGROUP_WRITEBACK=y there is one for each memory cgroup.
> >
> > This patch shows here state of each bdi_writeback in form:
> >
> > <global state>
> >
> > Id: 1
> > Cgroup: /
> > <root wb state>
> >
> > Id: xxx
> > Cgroup: /path
> > <cgroup wb state>
> >
> > Id: yyy
> > Cgroup: /path2
> > <cgroup wb state>
>
> Why is this considered useful?  What are the use cases.  ie, why should
> we add this to Linux?
>
> > mm/backing-dev.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++-------
> > 1 file changed, 93 insertions(+), 13 deletions(-)
>
> No documentation because it's debugfs, right?
>
> I'm struggling to understand why this is a good thing :(.  If it's
> there and people use it then we should document it for them.  If it's
> there and people don't use it then we should delete the code.
>

Well. Cgroup writeback has huge internal state:
bdi_writeback for each pair (bdi, memory cgroup ) which refers to some
blkio cgroup.
Each of them has writeback rate estimation, bunch of counters for
pages and flows and so on.
All this rich state almost completely hidden and gives no clue when
something goes wrong.
Debugging such dynamic structure with gdb is a pain.

Also all these features are artificially tied with cgroup2 interface
so almost nobody use them right now.

This patch extends legacy debug manhole to expose bit of actual state.
Alternative is exactly removing this debugfs file.

I'm using this debugfs interface for croups and find it very useful:
https://lore.kernel.org/patchwork/patch/973846/
but writeback has another dimension so needs own interface.
