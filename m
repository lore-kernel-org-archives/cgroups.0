From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 18:25:00 +0200
Message-ID: <20180720162500.GT2494@hirez.programming.kicks-ass.net>
References: <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
 <20180720154454.GR2494@hirez.programming.kicks-ass.net>
 <20180720155613.GB1934745@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3Cqmez5xv91CGTI0za12HyrLz9SVqDku4azKe5IUmDc=; b=bS0deEeetcouwZvmTdzTV/3eo
        kUbcdqOBJix8/K9j5QDOm6uNlFX/KGIuh7lVxLzQSnRA/5fFGQF6mjapXdPYEQu95OWAksWqFgMHa
        pEfwCDh2qrvdGQRtCHTN53r8Xnbwsvo+kO04W1BpmanHexge2kMTTF3TjLh8jn38psqreG2iJHBK/
        2HUNOGsCTJiPY/dVroO5lGhBFJJXgRuYY3YXmPMnKkBtBIVFmDKN7ZLUfrBrvIFp/EKb0jMcff0F7
        Z8GWMY/1sJrhIFAq9vqsUSbgbeKUvyPlpGCUKepo1ZneDY+K1RvxGMtQutfjh+mZmbE4ynPhb4ozk
    
Content-Disposition: inline
In-Reply-To: <20180720155613.GB1934745@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Fri, Jul 20, 2018 at 08:56:13AM -0700, Tejun Heo wrote:
> Hello, Peter.
> 
> On Fri, Jul 20, 2018 at 05:44:54PM +0200, Peter Zijlstra wrote:
> > > The currently proposed implementation is somewhere in the middle.  It
> > > kinda gets there by restricting a partition to be a child of another
> > > partition, which may be okay but it does make the whole delegation
> > > mechanism less useful.
> > 
> > So the implementation does not set ownership of the 'partition' file to
> > that of the parent directory? Because _that_ is what I understood from
> > Waiman (many versions ago). And that _does_ allow delegation to work
> > nicely.
> 
> So, that part isn't the problem.  The problem is that if we allow
> partitioning nested further away from ancestor, the descendant would
> be able to take away reources from the removed ancestor.

If the partition file is owned by the parent, the descendant cannot take
away anything. It can only read the file, not actually write to it.

To be explicit, if we have:

	/.			(uid = root)
	/A/.			(uid = user1)
	/A/cpuset.partition	(uid = root)

so ./*/cpuset.partition is always owned by .

> Waiman avoids this problem by only allowing partitions to nest but
> then it's kinda weird cuz it's just a separate tree.

The only real constraint is that the parent must have exclusive
'ownership' of the CPUs. Being a partition mandates that to be so. There
is no other way to distinguish exclusive / shared CPUs.

But I don't see how any of this is related to delegation per se. It is a
prerequisite for creating nested partitions, which in turn is a
prerequisite for delegation of partitions.

> > > > > 2. take away any given cpu from ist subtree.

> > Still, the question was, how is this (dispicable or not) behaviour not
> > allowed by the current implementation?
> 
> I'm not quite sure what you're trying to ask.  Can you elaborate?

We can always offline the CPU, so how exactly can the ancestor not take
back it's CPU?

The parent can simply shrink it's cpuset.cpus, no? Then the child gets
to recompute its setup and it might find its sub-partition just became
smaller or empty -- just like hotplug.


