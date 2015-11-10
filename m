From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] Account certain kmem allocations to memcg
Date: Tue, 10 Nov 2015 14:23:19 +0100
Message-ID: <20151110132319.GI8058@dhcp22.suse.cz>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <60b4d1631e3a302246859d6a39ac7c6d6cbf3af3.1446924358.git.vdavydov@virtuozzo.com>
 <20151109143955.GF8916@dhcp22.suse.cz>
 <20151110080709.GR31308@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110080709.GR31308@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 10-11-15 11:07:09, Vladimir Davydov wrote:
> On Mon, Nov 09, 2015 at 03:39:55PM +0100, Michal Hocko wrote:
[...]
> > pipe buffers are trivial to abuse (e.g. via fd passing) so we want to
> 
> You might also mention allocations caused by select/poll, page tables,
> radix_tree_node, etc. They all might be abused, but the primary purpose
> of this patch set is not catching abusers, but providing reasonable
> level of isolation for most normal workloads. Let's add everything above
> that in separate patches.

Sure I do not have any objections against step by step approach.
 
> > cap those as well. The following should do the trick AFAICS.
> 
> Actually, no - you only account pipe metadata while anon pipe buffer
> pages, which usually constitute most of memory consumed by a pipe, still
> go unaccounted. I'm planning to make pipe accountable later.

You are right! I have missed pipe_write allocates the real page.

> > ---
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index 8865f7963700..c4b7e8c08362 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -590,7 +590,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
> >  
> >  	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
> >  	if (pipe) {
> > -		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL);
> > +		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL | __GFP_ACCOUNT);
> 
> GFP_KERNEL | __GFP_ACCOUNT are used really often, that's why I
> introduced GFP_KERNEL_ACCOUNT.

Sure that is better.
-- 
Michal Hocko
SUSE Labs
