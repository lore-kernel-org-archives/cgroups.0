From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 2/3] mm: memcontrol: simplify detecting when the
 memory+swap limit is hit
Date: Wed, 24 Sep 2014 19:14:21 +0400
Message-ID: <20140924151421.GA29445@esperanza>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
 <1411571338-8178-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1411571338-8178-3-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:08:57AM -0400, Johannes Weiner wrote:
> When attempting to charge pages, we first charge the memory counter
> and then the memory+swap counter.  If one of the counters is at its
> limit, we enter reclaim, but if it's the memory+swap counter, reclaim
> shouldn't swap because that wouldn't change the situation.  However,
> if the counters have the same limits, we never get to the memory+swap
> limit.  To know whether reclaim should swap or not, there is a state
> flag that indicates whether the limits are equal and whether hitting
> the memory limit implies hitting the memory+swap limit.
> 
> Just try the memory+swap counter first.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
