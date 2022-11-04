From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Fri, 4 Nov 2022 06:17:05 +0100
Message-ID: <20221104051705.GB15721@lst.de>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com> <20221104023938.2346986-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20221104023938.2346986-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Fri, Nov 04, 2022 at 10:39:37AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> match_u64() is called inside ioc->lock, which causes smatch static
> checker warnings:
> 
> block/blk-iocost.c:3211 ioc_qos_write() warn: sleeping in atomic context
> block/blk-iocost.c:3240 ioc_qos_write() warn: sleeping in atomic context
> block/blk-iocost.c:3407 ioc_cost_model_write() warn: sleeping in atomic
> context
> 
> Fix the problem by introducing a mutex and using it while prasing input
> params.

s/prasing/parsing/

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
