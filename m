From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Thu, 10 May 2018 10:18:20 -0400
Message-ID: <20180510141820.GF19348@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
 <20180509101454.GM12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UXMOzpcdCfLIpZueP/nQgzxMtZAkF9tE4/jmOq63/WU=; b=ulPrnldeFVP2VGP8NZvlGP6Leq
        eYw+GR0uXw1sJzPkmxra7GxGXXrX77pPBUGLEPgwqCYF8HiSvI5JjNENKRdItpaie6i+cm2HkuX5D
        ApxOFW6rnm1mFmiAcqYKxgLxXCFL1/UTigbZRb/zegBIvMZn0v1teJn6mDPkvJk1VZVI=;
Content-Disposition: inline
In-Reply-To: <20180509101454.GM12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Wed, May 09, 2018 at 12:14:54PM +0200, Peter Zijlstra wrote:
> On Mon, May 07, 2018 at 05:01:34PM -0400, Johannes Weiner wrote:
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 15750c222ca2..1658477466d5 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
[...]
> What's all this churn about?

The psi callbacks in kernel/sched/stat.h use these rq lock functions
from this file, but sched.h includes stat.h before those definitions.

I'll move this into a separate patch with a proper explanation.
