From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND v6 6/8] blk-throttle: calling
 throtl_dequeue/enqueue_tg in pairs
Date: Wed, 27 Jul 2022 08:40:46 -1000
Message-ID: <YuGGrltCqPo/Fk9A@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-7-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=O7PRtfALKD26c9idwQS3/BsCO0uliH3vHN7FmxUyMrQ=;
        b=VawqO6rHCKwIX+rnfZ6sWjzncCv94kTQ+6I4ygjCdXlXxn9qtkAi6TZyCHWZLTrMEw
         QVeEPrmWcA10AYdsoYrYAMEDZAAnFEvgvxLwsZOOLn8nsHIe8kBItEISAAx/LNDbmg2l
         rE+TpFFag0cTUO3DPEY3eU9dfAWLSHnMaOZ4CRDNNJb4wSAGXWHC+qcm0AzkefG0gxz9
         nqZz6CQhN3g1JPQvFhxVvqBIyeX1qyVI/MdTsqZBItRdfFptrNpA21u+L9qwTzntYb4k
         RhBPJQDafthfa5LqUgj+4sTTFMY6UdeV14drKkCbjQ8wQGLiGV8bXrtwBc1Yol7utXWy
         rvAA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-7-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Fri, Jul 01, 2022 at 05:34:39PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> It's a litter weird to call throtl_dequeue_tg() unconditionally in
         ^
         little

> throtl_select_dispatch(), since it will be called in
> tg_update_disptime() again if some bio is still throttled.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Maybe note that this doesn't create any functional differences in the
description?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
