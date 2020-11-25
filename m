From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] blk-cgroup: prevent rcu_sched detected stalls
 warnings in blkg_destroy_all()
Date: Wed, 25 Nov 2020 07:53:12 -0500
Message-ID: <X75TuKMuO2Ru+rVt@mtj.duckdns.org>
References: <20201121083420.3857433-1-yukuai3@huawei.com>
 <X75O8BNVSX3ZE86w@mtj.duckdns.org>
 <a24c48a3-6f17-98ac-47ad-770dd7e775ec@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2X0u1zymrYQOExBICa76gdQ48XGpkWMEvIhEcoogarU=;
        b=h7OFb4cEn3IpHhhmZsFcA2eih4hE1UpgsipaoC3FI2JkDg6aKHoI1bASA8i3rOFMzB
         RrPBAUJWAS+C7jH6bfxUekTUIfftfA/e2mf7MGBFHctQIlbpHuum4v/Oqwi80+CZszaP
         /36qAXSlJkmebZWFvlGQgg6buFqwe0ePfG2VJqk58y8bOoqNsEfLyzR6+ckzM8sFCWK1
         5C6rU+hO/4CCwKSLu/gQCovGnIz7UBzovijPSThu1Whb77PECc/SsguTi2Ep2+/+assZ
         l35vCvidV9OAgmqAyO7q1fdcOJmw/JI4UC0M5Rs73SylB8xrhqAyTVZUaGSUgTLmWqZO
         mIOA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <a24c48a3-6f17-98ac-47ad-770dd7e775ec@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, zhangxiaoxu5@huawei.com, houtao1@huawei.com

Hello,

On Wed, Nov 25, 2020 at 08:49:19PM +0800, yukuai (C) wrote:
> > You can't continue iteration after dropping both locks. You'd have to jump
> > out of loop and start list_for_each_entry_safe() again.
> 
> Thanks for your review, it's right. On the other hand
> blkcg_activate_policy() and blkcg_deactivate_policy() might have the
> same issue. My idea is that inserting a bookmark to the list, and
> restard from here.

For destruction, as we're destroying the list anyway, we don't need to
insert bookmark and start over from the beginning. For [de]activate policy,
we might need something fancier or change locking so that we can sleep while
iterating. However, policy [de]activations are a lot less of a problem as
they aren't operations which can happen commonly.

> By the way, I found that blk_throtl_update_limit_valid() is called from
> throtl_pd_offline(). If CONFIG_BLK_DEV_THROTTLING_LOW is off, lower
> limit will always be zero, therefor a lot of time will be wasted to
> iterate descendants to find a nonzero lower limit.
> 
> Do you think it's ok to do such modification:

Yeah, sure. Looks fine to me.

Thanks.

-- 
tejun
