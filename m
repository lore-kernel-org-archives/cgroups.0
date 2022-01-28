From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] mm/page_owner: Dump memcg information
Date: Fri, 28 Jan 2022 16:31:07 -0500
Message-ID: <e14e8c96-b2e3-cb57-2c35-284116798225@redhat.com>
References: <20220128195642.416743-1-longman@redhat.com>
 <20220128195642.416743-3-longman@redhat.com>
 <20220128212249.GI785175@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643405486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPaaPTwaHnrZy5BBxHC8AwDN/oX7cxF5Nc5fiuL/xAs=;
        b=L1JMuwJe5kfMqxQiPSc02NKDIsEuZ6FkbEfmxIa0wffJxLyJpgbSZnI9p/c48Kxop+6aEw
        D6gzfYmDfsvWiyHhND65z6sOuPOOuPs5A0ok1UW44DVqnk7oZ/kq+/yRm/37fZP7B3br5V
        83QAaa501fO2h47uoe2EamSZzPrSEi0=
Content-Language: en-US
In-Reply-To: <20220128212249.GI785175@iweiny-DESK2.sc.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ira Weiny <ira.weiny@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>

On 1/28/22 16:22, Ira Weiny wrote:
> On Fri, Jan 28, 2022 at 02:56:42PM -0500, Waiman Long wrote:
>> It was found that a number of offlined memcgs were not freed because
>> they were pinned by some charged pages that were present. Even "echo
>> 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
>> offlined but not freed memcgs tend to increase in number over time with
>> the side effect that percpu memory consumption as shown in /proc/meminfo
>> also increases over time.
>>
>> In order to find out more information about those pages that pin
>> offlined memcgs, the page_owner feature is extended to dump memory
>> cgroup information especially whether the cgroup is offlined or not.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/page_owner.c | 28 ++++++++++++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index c52ce9d6bc3b..e5d8c642296b 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/migrate.h>
>>   #include <linux/stackdepot.h>
>>   #include <linux/seq_file.h>
>> +#include <linux/memcontrol.h>
>>   #include <linux/sched/clock.h>
>>   
>>   #include "internal.h"
>> @@ -339,6 +340,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   		depot_stack_handle_t handle)
>>   {
>>   	int ret = 0, pageblock_mt, page_mt;
>> +	unsigned long __maybe_unused memcg_data;
>>   	char *kbuf;
>>   
>>   	count = min_t(size_t, count, PAGE_SIZE);
>> @@ -371,6 +373,32 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   			"Page has been migrated, last migrate reason: %s\n",
>>   			migrate_reason_names[page_owner->last_migrate_reason]);
>>   
>> +#ifdef CONFIG_MEMCG
>> +	/*
>> +	 * Look for memcg information and print it out
>> +	 */
>> +	memcg_data = READ_ONCE(page->memcg_data);
>> +	if (memcg_data) {
>> +		struct mem_cgroup *memcg = page_memcg_check(page);
>> +		bool onlined;
>> +		char name[80];
>> +
>> +		if (memcg_data & MEMCG_DATA_OBJCGS)
>> +			SNPRINTF(kbuf, count, ret, err, "Slab cache page\n");
>> +
>> +		if (!memcg)
>> +			goto copy_out;
>> +
>> +		onlined = (memcg->css.flags & CSS_ONLINE);
>> +		cgroup_name(memcg->css.cgroup, name, sizeof(name) - 1);
>> +		SNPRINTF(kbuf, count, ret, err, "Charged %sto %smemcg %s\n",
>                                                          ^^^
> 						Extra specifier?
>
> Did this compile without warnings?

Yes, there was no warning.

Cheers,
Longmna

> Ira
>
>> +			PageMemcgKmem(page) ? "(via objcg) " : "",
>> +			onlined ? "" : "offlined ", name);
>> +	}
>> +
>> +copy_out:
>> +#endif
>> +
>>   	SNPRINTF(kbuf, count, ret, err, "\n");
>>   
>>   	if (copy_to_user(buf, kbuf, ret))
>> -- 
>> 2.27.0
>>
>>

