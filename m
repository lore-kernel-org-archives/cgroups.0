From: Hou Tao <houtao@huaweicloud.com>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Sun, 5 Feb 2023 15:17:01 +0800
Message-ID: <933b39ce-888b-e799-2f49-661356ac50fd@huaweicloud.com>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <a2d8d491-7410-2dd8-cc11-a0519e2025b6@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <a2d8d491-7410-2dd8-cc11-a0519e2025b6@acm.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

Hi,

On 2/4/2023 3:51 AM, Bart Van Assche wrote:
> On 1/31/23 20:52, Hou Tao wrote:
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst
>> b/Documentation/admin-guide/cgroup-v2.rst
>> index c8ae7c897f14..e0b9f73ef62a 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2038,17 +2038,27 @@ that attribute:
>>       Change the I/O priority class of all requests into IDLE, the lowest
>>       I/O priority class.
>>   +  promote-to-rt
>> +    For requests that have I/O priority class BE or that have I/O priority
>> +        class IDLE, change it into RT. Do not modify the I/O priority class
>> +        of requests that have priority class RT.
>
> Please document whether or not this policy modifies the I/O priority
> (IOPRIO_PRIO_DATA()). Do you agree that the I/O priority should be preserved
> when promoting from BE to RT and that only the I/O priority class should be
> modified for such promotions?
I don't think it is a good idea to keep priority data for BE and IDLE class,
else after the override of bi_ioprio, a priority with IDLE class and high
priority data (e.g., 0) will have higher priority than BE class with low
priority data (e.g., 7). So maybe we should assign the lowest priority data to
the promoted io priority.
>
>>   The following numerical values are associated with the I/O priority policies:
>>   -+-------------+---+
>> -| no-change   | 0 |
>> -+-------------+---+
>> -| none-to-rt  | 1 |
>> -+-------------+---+
>> -| rt-to-be    | 2 |
>> -+-------------+---+
>> -| all-to-idle | 3 |
>> -+-------------+---+
>> +
>> ++---------------+---------+-----+
>> +| policy        | inst    | num |
>> ++---------------+---------+-----+
>> +| no-change     | demote  | 0   |
>> ++---------------+---------+-----+
>> +| none-to-rt    | demote  | 1   |
>> ++---------------+---------+-----+
>> +| rt-to-be      | demote  | 2   |
>> ++---------------+---------+-----+
>> +| idle          | demote  | 3   |
>> ++---------------+---------+-----+
>> +| promote-to-rt | promote | 1   |
>> ++---------------+---------+-----+
>
> I prefer that this table is not modified. The numerical values associated with
> policies only matters for none-to-rt, rt-to-be and all-to-idle but not for
> promote-to-rt. So I don't think that it is necessary to mention a numerical
> value for the promote-to-rt policy. Additionally, "none-to-rt" is not a policy
> that demotes the I/O priority but a policy that may promote the I/O priority.
Yes, this is no need to associate a number with promote-rt policy. Will fix in
v2. "none-to-rt" may promote io priority when the priority if NONE, although for
now bi_ioprio will never be NONE when blkcg_set_ioprio() is called.
>
>> +-- If the instruction is promotion, change the request I/O priority class
>> +-  into the minimum of the I/O priority class policy number and the numerical
>> +-  I/O priority class.
>
> Using the minimum value seems wrong to me because that will change
> IOPRIO_VALUE(IOPRIO_CLASS_RT, 1) into IOPRIO_VALUE(IOPRIO_CLASS_RT, 0).
Yes, you are right. Will fix in v2.
>
> Thanks,
>
> Bart.

