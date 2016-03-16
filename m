From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH] mm: memcontrol: reclaim when shrinking memory.high below
 usage
Date: Wed, 16 Mar 2016 17:47:14 +0300
Message-ID: <20160316144713.GB18142@esperanza>
References: <1457643015-8828-1-git-send-email-hannes@cmpxchg.org>
 <20160311083440.GI1946@esperanza>
 <20160316054157.GB11006@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+QOQJYqNeOp+NQ/ruxZRK2znHWNOMkKeWx+fduaIMDo=;
 b=PHwXe7YxbiKI6dzfqTxGiX2B4O4pWfnpm2A5EYqck4PXWFl/08THqF6F4MQOLm8e/JRp2FZLXneIjzhyIGnQC4hZPEkiQdgiu0P462xGjwFIE3Fg3LHHNxHl8TOZxY5Wl/PjkzfcxG5Wydi0+G03BNI1/x6fDVcNjycR4pJMnis=
Content-Disposition: inline
In-Reply-To: <20160316054157.GB11006@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Mar 15, 2016 at 10:41:57PM -0700, Johannes Weiner wrote:
> On Fri, Mar 11, 2016 at 11:34:40AM +0300, Vladimir Davydov wrote:
> > On Thu, Mar 10, 2016 at 03:50:13PM -0500, Johannes Weiner wrote:
> > > When setting memory.high below usage, nothing happens until the next
> > > charge comes along, and then it will only reclaim its own charge and
> > > not the now potentially huge excess of the new memory.high. This can
> > > cause groups to stay in excess of their memory.high indefinitely.
> > > 
> > > To fix that, when shrinking memory.high, kick off a reclaim cycle that
> > > goes after the delta.
> > 
> > I agree that we should reclaim the high excess, but I don't think it's a
> > good idea to do it synchronously. Currently, memory.low and memory.high
> > knobs can be easily used by a single-threaded load manager implemented
> > in userspace, because it doesn't need to care about potential stalls
> > caused by writes to these files. After this change it might happen that
> > a write to memory.high would take long, seconds perhaps, so in order to
> > react quickly to changes in other cgroups, a load manager would have to
> > spawn a thread per each write to memory.high, which would complicate its
> > implementation significantly.
> 
> While I do expect memory.high to be adjusted every once in a while, I
> can't see anybody doing it by a significant fraction of the cgroup
> every couple of seconds - or tighter than the workingset; and dropping
> use-once cache is cheap. What kind of usecase would that be?

I agree that a load manager won't need to adjust memory.high by a
significant amount often, but there can be a lot of containers running,
so even if it takes 10 ms to adjust memory.high for one container, it
will take up to a second for 100 containers. I expect that a load
manager implementation will just blindly spawn a thread per each
memory.high update to be sure it won't be stalled for too long.

> 
> But even if we're wrong about it and this becomes a scalability issue,
> the knob - even when reclaiming synchroneously - makes no guarantees
> about the target being met once the write finishes. It's a best effort
> mechanism. What would break if we made it async later on?

You're right of course - we wouldn't be able to change async to sync,
but not the other way round. However, I'm afraid that by making it sync
from the very beginning we effectively enforce userspace applications
that need to update memory.{low,high} often to use multi-threading. Not
sure if it's that bad though.

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
