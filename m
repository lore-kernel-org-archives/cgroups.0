From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Tue, 1 Nov 2022 06:46:35 -1000
Message-ID: <Y2FNa4bGhJoevRKT@slm.duckdns.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org>
 <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8NNV/E5PvWzmIXNGvDSWT/6GgvR8jci+9gjd8ctauYo=;
        b=LEL4GYFUmS8dUOAT/5nK1/KYd+ZwtOmK9IedlMya1qlOZRx+FuuuuA/CtLRS+eCLRz
         Nsz6Dr/k/g6GAPFyavmARI1wuovp24HHeB6HGw0lS3IQv+qRkvB0JZ1gKMbi/FLWoeYh
         H2hrCDdMs7KYEipsyf2LL7i2N5mYxjOCRDArSv1s0QSKfzMKIORCDRuOqdmBpwsohacW
         6QuUicBqOf+POhLdqmHX7PXtL0vRcyB4s4VBHQpx3CLs1uS4Aad6MGQMTANTDZpWbGKo
         YyQDpVTaEkJBqnArwECrk8uywmNczFnR0FTUAaZWfA8KK93xKlpBmR2J0DO1TKHyVw0i
         qwug==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d833ad15-f458-d43d-cab7-de62ff54a939-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Nov 01, 2022 at 06:46:56AM +0100, Jiri Slaby wrote:
> Yes. The real problem is that using anything else then an INT_MIN <= x <=
> INT_MAX _constant_ in an enum is undefined in ANSI C < 2x (in particular, 1
> << x is undefined too). gcc manual defines unsigned int on the top of that
> as defined too (so this holds for our -std=g*).
> 
> > I suppose the most reasonable thing to do here is just splitting them into
> > separate enum definitions. Does anyone know how this behavior change came to
> > be?
> 
> C2x which introduces un/signed long enums. See the bug I linked in the
> commit log:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

I see. So, it was an extension but the new standard is defined differently
and we're gonna end up with that behavior.

> The change is also turned on in < C2x on purpose. AIUI, unless there is too
> much breakage. So we'd need to sort it out in (rather distant) future anyway
> (when we come up to -std=g2x).

The part that the new behavior applying to <C2x feels like an odd decision.
I'm having a hard time seeing the upsides in doing so but maybe that's just
me not knowing the area well enough.

> > Do we know whether clang is gonna be changed the same way?
> 
> In C2x, Likely. In < C2x, dunno what'd be the default.

It looks like we can do one of the following two:

* If gcc actually changes the behavior for <c2x, split the enums according
  to their sizes. This feels rather silly but I can't think of a better way
  to cater to divergent compiler behaviors.

* If gcc doesn't change the behavior for <c2x, there's nothing to do for the
  time being. Later when we switch to -std=g2x, we can just change the
  format strings to use the now larger types.

Does the above make sense?

Thanks.

-- 
tejun
