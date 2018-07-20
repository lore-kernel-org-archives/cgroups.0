From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 04:45:49 -0700
Message-ID: <20180720114549.GY72677@devbig577.frc2.facebook.com>
References: <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6sEETIyfIWdZRxqCxHBW0J9SmgRvXDxvZJWaFQVYhbs=;
        b=SoTwqdmEbMmonRN971Cup0y96sOq+fVjiBQwt8k5GQW3n/CY3/uphhAc+dbm0ZQHbC
         WRvSknKlP5dMGiyUdna2lEg1NrNp369STOC6hvl0EjNFAdz0UCqezggg524ncXMC4R4o
         O8CHWpfqaQUpje/dSk3IQf7z1vU3XhVwFntucnj5TAPxJItXnBeC63IqvR+fbxqdaeGn
         ZgsLgpFeeWocjSdcNiPbyOJFE8RItgazlBaNJ04oTs8Ffu5BnKndtIjFDhOQsa3Zyb7K
         7zjV6jLgnqoW2itWkpjHi7sDcKn7qIaEnOmBpxCmnf79JoyTNcH1aVQDLhdVT0m1MoWf
         7DUw==
Content-Disposition: inline
In-Reply-To: <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello,

On Fri, Jul 20, 2018 at 01:31:21PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 19, 2018 at 09:52:01AM -0700, Tejun Heo wrote:
> > On Thu, Jul 19, 2018 at 11:52:46AM -0400, Waiman Long wrote:
> > > BTW, the way the partition is currently implemented right now is that a
> > > child cannot be a partition root unless its parent is a partition root
> > > itself. That is to avoid turning on partition to affect ancestors
> > > further up the hierarchy than just the parent. So in the case of a
> > > container, it cannot allocate sub-partitions underneath it unless it is
> > > a partition itself. Will that solve your concern?
> > 
> > Hmm... so a given ancestor must be able to both
> > 
> > 1. control which cpus are moved into a partition in all of its
> >    subtree.
> 
> By virtue of the partition file being owned by the parent, this is
> already achived, no?

The currently proposed implementation is somewhere in the middle.  It
kinda gets there by restricting a partition to be a child of another
partition, which may be okay but it does make the whole delegation
mechanism less useful.

> > 2. take away any given cpu from ist subtree.
> 
> I really hate this obsession of yours and doubly so for partitions. But
> why would this currently not be allowed?

Well, sorry that you hate it.  It's a fundamental architectural
constraint.  If it can't satisfy that, it should't be in cgroup.

Thanks.

-- 
tejun
