From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/19] blk-cgroup: store a gendisk to throttle in struct
 task_struct
Date: Thu, 2 Feb 2023 14:17:55 -1000
Message-ID: <Y9xSs0Gf8Qcr9R7w@slm.duckdns.org>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQ2SE0xgSABc11mXNWl+oiadQkiomrK4JUHBAot+aRE=;
        b=Ej/GrPr2RzCgO9vpRQBNclgQuceQb6QIjdnDFM0M4Dcq6P/sNAuyxhNH0LXuXbxfyc
         g2pIvuuGTSmqfU0z2dOlCmoP/Ec/h3m9r/hNF0m5hpUt4gJdQ8RGoBTEZw9CIPTRJK93
         wlK1JajBcwddE+Xd9elPV7yHz2nlt12lHnPNonYfaunszbwhJMVjZUBGxuhdsUUccUq7
         1imFJjOP8ZnJUHgaCrji200rJik7ZgaX/5nrxUNfOUcKbek4xbOhbJexnnH8DITZvPDS
         /F9t8tixH+O5dP0Lt8w66q/FdMknBH9RWUkDlMRQGXLngA8AHLmO5piYP8pdmsZEbTmo
         BONA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-8-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Wed, Feb 01, 2023 at 02:41:11PM +0100, Christoph Hellwig wrote:
> Switch from a request_queue pointer and reference to a gendisk once
> for the throttle information in struct task_struct.
> 
> Move the check for the dead disk to the latest place now that is is
> unbundled from the reference grab.

The change looks fine to me but can you please separate out the dead disk
test change to its own patch and explain why?

Thanks.

-- 
tejun
