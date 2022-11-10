From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH] block, bfq: fix null pointer dereference in
 bfq_bio_bfqg()
Date: Thu, 10 Nov 2022 11:30:24 +0800
Message-ID: <371bdeac-7841-af8b-cb45-03e49f8589bd@huaweicloud.com>
References: <20221108103434.2853269-1-yukuai1@huaweicloud.com>
 <9e0d8652-adda-3d39-88cd-d735194d4083@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <9e0d8652-adda-3d39-88cd-d735194d4083@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, Yu Kuai <yukuai1@huaweicloud.com>, "jack@suse.cz" <jack@suse.cz>, "tj@kernel.org" <tj@kernel.org>, "josef@toxicpanda.com" <josef@toxicpanda.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yi.zhang@huawei.com" <yi.zhang@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2022/11/09 6:50, Chaitanya Kulkarni 写道:
> 
> 
> Please submit the block tests for this as this is clearly non-trivial
> issue that needs to be tested every release ..

I wrote a c reporducer that is 100% reproducible in v5.10, I'll try to
add a block test. However, it might take sometime because I'm not
familar with blktests yet...

Thanks,
Kuai
> 
> -ck
> 
> 

