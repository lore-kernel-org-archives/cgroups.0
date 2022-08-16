From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 3/9] blk-throttle: factor out code to calculate
 ios/bytes_allowed
Date: Tue, 16 Aug 2022 09:47:11 -1000
Message-ID: <Yvv0P5YXf2HdEC1d@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=vllq36/daEKxm2CDMyNXs0id/mJg/Ne6mr0IeuT3myQ=;
        b=TrlTzDve7P6EFOm6VCsVgEKIHRFvxY+ZaHDsXeab/pd4Z8HbF6qIOvR8El7kRzypgj
         X1Si/5qJ0ANF0XHOatZW0diA0derl7lczuLx4jfvX9tR1vKsUQT/mNHO7z/dGXH2rKHx
         1BB2riwObOQMawpCcY+N/k2WZM75VWMeMIZMydCWZzaykXNlQDm5D9+Cgb8qLZQCgBWV
         TjEev9s9PUygbDw86uQt3fFKIy8uTyDFypdmVcSn9+8e+9A2I6XL9O6/Wz57xkSZB3Pt
         ei0mxzhNTBiCaktvr9zbxzeIoKYP5jqfDbNk5pXA5BbXWaIQdsM7IlIGkdv0tjot/kKS
         8+MA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 02, 2022 at 10:04:09PM +0800, Yu Kuai wrote:
> +static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
> +				  u32 iops_limit, unsigned long *wait)

While at it, can you please rename these functions to tg_within_iops_limit?
"within" is a single word. Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
