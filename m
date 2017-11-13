From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] blk-throtl: don't throttle the same IO multiple times
Date: Mon, 13 Nov 2017 11:58:54 -0800
Message-ID: <20171113195854.GJ983427@devbig577.frc2.facebook.com>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-8-tj@kernel.org>
 <20171113040716.kaheegc4qub42n6z@kernel.org>
 <20171113111348.GF983427@devbig577.frc2.facebook.com>
 <20171113155745.GI983427@devbig577.frc2.facebook.com>
 <20171113195413.b5lzqem2pt2bg4oe@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wou4yEYzjp1gjDdDbic2wwEmwiA1r3OV+cb55KG/TSU=;
        b=Z5UlriljNZsLpR12vil1Qh5ZfZxgq6fWDEK6d0pA9Heby1QMwkwJuh9+DB/PGWhWj0
         lEsEBE6Yu17ubXOq4eN9GeDJjF6Ww0jnFxhrhFafzY1Le35enxocD5moieF1GtogeXwZ
         Ah2tfsMlZrddRSzrSPTjzwtiEpPRyOI1m5wJZap0htTxGBX6oFlx0gbja2Am7UO09eRJ
         QK72RAsJO3pu+Qd5umZ9kkGM8UrM+cjQsklQHH6IazIBY1OzFUR1Xx6QriDmnA3PkIVm
         H42+eJdhk47SB0grzVdC3PeswEMS9AeALutNBcMPmF0ZzM1XOR2w4b7zk1pnI7qjFDo4
         XNcA==
Content-Disposition: inline
In-Reply-To: <20171113195413.b5lzqem2pt2bg4oe-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Nov 13, 2017 at 11:54:13AM -0800, Shaohua Li wrote:
> I'm not sure how you are going to make this correct. The mechanism is very
> fragile. So for example, 'q->make_request_fn(q, bio)' could just queue the bio
> somewhere and handle in other context (both dm and md do this). The bio will be
> called again with generic_make_request. In this case, the second time shouldn't
> throttle the bio. The bio could be called again with generic_make_request but
> with bdev changed. In this case, the second time should throttle the bio
> (against the new bdev). There are a lot of different usages of bio. I'd rather
> not depend on generic_make_request dispatches new bio immediately. That's why I
> add a bdev in my patch.

I see.  Yeah, that makes sense.  The cloned bios may get queued to a
different request_queue asynchronously and without remembering the
last queue, you can't tell whether it's a new queue or not.  I'll drop
this one and test with your patch.

Thanks.

-- 
tejun
