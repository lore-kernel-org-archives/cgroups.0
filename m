From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 1/5] mm/shmem: support deterministic charging of tmpfs
Date: Tue, 9 Nov 2021 12:18:37 +1100
Message-ID: <20211109011837.GF418105@dread.disaster.area>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-2-almasrymina@google.com>
 <20211108221047.GE418105@dread.disaster.area>
 <YYm1v25dLZL99qKK@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <YYm1v25dLZL99qKK@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>, Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Nov 08, 2021 at 11:41:51PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 09, 2021 at 09:10:47AM +1100, Dave Chinner wrote:
> > > +	rcu_read_lock();
> > > +	memcg = rcu_dereference(mapping->host->i_sb->s_memcg_to_charge);
> > 
> > Anything doing pointer chasing to obtain static, unchanging
> > superblock state is poorly implemented. The s_memcg_to_charge value never
> > changes, so this code should associate the memcg to charge directly
> > on the mapping when the mapping is first initialised by the
> > filesystem. We already do this with things like attaching address
> > space ops and mapping specific gfp masks (i.e
> > mapping_set_gfp_mask()), so this association should be set up that
> > way, too (e.g. mapping_set_memcg_to_charge()).
> 
> I'm not a fan of enlarging struct address_space with another pointer
> unless it's going to be used by all/most filesystems.  If this is
> destined to be a shmem-only feature, then it should be in the
> shmem_inode instead of the mapping.

Neither am I, but I'm also not a fan of the filemap code still
having to drill through the mapping to the host inode just to check
if it needs to do special stuff for shmem inodes on every call that
adds a page to the page cache. This is just as messy and intrusive
and the memcg code really has no business digging about in the
filesystem specific details of the inode behind the mapping.

Hmmm. The mem_cgroup_charge() call in filemap_add_folio() passes a
null mm context, so deep in the guts it ends getting the memcg from
active_memcg() in get_mem_cgroup_from_mm(). That ends up using
current->active_memcg, so maybe a better approach here is to have
shmem override current->active_memcg via set_active_memcg() before
it enters the generic fs paths and restore it on return...

current_fsmemcg()?

> If we are to have this for all filesystems, then let's do that properly
> and make it generic functionality from its introduction.

Fully agree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
