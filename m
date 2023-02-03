From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/19] blk-cgroup: improve error unwinding in blkg_alloc
Date: Thu, 2 Feb 2023 14:10:07 -1000
Message-ID: <Y9xQ33MtLhoxtPNv@slm.duckdns.org>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kfNBgxSSJowqr7f+kUtO8SrtMneOtknsJRJcWhm3UM=;
        b=MfH7+aDprhldVN4x7NFL8jm8YAifDholHfvo/JApNRoGIQbAQS8a7v/X6sYID6DCFs
         ChgCX55D0e7oRxWe17EQk+cb7krzhwFdmJNXQSq3qSg+qUsmbLGBAnuehS4oa7Atg3eV
         t5Y6qiQ78HgQIbFuhKg53N/DXWQ3hGB08/4dKqxYq+8XZSkxVQ1vdWaprJamx9lR0OnH
         aS/ctHNBYfd1nja49T9VtQlzNjM4mjCngbn3coIwp577DTyZmiS3YmVxA/MEj7CVDxke
         sj4kufnoLb2i/NM0JyWgkxQ3U0DqNeG/WAN1TwGM+pHdITdBle1rdZ152VAcQuXiABLl
         aO0A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-4-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 01, 2023 at 02:41:07PM +0100, Christoph Hellwig wrote:
> Unwind only the previous initialization steps that happened in blkg_alloc
> using goto based unwinding.  This avoids the need for the !queue special
> case in blkg_free.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

This is fine but is this necessarily better? If it's needed for future
changes, maybe that should be mentioned?

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
