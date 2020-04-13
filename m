From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Mon, 13 Apr 2020 09:56:21 -0400
Message-ID: <20200413135621.GB60335@mtj.duckdns.org>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
 <20200409014406.GA370295@localhost.localdomain>
 <20200409021119.GJ162390@mtj.duckdns.org>
 <20200409023857.GB370295@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MEV4w5u8wTFD0TinBcOlOPPgb+JBc/8ZPXNjItBqEvc=;
        b=nhu8f+65G6mbDWJj8y7QJL/7UlzoaljLRQvRspKyQ1CA/3V1M0C4N1KGLFfrTbL8Tt
         tocYT+riHzS6jXIOooqsI+Q70TgCylKcvjHW4rv4Wqzfs18PJ5vAmK+8EyMAiPZdCYAY
         rue0xXczbx7/bbAKqpvIw/a5qCiA7yFQ/RyUo3AdGMjI2ziPFbOK2CCnThdfiJ9VjpxC
         IBmL2aH+zNXCSWto2s+rkQfVgZ7Y37rnId0ypzJV1nlC70CMyYGi84ECkUDEjHNpu5oS
         6uM0V++40A/0m0a86BcwN22LCZ6RBqGoi0NZjG//9GlQ8hYOpARHuViznwHNdU1zRaTU
         PNjQ==
Content-Disposition: inline
In-Reply-To: <20200409023857.GB370295-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org

Hello,

On Thu, Apr 09, 2020 at 10:38:57AM +0800, Ming Lei wrote:
> On Wed, Apr 08, 2020 at 10:11:19PM -0400, Tejun Heo wrote:
> > On Thu, Apr 09, 2020 at 09:44:06AM +0800, Ming Lei wrote:
> > > Almost all __blk_mq_end_request() follow blk_update_request(), so the
> > > completed bytes can be passed to __blk_mq_end_request(), then we can
> > > avoid to introduce this field.
> > 
> > But on some drivers blk_update_request() may be called multiple times before
> > __blk_mq_end_request() is called and what's needed here is the total number of
> > bytes in the whole request, not just in the final completion.
> 
> OK.
> 
> Another choice might be to record request bytes in rq's payload
> when calling .queue_rq() only for these drivers.

There sure are multiple ways to skin a cat.

> > > Also there is just 20 callers of __blk_mq_end_request(), looks this kind
> > > of change shouldn't be too big.
> > 
> > This would work iff we get rid of partial completions and if we get rid of
> > partial completions, we might as well stop exposing blk_update_request() and
> > __blk_mq_end_request().
> 
> Indeed, we can store the completed bytes in request payload, so looks killing
> partial completion shouldn't be too hard.

There's a reason why we've had partial completions. On slower IO devices, like
floppy, partial completions actually are advantageous. I'm not arguing this
still holds up as a valid justification but getting rid of partial completions
isn't just a decision about plumbing details either.

Thanks.

-- 
tejun
