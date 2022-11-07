From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Mon, 7 Nov 2022 06:56:33 +0100
Message-ID: <20221107055633.GG28873@lst.de>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com> <20221104023938.2346986-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20221104023938.2346986-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
