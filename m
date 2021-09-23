From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 4/4] block: cancel all throttled bios in
 blk_cleanup_queue()
Date: Thu, 23 Sep 2021 21:31:37 +0800
Message-ID: <aab71a7e-830b-ac48-67f1-83be4e8e364f@huawei.com>
References: <20210922125115.381752-1-yukuai3@huawei.com>
 <20210922125115.381752-5-yukuai3@huawei.com> <YUs/CcSKqNoIIXoW@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YUs/CcSKqNoIIXoW@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yi.zhang@huawei.com

On 2021/09/22 22:34, Christoph Hellwig wrote:
> On Wed, Sep 22, 2021 at 08:51:15PM +0800, Yu Kuai wrote:
>> Throttled bios can't be issued after queue is dying in
>> blk_cleanup_queue(), thus it's better to cancel them immediately
>> rather than waiting for throttle is done.
>>
>> For example, if user thread is throttled with low bps while is
>> issuing large io, and the device is deleted. The user thread will
>> wait for a long time for io to return.
> 
> blk_cleanup_queue is too late, this will need to go into del_gendisk
> and on top of my "tear down file system I/O in del_gendisk" series.
> .
> 

Hi,

I see what your series is trying to do, it semms not easy to
collaborate. I'll wait for your series to applied if you don't mind,
or you can take over this series.

Thanks,
Kuai
