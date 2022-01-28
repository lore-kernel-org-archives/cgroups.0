From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/2] mm/page_owner: Introduce SNPRINTF() macro that
 includes length error check
Date: Fri, 28 Jan 2022 16:22:55 -0500
Message-ID: <2b68eb66-db17-a8a2-2a07-48b8584da841@redhat.com>
References: <20220128195642.416743-1-longman@redhat.com>
 <20220128195642.416743-2-longman@redhat.com>
 <20220128211848.GH785175@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643404982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hvrb/vy89ZNYuwBLWpFtg9jTrt+DtAEe9H5nZb7p2Ts=;
        b=G997xVP6dOHFI3Dqtez/fBYGuFLDUojcU/gzOgVu/XU651vIcG5fPhwhWd0llKaUlvFOeQ
        SQoUiTT1r/F7JG6qQUdoyGwR0H6IsjEEMH3uYGIhzu7qgCwMm7xHRfDHnTvQILTy9O6v30
        m8De1S8kTzscTnx+8xkHKQkGw4TVeHI=
Content-Language: en-US
In-Reply-To: <20220128211848.GH785175@iweiny-DESK2.sc.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ira Weiny <ira.weiny@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>


On 1/28/22 16:18, Ira Weiny wrote:
> On Fri, Jan 28, 2022 at 02:56:41PM -0500, Waiman Long wrote:
>> In print_page_owner(), there is a repetitive check after each snprintf()
>> to make sure that the final length is less than the buffer size. Simplify
>> the code and make it easier to read by embedding the buffer length
>> check and increment inside the macro.
> This does not follow the kernel coding style of not putting control flow
> statements in macros.[1]

OK, fair enough. I can remove the macro and repost the patch.

Cheers,
Longman

>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/page_owner.c | 50 +++++++++++++++++++++++--------------------------
>>   1 file changed, 23 insertions(+), 27 deletions(-)
> And in the end you only saved 4 lines of code to read...  Not worth it IMO.
>
> Ira
>
> [1] https://www.kernel.org/doc/html/v4.17/process/coding-style.html
>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 99e360df9465..c52ce9d6bc3b 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -325,12 +325,20 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>>   	seq_putc(m, '\n');
>>   }
>>   
>> +#define SNPRINTF(_buf, _size, _len, _err, _fmt, ...)			\
>> +	do {								\
>> +		_len += snprintf(_buf + _len, _size - _len, _fmt,	\
>> +				 ##__VA_ARGS__);			\
>> +		if (_len >= _size)					\
>> +			goto _err;					\
>> +	} while (0)
>> +
>>   static ssize_t
>>   print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   		struct page *page, struct page_owner *page_owner,
>>   		depot_stack_handle_t handle)
>>   {
>> -	int ret, pageblock_mt, page_mt;
>> +	int ret = 0, pageblock_mt, page_mt;
>>   	char *kbuf;
>>   
>>   	count = min_t(size_t, count, PAGE_SIZE);
>> @@ -338,44 +346,32 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   	if (!kbuf)
>>   		return -ENOMEM;
>>   
>> -	ret = snprintf(kbuf, count,
>> -			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
>> -			page_owner->order, page_owner->gfp_mask,
>> -			&page_owner->gfp_mask, page_owner->pid,
>> -			page_owner->ts_nsec, page_owner->free_ts_nsec);
>> -
>> -	if (ret >= count)
>> -		goto err;
>> +	SNPRINTF(kbuf, count, ret, err,
>> +		"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
>> +		page_owner->order, page_owner->gfp_mask,
>> +		&page_owner->gfp_mask, page_owner->pid,
>> +		page_owner->ts_nsec, page_owner->free_ts_nsec);
>>   
>>   	/* Print information relevant to grouping pages by mobility */
>>   	pageblock_mt = get_pageblock_migratetype(page);
>>   	page_mt  = gfp_migratetype(page_owner->gfp_mask);
>> -	ret += snprintf(kbuf + ret, count - ret,
>> -			"PFN %lu type %s Block %lu type %s Flags %pGp\n",
>> -			pfn,
>> -			migratetype_names[page_mt],
>> -			pfn >> pageblock_order,
>> -			migratetype_names[pageblock_mt],
>> -			&page->flags);
>> -
>> -	if (ret >= count)
>> -		goto err;
>> +	SNPRINTF(kbuf, count, ret, err,
>> +		"PFN %lu type %s Block %lu type %s Flags %pGp\n",
>> +		pfn, migratetype_names[page_mt],
>> +		pfn >> pageblock_order,
>> +		migratetype_names[pageblock_mt],
>> +		&page->flags);
>>   
>>   	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>>   	if (ret >= count)
>>   		goto err;
>>   
>> -	if (page_owner->last_migrate_reason != -1) {
>> -		ret += snprintf(kbuf + ret, count - ret,
>> +	if (page_owner->last_migrate_reason != -1)
>> +		SNPRINTF(kbuf, count, ret, err,
>>   			"Page has been migrated, last migrate reason: %s\n",
>>   			migrate_reason_names[page_owner->last_migrate_reason]);
>> -		if (ret >= count)
>> -			goto err;
>> -	}
>>   
>> -	ret += snprintf(kbuf + ret, count - ret, "\n");
>> -	if (ret >= count)
>> -		goto err;
>> +	SNPRINTF(kbuf, count, ret, err, "\n");
>>   
>>   	if (copy_to_user(buf, kbuf, ret))
>>   		ret = -EFAULT;
>> -- 
>> 2.27.0
>>
>>

