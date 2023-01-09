From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Mon, 9 Jan 2023 07:10:22 -1000
Message-ID: <Y7xKfl7gGt+wb/I2@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3>
 <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
 <20230109105916.jvnhjdseqkwejmws@quack3>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v2F7MnQjWUM2mz3fa62EsZ0QXZ22HhpfAIEPFOeLt3g=;
        b=NUhh4xIZ+AOJcgsbU0xvlzbsJbVG+9T3Se2OyuTTwY9bT6lLSXeiL/gqBhuZRqP3gk
         DcSVyYGX4HnFUgLJH2s4TxhsSe2evRnc6dYpBgAWjfnWyvzIJcdOSYmZYjTh0z6n7dS5
         IDPQdCNb6odXMeAbi0edwjLaLnBRrvUSSKuDZ8KHQkTzhPmCuXO4iqDYkoDJ9gECFfyX
         ElnMf/H5FC3HCww5Zd8pZUVzLTH19cA5dXo+zTlZkxrTTwZs4Kn/yWlUz0OTbjIEi4Vd
         Oizt0ucUcD7hftQewLu/5aC2S9piZMYt0TUDDcyv3Ix1xigSYrBMFxSXTWg8QSXqjtFa
         zSfg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230109105916.jvnhjdseqkwejmws@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Jinke Han <hanjinke.666@bytedance.com>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com

Hello, Jan.

On Mon, Jan 09, 2023 at 11:59:16AM +0100, Jan Kara wrote:
> Yeah, I agree there's no way back :). But actually I think a lot of the
> functionality of IO schedulers is not needed (by you ;)) only because the
> HW got performant enough and so some issues became less visible. And that
> is all fine but if you end up in a configuration where your cgroup's IO
> limits and IO demands are similar to how the old rotational disks were
> underprovisioned for the amount of IO needed to be done by the system
> (i.e., you can easily generate amount of IO that then takes minutes or tens
> of minutes for your IO subsystem to crunch through), you hit all the same
> problems IO schedulers were trying to solve again. And maybe these days we
> incline more towards the answer "buy more appropriate HW / buy higher
> limits from your infrastructure provider" but it is not like the original
> issues in such configurations disappeared.

Yeah, but I think there's a better way out as there's still a difference
between the two situations. W/ hard disks, you're actually out of bandwidth.
With SSDs, we know that there are capacity that we can borrow to get out of
the tough spot. e.g. w/ iocost, you can constrain a cgroup to a point where
its throughput gets to a simliar level of hard disks; however, that still
doesn't (or at least shouldn't) cause noticeable priority inversions outside
of that cgroup because issue_as_root promotes the IOs which can be waited
upon by other cgroups to root charging the cost to the cgroup as debts and
further slowing it down afterwards.

There's a lot to be improved - e.g. the debt accounting and payback, and
propagation to originator throttling isn't very accurate leading to usually
over-throttling and under-utilization in some cases. The coupling between IO
control and dirty throttling is there and kinda works but it seems like it's
pretty easy to make it misbehave under heavy control and so on. But, even
with all those shortcomings, at least iocost is feature complete and already
works (not perfectly but still) in most cases - it can actually distribute
IO bandwidth across the cgroups with arbitrary weights without causing
noticeable priority inversions across cgroups.

blk-throttle unfortunately doesn't have issue_as_root and the issuer delay
mechanism hooked up and we found that it's near impossible to configure
properly in any scalable manner. Raw bw and iops limits just can't capture
application behavior variances well enough. Often, the valid parameter space
becomes null when trying to cover varied behaviors. Given the problem is
pretty fundamental for the control scheme, I largely gave up on it with the
long term goal of implementing io.max on top of iocost down the line.

> > Another layering problem w/ controlling from elevators is that that's after
> > request allocation and the issuer has already moved on. We used to have
> > per-cgroup rq pools but ripped that out, so it's pretty easy to cause severe
> > priority inversions by depleting the shared request pool, and the fact that
> > throttling takes place after the issuing task returned from issue path makes
> > propagating the throttling operation upwards more challenging too.
> 
> Well, we do have .limit_depth IO scheduler callback these days so BFQ uses
> that to solve the problem of exhaustion of shared request pool but I agree
> it's a bit of a hack on the side.

Ah didn't know about that. Yeah, that'd help the situation to some degree.

> > My bet is that inversion issues are a lot more severe with blk-throttle
> > because it's not work-conserving and not doing things like issue-as-root or
> > other measures to alleviate issues which can arise from inversions.
> 
> Yes, I agree these features of blk-throttle make the problems much more
> likely to happen in practice.

As I wrote above, I largely gave up on blk-throttle and things like tweaking
sync write priority doesn't address most of its problems (e.g. it's still
gonna be super easy to stall the whole system with a heavily throttled
cgroup). However, it can still be useful for some use cases and if it can be
tweaked to become a bit better, I don't see a reason to not do that.

Thanks.

-- 
tejun
