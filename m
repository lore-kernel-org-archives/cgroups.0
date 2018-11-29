From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 05/13] blkcg: associate blkg when associating a device
Date: Thu, 29 Nov 2018 14:54:07 -0500
Message-ID: <20181129195407.GB95415@dennisz-mbp.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-6-dennis@kernel.org>
 <20181129155333.GE2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129155333.GE2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 29, 2018 at 07:53:33AM -0800, Tejun Heo wrote:
> On Mon, Nov 26, 2018 at 04:19:38PM -0500, Dennis Zhou wrote:
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
> >  do {						\
> >  	if ((bio)->bi_disk != (bdev)->bd_disk)	\
> >  		bio_clear_flag(bio, BIO_THROTTLED);\
> 
> Generally looks okay to me but I'm not sure about bio_set_dev_only().
> Maybe sth more explicit like bio_set_dev_without_blkg()?  Also, can
> you please add comments explaining which should be used when?
> 

I've switched it to bio_set_dev_without_blkg() and added the comment
below and added a comment in the use cases. Let me know if the wording
is fine below.

+/*
+ * Bio device setters.  A blkg represents the relationship between a blkcg
+ * and a request_queue.  When the device is set for a bio, it becomes possible
+ * to do blkg association.  Importantly, a blkg also holds a pointer back to
+ * the request_queue.  In general, bio_set_dev() should be used to keep
+ * bio->bi_disk->queue and bio->bi_blkg->q consistent.  If blkg association
+ * will be done explicitly or is a bio based device, use
+ * bio_set_dev_without_blkg().
+ */

Thanks,
Dennis
