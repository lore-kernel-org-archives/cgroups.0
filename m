From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: Free spare array to avoid memory leak
Date: Thu, 08 Mar 2012 10:11:32 +0800
Message-ID: <4F581554.6020801@gmail.com>
References: <1331036004-7550-1-git-send-email-handai.szj@taobao.com> <20120307230819.GA10238@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=P6cjtSOVWU9rumvbFchyND4/soFkhGoE1lChHQ9O/yA=;
        b=IkWihuJRb5MwIvgJnDR3K91uuO4g825uT5D/J8huSy8eJqdhpTB/NTtKc6n86KRiZc
         19yCXO6yswBsn4eVPtXfJFLG1Log49IKsS9QJIT/AYGOFlX0a4Q8PcuUKfsUXVVPAubZ
         1ZbYHJZ9oK/6pSTZmyD1rT7m9oRV1dvaa8zpNPPUGP3Ygj5rOjrZgRIZq/IxSDMTzfZs
         4QqJ4ZjLpRcyExW5NaL46uJhuCabDKadKgSwdSf4lxpeHKlOnwL233vGuHhlBJlfDjVi
         OGv1ZVc7q+Zq8d0crOq3250B6spiiZR1C4mJgGXcZiS1Y8l1RPx+58cRg1JtjPUlcb32
         tWxg==
In-Reply-To: <20120307230819.GA10238-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 03/08/2012 07:08 AM, Kirill A. Shutemov wrote:
> On Tue, Mar 06, 2012 at 08:13:24PM +0800, Sha Zhengju wrote:
>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> When the last event is unregistered, there is no need to keep the spare
>> array anymore. So free it to avoid memory leak.
> It's not a leak. It will be freed on next event register.


Yeah, I noticed that. But what if it is just the last one and no more
event registering ?


Thanks,
Sha

> Yeah, we don't have to keep spare if primary is empty. But is it worth to
> make code more complicated to save few bytes of memory?
>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> ---
>>   mm/memcontrol.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 22d94f5..3c09a84 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>>   swap_buffers:
>>   	/* Swap primary and spare array */
>>   	thresholds->spare = thresholds->primary;
>> +	/* If all events are unregistered, free the spare array */
>> +	if (!new) {
>> +		kfree(thresholds->spare);
>> +		thresholds->spare = NULL;
>> +	}
>> +
>>   	rcu_assign_pointer(thresholds->primary, new);
>>
>>   	/* To be sure that nobody uses thresholds */
>> -- 
>> 1.7.4.1
>>
