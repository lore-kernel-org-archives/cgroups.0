From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH -next] block: fix io hung of setting throttle limit
 frequently
Date: Tue, 17 May 2022 15:49:58 +0800
Message-ID: <YoNTpswO2+tEWbWo@T590>
References: <20220516014429.33723-1-zhangwensheng5@huawei.com>
 <YoKmCOAzwzw3Lz7g@slm.duckdns.org>
 <ca251645-8d52-7a93-6ac2-579d97922a9e@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652773811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fcxa52FaP/LJSTmTsYRMIBzyizNUgowBuXRZOO4RnAA=;
        b=VPny+DKtQg1QfmgCXr0WbYrT3NApY27T98anfyYSZDhvv/qsGU/SSDItd9F43QV4DkT2/x
        ObnH0U9uH7zx02JTMifgw3IiOWg9oDDUK3P4Lf5XWJfdt0FtuBeubTvewPfQL8SYCPFGPc
        QDW+FafzXELWvwO1r2q+cPRhvBjUzY8=
Content-Disposition: inline
In-Reply-To: <ca251645-8d52-7a93-6ac2-579d97922a9e@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Zhang Wensheng <zhangwensheng5@huawei.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue, May 17, 2022 at 11:12:28AM +0800, yukuai (C) wrote:
> 在 2022/05/17 3:29, Tejun Heo 写道:
> > On Mon, May 16, 2022 at 09:44:29AM +0800, Zhang Wensheng wrote:
> > > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> > > index 469c483719be..8acb205dfa85 100644
> > > --- a/block/blk-throttle.c
> > > +++ b/block/blk-throttle.c
> > > @@ -1321,12 +1321,14 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
> > >   	 * that a group's limit are dropped suddenly and we don't want to
> > >   	 * account recently dispatched IO with new low rate.
> > >   	 */
> > > -	throtl_start_new_slice(tg, READ);
> > > -	throtl_start_new_slice(tg, WRITE);
> > > +	if (!timer_pending(&sq->parent_sq->pending_timer)) {
> > > +		throtl_start_new_slice(tg, READ);
> > > +		throtl_start_new_slice(tg, WRITE);
> > > -	if (tg->flags & THROTL_TG_PENDING) {
> > > -		tg_update_disptime(tg);
> > > -		throtl_schedule_next_dispatch(sq->parent_sq, true);
> > > +		if (tg->flags & THROTL_TG_PENDING) {
> > > +			tg_update_disptime(tg);
> > > +			throtl_schedule_next_dispatch(sq->parent_sq, true);
> > > +		}
> > 
> > Yeah, but this ends up breaking the reason why it's starting the new slices
> > in the first place explained in the commit above, right? I'm not sure what
> > the right solution is but this likely isn't it.
> > 
> Hi, Tejun
> 
> Ming added a condition in tg_with_in_bps_limit():
> -       if (bps_limit == U64_MAX) {
> +       /* no need to throttle if this bio's bytes have been accounted */
> +       if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
> 
> Which will let the first throttled bio to be issued immediately once
> the config if updated.
> 
> Do you think this behaviour is OK? If so, we can do the same for
> tg_with_in_iops_limit.

IMO, you can't do that for iops limit. If BIO_THROTTLED is set for one
bio, all its bytes have been accounted, so no need to throttle this bio
in case of bps limit. iops limit is another story, since io account is
done in request IO which is based on split bio, so the bio(split bio)
still need to be check & throttle in case of iops limit.


Thanks,
Ming

