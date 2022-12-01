From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Thu, 1 Dec 2022 00:11:46 -1000
Message-ID: <Y4h94m8QMPtS4xJV@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
 <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
 <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pA5rgpRQHTSCN/GLM21EYU5Er0xU1UvmWyDaPEdq2Cw=;
        b=RHcGwSDXkjYbxA3YKl/rWeJUxYDAKLu2ymAgPasW2ObnBdRmEjmx4rW0oHKOgzu0vu
         DuKQhKP2dPrR7IHG8jv0kbMntMuAQ/rGgf4LqEJ/0yjFbLR2XtUb0NofTtdiJuqbPpBy
         Ka01w82uJUw4f2u3FwIdycBDfoiTgfXfMzBKM0R841WEG00s1FHlvS4St9Hf0UTnv+Mw
         kDXQ9dl0RRMJz+a8Rqm2MOOW1wZHU/s8uPNTJDcF7AmvorD0MtMGCTUyY/0YQNSf5isi
         jxE00CfvVD6QWtlKsUbjBb/YUEGRUUzTSzXZuzGjILxC+U3FpaUidhTb14Fe8ydR40Ug
         NqrA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Dec 01, 2022 at 10:12:13AM +0800, Yu Kuai wrote:
> 1) By mentioning that "del_gendisk() is quiescing the queue", do you
> suggest to add rcu_read_lock()? This seems wrong because blk_iocost_init
> requires memory allocation.

Quiescing uses SRCU so that should be fine but I'm not sure whether this is
the right one to piggyback on. Jens should have a better idea.

Thanks.

-- 
tejun
