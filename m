From: Hou Tao <houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2] blk-ioprio: Introduce promote-to-rt policy
Date: Thu, 23 Feb 2023 09:08:06 +0800
Message-ID: <48349bb4-68f1-365a-0556-742546d6dd68@huaweicloud.com>
References: <20230220135428.2632906-1-houtao@huaweicloud.com>
 <5ff2b68a-a8fb-7901-2c38-1056a2c59f70@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5ff2b68a-a8fb-7901-2c38-1056a2c59f70-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi,

On 2/22/2023 3:38 PM, Bagas Sanjaya wrote:
> On 2/20/23 20:54, Hou Tao wrote:
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 74cec76be9f2..ccfb9fdfbc16 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -2021,31 +2021,33 @@ that attribute:
>>    no-change
>>  	Do not modify the I/O priority class.
>>  
>> -  none-to-rt
>> -	For requests that do not have an I/O priority class (NONE),
>> -	change the I/O priority class into RT. Do not modify
>> -	the I/O priority class of other requests.
>> +  promote-to-rt
>> +	For requests that have a no-RT I/O priority class, change it into RT.
> "non-RT" maybe? Or the original wording is better?
Because promote-to-rt doesn't work like none-to-rt, so using the original word
is incorrect. Will fix it to non-RT in v3.
>> +	Also change the priority level of these requests to 4. Do not modify
>> +	the I/O priority of requests that have priority class RT.>  
>>    restrict-to-be
>>  	For requests that do not have an I/O priority class or that have I/O
>> -	priority class RT, change it into BE. Do not modify the I/O priority
>> -	class of requests that have priority class IDLE.
>> +	priority class RT, change it into BE. Also change the priority level
>> +	of these requests to 0. Do not modify the I/O priority class of
>> +	requests that have priority class IDLE.
>>  
>>    idle
>>  	Change the I/O priority class of all requests into IDLE, the lowest
>>  	I/O priority class.
>>  
>> +  none-to-rt
>> +	Deprecated. Just an alias for promote-to-rt.
>> +
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
>> ++----------------+---+
>> +| no-change      | 0 |
>> ++----------------+---+
>> +| rt-to-be       | 2 |
>> ++----------------+---+
>> +| all-to-idle    | 3 |
>> ++----------------+---+
>>  
>>  The numerical value that corresponds to each I/O priority class is as follows:
>>  
>> @@ -2061,9 +2063,13 @@ The numerical value that corresponds to each I/O priority class is as follows:
>>  
>>  The algorithm to set the I/O priority class for a request is as follows:
>>  
>> -- Translate the I/O priority class policy into a number.
>> -- Change the request I/O priority class into the maximum of the I/O priority
>> -  class policy number and the numerical I/O priority class.
>> +- If I/O priority class policy is promote-to-rt, change the request I/O
>> +  priority class to IOPRIO_CLASS_RT and change the request I/O priority
>> +  level to 4.
>> +- If I/O priorityt class is not promote-to-rt, translate the I/O priority
>> +  class policy into a number, then change the request I/O priority class
>> +  into the maximum of the I/O priority class policy number and the numerical
>> +  I/O priority class.
>>  
>>  PID
>>  ---
> The rest is LGTM.
Thanks for you review.
>

