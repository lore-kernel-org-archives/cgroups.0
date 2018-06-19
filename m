From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 3/3] fs, mm: account buffer_head to kmemcg
Date: Tue, 19 Jun 2018 10:40:44 -0700
Message-ID: <20180619174040.GA4304@castle.DHCP.thefacebook.com>
References: <20180619051327.149716-1-shakeelb@google.com>
 <20180619051327.149716-4-shakeelb@google.com>
 <20180619162741.GC27423@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=yvZV8MufaMcnkhb+wrsj2vgmLmmJ5wakwvUO7Tz/cBY=;
 b=IMSGJY5Nqf2NPkCqMVsvKLfPGR0tggwZ6mx71+Yv0Dhm6WaHs71ErLkqDpkuYr0kA9eH
 mQ0T3F2Nh9Kss7ei5vrzhqbgsSCuIef5AiwH0XtWrNlcetWOta/qP3qqSh8XhI//xL9z
 kwx09R+yVrWLo18Q81MaFwMUF+vjkwT23yw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvZV8MufaMcnkhb+wrsj2vgmLmmJ5wakwvUO7Tz/cBY=;
 b=FfmNtS7IYJOimhMQhCmU0QHXx3MOueMAQXMRTAq2JliUDlip//uf1+94GRLAHm7FXn9BqXcGJnW9Zp05xXfRbw5IXNx++qO0gWaMPgDQq5uutQcc5Cj6G0vNglqAzjxkd+yebDhY/rc/hJ/M8WIJwP6SQaI0WrdlwHbAjK58Hjk=
Content-Disposition: inline
In-Reply-To: <20180619162741.GC27423@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>

On Tue, Jun 19, 2018 at 12:27:41PM -0400, Johannes Weiner wrote:
> On Mon, Jun 18, 2018 at 10:13:27PM -0700, Shakeel Butt wrote:
> > The buffer_head can consume a significant amount of system memory and
> > is directly related to the amount of page cache. In our production
> > environment we have observed that a lot of machines are spending a
> > significant amount of memory as buffer_head and can not be left as
> > system memory overhead.
> > 
> > Charging buffer_head is not as simple as adding __GFP_ACCOUNT to the
> > allocation. The buffer_heads can be allocated in a memcg different from
> > the memcg of the page for which buffer_heads are being allocated. One
> > concrete example is memory reclaim. The reclaim can trigger I/O of pages
> > of any memcg on the system. So, the right way to charge buffer_head is
> > to extract the memcg from the page for which buffer_heads are being
> > allocated and then use targeted memcg charging API.
> > 
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Greg Thelen <gthelen@google.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  fs/buffer.c                | 14 +++++++++++++-
> >  include/linux/memcontrol.h |  7 +++++++
> >  mm/memcontrol.c            | 21 +++++++++++++++++++++
> >  3 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 8194e3049fc5..26389b7a3cab 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -815,10 +815,17 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
> >  	struct buffer_head *bh, *head;
> >  	gfp_t gfp = GFP_NOFS;
> >  	long offset;
> > +	struct mem_cgroup *old_memcg;
> > +	struct mem_cgroup *memcg = get_mem_cgroup_from_page(page);
> >  
> >  	if (retry)
> >  		gfp |= __GFP_NOFAIL;
> >  
> > +	if (memcg) {
> > +		gfp |= __GFP_ACCOUNT;
> > +		old_memcg = memalloc_memcg_save(memcg);
> > +	}
> 
> Please move the get_mem_cgroup_from_page() call out of the
> declarations and down to right before the if (memcg) branch.
> 
> >  	head = NULL;
> >  	offset = PAGE_SIZE;
> >  	while ((offset -= size) >= 0) {
> > @@ -835,6 +842,11 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
> >  		/* Link the buffer to its page */
> >  		set_bh_page(bh, page, offset);
> >  	}
> > +out:
> > +	if (memcg) {
> > +		memalloc_memcg_restore(old_memcg);
> > +#ifdef CONFIG_MEMCG
> > +		css_put(&memcg->css);
> > +#endif
> 
> Please add a put_mem_cgroup() ;)

I've added such helper by commit 8a34a8b7fd62 ("mm, oom: cgroup-aware OOM killer").
It's in the mm tree.

Thanks!
