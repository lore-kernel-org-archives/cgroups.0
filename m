From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 17:44:54 +0200
Message-ID: <20180720154454.GR2494@hirez.programming.kicks-ass.net>
References: <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CTrgbzCEKwqwIlnAuzvzAfy7hiCeZtkIp3hlVKFAupY=; b=ZDkXng6iPrf7HgV0QmP6nbYJZ
        iepEUF6kOnr6mFNCo5Rd5SuQb2txNi/aPqt3Al2wttST8EAwOA/ClV6akx5jFIfu3qp/1RejfCf+u
        jjMq2z7TQQOQG05F47AQQtLOc71uyHpEdV7AitHRuCCx0U8jnBEBNRwGvC0XUc0g/OCMXe2pgFALw
        ZKsWMEpmR8nXpDCyaq6mJ4cvAMzJxzmjMzGIhgNmHziQfbOMPL7OUPTopKK1uSaJh8H/2RDIVzNp3
        jh273DMC6davrkmmBvfNAgZ4L4JIfKXEO8qXnG6ddf5NrXzwrtHsJfWu7+r39njbXElf/5oJU2LDk
      
Content-Disposition: inline
In-Reply-To: <20180720114549.GY72677@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Fri, Jul 20, 2018 at 04:45:49AM -0700, Tejun Heo wrote:

> > > Hmm... so a given ancestor must be able to both
> > > 
> > > 1. control which cpus are moved into a partition in all of its
> > >    subtree.
> > 
> > By virtue of the partition file being owned by the parent, this is
> > already achived, no?
> 
> The currently proposed implementation is somewhere in the middle.  It
> kinda gets there by restricting a partition to be a child of another
> partition, which may be okay but it does make the whole delegation
> mechanism less useful.

So the implementation does not set ownership of the 'partition' file to
that of the parent directory? Because _that_ is what I understood from
Waiman (many versions ago). And that _does_ allow delegation to work
nicely.

> > > 2. take away any given cpu from ist subtree.
> > 
> > I really hate this obsession of yours and doubly so for partitions. But
> > why would this currently not be allowed?
> 
> Well, sorry that you hate it.  It's a fundamental architectural
> constraint.  If it can't satisfy that, it should't be in cgroup.

So is hierarchical behaviour; but you seem willing to forgo that.

Still, the question was, how is this (dispicable or not) behaviour not
allowed by the current implementation?
