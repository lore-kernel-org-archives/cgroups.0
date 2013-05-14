From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 00/31] kmemcg shrinkers
Date: Tue, 14 May 2013 15:45:24 +1000
Message-ID: <20130514054524.GD29466@dastard>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org>
 <20130513071359.GM32675@dastard>
 <51909D84.7040800@parallels.com>
 <20130514014805.GA29466@dastard>
 <20130514052244.GC29466@dastard>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130514052244.GC29466@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Glauber Costa <glommer@openvz.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org

On Tue, May 14, 2013 at 03:22:44PM +1000, Dave Chinner wrote:
> On Tue, May 14, 2013 at 11:48:05AM +1000, Dave Chinner wrote:
...
> patch 4 needs some work:
> 
> 	- fix the above leak shrink list leak
> 	- fix the scope of the sb locking inside shrink_dcache_sb()
> 	- remove the readditional of dentry_lru_prune().
> 
> The reworked patch below does this.

And has a compile warning in it. And seeing as other patches need to
be rebased as a result of this change, I'll post the new patches as
responses to the patches that need to be modified....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
