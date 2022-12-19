From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next 2/4] blk-iocost: don't throttle bio if iocg is
 offlined
Date: Mon, 19 Dec 2022 11:28:48 -1000
Message-ID: <Y6DXkLeOmu7VWovz@slm.duckdns.org>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
 <20221217030527.1250083-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+/Zc6HF+HMCFeX1vjX9OMe2YVRCyrJBTigomMNkApo=;
        b=YTxP4cH27crU7cLDy6KXr1WIQp1FJaDX9Sc61wvNatsiejqKbzyE48BOtkzQoEJscq
         Xq9vKKPkduSkCxvqnlSJ+xuUS2DG/FkZUqHmNjXz3ZlcQzGeXsru7Uj9z9tn9cNlKJtl
         UUpC3fWTWzopHj4/75cKXOvthjER/sDCA+LF4YYRxrp8gfhIhktADeGATWDVFd25z9Y5
         JYoI8ra68qoDQVE/4Cz0stB9x1/ZcyVfutfh5n2O/wU3DijgV25mNSCglMHsoJDRC8Fd
         RhkwwWhNETISGbtH3iG3qYZwuVADiu/Un2Gv90U3+kE5KnTgdnaPZfqNW+tChGZ8PbWB
         INsw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221217030527.1250083-3-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Sat, Dec 17, 2022 at 11:05:25AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> bio will grab blkg reference, however, blkcg->online_pin is not grabbed,
> hence cgroup can be removed after thread exit while bio is still in
> progress. Bypass io in this case since it doesn't make sense to
> throttle bio while cgroup is removed.

I don't get it. Why wouldn't that make sense? ISTR some occasions where we
clear the config to mitigate exits stalling for too long but in general a
policy being active on a draining cgroup shouldn't be a problem.

Thanks.

-- 
tejun
