From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH] blkcg: handle dying request_queue when associating a blkg
Date: Thu, 13 Dec 2018 10:47:13 -0500
Message-ID: <20181213154713.GA76721@dennisz-mbp.dhcp.thefacebook.com>
References: <20181211230308.66276-1-dennis@kernel.org>
 <1544570173.185366.397.camel@acm.org>
 <20181212040643.GA73727@dennisz-mbp.dhcp.thefacebook.com>
 <1544658892.185366.412.camel@acm.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544658892.185366.412.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Wed, Dec 12, 2018 at 03:54:52PM -0800, Bart Van Assche wrote:
> On Tue, 2018-12-11 at 23:06 -0500, Dennis Zhou wrote:
> > Hi Bart,
> > 
> > On Tue, Dec 11, 2018 at 03:16:13PM -0800, Bart Van Assche wrote:
> > > On Tue, 2018-12-11 at 18:03 -0500, Dennis Zhou wrote:
> > > > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > > > index 6bd0619a7d6e..c30661ddc873 100644
> > > > --- a/block/blk-cgroup.c
> > > > +++ b/block/blk-cgroup.c
> > > > @@ -202,6 +202,12 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
> > > >  	WARN_ON_ONCE(!rcu_read_lock_held());
> > > >  	lockdep_assert_held(&q->queue_lock);
> > > >  
> > > > +	/* request_queue is dying, do not create/recreate a blkg */
> > > > +	if (blk_queue_dying(q)) {
> > > > +		ret = -ENODEV;
> > > > +		goto err_free_blkg;
> > > > +	}
> > > > +
> > > >  	/* blkg holds a reference to blkcg */
> > > >  	if (!css_tryget_online(&blkcg->css)) {
> > > >  		ret = -ENODEV;
> > > 
> > > What prevents that the queue state changes after blk_queue_dying() has returned
> > > and before blkg_create() returns? Are you sure you don't need to protect this
> > > code with a blk_queue_enter() / blk_queue_exit() pair?
> > > 
> > 
> > Hmmm. So I think the idea is that we rely on normal shutdown as I don't
> > think there is anything wrong with creating a blkg on a dying
> > request_queue. When we are doing association, the request_queue should
> > be pinned by the open call. What we are racing against is when the
> > request_queue is shutting down, it goes around and destroys the blkgs.
> > For clarity, QUEUE_FLAG_DYING is set in blk_cleanup_queue() before
> > calling blk_exit_queue() which eventually calls blkcg_exit_queue().
> > 
> > The use of blk_queue_dying() is to determine whether blkg shutdown has
> > already started as if we create one after it has started, we may
> > incorrectly orphan a blkg and leak it. Both blkg creation and
> > destruction require holding the queue_lock, so if the QUEUE_FLAG_DYING
> > flag is set after we've checked it, it means blkg destruction hasn't
> > started because it has to wait on the queue_lock. If QUEUE_FLAG_DYING is
> > set, then we have no guarantee of knowing what phase blkg destruction is
> > in leading to a potential leak.
> 
> Hi Dennis,
> 
> To answer my own question: since all queue flag manipulations are protected
> by the queue lock and since blkg_create() is called with the queue lock held
> the above code does not need any further protection. Hence feel free to add
> the following:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

It seems that Christoph in 57d74df90783 ("block: use atomic bitops for
->queue_flags") changed it so that flag manipulations no longer are
protected by the queue_lock in for-4.21/block. But I think my
explanation above suffices that we will always be able to clean up a
blkg created as long as the QUEUE_FLAG_DYING is not set.

Thanks for reviewing this!
Dennis
