From: QiuLaibin <qiulaibin@huawei.com>
Subject: Re: [PATCH -next v2] blk-throttle: Set BIO_THROTTLED when bio has
 been throttled
Date: Wed, 18 May 2022 08:39:16 +0800
Message-ID: <356ba1b6-7979-a767-2501-0a96b653c860@huawei.com>
References: <20220301123919.2381579-1-qiulaibin@huawei.com>
 <Yh92UQ9/bxe6EcWe@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Yh92UQ9/bxe6EcWe@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>
Cc: tj@kernel.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

friendly ping....

在 2022/3/2 21:51, Ming Lei 写道:
> On Tue, Mar 01, 2022 at 08:39:19PM +0800, Laibin Qiu wrote:
>> 1.In current process, all bio will set the BIO_THROTTLED flag
>> after __blk_throtl_bio().
>>
>> 2.If bio needs to be throttled, it will start the timer and
>> stop submit bio directly. Bio will submit in
>> blk_throtl_dispatch_work_fn() when the timer expires.But in
>> the current process, if bio is throttled. The BIO_THROTTLED
>> will be set to bio after timer start. If the bio has been
>> completed, it may cause use-after-free blow.
>>
>> BUG: KASAN: use-after-free in blk_throtl_bio+0x12f0/0x2c70
>> Read of size 2 at addr ffff88801b8902d4 by task fio/26380
> 
> After the queue lock is released, the bio can be dispatched & completed,
> so it shouldn't be touched after lock release:
> 
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> 
> Thanks,
> Ming
> 
> .
