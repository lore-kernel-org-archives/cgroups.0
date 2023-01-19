From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH -next v3 3/3] blk-cgroup: synchronize pd_free_fn() from
 blkg_free_workfn() and blkcg_deactivate_policy()
Date: Thu, 19 Jan 2023 17:43:45 +0100
Message-ID: <20230119164345.GC3332@lst.de>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com> <20230119110350.2287325-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230119110350.2287325-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com

The this change itself looks good, but it will clash badly with my
"switch blk-cgroup to work on gendisk" series:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can I get some reviews for that series once I rebase and repost it
after this series is merged?
