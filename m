From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Wed, 26 Jan 2022 07:03:06 -1000
Message-ID: <YfF+yukISfkuc9IK@slm.duckdns.org>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com>
 <Yd5FkuhYX9YcgQkZ@T590>
 <b416e6a6-f2c9-caf3-dacd-f937746207da@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AwYHKz1GfwyPBAeaDvfhIvi+S5N70d9KsK6NMZPpRu0=;
        b=G43+bA1dTI/pzs7p8eykDJ6DRBvA00FoYTGWOy8LNRG+HKOJndQBXGBO0TJvffG7rB
         t2X5cteQXJTkmavc0204qAqPFBZi0Q8Ki8to+HmHZlNc7BEPiZw+LS+dd3lwrys7tjF1
         ZkwqkPS1xpGGj3fr9hCnkQrefH038dMHVFlSGd7LL0HNcLN0j+vTifguCFW1BwBlhJ1x
         HZCRCeJGKa0D5k0TRNUV5Ws1eB7T8JLVe3k4t87kJJmeq9yikZVeTi1+eIwlYOk3FFWg
         hYug8J9JYnWru2MIomZE/ucY+Vi/dK8dMqVNVxgSvruDnFRBZUN0kfmluLWJ52LTdJq/
         q9iQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b416e6a6-f2c9-caf3-dacd-f937746207da-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Jan 24, 2022 at 11:50:11AM +0800, yukuai (C) wrote:
> Both ways can fix the problem, which way do you prefer?

Ming's suggested change seems simpler, no?

Thanks.

-- 
tejun
