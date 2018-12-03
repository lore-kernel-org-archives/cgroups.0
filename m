From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 05/13] blkcg: associate blkg when associating a device
Date: Mon, 3 Dec 2018 17:52:22 -0500
Message-ID: <20181203225222.GA3801@dennisz-mbp.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-6-dennis@kernel.org>
 <20181130095426.GB17103@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130095426.GB17103@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Nov 30, 2018 at 01:54:26AM -0800, Christoph Hellwig wrote:
> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index 62715a5a4f32..8bc9d9b29fd3 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -486,6 +486,12 @@ extern unsigned int bvec_nr_vecs(unsigned short idx);
> >  extern const char *bio_devname(struct bio *bio, char *buffer);
> >  
> >  #define bio_set_dev(bio, bdev) 			\
> > +do {						\
> > +	bio_set_dev_only(bio, bdev);		\
> > +	bio_associate_blkg(bio);		\
> > +} while (0)
> > +
> > +#define bio_set_dev_only(bio, bdev)		\
> 
> This lacks any explanation on when you would use bio_set_dev_only or
> bio_set_dev.  Please document why we need both and why you'd choose or
> the other.

I realized after thinking about this more and checking more use cases
that it isn't as simple as swapping macro uses because many of the
callers share common bio allocation paths. I think the simplest way
forward is to have writeback and swap do reassociation and split out bio
init code in a future series. So in v5, there is only bio_set_dev().

Thanks,
Dennis
