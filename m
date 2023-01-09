From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Mon, 9 Jan 2023 11:59:16 +0100
Message-ID: <20230109105916.jvnhjdseqkwejmws@quack3>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3>
 <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673261957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0zum01+6W6CWGMuMAoT/HPm/pZWcmXb0ZmN9Mhpgb7I=;
        b=ymj96arAyGY+TaDCybETNaeMAySXQp5KaSrVNcO0/OpY+kQw5rdon1sjJB7tKOPbOyxBwd
        A2CoKC/TqexuuhGvp62eh3K/FkSGbUpPtWfJM7Q8WOHWgpjlmaSUOJRn9OKafa1k8qdnjW
        t4yKDvi7JUiI9afyU16poZuHMUoIIU4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673261957;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0zum01+6W6CWGMuMAoT/HPm/pZWcmXb0ZmN9Mhpgb7I=;
        b=i8nH3Nw8dN1tGgWZlu3bylvucdc8gG2H7zcFWPr66gE2yEASNbya0Ohs/HqWFhRbPegPeF
        LQGbI2DPoix2hhAA==
Content-Disposition: inline
In-Reply-To: <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jinke Han <hanjinke.666@bytedance.com>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com

Hello!

On Fri 06-01-23 06:58:05, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 06, 2023 at 04:38:13PM +0100, Jan Kara wrote:
> > Generally, problems are this are taken care of by IO schedulers. E.g. BFQ
> > has quite a lot of logic exactly to reduce problems like this. Sync and
> > async queues are one part of this logic inside BFQ (but there's more).
> 
> With modern ssd's, even deadline's overhead is too high and a lot (but
> clearly not all) of what the IO schedulers do are no longer necessary. I
> don't see a good way back to elevators.

Yeah, I agree there's no way back :). But actually I think a lot of the
functionality of IO schedulers is not needed (by you ;)) only because the
HW got performant enough and so some issues became less visible. And that
is all fine but if you end up in a configuration where your cgroup's IO
limits and IO demands are similar to how the old rotational disks were
underprovisioned for the amount of IO needed to be done by the system
(i.e., you can easily generate amount of IO that then takes minutes or tens
of minutes for your IO subsystem to crunch through), you hit all the same
problems IO schedulers were trying to solve again. And maybe these days we
incline more towards the answer "buy more appropriate HW / buy higher
limits from your infrastructure provider" but it is not like the original
issues in such configurations disappeared.

> > But given current architecture of the block layer IO schedulers are below
> > throttling frameworks such as blk-throtl so they have no chance of
> > influencing problems like this. So we are bound to reinvent the scheduling
> > logic IO schedulers are already doing. That being said I don't have a good
> > solution for this or architecture suggestion. Because implementing various
> > throttling frameworks within IO schedulers is cumbersome (complex
> > interactions) and generally the perfomance is too slow for some usecases.
> > We've been there (that's why there's cgroup support in BFQ) and really
> > the current architecture is much easier to reason about.
> 
> Another layering problem w/ controlling from elevators is that that's after
> request allocation and the issuer has already moved on. We used to have
> per-cgroup rq pools but ripped that out, so it's pretty easy to cause severe
> priority inversions by depleting the shared request pool, and the fact that
> throttling takes place after the issuing task returned from issue path makes
> propagating the throttling operation upwards more challenging too.

Well, we do have .limit_depth IO scheduler callback these days so BFQ uses
that to solve the problem of exhaustion of shared request pool but I agree
it's a bit of a hack on the side.

> At least in terms of cgroup control, the new bio based behavior is a lot
> better. In the fb fleet, iocost is deployed on most (virtually all) of the
> machines and we don't see issues with severe priority inversions.
> Cross-cgroup control is pretty well controlled. Inside each cgroup, sync
> writes aren't prioritized but nobody seems to be troubled by that.
> 
> My bet is that inversion issues are a lot more severe with blk-throttle
> because it's not work-conserving and not doing things like issue-as-root or
> other measures to alleviate issues which can arise from inversions.

Yes, I agree these features of blk-throttle make the problems much more
likely to happen in practice.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
