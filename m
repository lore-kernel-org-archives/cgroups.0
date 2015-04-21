From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 12/49] writeback: move backing_dev_info->bdi_stat[] into
 bdi_writeback
Date: Tue, 21 Apr 2015 17:05:59 +0200
Message-ID: <20150421150559.GB32616@quack.suse.cz>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-13-git-send-email-tj@kernel.org>
 <20150420150231.GA17020@quack.suse.cz>
 <20150420175626.GB4206@htj.duckdns.org>
 <20150421085119.GA24278@quack.suse.cz>
 <20150421150229.GA9455@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150421150229.GA9455-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

On Tue 21-04-15 11:02:29, Tejun Heo wrote:
> On Tue, Apr 21, 2015 at 10:51:19AM +0200, Jan Kara wrote:
> >   I can easily understand what "initializing writeback structure" means but
> > "exiting writeback structure" doesn't really make sense to me. OTOH
> > "destroying writeback structure" does make sense to me. That's the only
> > reason.
> 
> We have enough cases where "exit" is used that way starting with
> module_exit() and all the accompanying __exit annotations and there
> are quite a few others.  I think it's enough to establish "exit" as
> the counterpart of "init" but I do agree that it felt a bit alien to
> me at the beginning too.
> 
> In general, I've been sticking with create/destroy if the object
> itself is being created or destroyed and init/exit if the object
> itself stays put across init/exit which is the case here.  This isn't
> quite universal but I think there exists enough of a pattern to make
> it worthwhile to stick to it.  As such, I'd like to stick to the
> current names if it isn't a big deal.
  It's not a big deal, so feel free to keep your naming. It's not a
function I'd stare at every day ;)

								Honza

-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
