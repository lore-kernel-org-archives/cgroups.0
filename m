From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/19] blk-cgroup: delay blk-cgroup initialization until
 add_disk
Date: Thu, 2 Feb 2023 14:08:13 -1000
Message-ID: <Y9xQbSp3BjHM+VtS@slm.duckdns.org>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMk1NYKC1lJtEdtB8eToFsMCqzZsTQWGW+RVlS9XghE=;
        b=LOvy3i72nUa/WOnJbZkQjbqz2F990paP9jA/43nmN61WN+V9gt871bPmm3L8Yzb6KH
         GDCMJckpYT3lmvmczvKebXE6tzN56T0j+K5aNRchPoXGaJewwd6OdQ1xfjRCr3ASDeGP
         ZUe5rMIkYuUTrutLb7EqOAFi4/55Nn+y15xClpYXbBKFVnR8VCJof6Nkl7EG1AEcgfUl
         gTq1Ai9k/InCmWskbQ0snTA/M5jbJWSI4Y5cxrHDR7yL/iV7UwEnUT6x4gGS4NOfRljz
         mdDndjieKV7yd09ETOYEAxHFPtFcB8MrLcpCjA+9QlM/aeMUNiqRsTHboDM1MrnzBZ8j
         s4fw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Wed, Feb 01, 2023 at 02:41:06PM +0100, Christoph Hellwig wrote:
> There is no need to initialize the cgroup code before the disk is marked
> live.  Moving the cgroup initialization earlier will help to have a
> fully initialized struct device in the gendisk for the cgroup code to
> use in the future.  Similarly tear the cgroup information down in
> del_gendisk to be symmetric and because none of the cgroup tracking is
> needed once non-passthrough I/O stops.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

For 01 - 02:

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
