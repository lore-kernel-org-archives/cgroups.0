From: Hou Tao <houtao@huaweicloud.com>
Subject: Re: [PATCH v2] blk-ioprio: Introduce promote-to-rt policy
Date: Mon, 27 Feb 2023 21:56:25 +0800
Message-ID: <05eafc4f-2d60-b7e6-1d5d-9a08709916e8@huaweicloud.com>
References: <20230220135428.2632906-1-houtao@huaweicloud.com>
 <20230227130305.2idxwmz2kdnacolc@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20230227130305.2idxwmz2kdnacolc@quack3>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Bagas Sanjaya <bagasdotme@gmail.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

Hi

On 2/27/2023 9:03 PM, Jan Kara wrote:
> On Mon 20-02-23 21:54:28, Hou Tao wrote:
>> From: Hou Tao <houtao1@huawei.com>
>>
>> Since commit a78418e6a04c ("block: Always initialize bio IO priority on
>> submit"), bio->bi_ioprio will never be IOPRIO_CLASS_NONE when calling
>> blkcg_set_ioprio(), so there will be no way to promote the io-priority
>> of one cgroup to IOPRIO_CLASS_RT, because bi_ioprio will always be
>> greater than or equals to IOPRIO_CLASS_RT.
>>
>> It seems possible to call blkcg_set_ioprio() first then try to
>> initialize bi_ioprio later in bio_set_ioprio(), but this doesn't work
>> for bio in which bi_ioprio is already initialized (e.g., direct-io), so
>> introduce a new ioprio policy to promote the iopriority of bio to
>> IOPRIO_CLASS_RT if the ioprio is not already RT.
>>
>> So introduce a new promote-to-rt policy to achieve this. For none-to-rt
>> policy, although it doesn't work now, but considering that its purpose
>> was also to override the io-priority to RT and allow for a smoother
>> transition, just keep it and treat it as an alias of the promote-to-rt
>> policy.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Looks good to me. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
Thanks for the review.
>
> Just one question regarding doc below:
>
>> ++----------------+---+
>> +| no-change      | 0 |
>> ++----------------+---+
>> +| rt-to-be       | 2 |
>> ++----------------+---+
>> +| all-to-idle    | 3 |
>> ++----------------+---+
> Shouldn't there be preempt-to-rt somewhere in this table as well? Or why
> this this in the doc at all? I'd consider the numbers to be kernel internal
> thing?
These numbers are used in the algorithm paragraph below to explain how the final
ioprio is calculated. For prompt-to-rt policy, the algorithm is different and
the number is unnecessary.

> 								Honza

