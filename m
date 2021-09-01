From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding
 sqpoll cpu
Date: Wed, 1 Sep 2021 06:42:34 -1000
Message-ID: <YS+teuBxFf4FDR2Z@slm.duckdns.org>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
 <YS+tPq1eiQLx4P3M@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I/12n8rMfk8oX95Dp/kXhDB9zSufOAz0gOizwOSygwA=;
        b=H7mNS9HMvgMOWRHP97ycjoSDuuEtjVdJIYCUlqa2c0NCNb2NsE4kulK1Mxf2TgcFD4
         J9DHpdMgW5jd9BeLaFDF14Cm0vkRYHdEQaNyuKHjPKX8n87v4jmj4ZDlnLUjjf5eh8sv
         MpwaozggVg9f4wmh0aQA0RvlhAa0nyprm8O45fPcshfXZPd7uRyn9/ZrxMwtule0d7le
         XnxkMgJdyNlwI1lIy6V+ieBs6QyWgmFHgfdQho3Y9mLMYrIn8eIzW90i/uG+oMljT2q/
         xkj27W3WnoA+uPu0AirIYiUeNUy4BR+fQvJK+lADfxrX0PIFZZTjGk5kEV1mwUJ7996J
         Kwqw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YS+tPq1eiQLx4P3M@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <haoxu@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

On Wed, Sep 01, 2021 at 06:41:34AM -1000, Tejun Heo wrote:
> I don't know what the intended behavior here should be and we haven't been
                                                                ^
                                                                have
> pretty bad at defining reasonable behavior around cpu hotplug, so it'd
> probably be worthwhile to consider what the behavior should be.

-- 
tejun
