From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/15] blkcg: fix ref count issue with bio_blkcg using
 task_css
Date: Fri, 31 Aug 2018 16:04:20 -0700
Message-ID: <20180831230420.GB1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-5-dennisszhou@gmail.com>
 <20180831153538.brzgcm3rgmwfy3rg@destiny>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mTxI2cMyb0DZL6tFA4aDgckTs2eXVqvVeVNbuADggPg=;
        b=KM/g7Nv4zU7+yNBwYcg1a6cVxScr+kBecO+gj/pM59O1sCrBdIxya90ApCd1WlkSBx
         zo5FIR2FpvTWbbIKr262uUovA5Lal4EYIkR7y7zkhC0qhnSH2kJi7HEnbGBmXtqF+Srb
         CR165COamE0I8d/usGGeCED1bcp7ex7MEfT2b7cUTKaHuwQe9SyMvQeYdySM1ZDB3W9K
         Jqg+o/bcyZkSjuvGwJG3ufZwDsUes+sGVAIwgfyzDLoAgBKxJCZ/sUHtcx4gx9F445CN
         Oo7sVd2RwEnK3dETjNhIbymQLhkmnIMO/i4eqjrRzcOxaetEGehx99cQAuD+culjt+lV
         rk5w==
Content-Disposition: inline
In-Reply-To: <20180831153538.brzgcm3rgmwfy3rg@destiny>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Dennis Zhou <dennisszhou@gmail.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 31, 2018 at 11:35:39AM -0400, Josef Bacik wrote:
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

The only time css_tryget() on task_css(current, xxx) can fail is if it
races against the current thread migrating away from that cgroup and
that cgroup is now getting destroyed.  IOW,

1. For css_tryget() to fail, the cgroup must be dying.
2. The cgroup must be empty for it to be dying.
3. current must have already been migrated away to a different cgroup.

So, the above happens only when racing against css_set_move_task() -
it's seeing the old css pointer.  As the membership pointer switching
must already have happened, all it's waiting for is the new css
membership pointer to be propagated on the polling cpu, making
cpu_relax() busy loop the right thing to do.

This pattern is also used in task_get_css() and cgroup_sk_alloc().
Given that it's a bit tricky, it probably would be worthwhile to
factor out and document it.

Once Josef's other concerns are addressed, please feel free to add

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
