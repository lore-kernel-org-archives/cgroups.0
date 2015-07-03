From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 36/51] writeback: implement bdi_for_each_wb()
Date: Fri, 3 Jul 2015 14:26:27 +0200
Message-ID: <20150703122627.GK23329@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-37-git-send-email-tj@kernel.org>
 <20150701072757.GW7252@quack.suse.cz>
 <20150702022226.GH26440@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150702022226.GH26440-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Wed 01-07-15 22:22:26, Tejun Heo wrote:
> On Wed, Jul 01, 2015 at 09:27:57AM +0200, Jan Kara wrote:
> > > +#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
> > > +	for ((iter)->next_id = (start_blkcg_id);			\
> > > +	     ({	(wb_cur) = !(iter)->next_id++ ? &(bdi)->wb : NULL; }); )
> > > +
> > 
> > This looks quite confusing. Won't it be easier to understand as:
> > 
> > struct wb_iter {
> > } __attribute__ ((unused));
> > 
> > #define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id) \
> >   if (((wb_cur) = (!start_blkcg_id ? &(bdi)->wb : NULL)))
> 
> But then break or continue wouldn't work as expected.  It can get
> really confusing when it's wrapped by an outer loop.

That's a good point. Thanks for explanation. Maybe add a comment like:
/*
 * We use use this seemingly complicated 'for' loop so that 'break' and
 * 'continue' continue to work as expected.
 */

								Honza

-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
