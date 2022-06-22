From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [External] Re: [PATCH] sched: RT bandwidth interface for cgroup
 unified hierarchy
Date: Wed, 22 Jun 2022 09:52:47 +0800
Message-ID: <d5d884c5-ed82-4ea9-4c08-e284d80239af@bytedance.com>
References: <20220621123542.1444-1-zhouchengming@bytedance.com>
 <7933e208-cd4f-2234-58cb-2e5b40e795d8@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8BeHII7j2RVL5an2X6ClS6MJ44OPIqlDCSKDBki0jmc=;
        b=g4hG9kGoLq+3irH9R5WvwKlQ1UTs4YU/rtZy5pOgAKIEfNvUCpb87PJ3vwqrTAgDSx
         wNkg3fSqnDrcpysjQmN0qcI9Uqi0sY3G9U9o782kxL01r6zdR1+1KbcWffbbTkGD60Yw
         v+BguyznyT+Jd5VBQaL1lbCl3QBXICIghqQA6DxNcwZ1HRA1/L8H/pjbU5oXvCkL+cxV
         bHtwjbr+a0DjKFISj8UoiVHmgV14wtImCCbmTJPz8XwPzWTEviekvs4NRhyDwyFNhmHO
         PZ5CPU/Zxxq4xg2gKQBS8AHBGrbI7+FMaxaXiSxhT5Y3UcVqTCjK4dkcL76P62GGfZnv
         4lLg==
Content-Language: en-US
In-Reply-To: <7933e208-cd4f-2234-58cb-2e5b40e795d8@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Randy Dunlap <rdunlap@infradead.org>, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On 2022/6/21 23:59, Randy Dunlap wrote:
> Hi--
> 
> On 6/21/22 05:35, Chengming Zhou wrote:
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 176298f2f4de..3d2949e16e04 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1055,6 +1055,19 @@ All time durations are in microseconds.
>>  
>>  	The burst in the range [0, $MAX].
>>  
>> +  cpu.max.rt
>> +	A read-write two value file which exists on all cgroups when
> 
> 	             two-value
> 
>> +	CONFIG_RT_GROUP_SCHED enabled, to control CPU bandwidth for
> 
> 	                      is enabled,
> 
>> +	RT threads in the task group.
>> +
>> +	The maximum bandwidth limit.  It's in the following format::
>> +
>> +	  $MAX $PERIOD
>> +
>> +	which indicates that RT threads in the group may consume upto
> 
> 	                                                         up to
> 
>> +	$MAX in each $PERIOD duration.  "max" for $MAX indicates no
>> +	limit.  If only one number is written, $MAX is updated.
> 

Thanks for review, I will send v2 later.
