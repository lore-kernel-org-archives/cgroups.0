From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Mon, 13 Apr 2020 09:52:12 -0400
Message-ID: <20200413135212.GA60335@mtj.duckdns.org>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
 <b027a718-1c76-6e34-1edb-5435a5605d35@acm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pEQ2ZN/sQMUNp0cAGyj+0Oo/y3A6wiKh+7dkMJzMwVI=;
        b=MRSZ1qTh0me/yxxie/3CYFIGX8lrDC3ISjXJe6J7lVXk3NNURSYMsAEkOVRdvkUZVL
         K97VBE5C8GBEcLI1j6snQqwxNHlR4+HRv+4c/KG8wrRFOyycSy4N/YUZrTbaWF/itcdj
         cB85PL1NzoFmMsWzbeHhQx6dVVQzIf3ZmbjjAeD+6Zxf9S4eQh8M7DkjB6DbllIxcu9+
         EKj5ePFmNh8aNV2InN7y+YDDIRVaayW85AjvKvBf+4LPxQciv2SkXZe9Pwsh7Sb+gzyp
         dfQBXRF70YH8Zx2h75h9z8upaN74WXugMBbMvCCiTmq4wrRoQAEL6eB/jTiTQivTf8P6
         cxJQ==
Content-Disposition: inline
In-Reply-To: <b027a718-1c76-6e34-1edb-5435a5605d35-HInyCGIudOg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org

Hello,

On Wed, Apr 08, 2020 at 08:44:17PM -0700, Bart Van Assche wrote:
> On 2020-04-08 13:14, Tejun Heo wrote:
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 32868fbedc9e..bfd34c6a27ef 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -142,6 +142,14 @@ struct request {
> >  
> >  	/* the following two fields are internal, NEVER access directly */
> >  	unsigned int __data_len;	/* total data len */
> > +#ifdef CONFIG_BLK_RQ_IO_DATA_LEN
> > +	/*
> > +	 * Total data len at the time of issue. This doesn't get deducted by
> > +	 * blk_update_request() and can be used by completion path to determine
> > +	 * the request size.
> > +	 */
> > +	unsigned int io_data_len;
> > +#endif
> >  	sector_t __sector;		/* sector cursor */
> >  
> >  	struct bio *bio;
> 
> So we have one struct member with the description "total data len" and
> another struct member with the description "total data len at the time
> of issue"? How could one not get confused by these descriptions?

The new one explicitly says it doesn't get deducted by update_request.

> This change makes the comment above __data_len incorrect. Please update
> that comment or move io_data_len in front of that comment.

Sure.

> How does this change interact with the code in drivers/scsi/sd.c that
> manipulates __data_len directly?

It doesn't.

Thanks.

-- 
tejun
