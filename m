From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH RESEND] memcg: Free spare array to avoid memory leak
Date: Thu, 03 May 2012 11:09:49 +0800
Message-ID: <4FA1F6FD.7060100@gmail.com>
References: <1334825690-9065-1-git-send-email-handai.szj@taobao.com> <20120501140314.1d7312fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=Vy9iYvvBuiTGw2XAEKw5t6rwQoTvd5C4MMYKq9KmNmI=;
        b=wGaOv/kgxyaIQIybnwBZRa/i9YhJiE9iUw+SEHEUjiTXZLWO+L1/rAVnMGOZ4a6mar
         oIYv+awwRE30ExqGOF34JlLx8zGz21ILVlDqXRpK37nZgs20oeTf9XuVXRUnNGyHb01u
         DkIhG867EBhtGUNLCImwcKv/TnvcCqVDHrhnTlbm+OV62/PBNBnWF3iAO3sOvWeqJWul
         bY54QKib17+hDzRk6D9EY7iwppotZ+/v8W2lsTtEj6AUsxNUo4/LNkSAVcn116GydCcU
         b8jm41OMC541GVMjgiYdrOkg2Y23B5lLRO3D+rQlMr9hxfLCab6F0AK9bBycphCuEpOo
         PwDQ==
In-Reply-To: <20120501140314.1d7312fb.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sha Zhengju <handai.szj@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 05/02/2012 05:03 AM, Andrew Morton wrote:
> On Thu, 19 Apr 2012 16:54:50 +0800
> Sha Zhengju<handai.szj@gmail.com>  wrote:
>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> When the last event is unregistered, there is no need to keep the spare
>> array anymore. So free it to avoid memory leak.
> How serious is this leak?  Is there any way in which it can be used to
> consume unbounded amounts of memory?

While registering events, the ->primary will apply for a larger array to 
store
the new threshold info and the ->spare holds the old primary space.
But once unregistering event, the ->primary and ->spare pointer will be 
swapped
after updating thresholds info. So if we have an eventfd with many(>1) 
thresholds
attached to it, mem_cgroup_usage_unregister_event() will finally leave 
->spare
holding a large array and have no chance to be freed.

I hope it is clear.

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
> The resulting code is really quite convoluted.  Try to read through it
> and follow the handling of ->primary and ->spare.  Head spins.
>
> What is the protocol here?  If ->primary is NULL then ->spare must also
> be NULL?
>

To be simple:  if new(->primary) is NULL, it means we are unregistering
the last threshold and there is no need to keep ->spare any more.
So give the ->spare array a chance to be freed.

Thanks,
Sha

> I'll apply the patch, although I don't (yet) have sufficient info to
> know which kernels it should be applied to.  Perhaps someone could
> revisit this code and see if it can be made more straightforward.
>
> .
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
