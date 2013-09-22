From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cfq: explicitly use 64bit divide operation for 64bit
 arguments
Date: Sun, 22 Sep 2013 12:51:22 -0400
Message-ID: <20130922165122.GB30946@htj.dyndns.org>
References: <1377883916-8957-1-git-send-email-anatol.pomozov@gmail.com>
 <1377885149-28208-1-git-send-email-anatol.pomozov@gmail.com>
 <CAOMFOmV-MxF5vQqL1y4yY45LebFXA2DP7fsJx5CZcF+SSe6f7w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4P7KUoRgTUoCe4+clrMkj+8xwhs5usAsDz0GyIDVHqw=;
        b=pFnaskaLttapEFlnsYVMgD0VqpZqvRNodJNmUcGERhoOWRfqjk76HqG5nZ0nqqfSDB
         neVzNk++lfJjkn81nYZU8S29+U0X2X1VXEykMi58mQ6/gQiWqEwcg0obXbJx3ZrmIOJb
         eX9QhNiVyStfgb4LJekbO8rXV4ar7JK/LinpWwy0itVShm8l7rbp7dVU6k6VGM0ekxC0
         kR5lLB/4hC5B7Q9KfTEfQhnDUSzrSo/F8eutIgFT9hpcJYRn0yfPZXcTiRyv6Bopk0vK
         rEABm1QoKSxFwC2R5Z+mSG+xt2D0SjwmGMOgIEtVE8r+gV1K2pr+GauH6EIotu20qLAM
         k4GQ==
Content-Disposition: inline
In-Reply-To: <CAOMFOmV-MxF5vQqL1y4yY45LebFXA2DP7fsJx5CZcF+SSe6f7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

(cc'ing Jens)

Hello,

On Fri, Sep 13, 2013 at 09:20:45AM -0700, Anatol Pomozov wrote:
> Hi, Tejun
> 
> On Fri, Aug 30, 2013 at 10:52 AM, Anatol Pomozov
> <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 'samples' is 64bit operant, but do_div() second parameter is 32.
> > do_div silently truncates high 32 bits and calculated result
> > is invalid.
> >
> > In case if low 32bit of 'samples' are zeros then do_div() produces
> > kernel crash.
> >
> > Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  block/cfq-iosched.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index d5bbdcf..c410752 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -1803,7 +1803,7 @@ static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
> >
> >         if (samples) {
> >                 v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
> > -               do_div(v, samples);
> > +               v = div64_u64(v, samples);
> >         }
> >         __blkg_prfill_u64(sf, pd, v);
> >         return 0;
> 
> what do you think about this patch?

Sorry about the delay.  Was traveling.

  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

blkcg patches are routed through Jens's block tree but I haven't been
able to get hold of Jens lately.  Jens?

Thanks.

-- 
tejun
