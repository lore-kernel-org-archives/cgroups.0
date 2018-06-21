From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Thu, 21 Jun 2018 11:20:13 +0200
Message-ID: <20180621092013.GU2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
 <20180620142735.GM2494@hirez.programming.kicks-ass.net>
 <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=clYijeDdCIi1ndl/s6LkWqPSsod6X7UFEYG/DR5QN18=; b=L35dYrdRofas/fU/r57FjG1Ob
        mhozuLtakh+eaIcfFquS9u1mc76DKd8s8iPWA6qPV9PHD1VSgGBk+RvotN8NMZjh6fuV4UfGX5A9s
        nSeySgxTeXZbA37BvbxyKc1UgmuvL/u6y9mb17g0vcehp/qhsDilEDM0VBwP50uW3BbKEgV/X9zzL
        28t2NSe3SMb7kz48nL3lxEL/MuC5an1TXO4xv3sb2yomEC5p1CSqgdixW++csskaWvLOqEfpif/8Y
        hFlQp8qk3WPubAgdfSayNnA/C1jaYm1acRUYvlesjXDWnTwwOxGXPg+JVF1zJMJATMrDjsHFfF3wU
    
Content-Disposition: inline
In-Reply-To: <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Thu, Jun 21, 2018 at 03:58:06PM +0800, Waiman Long wrote:

> As for the inconsistency between the real root and the container root,
> this is true for almost all the controllers. So it is a generic problem.
> One possible solution is to create a kind a pseudo root cgroup for the
> container that looks and feels like a real root. But is there really a
> need to do that?

I don't really know. I thought the idea was to make containers
indistinguishable from a real system. Now I know we're really rather far
away from that in reality, and I really have no clue how important all
that is.

It all depends on how exactly this works; is it like I assumed, that
this file is owned by the parent instead of the current directory? And
that if you namespace this, you have an effective read-only file?

Then fixing the inconsistency is trivial; simply provide a read-only
file for the actual root cgroup too.

And if the solution is trivial, I don't see a good reason not to do it.
