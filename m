From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Sun, 30 Jan 2022 13:22:46 -0500
Message-ID: <82c99093-e44b-7fac-14ab-9e8392d107ea@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com> <YfYxJR7ugv83ywAb@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643566978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wk6jWVv8m8Aoa9sIEtk8sb+YK7vTEczGSdx1RJXY09g=;
        b=W5Z8GQKcu4necknnywr1ITuCc1PY8O0YneTqDTTC8qXuSXbwtDZVk43Ho6lZeY007uIkyO
        UTNoTZiY5+oY+0ZMW5AR0fmo9fJRYdzZ0oHl+ygFeTGJbkXGjZxvPY7grCMne48tSR04Rj
        0m5rQr9ztGSxITQ7OOoIsXRbZyFFlMk=
Content-Language: en-US
In-Reply-To: <YfYxJR7ugv83ywAb@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Mike Rapoport <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Rafael Aquini <aquini@redhat.com>

On 1/30/22 01:33, Mike Rapoport wrote:
> On Sat, Jan 29, 2022 at 03:53:15PM -0500, Waiman Long wrote:
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
>>   mm/page_owner.c | 31 +++++++++++++++++++++++++++++++
>>   1 file changed, 31 insertions(+)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 28dac73e0542..8dc5cd0fa227 100644
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
>> @@ -331,6 +332,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   		depot_stack_handle_t handle)
>>   {
>>   	int ret, pageblock_mt, page_mt;
>> +	unsigned long __maybe_unused memcg_data;
>>   	char *kbuf;
>>   
>>   	count = min_t(size_t, count, PAGE_SIZE);
>> @@ -365,6 +367,35 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>>   			migrate_reason_names[page_owner->last_migrate_reason]);
>>   	}
>>   
>> +#ifdef CONFIG_MEMCG
> Can we put all this along with the declaration of memcg_data in a helper
> function please?
>
Sure. Will post another version with that change.

Cheers,
Longman

