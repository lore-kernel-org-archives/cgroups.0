From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 1/5] mm/shmem: support deterministic charging of tmpfs
Date: Mon, 8 Nov 2021 23:41:51 +0000
Message-ID: <YYm1v25dLZL99qKK@casper.infradead.org>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-2-almasrymina@google.com>
 <20211108221047.GE418105@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zyBXp9nFXyKpys6NToLTdLN2RrQcXAbIwe3B9JMITY8=; b=FRAwff94oZ+NODBFNyR3YgpLuB
        xxiX8cuJ4urF0o/WkJXojrXi5DskSv5tMDChxw3aAS0RM768tRSF2wy494p6yTHotLmzkgHURxvZ1
        WU8Fi8s9+EjjLlfy8w217m3iIrWZ3QpL2zv0a40kifhYxUtZBCyCEEX2PCuXKxvgiAhI+ZpuTvJae
        CQoCJHi4FRgSI7JVwwrojEjhe1yWTwgkTAZfodQpO14jM6vVx8zdAF318d0zj1d/YQjx2d7rA88/4
        uCqKFhquarFVBLJtrOa162D9iLN6aHka+1KVrJlLDz6RZCKkNKC4h0IDPKQ+FM0mpB9OPyhq06eAe
        8vnpA6KA==;
Content-Disposition: inline
In-Reply-To: <20211108221047.GE418105-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 09, 2021 at 09:10:47AM +1100, Dave Chinner wrote:
> > +	rcu_read_lock();
> > +	memcg = rcu_dereference(mapping->host->i_sb->s_memcg_to_charge);
> 
> Anything doing pointer chasing to obtain static, unchanging
> superblock state is poorly implemented. The s_memcg_to_charge value never
> changes, so this code should associate the memcg to charge directly
> on the mapping when the mapping is first initialised by the
> filesystem. We already do this with things like attaching address
> space ops and mapping specific gfp masks (i.e
> mapping_set_gfp_mask()), so this association should be set up that
> way, too (e.g. mapping_set_memcg_to_charge()).

I'm not a fan of enlarging struct address_space with another pointer
unless it's going to be used by all/most filesystems.  If this is
destined to be a shmem-only feature, then it should be in the
shmem_inode instead of the mapping.

If we are to have this for all filesystems, then let's do that properly
and make it generic functionality from its introduction.
