From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Mon, 2 Jul 2018 09:32:25 -0700
Message-ID: <20180702163225.GH533219@devbig577.frc2.facebook.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
 <20180620142735.GM2494@hirez.programming.kicks-ass.net>
 <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
 <20180621092013.GU2494@hirez.programming.kicks-ass.net>
 <1eb82b46-aa97-2ada-5196-5d7fc1cda87d@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aP337yMUwjNxwESmqz63nB2IfmzYkv0fwTzPmlQUTIQ=;
        b=drGLuWhUq4aurFCSnVKzj98WS3+4Y6rlKp6TuzYIjbcp08d/nl/udzQ0zkONrVT2ZE
         yklCdGVYF6ccURz1O/qaaCDVlgMV6T6r8SLOlCmfEfMlusdsbl+A9zFiu3b6rZ6WT4oW
         M52CJO/0714RDtezb9EIYc85awFBDikA7DYvADC7T8a2KqS1Yoc3mHarv213DeVSUdsw
         7XNIuzqIM/ohPE80sne39nTIdnqipFchy1v95A+TN9yZnMpOiEiuzCRQOBKdpamhdhei
         3hEEUGxdn/w76+bifw2/l0lEn6xJ8Nb2mYsAP+hUbc+pphcJW+fzIl2HsDhCUi/2KWd/
         KcTQ==
Content-Disposition: inline
In-Reply-To: <1eb82b46-aa97-2ada-5196-5d7fc1cda87d@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello,

On Fri, Jun 22, 2018 at 11:00:03AM +0800, Waiman Long wrote:
> On 06/21/2018 05:20 PM, Peter Zijlstra wrote:
> >> As for the inconsistency between the real root and the container root,
> >> this is true for almost all the controllers. So it is a generic problem.
> >> One possible solution is to create a kind a pseudo root cgroup for the
> >> container that looks and feels like a real root. But is there really a
> >> need to do that?
> > I don't really know. I thought the idea was to make containers
> > indistinguishable from a real system. Now I know we're really rather far
> > away from that in reality, and I really have no clue how important all
> > that is.
> 
> That will certainly be the ideal.

Sure, ideal in theoretical sense; however, the practical cost-benefit
ratio of trying to make containers indistinguishible from system
doesn't seem enough to justify the effort.  Not yet anyway.  It'd be
nice to not paint ourselves into a corner where we can't get the
equivalence without major interface changes later but I think that's
about the extent we should go for now.

> > It all depends on how exactly this works; is it like I assumed, that
> > this file is owned by the parent instead of the current directory? And
> > that if you namespace this, you have an effective read-only file?
> 
> Yes, that is right.
> 
> > Then fixing the inconsistency is trivial; simply provide a read-only
> > file for the actual root cgroup too.
> >
> > And if the solution is trivial, I don't see a good reason not to do it.
> 
> Do you mean providing a flag like READONLY_AT_ROOT so that it will be
> read-only at the real root? That is an cgroup architectural decision
> that needs input from Tejun. Anyway, this issue is not specific to this
> patchset and I would like to break it out as a separate discussion
> independent of this patchset.

Yeah, it's a larger problem than cpuset and different controllers
trying it in different ways isn't a good idea anyway.  Let's shelve
this topic for now.

Thanks.

-- 
tejun
