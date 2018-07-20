From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 13:31:21 +0200
Message-ID: <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SXbZTz5Xm2/AOPZI50e723sEbsMKkKj7CD7XVXdiu7Y=; b=XPla7+BE3HaQKI4SF/MhWUa8g
        GzqJ5t7svGuTrMnUxJsU3iNbPpTbDzFuaIoJFCUZ8fH2p8H3fq37INwTkfBER9CXmXbBOdWcuxBW6
        nJWSioSVHU3uXedtnP9FkfizI2+q02EVXfQLmlXWc+XmYKEATlhwDjK7kHyKP++T8L23gmQT0KRpp
        X8W/0IBkTD3T+SvBf/CNgl0wys4TSxLQCueBLEmmFBr2f4xUzd3RUTN2Glloo807FYSpshJ6sKTKE
        VyLaf8c+qPoBaIndVFL4vfQaM/1tsIQixhS/jJba7O6WxaCiqh74CHbAHuxJ0zHuRhq86Htj4mrCR
      
Content-Disposition: inline
In-Reply-To: <20180719165201.GU72677@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Thu, Jul 19, 2018 at 09:52:01AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 19, 2018 at 11:52:46AM -0400, Waiman Long wrote:
> > BTW, the way the partition is currently implemented right now is that a
> > child cannot be a partition root unless its parent is a partition root
> > itself. That is to avoid turning on partition to affect ancestors
> > further up the hierarchy than just the parent. So in the case of a
> > container, it cannot allocate sub-partitions underneath it unless it is
> > a partition itself. Will that solve your concern?
> 
> Hmm... so a given ancestor must be able to both
> 
> 1. control which cpus are moved into a partition in all of its
>    subtree.

By virtue of the partition file being owned by the parent, this is
already achived, no?

> 2. take away any given cpu from ist subtree.

I really hate this obsession of yours and doubly so for partitions. But
why would this currently not be allowed?
