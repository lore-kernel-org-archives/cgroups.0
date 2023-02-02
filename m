From: Hou Tao <houtao@huaweicloud.com>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Thu, 2 Feb 2023 18:50:07 +0800
Message-ID: <336ed542-6b73-0f69-a4ee-4119e73ddb1d@huaweicloud.com>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <Y9or5PkdXj/D94fR@debian.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <Y9or5PkdXj/D94fR@debian.me>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Bagas Sanjaya <bagasdotme@gmail.com>, linux-block@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

Hi,

On 2/1/2023 5:07 PM, Bagas Sanjaya wrote:
> On Wed, Feb 01, 2023 at 12:52:27PM +0800, Hou Tao wrote:
>>  The following numerical values are associated with the I/O priority policies:
>>  
>> -+-------------+---+
>> -| no-change   | 0 |
>> -+-------------+---+
>> -| none-to-rt  | 1 |
>> -+-------------+---+
>> -| rt-to-be    | 2 |
>> -+-------------+---+
>> -| all-to-idle | 3 |
>> -+-------------+---+
>> +
>> ++---------------+---------+-----+
>> +| policy        | inst    | num |
>> ++---------------+---------+-----+
>> +| no-change     | demote  | 0   |
>> ++---------------+---------+-----+
>> +| none-to-rt    | demote  | 1   |
>> ++---------------+---------+-----+
>> +| rt-to-be      | demote  | 2   |
>> ++---------------+---------+-----+
>> +| idle          | demote  | 3   |
>> ++---------------+---------+-----+
>> +| promote-to-rt | promote | 1   |
>> ++---------------+---------+-----+
>>  
> The first row should have been header row:
>
> ---- >8 ----
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index e0b9f73ef62a9e..55f9b579716564 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2048,7 +2048,7 @@ The following numerical values are associated with the I/O priority policies:
>  
>  +---------------+---------+-----+
>  | policy        | inst    | num |
> -+---------------+---------+-----+
> ++===============+=========+=====+
>  | no-change     | demote  | 0   |
>  +---------------+---------+-----+
>  | none-to-rt    | demote  | 1   |
>
>> @@ -2064,9 +2074,13 @@ The numerical value that corresponds to each I/O priority class is as follows:
>>  
>>  The algorithm to set the I/O priority class for a request is as follows:
>>  
>> -- Translate the I/O priority class policy into a number.
>> -- Change the request I/O priority class into the maximum of the I/O priority
>> -  class policy number and the numerical I/O priority class.
>> +-- Translate the I/O priority class policy into an instruction and a number
>> +-- If the instruction is demotion, change the request I/O priority class
>> +-  into the maximum of the I/O priority class policy number and the numerical
>> +-  I/O priority class.
>> +-- If the instruction is promotion, change the request I/O priority class
>> +-  into the minimum of the I/O priority class policy number and the numerical
>> +-  I/O priority class.
>>  
> Remove the excessive bullet list marker or the list above become paragraph
> instead:
>
> ---- >8 ----
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 55f9b579716564..c3f16386c47bdf 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2074,12 +2074,12 @@ The numerical value that corresponds to each I/O priority class is as follows:
>  
>  The algorithm to set the I/O priority class for a request is as follows:
>  
> --- Translate the I/O priority class policy into an instruction and a number
> --- If the instruction is demotion, change the request I/O priority class
> --  into the maximum of the I/O priority class policy number and the numerical
> --  I/O priority class.
> --- If the instruction is promotion, change the request I/O priority class
> --  into the minimum of the I/O priority class policy number and the numerical
> +- Translate the I/O priority class policy into an instruction-number pair.
> +- If the instruction is demotion, change the request I/O priority class
> +  into the maximum of the I/O priority class policy number and the numerical
> +  I/O priority class.
> +- If the instruction is promotion, change the request I/O priority class
> +  into the minimum of the I/O priority class policy number and the numerical
>  -  I/O priority class.
>  
>  PID
>
> Thanks.
Thanks for your comments. Will fix in v2.
>

