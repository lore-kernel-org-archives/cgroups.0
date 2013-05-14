From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v6 00/31] kmemcg shrinkers
Date: Tue, 14 May 2013 11:38:18 +0400
Message-ID: <5191E9EA.9040709@parallels.com>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org> <20130513071359.GM32675@dastard> <51909D84.7040800@parallels.com> <20130514014805.GA29466@dastard> <20130514052244.GC29466@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130514052244.GC29466@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glommer@openvz.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org

On 05/14/2013 09:22 AM, Dave Chinner wrote:
> I've found the problem. dentry_kill() returns the current dentry if
> it cannot lock the dentry->d_inode or the dentry->d_parent, and when
> that happens try_prune_one_dentry() silently fails to prune the
> dentry.  But, at this point, we've already removed the dentry from
> both the LRU and the shrink list, and so it gets dropped on the
> floor.
> 
Great. I had already an idea that it had something to do with a dentry
being removed from the LRU and not being put back, but I was looking at
the wrong circumstance. oz, oz oi oi oi!

> patch 4 needs some work:
> 
> 	- fix the above leak shrink list leak
> 	- fix the scope of the sb locking inside shrink_dcache_sb()
> 	- remove the readditional of dentry_lru_prune().
I readded this just because there are more work that needs to be done
upon prune that is always the same. This is specially true in later
patches, IIRC. I don't think dentry_lru_prune() has anything to do
directly with the problem we are seeing now, and this is just a question
of duplicated code vs not. But I am ultimately fine either way.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
