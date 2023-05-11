From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH -next 6/6] blk-iocost: move
 wbt_enable/disable_default() out of spinlock
Date: Thu, 11 May 2023 17:25:05 +0200
Message-ID: <20230511152505.GF7880@lst.de>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com> <20230511014509.679482-7-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230511014509.679482-7-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
