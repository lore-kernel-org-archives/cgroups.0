From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 04/13] blkcg: introduce common blkg association logic
Date: Thu, 29 Nov 2018 14:48:29 -0500
Message-ID: <20181129194829.GA95415@dennisz-mbp.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-5-dennis@kernel.org>
 <20181129154917.GD2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129154917.GD2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 29, 2018 at 07:49:17AM -0800, Tejun Heo wrote:
> On Mon, Nov 26, 2018 at 04:19:37PM -0500, Dennis Zhou wrote:
> > There are 3 ways blkg association can happen: association with the
> > current css, with the page css (swap), or from the wbc css (writeback).
> > 
> > This patch handles how association is done for the first case where we
> > are associating bsaed on the current css. If there is already a blkg
> > associated, the css will be reused and association will be redone as the
> > request_queue may have changed.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> A minor nit below.
> 
> > +/**
> > + * bio_associate_blkg - associate a bio with a blkg from q
> > + * @bio: target bio
> > + *
> > + * Associate @bio with the blkg found from the bio's css and request_queue.
> > + * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
> > + * already associated, the css is reused and association redone as the
> > + * request_queue may have changed.
> > + */
> > +void bio_associate_blkg(struct bio *bio)
> > +{
> > +	struct request_queue *q;
> > +	struct blkcg *blkcg;
> > +	struct blkcg_gq *blkg;
> > +
> > +	if (!bio_has_queue(bio))
> > +		return;
> 
> So, this isn't actually necessary cuz we don't stack with
> request_queues but it might be more consistent to call disassociate
> before returning above so that even if sth like that happens the
> function always guarantees that the blkg and bio agree.

Ah. That makes sense. I've changed bio_has_queue() to be
bio_blkg_association_check(). This calls disassociate and should handle
the case a bio transfers from a request_queue device to a bio driven
device. It changes the future patches slightly as we have to remember
the css before doing the check in case we want to reassociate with the
same css.

Thanks,
Dennis
