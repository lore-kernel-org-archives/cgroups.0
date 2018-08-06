From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: WARNING in try_charge
Date: Mon, 6 Aug 2018 11:31:07 -0400
Message-ID: <20180806153107.GD9888@cmpxchg.org>
References: <0000000000005e979605729c1564@google.com>
 <20180806091552.GE19540@dhcp22.suse.cz>
 <CACT4Y+Ystnwv4M6Uh+HBKbdADAnJ6otfR0GoA20crzqV+b2onQ@mail.gmail.com>
 <20180806094827.GH19540@dhcp22.suse.cz>
 <CACT4Y+ZJsDo1gjzHvbFVqHcrL=tFJXTAAWLs9mAJSv3+LiCdmA@mail.gmail.com>
 <20180806110224.GI19540@dhcp22.suse.cz>
 <CACT4Y+awxBatn3GQc7EWHVfHqMLKC9eVKjQMbJkCk0Po-X4VDQ@mail.gmail.com>
 <20180806142124.GP19540@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2GqIl2Igk9YwCWaoMedz8uktj2Dvrc+kRj9fzcXAx2Y=;
        b=I2fbLXpA5/dyePV4VturmfTyLqz6fcZBzwMIvPkUyRMnANcFekann+eVsyFNFIauoE
         CZ90ElaC6jZJFKzbVRdh8hopa+Oxlu28iXcGew41Xdh5chsfbIKgFGC1tZq5Eq7ZVysT
         PsrjzkIxHHSJ8WbFkYDxqdUNp6Kwbin47XzJgFOzSq2XtcYi3e0/hRlvjeikEC1ael49
         wIS7bpTS+Og40GPPB9BMf8gpvYkyOGV+R+6SnnUNJbBoiKyDYK3zfSRvJj5E3u79R5TI
         SJepTyJB3ZuJTe7kEdNNxIOIdfGz/qoSBn6vQ365BE/hekrS2wFiGUj7C6Jiv3TRNfeT
         qBig==
Content-Disposition: inline
In-Reply-To: <20180806142124.GP19540@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Dmitry Torokhov <dtor@google.com>

On Mon, Aug 06, 2018 at 04:21:24PM +0200, Michal Hocko wrote:
> On Mon 06-08-18 13:57:38, Dmitry Vyukov wrote:
> > On Mon, Aug 6, 2018 at 1:02 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > > If you have a strong reason to believe that this is an abuse of WARN I
> > > am all happy to change that. But I haven't heard any yet, to be honest.
> > 
> > WARN must not be used for anything that is not kernel bugs. If this is
> > not kernel bug, WARN must not be used here.
> 
> This is rather strong wording without any backing arguments. I strongly
> doubt 90% of existing WARN* match this expectation. WARN* has
> traditionally been a way to tell that something suspicious is going on.
> Those situation are mostly likely not fatal but it is good to know they
> are happening.

I have to agree with Dmitry here. WARN should indicate a real kernel
issue, not user input that knowingly triggers undesirable behavior in
the kernel. It's our assert() for states we don't think are possible.

I would wager that MOST developers and users understand it that way.
