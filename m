From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH 04/15] blkcg: fix ref count issue with bio_blkcg using
 task_css
Date: Thu, 6 Sep 2018 11:21:23 -0400
Message-ID: <20180906152120.GA5055@dennisz-mbp.dhcp.thefacebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-5-dennisszhou@gmail.com>
 <20180831153538.brzgcm3rgmwfy3rg@destiny>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zb2t7fnEFpTNY92P+q79KIuwpqsi0lHQ8yrY3sayUYo=;
        b=dfEQPOBaSRiw1xlv2rsfYhgg1AgZjEGmxweeotaQt76RJ6rsw/kynSjJNQADcdre/b
         NYQx1xIVWWgu377YSlkvCTuowzC+Gw0ZvNfCj7ksqNwcJI3i3w+TRlnPQSDiNboj3Umx
         1uQi7QV3qgALw9D2eBzNZDS37Ts1bl6LMwuopKKkbAXs7O4cg9SFL5KXiEwLJ/V3DIij
         JvGDaWcltZF1RajrLj8e0RclKnPd2WS7a1b4QVebhg+ncuz3p4FlXQtNnGyMVu6S74db
         ckmszjeTLQimwH3zk/fUWEGEc7pYVoUA6GydO5kUOjtlip80CRpOwxOJvgJTCsCexgb4
         0pOA==
Content-Disposition: inline
In-Reply-To: <20180831153538.brzgcm3rgmwfy3rg@destiny>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 31, 2018 at 11:35:39AM -0400, Josef Bacik wrote:
> On Thu, Aug 30, 2018 at 09:53:45PM -0400, Dennis Zhou wrote:
> > From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> > +/**
> > + * blkcg_get_css - find and get a reference to the css
> > + *
> > + * Find the css associated with either the kthread or the current task.
> > + */
> > +static inline struct cgroup_subsys_state *blkcg_get_css(void)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +
> > +	rcu_read_lock();
> > +
> > +	css = kthread_blkcg();
> > +	if (css) {
> > +		css_get(css);
> > +	} else {
> > +		while (true) {
> > +			css = task_css(current, io_cgrp_id);
> > +			if (likely(css_tryget(css)))
> > +				break;
> > +			cpu_relax();
> 
> Does this work?  I'm ignorant of what cpu_relax() does, but it seems if we're
> rcu_read_lock()'ed here we aren't going to queisce so if we fail to get the css
> here we just simply aren't going to get it unless we go to sleep right?  An
> honest question, because this is all magic to me, I'd like to understand how
> this isn't going to infinite loop on us if css_tryget(css) fails.
> 

Tejun replied earlier with an indepth answer. Thanks Tejun! I'll make
sure to add a comment detailing what's going on.

> > +/**
> > + * bio_blkcg - grab the blkcg associated with a bio
> > + * @bio: target bio
> > + *
> > + * This returns the blkcg associated with a bio, NULL if not associated.
> > + * Callers are expected to either handle NULL or know association has been
> > + * done prior to calling this.
> > + */
> >  static inline struct blkcg *bio_blkcg(struct bio *bio)
> >  {
> > -	struct cgroup_subsys_state *css;
> > -
> >  	if (bio && bio->bi_css)
> >  		return css_to_blkcg(bio->bi_css);
> > -	css = kthread_blkcg();
> > -	if (css)
> > -		return css_to_blkcg(css);
> > -	return css_to_blkcg(task_css(current, io_cgrp_id));
> > +	return NULL;
> >  }
> >  
> 
> So this is fine per se, but I know recently I was doing a bio_blkcg(NULL) to get
> whatever the blkcg was for the current task.  I threw that work away so I'm not
> worried about me, but have you made sure nobody else is doing something similar?
> 

Initially I thought the BFQ and CFQ stuff only interacted with bios
which should already be associated. Turns out during init, they rely on
that bio_blkcg to read from current and then do the wrong thing of hard
associating with it (_get vs _tryget).

I've created a __bio_blkcg which is identical to the old function with
notes to not use it. Making changes to BFQ and CFQ would take a good bit
more work to make sure I'm not breaking what they're expecting to do, so
I leave that to future work.

> >  static inline bool blk_cgroup_congested(void)
> > @@ -519,6 +549,11 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
> >  	rcu_read_lock();
> >  
> >  	blkcg = bio_blkcg(bio);
> > +	if (blkcg) {
> > +		css_get(&blkcg->css);
> > +	} else {
> > +		blkcg = css_to_blkcg(blkcg_get_css());
> > +	}
> 
> Kill these extra braces please.  Thanks,

Done.

Thanks,
Dennis
