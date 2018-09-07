From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH 03/12] blkcg: convert blkg_lookup_create to find closest
 blkg
Date: Fri, 7 Sep 2018 16:33:21 -0400
Message-ID: <20180907203320.GB97913@dennisz-mbp.dhcp.thefacebook.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
 <20180906211045.29055-4-dennisszhou@gmail.com>
 <20180907172730.GB1100574@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FT1JS+mP7s3H0ehWUhrZs7M0IklabbNNqY5+yLxrfIE=;
        b=Q1VKss8Lue+m3hZoEmC1iP9DFK/xjg8lz1z8J7Ujsr7HryEXQRC1lTg8wqGJFvxEO+
         bd6Jb9sfUf7vD4tNZT9y3zGccUxxhlimUzWYrXJuwB9/mafY4IGuHQxR0mAMY/8DVqKk
         XPbtVip+rWcYNrCiTrrmfWfHMAklxPNakcHRBTmKYMRkB1bUWmQqU3ur/ge1Obdv8mrK
         o2ZhlPouil/4ldzGShrmQDbafb2xbiaTEhebWY9C25oDyu8JjAGeXmn5OW4edWw48Ze2
         3543IoWePb2R+ECB4s6AqNpjWBWVtm1Da2qpk8YD3a2iOVqn81bdIt7Ii0P0psva5JXm
         NLrg==
Content-Disposition: inline
In-Reply-To: <20180907172730.GB1100574@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Tejun,

On Fri, Sep 07, 2018 at 10:27:30AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 06, 2018 at 05:10:36PM -0400, Dennis Zhou wrote:
> > @@ -2021,9 +2021,7 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
> >  {
> >  	if (unlikely(bio->bi_blkg))
> >  		return -EBUSY;
> > +	bio->bi_blkg = blkg_try_get_closest(blkg);
> >  	return 0;
> 
> It prolly would be a good idea to point out that the associated blkg
> might not be the same one passed in.  Maybe this gets cleared up later
> in the series?
> 

Heh. I added comments everywhere else but the place it's used. Updated.

In hindsight though, it does make it a little problematic here as you
may have a different blkg than css. FWIW, it makes the next few patches
easier to read as they don't need to do nontrivial error handling that
will eventually be ripped out. And this is to really handle the edge
cases of OOM and dying cgroups. If you think it's worth fixing I can go
back through the set and adjust it all.

> > @@ -298,14 +297,23 @@ struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
> >  	while (true) {
> >  		struct blkcg *pos = blkcg;
> >  		struct blkcg *parent = blkcg_parent(blkcg);
> > -
> > -		while (parent && !__blkg_lookup(parent, q, false)) {
> > +		struct blkcg_gq *ret_blkg = NULL;
> > +
> > +		while (parent) {
> > +			blkg = __blkg_lookup(parent, q, false);
> > +			if (blkg) {
> > +				/* remember closest blkg */
> > +				ret_blkg = blkg;
> > +				break;
> > +			}
> >  			pos = parent;
> >  			parent = blkcg_parent(parent);
> >  		}
> >  
> >  		blkg = blkg_create(pos, q, NULL);
> > -		if (pos == blkcg || IS_ERR(blkg))
> > +		if (IS_ERR(blkg))
> > +			return ret_blkg ?: q->root_blkg;
> 
> Why not ret_blkg here?
> 

ret_blkg is only set if a parent exists. I can move that up to the
definition to remove the extra branch.

Thanks,
Dennis
