From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: make threshold index in the right position
Date: Thu, 02 Feb 2012 18:54:23 +0800
Message-ID: <4F2A6B5F.3090303@gmail.com>
References: <1328175919-11209-1-git-send-email-handai.szj@taobao.com> <20120202101410.GA12291@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=ST42Vvxk/EaPQWBcE3scRlkHwO+/NqrOxqHlALEwrAM=;
        b=YAclsRFpo4Ofqab00YTozAN9yBcpbXm6MYyyS3Nhg0jBPcANRUhAnJqNKWp68aLNou
         GMq2AgD9Afo92vgjh36H/Oyu1UxUp1F/W+eg47xH92BA/6OSd459YHLHZ4Y3XlDn/r72
         QeeFAeXInsu4WQ8+yAe+XtmGj9Q+MYFtIb9CQ=
In-Reply-To: <20120202101410.GA12291-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 02/02/2012 06:14 PM, Kirill A. Shutemov wrote:
> On Thu, Feb 02, 2012 at 05:45:19PM +0800, Sha Zhengju wrote:
>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Index current_threshold may point to threshold that just equal to
>> usage after __mem_cgroup_threshold is triggerd.
> I don't see it. Could you describe conditions?
>
It is because of the following code path in __mem_cgroup_threshold:
{
     ...
         i = t->current_threshold;

         for (; i >= 0 && unlikely(t->entries[i].threshold > usage); i--)
                 eventfd_signal(t->entries[i].eventfd, 1);
         i++;

         for (; i < t->size && unlikely(t->entries[i].threshold <= 
usage); i++)
                 eventfd_signal(t->entries[i].eventfd, 1);

         t->current_threshold = i - 1;
     ...
}

For example:
now:
     threshold array:  3  5  7  9   (usage = 6)
                                    ^
                                 index

next turn:
     threshold array:  3  5  7  9   (usage = 7)
                                        ^
                                     index

after registering a new event(threshold = 10):
     threshold array:  3  5  7  9  10 (usage = 7)
                                    ^
                                 index
>> But after registering
>> a new event, it will change (pointing to threshold just below usage).
>> So make it consistent here.
>>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Cc: Kirill A. Shutemov<kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/memcontrol.c |    7 ++++---
>>   1 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 22d94f5..79f4a58 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -183,7 +183,7 @@ struct mem_cgroup_threshold {
>>
>>   /* For threshold */
>>   struct mem_cgroup_threshold_ary {
>> -	/* An array index points to threshold just below usage. */
>> +	/* An array index points to threshold just below or equal to usage. */
>>   	int current_threshold;
>>   	/* Size of entries[] */
>>   	unsigned int size;
>> @@ -4319,14 +4319,15 @@ static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
>>   	/* Find current threshold */
>>   	new->current_threshold = -1;
>>   	for (i = 0; i<  size; i++) {
>> -		if (new->entries[i].threshold<  usage) {
>> +		if (new->entries[i].threshold<= usage) {
>>   			/*
>>   			 * new->current_threshold will not be used until
>>   			 * rcu_assign_pointer(), so it's safe to increment
>>   			 * it here.
>>   			 */
>>   			++new->current_threshold;
>> -		}
>> +		} else
>> +			break;
>>   	}
>>
>>   	/* Free old spare buffer and save old primary buffer as spare */
>> -- 
>> 1.7.4.1
>>
