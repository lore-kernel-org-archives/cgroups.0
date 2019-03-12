From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: KASAN: null-ptr-deref Read in reclaim_high
Date: Tue, 12 Mar 2019 15:31:15 -0700
Message-ID: <20190312223113.GA38846@gmail.com>
References: <0000000000001fd5780583d1433f@google.com>
 <20190311163747.f56cceebd9c2661e4519bdfc@linux-foundation.org>
 <CACT4Y+byKQSOCte3JS9XOnyr+aVSEFtBvLxG2-HUrZX3-82Hcg@mail.gmail.com>
 <20190311232541.db8571d2e3e0ca636785f31f@linux-foundation.org>
 <20190312064300.GB9123@sol.localdomain>
 <CACT4Y+Z1rkS5bf3x9Y+0ke=zZ+mM2F5+vN-JtSQpjD09STRNdw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552429876;
        bh=E9LjOuH7NlwjEdXrTTN9jNJ+sUFTiiXDJcLC3CteIKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mgDX2Ja0bynZtaS+WaK0y1rIkv62DHI1nWFmMJVzq0Ab5gTiYtd3ESuN0la/2mzia
         ssElYhG4GEHO30ZyTTSfAA+ij6UvykwLWf125Q6r7jfYwZtx7X8+AhTPaf2rYFUvRK
         scu7n6Pk8F6/V+jQh3VeCW6SbeYVd0gpGU7wmV0E=
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z1rkS5bf3x9Y+0ke=zZ+mM2F5+vN-JtSQpjD09STRNdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

Hi Dmitry,

On Tue, Mar 12, 2019 at 09:21:09AM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> On Tue, Mar 12, 2019 at 7:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Mon, Mar 11, 2019 at 11:25:41PM -0700, Andrew Morton wrote:
> > > On Tue, 12 Mar 2019 07:08:38 +0100 Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > > On Tue, Mar 12, 2019 at 12:37 AM Andrew Morton
> > > > <akpm@linux-foundation.org> wrote:
> > > > >
> > > > > On Mon, 11 Mar 2019 06:08:01 -0700 syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > > syzbot has bisected this bug to:
> > > > > >
> > > > > > commit 29a4b8e275d1f10c51c7891362877ef6cffae9e7
> > > > > > Author: Shakeel Butt <shakeelb@google.com>
> > > > > > Date:   Wed Jan 9 22:02:21 2019 +0000
> > > > > >
> > > > > >      memcg: schedule high reclaim for remote memcgs on high_work
> > > > > >
> > > > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155bf5db200000
> > > > > > start commit:   29a4b8e2 memcg: schedule high reclaim for remote memcgs on..
> > > > > > git tree:       linux-next
> > > > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=175bf5db200000
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=135bf5db200000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=611f89e5b6868db
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=fa11f9da42b46cea3b4a
> > > > > > userspace arch: amd64
> > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14259017400000
> > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141630a0c00000
> > > > > >
> > > > > > Reported-by: syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com
> > > > > > Fixes: 29a4b8e2 ("memcg: schedule high reclaim for remote memcgs on
> > > > > > high_work")
> > > > >
> > > > > The following patch
> > > > > memcg-schedule-high-reclaim-for-remote-memcgs-on-high_work-v3.patch
> > > > > might have fixed this.  Was it applied?
> > > >
> > > > Hi Andrew,
> > > >
> > > > You mean if the patch was applied during the bisection?
> > > > No, it wasn't. Bisection is very specifically done on the same tree
> > > > where the bug was hit. There are already too many factors that make
> > > > the result flaky/wrong/inconclusive without changing the tree state.
> > > > Now, if syzbot would know about any pending fix for this bug, then it
> > > > would not do the bisection at all. But it have not seen any patch in
> > > > upstream/linux-next with the Reported-by tag, nor it received any syz
> > > > fix commands for this bugs. Should have been it aware of the fix? How?
> > >
> > > memcg-schedule-high-reclaim-for-remote-memcgs-on-high_work-v3.patch was
> > > added to linux-next on Jan 10.  I take it that this bug was hit when
> > > testing the entire linux-next tree, so we can assume that
> > > memcg-schedule-high-reclaim-for-remote-memcgs-on-high_work-v3.patch
> > > does not fix it, correct?
> > >
> > > In which case, over to Shakeel!
> > >
> >
> > I don't understand what happened here.  First, the syzbot report doesn't say
> > which linux-next version was tested (which it should), but I get:
> >
> > $ git tag --contains 29a4b8e275d1f10c51c7891362877ef6cffae9e7
> > next-20190110
> > next-20190111
> > next-20190114
> > next-20190115
> > next-20190116
> >
> > That's almost 2 months old, yet this bug was just reported now.  Why?
> 
> Hi Eric,
> 
> This bug was reported on Jan 10:
> https://syzkaller.appspot.com/bug?extid=fa11f9da42b46cea3b4a
> https://groups.google.com/forum/#!msg/syzkaller-bugs/5YkhNUg2PFY/4-B5M7bDCAAJ
> 
> The start revision of the bisection process (provided) is the same
> that was used to create the reproducer. The end revision and bisection
> log are provided in the email.
> 
> How can we improve the format to make it more clear?
> 

syzbot started a new thread rather than sending the bisection result in the
existing thread.  So I thought it was a new bug report, as did everyone else
probably.

- Eric
