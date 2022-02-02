From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] mm/page_owner: Print memcg information
Date: Wed, 2 Feb 2022 11:12:36 -0500
Message-ID: <723f0d47-5450-a403-ed90-4643910f2eb2@redhat.com>
References: <20220131192308.608837-1-longman@redhat.com>
 <20220131192308.608837-4-longman@redhat.com>
 <YfkRS75D3xcqLT85@dhcp22.suse.cz>
 <33be132c-874d-1061-9003-50942275b221@redhat.com>
 <YfpFkVLBb0GsDFsi@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643818373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cm+XqTSkKFeyik40aW5v4P/kwC/jDTxnt6Ut6ZlmWb0=;
        b=VRZoJ62EzviT2deZP49FuzAG/lXvTswQGiFpDYmWAFtMczMpY332kNpovVjr6D2AKoCbYn
        dsrDIMMTrykO1AWXJi//ZLfGlBdL4MNfSqwN2chwXMS/YXns0LmcMYV+HIXnaAbKFZGp0h
        VMHk2zYuJPgPxkKMmdvpSa2DHRVynLg=
Content-Language: en-US
In-Reply-To: <YfpFkVLBb0GsDFsi-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/2/22 03:49, Michal Hocko wrote:
> On Tue 01-02-22 12:04:37, Waiman Long wrote:
>> On 2/1/22 05:54, Michal Hocko wrote:
>>> On Mon 31-01-22 14:23:07, Waiman Long wrote:
>>>> It was found that a number of offlined memcgs were not freed because
>>>> they were pinned by some charged pages that were present. Even "echo
>>>> 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
>>>> offlined but not freed memcgs tend to increase in number over time with
>>>> the side effect that percpu memory consumption as shown in /proc/meminfo
>>>> also increases over time.
>>>>
>>>> In order to find out more information about those pages that pin
>>>> offlined memcgs, the page_owner feature is extended to print memory
>>>> cgroup information especially whether the cgroup is offlined or not.
>>>>
>>>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    mm/page_owner.c | 39 +++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 39 insertions(+)
>>>>
>>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>>> index 28dac73e0542..a471c74c7fe0 100644
>>>> --- a/mm/page_owner.c
>>>> +++ b/mm/page_owner.c
>>>> @@ -10,6 +10,7 @@
>>>>    #include <linux/migrate.h>
>>>>    #include <linux/stackdepot.h>
>>>>    #include <linux/seq_file.h>
>>>> +#include <linux/memcontrol.h>
>>>>    #include <linux/sched/clock.h>
>>>>    #include "internal.h"
>>>> @@ -325,6 +326,42 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>>>>    	seq_putc(m, '\n');
>>>>    }
>>>> +#ifdef CONFIG_MEMCG
>>>> +/*
>>>> + * Looking for memcg information and print it out
>>>> + */
>>>> +static inline void print_page_owner_memcg(char *kbuf, size_t count, int *pret,
>>>> +					  struct page *page)
>>>> +{
>>>> +	unsigned long memcg_data = READ_ONCE(page->memcg_data);
>>>> +	struct mem_cgroup *memcg;
>>>> +	bool onlined;
>>>> +	char name[80];
>>>> +
>>>> +	if (!memcg_data)
>>>> +		return;
>>>> +
>>>> +	if (memcg_data & MEMCG_DATA_OBJCGS)
>>>> +		*pret += scnprintf(kbuf + *pret, count - *pret,
>>>> +				"Slab cache page\n");
>>>> +
>>>> +	memcg = page_memcg_check(page);
>>>> +	if (!memcg)
>>>> +		return;
>>>> +
>>>> +	onlined = (memcg->css.flags & CSS_ONLINE);
>>>> +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>>>> +	*pret += scnprintf(kbuf + *pret, count - *pret,
>>>> +			"Charged %sto %smemcg %s\n",
>>>> +			PageMemcgKmem(page) ? "(via objcg) " : "",
>>>> +			onlined ? "" : "offlined ",
>>>> +			name);
>>> I have asked in the previous version already but what makes the memcg
>>> stable (why it cannot go away and be reallocated for something else)
>>> while you are trying to get its name?
>> The memcg is not going away as long as the page isn't freed unless if it is
>> indirectly connected via objcg. Of course, there can be a race between the
>> page is going to be freed while the page_owner information is being
>> displayed.
> Right. And that means that cgtoup_name can go off the rail and wander
> through memory correct?
>
>> One solution is to add a simple bit lock to each of the
>> page_owner structure and acquire the lock when it is being written to or
>> read from.
> I do not really see how a bit lock could prevent memcg from going away.
> On the other hand I think RCU read lock should be sufficient to keep the
> memcg from going away completely.
Using rcu_read_lock() is also what I have been thinking of doing. So I 
will update the patch to add that for safety.
>
>> Anyway a lot of these debugging aids or tools don't eliminate all
>> the race conditions that affect the accuracy of the displayed information. I
>> can add a patch to eliminate this direct memcg race if you think this is
>> necessary.
> I do not mind inaccurate information. That is natural but reading
> through a freed memory can be really harmfull. So this really need to be
> sorted out.

Thanks for the review.

Cheers,
Longman

