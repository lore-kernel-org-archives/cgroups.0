From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 08/35] list: add a new LRU list type
Date: Thu, 6 Jun 2013 00:04:09 -0700
Message-ID: <20130606000409.e4333f7c.akpm@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-9-git-send-email-glommer@openvz.org>
	<20130605160758.19e854a6995e3c2a1f5260bf@linux-foundation.org>
	<20130606024909.GP29338@dastard>
	<20130605200554.d4dae16f.akpm@linux-foundation.org>
	<20130606044426.GX29338@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130606044426.GX29338@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Thu, 6 Jun 2013 14:44:26 +1000 Dave Chinner <david@fromorbit.com> wrote:

> > Why was it called "lru", btw?  iirc it's actually a "stack" (or
> > "queue"?) and any lru functionality is actually implemented externally.
> 
> Because it's a bunch of infrastructure and helper functions that
> callers use to implement a list based LRU that tightly integrates
> with the shrinker infrastructure.  ;)
> 
> I'm open to a better name - something just as short and concise
> would be nice ;)

Not a biggie, but it's nice to get these things exact on day one.

"queue"?  Because someone who wants a queue is likely to look at
list_lru.c and think "hm, that's no good".  Whereas if it's queue.c
then they're more likely to use it.  Then start cursing at its
internal spin_lock() :)

But anyone who just wants a queue doesn't want their queue_lru_del()
calling into memcg code(!).  I do think it would be more appropriate to
discard the lib/ idea and move it all into fs/ or mm/.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
