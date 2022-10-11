From: Kemeng Shi <shikemeng@huawei.com>
Subject: Re: [PATCH 1/4] blk-cgroup: Remove unnecessary blk_ioprio_exit in
 blkcg_init_queue
Date: Tue, 11 Oct 2022 09:04:35 +0800
Message-ID: <79030a54-aaeb-4115-03a9-d8f69b63b919@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-2-shikemeng@huawei.com>
 <Y0PLwj/l/l4QPpTC@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Y0PLwj/l/l4QPpTC@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@infradead.org>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



on 10/10/2022 3:37 PM, Christoph Hellwig wrote:
> On Mon, Oct 10, 2022 at 10:38:56AM +0800, Kemeng Shi wrote:
>> Function blk_ioprio_init only alloc blkg_policy_data which will be freed
>> in blkg_destroy_all, so no blk_ioprio_exit is called when blk_throtl_init
>> is failed in blkcg_init_queue. Also blk_ioprio_exit is not called in
>> blkcg_exit_queue for the same reason. Just remove blk_ioprio_exit to
>> keep behavior consistent.
> 
> This code looks very different in current mainline.
Thanks for review. I will remove this patch and make new patches based on
mainline code.
-- 
Best wishes
Kemeng Shi
