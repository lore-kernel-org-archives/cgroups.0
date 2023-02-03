From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/19] blk-cgroup: simplify blkg freeing from
 initialization failure paths
Date: Thu, 2 Feb 2023 14:12:54 -1000
Message-ID: <Y9xRhm12BtP0opKL@slm.duckdns.org>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qWrxRvXYkO0FIHGpgnvF1HbU2gb6xyHIhFjdJfXiDL8=;
        b=jefwpmuUIXNHiDEXoWrz0zwJUkVE2aApHuVeZJ+yR9RdPv/1qhJSf2LMP0ddT6Fdv+
         5HgK381bL5ilSxbhhSD+w4clm0Kywl59IIQ98bTdgzZoBAYSxzLvu/tdrEI8dd8ICNSP
         fH8WZDgizFOEz5MEbCVLq5TJfoE6bb+Y1hsviBA/IaZ//ZuAPx4cyzZ8etfz8yBuDVII
         A+RmdA6OQldCinFvHn2d+0YXyfNr+fYq7mFlXq5mBfCpVPpJm4ws3V6HAH5S9YjA5h9U
         dIc0qf7nfUF3qt6+f8JyaTK2klhmDNWGp2DNlt3MZuQnNazV1V+sSufpcbceho0ptfB8
         SlPg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-5-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 01, 2023 at 02:41:08PM +0100, Christoph Hellwig wrote:
> There is no need to delay freeing a blkg to a workqueue when freeing it
> after an initialization failure.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Ditto, ack but I'm not sure this is necessarily better.

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
