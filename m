From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Date: Mon, 2 Jun 2014 13:24:54 -0400
Message-ID: <20140602172454.GA8912@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ao++KD1g880DEmy2xz4JaJ4SL2vzg/zvdNIEMjv3nkE=;
        b=hhlIBtxht876zpakdCL4QhZmZVfxziIqDuGR1ANmV3W3h0BFaHu5V4MznK5MIsn/Wc
         BHVnMBgDvhXBw3366telOwFO3+2a7yOuYSK5qh7VEjrLwnyvd/UkIP0GREHytBTs4mqe
         FGvXjG0zDjaUagzZePVvp+CbT/pn/F+aorAuWLJ6HaWVQBAL+m9Uoqn3q7dHuTbxVbcV
         +iPmaUUgqkTxuxJOQXofalinGQIwtpkZGa5oOvZauQBWUfDIMiRiuIb/amG1dZRuVYpQ
         ogfhAbJr60rnO9POQAIWD2tNqWINnpSZRnTqBiFbmD/UQGBKBKiz3QLexOgVV3H9mfFH
         LnRA==
Content-Disposition: inline
In-Reply-To: <538C8A47.1050502-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Jens.

On Mon, Jun 02, 2014 at 08:29:27AM -0600, Jens Axboe wrote:
> One thing I've neglected to bring up but have been thinking about - we're
> quickly getting to the point where the old request_fn IO path will become a
> legacy thing, mostly in maintenance mode. That isn't a problem for morphing
> bfq and cfq, but it does mean that development efforts in this area would be
> a lot better spent writing an IO scheduler that fits into the blk-mq
> framework instead.

What I'm planning right now is improving blkcg so that it can do both
proportional and hard limits with high cpu scalability, most likely
using percpu charge caches.  It probably would be best to roll all
those into one piece of logic.  I don't think, well at least hope,
that we'd need multiple modular scheduler / blkcg implementations for
blk-mq and both can be served by built-in scheduling logic.
Regardless of device speed, we'd need some form of fairness
enforcement after all.

Thanks.

-- 
tejun
