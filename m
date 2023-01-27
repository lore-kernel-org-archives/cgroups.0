From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/15] blk-wbt: open code wbt_queue_depth_changed in
 wbt_update_limits
Date: Fri, 27 Jan 2023 13:56:38 -1000
Message-ID: <Y9RkttC/XAScKdQp@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-9-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBcMmlP1oNR6HwzicKU5lpUtRWz5wSpADFnTmuSK9G4=;
        b=JekLdnK+ZQwksZmuaCiVS64kjOmWLje3UCcDBdnV9poXYxxuO+wkHGWpYnTJq7cAmU
         7XZRUIICytVduVw1l40UPjKGwrrFde3ClLvR8MDo3QI5/Uoj7X9ZwY463+xFMh0nHsX/
         45Nz5HNkjA8BwSVUuxl9NY+ibbh873bLevbT9A718Ou6dQG5pFX/6qQtefVbYHWfRLZb
         EvP/H4NLJczStEuCukbH77eRYHjNXSDJS8yZszY8A6Q9gXy5FpZbxK7Zki4AVpeh+75F
         2sWpeMNcxaN5AKttnaU2bkB/rDn+b00yFHKCerXGzrCvrTYWazvQe+CqZH1j8V08HyxS
         Iq3w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-9-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Tue, Jan 24, 2023 at 07:57:08AM +0100, Christoph Hellwig wrote:
> No real need to all the method here, so open code to it to prepare

I might be being slow but can't understand what the first sentence is
saying. I think making the descriptions a bit more detailed would be
generally helpful.

Thanks.

-- 
tejun
