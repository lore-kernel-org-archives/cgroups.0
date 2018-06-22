From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 3/3] fs, mm: account buffer_head to kmemcg
Date: Fri, 22 Jun 2018 16:33:00 -0700
Message-ID: <CALvZod7G-ggYTpmdDsNeQRf4upYa34ccOerVmEkEkLOVFrBr2w@mail.gmail.com>
References: <20180619051327.149716-1-shakeelb@google.com> <20180619051327.149716-4-shakeelb@google.com>
 <20180619162741.GC27423@cmpxchg.org> <20180619174040.GA4304@castle.DHCP.thefacebook.com>
 <CALvZod5_0_LuqWpri=uviE5hHhTMPT0VQOZDgHtTtLhvcCtb3A@mail.gmail.com> <20180619195525.GA19193@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qy3+0q/fVBbc2dAVUxya1AwaevtUb1eg2jOOr+xBLU=;
        b=kqb1TCDjJXLWckIe4SKVZu7TK6ahDjUWu7JvsQSBLChnkm3xxH2vTpAF0/TzKWnNXY
         qvmlvR11ADhDSvDiviImtRvSY+oYcgJOtj7PpUuwmuNm+BHp/YCqj/u/XXuLZ2R3dxZZ
         sXLrbUwpWPvnUbgwC81J75gS89vk52KwUizgF7ryvuBArBsPze318WDSjiFhpu/yCQ9U
         JEfpI2ueMEqDUoyY4XGGAQ2yWIUObZWyesH6idVlFaJqFkePYjn95r+ztnuSBUf63vav
         drh1bJG24m8hTicK4j3EBvwA79caaLQPRNG12fv8U1Mu/8rw/aoWTxKCddyO9LS1qJj3
         Oo6Q==
In-Reply-To: <20180619195525.GA19193@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>

On Tue, Jun 19, 2018 at 12:55 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Jun 19, 2018 at 12:51:15PM -0700, Shakeel Butt wrote:
> > On Tue, Jun 19, 2018 at 10:41 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Tue, Jun 19, 2018 at 12:27:41PM -0400, Johannes Weiner wrote:
> > > > On Mon, Jun 18, 2018 at 10:13:27PM -0700, Shakeel Butt wrote:
> > > > > The buffer_head can consume a significant amount of system memory and
> > > > > is directly related to the amount of page cache. In our production
> > > > > environment we have observed that a lot of machines are spending a
> > > > > significant amount of memory as buffer_head and can not be left as
> > > > > system memory overhead.
> > > > >
> > > > > Charging buffer_head is not as simple as adding __GFP_ACCOUNT to the
> > > > > allocation. The buffer_heads can be allocated in a memcg different from
> > > > > the memcg of the page for which buffer_heads are being allocated. One
> > > > > concrete example is memory reclaim. The reclaim can trigger I/O of pages
> > > > > of any memcg on the system. So, the right way to charge buffer_head is
> > > > > to extract the memcg from the page for which buffer_heads are being
> > > > > allocated and then use targeted memcg charging API.
> > > > >
> > > > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > > > Cc: Jan Kara <jack@suse.cz>
> > > > > Cc: Greg Thelen <gthelen@google.com>
> > > > > Cc: Michal Hocko <mhocko@kernel.org>
> > > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > > > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > ---
> > > > >  fs/buffer.c                | 14 +++++++++++++-
> > > > >  include/linux/memcontrol.h |  7 +++++++
> > > > >  mm/memcontrol.c            | 21 +++++++++++++++++++++
> > > > >  3 files changed, 41 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/fs/buffer.c b/fs/buffer.c
> > > > > index 8194e3049fc5..26389b7a3cab 100644
> > > > > --- a/fs/buffer.c
> > > > > +++ b/fs/buffer.c
> > > > > @@ -815,10 +815,17 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
> > > > >     struct buffer_head *bh, *head;
> > > > >     gfp_t gfp = GFP_NOFS;
> > > > >     long offset;
> > > > > +   struct mem_cgroup *old_memcg;
> > > > > +   struct mem_cgroup *memcg = get_mem_cgroup_from_page(page);
> > > > >
> > > > >     if (retry)
> > > > >             gfp |= __GFP_NOFAIL;
> > > > >
> > > > > +   if (memcg) {
> > > > > +           gfp |= __GFP_ACCOUNT;
> > > > > +           old_memcg = memalloc_memcg_save(memcg);
> > > > > +   }
> > > >
> > > > Please move the get_mem_cgroup_from_page() call out of the
> > > > declarations and down to right before the if (memcg) branch.
> > > >
> > > > >     head = NULL;
> > > > >     offset = PAGE_SIZE;
> > > > >     while ((offset -= size) >= 0) {
> > > > > @@ -835,6 +842,11 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
> > > > >             /* Link the buffer to its page */
> > > > >             set_bh_page(bh, page, offset);
> > > > >     }
> > > > > +out:
> > > > > +   if (memcg) {
> > > > > +           memalloc_memcg_restore(old_memcg);
> > > > > +#ifdef CONFIG_MEMCG
> > > > > +           css_put(&memcg->css);
> > > > > +#endif
> > > >
> > > > Please add a put_mem_cgroup() ;)
> > >
> > > I've added such helper by commit 8a34a8b7fd62 ("mm, oom: cgroup-aware OOM killer").
> > > It's in the mm tree.
> > >
> >
> > I was using mem_cgroup_put() defined by Roman's patch but there were a
> > lot of build failure reports where someone was taking this series
> > without Roman's series or applying the series out of order. Andrew
> > asked me to keep it like this and then he will convert these callsites
> > into mem_cgroup_put() after making making sure Roman's series is
> > applied in mm tree. I will recheck with him, how he wants to handle it
> > now.
>
> I can also split the introduction of mem_cgroup_put() into a separate commit,
> as it seems to be usable not only by the cgroup oom stuff.
> Please, let me know, if it's a preferred way to go.
>

Oh I forgot to reply. Yes, let's do that, a separate patch to
introduce mem_cgroup_put() which can used by remote charging and memcg
aware oom-killer patches.

Shakeel
