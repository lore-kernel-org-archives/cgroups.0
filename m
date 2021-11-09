From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/5] mm/shmem: support deterministic charging of tmpfs
Date: Tue, 9 Nov 2021 15:56:03 -0800
Message-ID: <CAHS8izNwX80px5X=JrQAfgTBO5=rCN_hSybLW6T1CWmqG5b7eQ@mail.gmail.com>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-2-almasrymina@google.com> <20211108221047.GE418105@dread.disaster.area>
 <YYm1v25dLZL99qKK@casper.infradead.org> <20211109011837.GF418105@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoK2BBW7Jb6r8LW9mP4KvyVyymYNKZIHae58TqDdmjM=;
        b=e62I04EFslO8JvLVvNHAQ9M278/k+EW9C9hQfqvs/2+1DafaBcurjF1Tw40Jotuw+8
         a76hUHEIBUw5sz5N2VC+8FIXdNs5LWOHUchzTowWdzRQ/qhobM2E6HSI8tealG9nyest
         n2XPAp6ghoqcSFzmU+dOTMiMh92xrGfzgVxjnE32SvOSK3UTFa+XyHQAYUb3cuogUoI3
         ktrpsTE3cnwIVA+a7jEVel4GzAXQTy3pA5r5hQezKzGG9mHJiJKuHKaOieoaFn5B8RRJ
         ylafV0ZEx69LyWI/2bXv3H+IPK2Jfx1t20og61f7SXBp24yFlnMaUX9QSaLexn24zRvF
         S8pQ==
In-Reply-To: <20211109011837.GF418105-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 8, 2021 at 5:18 PM Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>
> On Mon, Nov 08, 2021 at 11:41:51PM +0000, Matthew Wilcox wrote:
> > On Tue, Nov 09, 2021 at 09:10:47AM +1100, Dave Chinner wrote:
> > > > + rcu_read_lock();
> > > > + memcg = rcu_dereference(mapping->host->i_sb->s_memcg_to_charge);
> > >
> > > Anything doing pointer chasing to obtain static, unchanging
> > > superblock state is poorly implemented. The s_memcg_to_charge value never
> > > changes, so this code should associate the memcg to charge directly
> > > on the mapping when the mapping is first initialised by the
> > > filesystem. We already do this with things like attaching address
> > > space ops and mapping specific gfp masks (i.e
> > > mapping_set_gfp_mask()), so this association should be set up that
> > > way, too (e.g. mapping_set_memcg_to_charge()).
> >
> > I'm not a fan of enlarging struct address_space with another pointer
> > unless it's going to be used by all/most filesystems.  If this is
> > destined to be a shmem-only feature, then it should be in the
> > shmem_inode instead of the mapping.
>
> Neither am I, but I'm also not a fan of the filemap code still
> having to drill through the mapping to the host inode just to check
> if it needs to do special stuff for shmem inodes on every call that
> adds a page to the page cache. This is just as messy and intrusive
> and the memcg code really has no business digging about in the
> filesystem specific details of the inode behind the mapping.
>
> Hmmm. The mem_cgroup_charge() call in filemap_add_folio() passes a
> null mm context, so deep in the guts it ends getting the memcg from
> active_memcg() in get_mem_cgroup_from_mm(). That ends up using
> current->active_memcg, so maybe a better approach here is to have
> shmem override current->active_memcg via set_active_memcg() before
> it enters the generic fs paths and restore it on return...
>
> current_fsmemcg()?
>

Thank you for providing a detailed alternative. To be honest it seems
a bit brittle to me, as in folks can easily add calls to generic fs
paths forgetting to override the active_memcg and having memory
charged incorrectly, but if there is no other option and we want to
make this a shmem-only feature, I can do this anyway.

> > If we are to have this for all filesystems, then let's do that properly
> > and make it generic functionality from its introduction.
>
> Fully agree.

So the tmpfs feature addresses the first 2 usecases I mention in the
cover letter. For the 3rd usecase I will likely need to extend this
support to 1 disk-based filesystem, and I'm not sure which at this
point. It also looks like Roman has in mind 1 or more use cases and
may extend it to other filesystems as a result. I'm hoping that I can
provide the generic implementation and the tmpfs support and in follow
up patches folks can extend this to other file systems by providing
the fs-specific changes needed for that filesystem.

AFAICT with this patch the work to extend to another file system is to
parse the memcg= option in that filesystem, set the s_memcg_to_charge
on the superblock (or mapping) of that filesystem, and to charge
s_memcg_to_charge in fs specific code paths, so all are fs-specific
changes.

Based on this, it seems to me the suggestion is to hang the
memcg_to_charge off the mapping? I'm not sure if *most/all*
filesystems will eventually support it, but likely more than just
tmpfs.




>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
