From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] vmscan: take at least one pass with shrinkers
Date: Sun, 23 Dec 2012 10:53:40 +1100
Message-ID: <20121222235340.GI15182@dastard>
References: <1356086810-6950-1-git-send-email-glommer@parallels.com>
 <1356086810-6950-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1356086810-6950-3-git-send-email-glommer@parallels.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, kamezawa.hiroyu@jp.fujitsu.com, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>

On Fri, Dec 21, 2012 at 02:46:50PM +0400, Glauber Costa wrote:
> In very low free kernel memory situations, it may be the case that we
> have less objects to free than our initial batch size. If this is the
> case, it is better to shrink those, and open space for the new workload
> then to keep them and fail the new allocations.
> 
> More specifically, this happens because we encode this in a loop with
> the condition: "while (total_scan >= batch_size)". So if we are in such
> a case, we'll not even enter the loop.
> 
> This patch modifies turns it into a do () while {} loop, that will
> guarantee that we scan it at least once, while keeping the behaviour
> exactly the same for the cases in which total_scan > batch_size.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Dave Chinner <david@fromorbit.com>

I think you'll find I said:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

That has a significantly different meaning to Acked-by, so you
should be careful to correctly transcribe tags back to the
patches...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
