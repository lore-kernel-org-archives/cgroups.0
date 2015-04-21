From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 15/49] writeback: move backing_dev_info->wb_lock and
 ->worklist into bdi_writeback
Date: Tue, 21 Apr 2015 10:59:42 +0200
Message-ID: <20150421085942.GB24278@quack.suse.cz>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-16-git-send-email-tj@kernel.org>
 <20150420153224.GD17020@quack.suse.cz>
 <20150420181707.GD4206@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150420181707.GD4206-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon 20-04-15 14:17:07, Tejun Heo wrote:
> Hello, Jan.
> 
> On Mon, Apr 20, 2015 at 05:32:24PM +0200, Jan Kara wrote:
> > > @@ -454,9 +451,9 @@ EXPORT_SYMBOL(bdi_init);
> > >  
> > >  void bdi_destroy(struct backing_dev_info *bdi)
> > >  {
> > > -	bdi_wb_shutdown(bdi);
> > > -
> > > -	WARN_ON(!list_empty(&bdi->work_list));
> > > +	/* make sure nobody finds us on the bdi_list anymore */
> > > +	bdi_remove_from_list(bdi);
> > > +	wb_shutdown(&bdi->wb);
> > >  
> > >  	if (bdi->dev) {
> > >  		bdi_debug_unregister(bdi);
> >   But if someone ends up calling bdi_destroy() on unregistered bdi,
> > bdi_remove_from_list() will be corrupting memory, won't it? And if I
> 
> bdi_init() does INIT_LIST_HEAD() on it, so it should be fine, no?
  Yeah, checking the code again, we are fine.

> > remember right there were some corner cases where this really happened.
> > Previously we were careful and checked WB_registered. I guess we could
> > check for !list_empty(&bdi->bdi_list) and also reinit bdi_list in
> > bdi_remove_from_list() after synchronize_rcu_expedited().
> 
> But we can't call bdi_destroy() more than once no matter what.  We'd
> be doing double frees.
  Sorry, I was thinking about calling bdi_unregister() more than once but
as the call is moved into bdi_destroy() that is really called only once.

You can add:
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
