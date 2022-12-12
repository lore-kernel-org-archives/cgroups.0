From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2 block/for-6.2] blk-iolatency: Make initialization lazy
Date: Mon, 12 Dec 2022 12:44:44 -1000
Message-ID: <Y5eu3A3TMWRUYd+N@slm.duckdns.org>
References: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
 <Y5TRU2+s379DhUbj@slm.duckdns.org>
 <Y5bsBuwjcbHEjhIw@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7VOrhnDaJPP4RQqpd0yn3MDNObHRe5gWELFMKh7qM4U=;
        b=K7K+mAD97aLDIIC1hy4vdLBoNY+c97ZElXwCxgTOIojifLfLg41cVFoKvqLr/yVhk1
         Xjldnx46lS/tylmHuKBWVwZ4D2U9l+GT8F8s5UI32yHMzoFMkM7mUs9Da4pv87Zjqse+
         2XJ024MHSpu/PdMqoKQdEYibBrmPF9lU87wV/19tl80ThgAB4NAKl7C78NjLLiURkI2R
         q6nYnOOfA1EHzCb+N7RDZMNuR64hObK8l7uk/2pBvB20VhAEr1bw+sta4cxC9pmnD0Pm
         QaFK4ty88+u2jOBWDw5jxivjEMqNbOwhW9on44uPbvbxURNAWHDnSOnjjF4rz4m+f2d/
         RcUg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y5bsBuwjcbHEjhIw-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darklight2357-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Christoph.

On Mon, Dec 12, 2022 at 12:53:26AM -0800, Christoph Hellwig wrote:
> > +static int blk_iolatency_try_init(char *input)
> > +{
> > +	static DEFINE_MUTEX(init_mutex);
> > +	struct block_device *bdev;
> > +	int ret = 0;
> > +
> > +	bdev = blkcg_conf_open_bdev(&input);
> > +	if (IS_ERR(bdev))
> > +		return PTR_ERR(bdev);
> 
> > +retry:
> >  	ret = blkg_conf_prep(blkcg, &blkcg_policy_iolatency, buf, &ctx);
> > +	if (ret == -EOPNOTSUPP) {
> > +		ret = blk_iolatency_try_init(buf);
> 
> It's a little sad to do two block device lookups here (even if it
> obviously doesn't matter for performance).  I wonder if it would
> make sense to explicitly support the lazy init pattern
> in blkg_conf_prep somehow.
> 
> Otherwise I'm all for the lazy init.

Yeah, I thought about separating out open_bdev from blkg_conf_prep() but the
added complexity didn't feel very attractive given the usage pattern. Lemme
take a stab at it. Maybe it won't look too bad.

Thanks.

-- 
tejun
