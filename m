From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Wed, 8 Feb 2023 09:53:41 -0800
Message-ID: <7fcd4c38-ccbe-6411-e424-a57595ad9c0b@acm.org>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
 <4f7dcb3e-2d5a-cae3-0e1c-a82bcc3d2217@huaweicloud.com>
 <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
 <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
 <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
 <20230208134345.77bdep3kzp52haxu@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230208134345.77bdep3kzp52haxu@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On 2/8/23 05:43, Jan Kara wrote:
> On Fri 03-02-23 11:45:32, Bart Van Assche wrote:
>> On 2/2/23 17:48, Hou Tao wrote:
>>> I don't get it on how to remove IOPRIO_POL_PROMOTION when calculating the final
>>> ioprio for bio. IOPRIO_POL_PROMOTION is not used for IOPRIO_CLASS values but
>>> used to determinate on how to calculate the final ioprio for bio: choosing the
>>> maximum or minimum between blkcg ioprio and original bio bi_ioprio.
>>
>> Do the block layer code changes shown below implement the functionality
>> that you need?
> 
> Just one question guys: So with my a78418e6a04c ("block: Always initialize
> bio IO priority on submit") none-to-rt policy became effectively a noop as
> Hou properly noticed. Are we aware of any users that were broken by this?
> Shouldn't we rather fix the code so that none-to-rt starts to operate
> correctly again? Or maybe change the none-to-rt meaning to be actually
> promote-to-rt?
> 
> I have to admit I'm wondering a bit what was the intended usecase behind
> the introduction of none-to-rt policy. Can someone elaborate? promote-to-rt
> makes some sense to me - we have a priviledged cgroup we want to provide
> low latency access to IO but none-to-rt just does not make much sense to
> me...

Hi Jan,

The test results I shared some time ago show that IOPRIO_CLASS_NONE was 
the default I/O priority two years ago (see also 
https://lore.kernel.org/linux-block/20210927220328.1410161-5-bvanassche@acm.org/). 
The none-to-rt policy increases the priority of bio's that have not been 
assigned an I/O priority to RT. Does this answer your question?

Thanks,

Bart.

