From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 00/13 v4] block: always associate blkg and refcount
 cleanup
Date: Tue, 27 Nov 2018 17:15:49 -0500
Message-ID: <20181127221549.GA33981@dennisz-mbp.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181127210959.3c2yhp7citaxoqxm@macbook-pro-91.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181127210959.3c2yhp7citaxoqxm@macbook-pro-91.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 27, 2018 at 04:10:01PM -0500, Josef Bacik wrote:
> On Mon, Nov 26, 2018 at 04:19:33PM -0500, Dennis Zhou wrote:
> > Hi everyone,
> > 
> > This is respin of v3 [1] with fixes for the errors reported in [2] and
> > [3]. v3 was reverted in [4].
> > 
> > The issue in [3] was that bio->bi_disk->queue and blkg->q were out
> > of sync. So when I changed blk_get_rl() to use blkg->q, the wrong queue
> > was returned and elevator from q->elevator->type threw a NPE. Note, with
> > v4.21, the old block stack was removed and so this patch was dropped. I
> > did backport this to v4.20 and verified this series does not encounter
> > the error.
> > 
> > The biggest changes in v4 are when association occurs and clearly
> > defining the cases where association should happen.
> >   1. Association is now done when the device is set to keep blkg->q and
> >      bio->bi_disk->queue in sync.
> >   2. When a bio is submitted directly to the device, it will not be
> >      associated with a blkg. This is because a blkg represents the
> >      relationship between a blkcg and a request_queue. Going directly to
> >      the device means the request_queue may not exist meaning no blkg
> >      will exist.
> > 
> > The patch updating blk_get_rl() was dropped (v3 10/12). The patch to
> > always associate a blkg from v3 (v3 04/12) was fixed and split into
> > patches 0004 and 0005. 0011 is new removing bio_disassociate_task().
> > 
> > Summarizing the ideas of this series:
> >   1. Gracefully handle blkg failure to create by walking up the blkg
> >      tree rather than fall through to root.
> >   2. Associate a bio with a blkg in core logic rather than per
> >      controller logic.
> >   3. Rather than have a css and blkg reference, hold just a blkg ref
> >      as it also holds a css ref.
> >   4. Switch to percpu ref counting for blkg.
> > 
> 
> Hmm so reading through this series it's made me realize that iolatency is sort
> of broken.  It relies on knowing if it needs to do something with the bio if
> there is a blkg associated with it.  Before this patchset there wouldn't be a

I don't think there is anything wrong with blk-iolatency. blk-iolatency
piggybacks off of the rq_qos hooks which when throttle gets called means
submit has happened on the bio. As a byproduct, all bios that
blk-iolatency sees has a blkcg associated with it from
blkcg_bio_issue_check(). This lets blk-iolatency associate a blkg in the
throttle hook - blkcg_iolatency_throttle().

Order of functions called:
  generic_make_request()
    generic_make_request_checks() <- associates blkcg
    make_request_fn() (eventually blk_mq_make_request)
      rq_qos_throttle()
        blkcg_iolatency_throttle() <- associate blkg based on blkcg

blk-throttle is another story, it kind of does association really high
up, but lets the block layer manage the request_queue and attribute it
all to the first blkg seen. I believe this is just the top level blkg
(same css, first request_queue). Disclaimer, I haven't read through much
of the blk-throttle code.

> blkg on the bio unless it was specifically associated.  I'm going to need to
> figure out a different way to tag bio's to indicate that blk-iolatency should
> care about it.  Probably add a bio flag or something.  Thanks,

I think the interaction gets a little confusing with stacked block
devices, but regardless, shouldn't blk-iolatency care about every bio
that comes through anyway? I think this would just translate to
throttling at each request_queue and not just the entrance queue.

If a bio has a device with no request_queue, I don't think it will ever
reach blk-iolatency because the bio goes straight to device and a
requirement to get to call rq_qos_throttle is to have a request_queue.

Thanks,
Dennis
