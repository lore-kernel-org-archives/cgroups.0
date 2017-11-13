From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] blk-throtl: don't throttle the same IO multiple times
Date: Mon, 13 Nov 2017 11:54:13 -0800
Message-ID: <20171113195413.b5lzqem2pt2bg4oe@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-8-tj@kernel.org>
 <20171113040716.kaheegc4qub42n6z@kernel.org>
 <20171113111348.GF983427@devbig577.frc2.facebook.com>
 <20171113155745.GI983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113155745.GI983427-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Mon, Nov 13, 2017 at 07:57:45AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Nov 13, 2017 at 03:13:48AM -0800, Tejun Heo wrote:
> > You're right.  If we wanna take this approach, we need to keep the
> > throttled flag while cloning.  The clearing part is still correct tho.
> > Without that, I get 1/4 bw limit enforced.  Hmm... I'm not quite sure
> > where that 1/4 is coming from tho.  Will investigate more.
> 
> Okay, this is because when we spiit, the split bio is the first part
> which gets issued and then the orignal bio is wound forward and
> requeued.  So, for the splits, the original bio is the one which gets
> trimmed in the front and requeued, so not clearing BIO_THROTTLED is
> enough.  I think we should still copy BIO_THROTTLED on clones so that
> we don't get suprises w/ other bio drivers.

I'm not sure how you are going to make this correct. The mechanism is very
fragile. So for example, 'q->make_request_fn(q, bio)' could just queue the bio
somewhere and handle in other context (both dm and md do this). The bio will be
called again with generic_make_request. In this case, the second time shouldn't
throttle the bio. The bio could be called again with generic_make_request but
with bdev changed. In this case, the second time should throttle the bio
(against the new bdev). There are a lot of different usages of bio. I'd rather
not depend on generic_make_request dispatches new bio immediately. That's why I
add a bdev in my patch.

Thanks,
Shaohua
