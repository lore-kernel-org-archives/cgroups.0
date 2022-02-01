From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 3/4] mm/page_owner: Print memcg information
Date: Tue, 1 Feb 2022 11:54:03 +0100
Message-ID: <YfkRS75D3xcqLT85@dhcp22.suse.cz>
References: <20220131192308.608837-1-longman@redhat.com>
 <20220131192308.608837-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643712843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YltHOwLKpuO0VC3+4HmnZ1Xi40C0+Rd6appeqUz4Pqw=;
        b=KnPDIU68LSjnuG+3l0gU/QaHa/lBb7ETO3uVc1U6JBzrQj7PSPiEhew4hexC2uMM+z+HJu
        q7el6RJgbYzblwGSh2MDgXoWim29tXPX3+93EbPm/j7HbkQHEIB1Oh4Yod2x71/qKbz7In
        w1HbGSyc53w2Cbd8gWKg4evbUdSD0f4=
Content-Disposition: inline
In-Reply-To: <20220131192308.608837-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Mike Rapoport <rppt@kernel.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <guro@fb.com>, Rafael Aquini <aquini@redhat.com>

On Mon 31-01-22 14:23:07, Waiman Long wrote:
> It was found that a number of offlined memcgs were not freed because
> they were pinned by some charged pages that were present. Even "echo
> 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
> offlined but not freed memcgs tend to increase in number over time with
> the side effect that percpu memory consumption as shown in /proc/meminfo
> also increases over time.
> 
> In order to find out more information about those pages that pin
> offlined memcgs, the page_owner feature is extended to print memory
> cgroup information especially whether the cgroup is offlined or not.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_owner.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 28dac73e0542..a471c74c7fe0 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -10,6 +10,7 @@
>  #include <linux/migrate.h>
>  #include <linux/stackdepot.h>
>  #include <linux/seq_file.h>
> +#include <linux/memcontrol.h>
>  #include <linux/sched/clock.h>
>  
>  #include "internal.h"
> @@ -325,6 +326,42 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>  	seq_putc(m, '\n');
>  }
>  
> +#ifdef CONFIG_MEMCG
> +/*
> + * Looking for memcg information and print it out
> + */
> +static inline void print_page_owner_memcg(char *kbuf, size_t count, int *pret,
> +					  struct page *page)
> +{
> +	unsigned long memcg_data = READ_ONCE(page->memcg_data);
> +	struct mem_cgroup *memcg;
> +	bool onlined;
> +	char name[80];
> +
> +	if (!memcg_data)
> +		return;
> +
> +	if (memcg_data & MEMCG_DATA_OBJCGS)
> +		*pret += scnprintf(kbuf + *pret, count - *pret,
> +				"Slab cache page\n");
> +
> +	memcg = page_memcg_check(page);
> +	if (!memcg)
> +		return;
> +
> +	onlined = (memcg->css.flags & CSS_ONLINE);
> +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
> +	*pret += scnprintf(kbuf + *pret, count - *pret,
> +			"Charged %sto %smemcg %s\n",
> +			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			onlined ? "" : "offlined ",
> +			name);

I have asked in the previous version already but what makes the memcg
stable (why it cannot go away and be reallocated for something else)
while you are trying to get its name?
-- 
Michal Hocko
SUSE Labs
