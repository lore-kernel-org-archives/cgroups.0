From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] blk-cgroup: stop using seq_get_buf
Date: Wed, 11 Aug 2021 07:56:54 -1000
Message-ID: <YRQPZosdoT1vo2Kz@slm.duckdns.org>
References: <20210810152623.1796144-1-hch@lst.de>
 <20210810152623.1796144-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cwgWzWHzZMmumV5gjVMxV+Qi76br3EdobHy6Ey8p6Oc=;
        b=Jeti1NcsjNeJ8sVoIL8mh7m++DlwgRbKC99cR4nnyCCnGPgDZLr/KvcqfiyObb5HOu
         eWltR2gmBq5S9Gk9GFt0amAZJRljTQm4Hv99hFbu4m7nEU1ve8c9WhTcs/Nrt9hW4tcY
         wNq5fjTzDet658woLOZ4exZWaa9kLGaUcOVG9tJrTTweJ7OvFjUKkQyfsutp5ZeKJHGK
         XViFgpEt424rTRYOYiUVq3rAtI9o6mk4t62xiM/GUJLUcICgarEi2xutTomBgRvcWxyq
         WMSNJa4+Nj0vk4AOhTUKGMgEl8OqETTOvZ7wcCL9YCDkICefJDefT38pevcUKUzV1FFX
         2H+Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210810152623.1796144-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Aug 10, 2021 at 05:26:23PM +0200, Christoph Hellwig wrote:
> seq_get_buf is a crutch that undoes all the memory safety of the
> seq_file interface.  Use the normal seq_printf interfaces instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
