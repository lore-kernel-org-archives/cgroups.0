From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: null-ptr-deref Read in reclaim_high
Date: Wed, 13 Mar 2019 09:24:21 +0100
Message-ID: <CACT4Y+a775wdkjQcsZTLG_Jr4k2gSXnOQF6ZTJDPOc-kvPG9Xw@mail.gmail.com>
References: <0000000000001fd5780583d1433f@google.com> <20190311163747.f56cceebd9c2661e4519bdfc@linux-foundation.org>
 <CACT4Y+byKQSOCte3JS9XOnyr+aVSEFtBvLxG2-HUrZX3-82Hcg@mail.gmail.com>
 <20190311232541.db8571d2e3e0ca636785f31f@linux-foundation.org>
 <CACT4Y+Y0JdB-=yLLchw8icokn11iH2-XYoLJEOFKm6F88fJ3WQ@mail.gmail.com> <20190312225044.GB38846@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sWJhYk8XbJOljfYTwYXHU5dnczu5ZXpBjImg0UmG4eI=;
        b=L/YWlBOTVQ7xGetSIeg1oKOzbvAiqlPKIsnqzhO34EJOWCqI2SCXtEE8ktSnT5bkD5
         oxnSgNcfRMuHVY8oHsmACCw34mZN7zC/expYI3kueaMR6oCW6dGtlXWvvmU8st3+Ujcs
         JmNFDehqh9zcNaSehShsEdXXlC/axU1Z5lkInjXgnUrqWLjhXmiCPN8e+SQ0ae7AF7kE
         9l2CbuluoVQl3zyqSJzbaQjE0CdQZeY9gCm99reLPnLQo4nHpDBEy7aomVapTCfvoZ8F
         TM8M90u2o9vb6n4cTRXMUy9x9gcys1YOew/dHgrpGxRfIvnaqW4jBLtpSvHzRAo+fgkH
         mCLg==
In-Reply-To: <20190312225044.GB38846@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, syzbot <syzbot+fa11f9da42b46cea3b4a@syzkaller.appspotmail.com>, Cgroups <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Shakeel Butt <shakeelb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Tue, Mar 12, 2019 at 11:50 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Mar 12, 2019 at 09:33:44AM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> > On Tue, Mar 12, 2019 at 7:25 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
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
> > > In which case, over to Shakeel!
> >
> > Jan 10 is exactly when this bug was reported:
> > https://groups.google.com/forum/#!msg/syzkaller-bugs/5YkhNUg2PFY/4-B5M7bDCAAJ
> > https://syzkaller.appspot.com/bug?extid=fa11f9da42b46cea3b4a
> >
> > We don't know if that patch fixed the bug or not because nobody tested
> > the reproducer with that patch.
> >
> > It seems that the problem here is that nobody associated the fix with
> > the bug report. So people looking at open bug reports will spend time
> > again and again debugging this just to find that this was fixed months
> > ago. syzbot also doesn't have a chance to realize that this is fixed
> > and bisection is not necessary anymore. It also won't confirm/disprove
> > that the fix actually fixes the bug because even if the crash will
> > continue to happen it will look like the old crash just continues to
> > happen, so nothing to notify about.
> >
> > Associating fixes with bug reports solves all these problems for
> > humans and bots.
> >
>
> I think syzbot needs to be more aggressive about invalidating old bug reports on
> linux-next, e.g. automatically invalidate linux-next bugs that no longer occur
> after a few weeks even if there is a reproducer.  Patches get added, changed,
> and removed in linux-next every day.  Bugs that syzbot runs into on linux-next
> are often obvious enough that they get reported by other people too, resulting
> in bugs being fixed or dropped without people ever seeing the syzbot report.
> How do you propose that people associate fixes with syzbot reports when they
> never saw the syzbot report in the first place?
>
> This is a problem on mainline too, of course.  But we *know* it's a more severe
> problem on linux-next, and that a bug like this that only ever happened on
> linux-next and stopped happening 2 months ago, is much less likely to be
> relevant than a bug in mainline.  Kernel developers don't have time to examine
> every single syzbot report so you need to help them out by reducing the noise.

Please file an issue for this at https://github.com/google/syzkaller/issues

I also wonder how does this work for all other kernel bugs reports?
syzbot is not the only one reporting kernel bugs and we don't want to
invent new rules here.

Also note that what happens now may be not representative of what will
happen in a steady mode later. Now syzbot bisects old bugs accumulated
over 1+ year. Later if it reports a bug, it should bisect sooner. So
all of what happens in this bug report won't take place.
