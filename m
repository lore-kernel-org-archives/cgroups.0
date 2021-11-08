From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 1/5] mm/shmem: support deterministic charging of tmpfs
Date: Tue, 9 Nov 2021 09:10:47 +1100
Message-ID: <20211108221047.GE418105@dread.disaster.area>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-2-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20211108211959.1750915-2-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Nov 08, 2021 at 01:19:55PM -0800, Mina Almasry wrote:
> Add memcg= option to shmem mount.
> 
> Users can specify this option at mount time and all data page charges
> will be charged to the memcg supplied.
.....
> +/*
> + * Returns the memcg to charge for inode pages.  If non-NULL is returned, caller
> + * must drop reference with css_put().  NULL indicates that the inode does not
> + * have a memcg to charge, so the default process based policy should be used.
> + */
> +static struct mem_cgroup *
> +mem_cgroup_mapping_get_charge_target(struct address_space *mapping)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	if (!mapping)
> +		return NULL;
> +
> +	rcu_read_lock();
> +	memcg = rcu_dereference(mapping->host->i_sb->s_memcg_to_charge);

Anything doing pointer chasing to obtain static, unchanging
superblock state is poorly implemented. The s_memcg_to_charge value never
changes, so this code should associate the memcg to charge directly
on the mapping when the mapping is first initialised by the
filesystem. We already do this with things like attaching address
space ops and mapping specific gfp masks (i.e
mapping_set_gfp_mask()), so this association should be set up that
way, too (e.g. mapping_set_memcg_to_charge()).

And because this memcg pointer is static and unchanging for the entire
life of the superblock, the superblock *must* pin the memcg into
memory and that means we can elide the rcu locking altogether in the
fast path for all filesystems that don't support this functionality.
i.e. we can simply do:

	if (!mapping || !mapping->memcg_to_charge)
		return NULL;

And then only if there is a memcg to charge, we do the slow path
locking and lookup stuff...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
