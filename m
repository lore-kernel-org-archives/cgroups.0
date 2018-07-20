From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 08:56:13 -0700
Message-ID: <20180720155613.GB1934745@devbig577.frc2.facebook.com>
References: <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
 <20180720154454.GR2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K2eMCmaQOK7Kd62z2r1yCYs9jaqhAA7oLspxsoU77Gg=;
        b=ZVOgsdahfHcd3U74MwqjB/eRBcdxTKYmZiH5e23UjiJeMhkDTNUH+O56imkGcg1GIJ
         mi6SOh7LrYKQxMSVCzxogwzvvpmDA/NRtV8JQRMaF8n2bli69zUPPoNBrDWan/dmNsc1
         vipZrh/31yWBvR8n7/hCia5NxbRF2HbIwEVEn9kQ8NSoV3wVExa1602tbLuxc6WtLMrl
         txMk7mOuhk2F+PmD0xAkY1bZc/zZ7KOcG/XOMdeqvYyieMtj2l7KyjcsZV3/9+MN28Xt
         Sk/x0UJcLoLYIcKfUX/Jr4bjY5mL31jj42f6gmwoZC8igZrzv6XrAhthel5BcvoZu+L9
         9NLg==
Content-Disposition: inline
In-Reply-To: <20180720154454.GR2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello, Peter.

On Fri, Jul 20, 2018 at 05:44:54PM +0200, Peter Zijlstra wrote:
> > The currently proposed implementation is somewhere in the middle.  It
> > kinda gets there by restricting a partition to be a child of another
> > partition, which may be okay but it does make the whole delegation
> > mechanism less useful.
> 
> So the implementation does not set ownership of the 'partition' file to
> that of the parent directory? Because _that_ is what I understood from
> Waiman (many versions ago). And that _does_ allow delegation to work
> nicely.

So, that part isn't the problem.  The problem is that if we allow
partitioning nested further away from ancestor, the descendant would
be able to take away reources from the removed ancestor.  Waiman
avoids this problem by only allowing partitions to nest but then it's
kinda weird cuz it's just a separate tree.

> > > > 2. take away any given cpu from ist subtree.
> > > 
> > > I really hate this obsession of yours and doubly so for partitions. But
> > > why would this currently not be allowed?
> > 
> > Well, sorry that you hate it.  It's a fundamental architectural
> > constraint.  If it can't satisfy that, it should't be in cgroup.
> 
> So is hierarchical behaviour; but you seem willing to forgo that.

Well, we do have root or first-level only things.  Things just need to
be properly delegatable when they're hierarchical (and things should
be hierarchical only when that actually means something).  While not
desirable, considering the history, accomodating this specific usage
that way seems acceptable to me.

> Still, the question was, how is this (dispicable or not) behaviour not
> allowed by the current implementation?

I'm not quite sure what you're trying to ask.  Can you elaborate?

Thanks.

-- 
tejun
