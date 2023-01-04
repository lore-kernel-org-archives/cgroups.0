From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Wed, 4 Jan 2023 11:44:49 -1000
Message-ID: <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jN9NPhWClQWUyrodOitLH/xXA1FW1Ui0r+TGvgzsk+I=;
        b=cXrEG+Rp4bpoH5QyJuX+T/ITDUTrmTAEJgtTakf8Fr9Z2UG0eudj3G1B3lDoHATS9X
         Pm6qsmfthZzQfo5pwH5129XqjfONgWZpmjQsh6hCjB+U3UFtQApzIPA0V4UIicMRHLVf
         ULndJXZPOxNjsIVje3f6lnnvitNlrJ8pNe+cARywmDSANC5W+7zE1wsgyInuVxBGp+Oi
         GDTviBGjbYgvqpnJ283V4Bso2KLNrk9rYlt6fgtCBOOOhMfEHDYoT7LyBJxXrtwzdEtt
         GgtXjLoCt0V+UpuVq8WB7HCl+4VoRTlnuxfUcdagBib6D5T5KVB0CQcjGu4of9j+dW7r
         2Dow==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221227125502.541931-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Dec 27, 2022 at 08:55:01PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> iocost requires that child iocg must exit before parent iocg, otherwise
> kernel might crash in ioc_timer_fn(). However, currently iocg is exited
> in pd_free_fn(), which can't guarantee such order:
> 
> 1) remove cgroup can concurrent with deactivate policy;
> 2) blkg_free() triggered by remove cgroup is asynchronously, remove
> child cgroup can concurrent with remove parent cgroup;
> 
> Fix the problem by add refcounting for iocg, and child iocg will grab
> reference of parent iocg, so that parent iocg will wait for all child
> iocg to be exited.

Wouldn't it be better to do this refcnting in the blk-cgroup core code
rather than in blk-iocost?

Thanks.

-- 
tejun
