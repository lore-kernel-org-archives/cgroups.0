From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 4/5] mm: memcontrol: continue cache reclaim from offlined
 groups
Date: Fri, 17 Oct 2014 10:40:11 +0200
Message-ID: <20141017084011.GC5641@esperanza>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1413303637-23862-5-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 12:20:36PM -0400, Johannes Weiner wrote:
> On cgroup deletion, outstanding page cache charges are moved to the
> parent group so that they're not lost and can be reclaimed during
> pressure on/inside said parent.  But this reparenting is fairly tricky
> and its synchroneous nature has led to several lock-ups in the past.
> 
> Since css iterators now also include offlined css, memcg iterators can
> be changed to include offlined children during reclaim of a group, and
> leftover cache can just stay put.
> 
> There is a slight change of behavior in that charges of deleted groups
> no longer show up as local charges in the parent.  But they are still
> included in the parent's hierarchical statistics.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 218 +-------------------------------------------------------
>  1 file changed, 1 insertion(+), 217 deletions(-)

I do like the stats :-) However, as I've already mentioned, on big
machines we can end up with hundred of thousands of dead css's.
Iterating over all of them during reclaim may result in noticeable lags.
One day we'll have to do something about that I guess.

Another issue is that AFAICT currently we can't have more than 64K
cgroups due to the MEM_CGROUP_ID_MAX limit. The limit exists, because we
use css ids for tagging swap entries and we don't want to spend too much
memory on this. May be, we should simply use the mem_cgroup pointer
instead of the css id?

OTOH, the reparenting code looks really ugly. And we can't easily
reparent swap and kmem. So I think it's a reasonable change.

Acked-by: Vladimir Davydov <vdavydov@parallels.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
