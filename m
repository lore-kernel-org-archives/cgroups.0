From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Thu, 12 Jan 2023 14:53:42 -1000
Message-ID: <Y8CrloCDGhbU42OH@slm.duckdns.org>
References: <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
 <Y77s0f741mFfGlTO@slm.duckdns.org>
 <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFhlmdG7Cx41399yo/ozHBL4wwrrh2PAewE6ufP94qA=;
        b=i6ekoKSewTItPgRE2QdLfrvZixqAENBhz4Yj1/vL3BIQX1WDTpF0k3GyYEmg0KIHxA
         wj+1HMU7ALqFSNrA9RlqGF4D/uEBUivlqxRFfFOol7sG1QIJ1Sw2zxDYHbNQIys/Qsky
         0NFmblrpzx0KKcGh8kB+gjKI8HWtpVlNhmvIdyqXpDUvEnmzDJXr7Od4S3iqm/kBPJFZ
         vh4y1phX2awKQOOPubl5cOJ3nzq2TOqpX3SUlgiRM9D7awAY5ju8+KGxseEdOdDZZsoa
         fltbWpnTBk5i6j0UldFDab4ttCBFzpQSgO25zUk2bw5vHS/A6x2A/K5WVpUVGXOfc1WB
         PCCQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hello,

On Thu, Jan 12, 2023 at 02:18:15PM +0800, Yu Kuai wrote:
> remove the blkcg_deactivate_policy() from rq_qos_exit() from deleting
> the device, and delay the policy cleanup and free to blkg_destroy_all().
> Then the policies(other than bfq) can only call pd_free_fn() from
> blkg_destroy(), and it's easy to guarantee the order. For bfq, it can
> stay the same since bfq has refcounting itself.
> 
> Then for the problem that ioc can be freed in pd_free_fn(), we can fix
> it by freeing ioc in ioc_pd_free() for root blkg instead of
> rq_qos_exit().
> 
> What do you think?

That would remove the ability to dynamically remove an rq_qos policy, right?
We don't currently do it but given that having an rq_qos registered comes
with perf overhead, it's something we might want to do in the future - e.g.
only activate the policy when the controller is actually enabled. So, idk.
What's wrong with synchronizing the two removal paths? blkcg policies are
combinations of cgroups and block device configurations, so having exit
paths from both sides is kinda natural.

Thanks.

-- 
tejun
