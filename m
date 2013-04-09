From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: defer page_cgroup initialization
Date: Tue, 9 Apr 2013 17:45:17 +0400
Message-ID: <51641B6D.1090208@parallels.com>
References: <1365499511-10923-1-git-send-email-glommer@parallels.com> <20130409133630.GR1953@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130409133630.GR1953-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 04/09/2013 05:36 PM, Johannes Weiner wrote:
> On Tue, Apr 09, 2013 at 01:25:11PM +0400, Glauber Costa wrote:
>> We have now reached the point in which there is no real need to allocate
>> page_cgroup upon system boot. We can defer it to the first memcg
>> initialization, and if it fails, we treat it like any other memcg memory
>> failures (like for instance, if the mem_cgroup structure itself failed).
>> In the future, we may want to defer this to the first non-root cgroup
>> initialization, but we are not there yet. With that, page_cgroup can be
>> more silent in its initialization.
>>
>> Unfortunately, doing that for flatmem models would lead to significant
>> vmalloc-area waste. Since big-memory 32-bit machines are quite common,
>> this would be reality for most of them. This means that we will leave
>> FLATMEM alone, and fix only the SPARSEMEM case. We modify the message
>> slightly so that in future reports we know precisely if this message is
>> from a flatmem kernel or a older kernel initializing page_cgroup early.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> ---
>>  include/linux/page_cgroup.h | 13 +++++++------
>>  init/main.c                 |  1 -
>>  mm/memcontrol.c             |  2 ++
>>  mm/page_cgroup.c            | 19 ++++++++-----------
>>  4 files changed, 17 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
>> index 777a524..bfb43f0 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -33,11 +33,16 @@ void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
>>  static inline void __init page_cgroup_init_flatmem(void)
>>  {
>>  }
>> -extern void __init page_cgroup_init(void);
>> +extern bool page_cgroup_init(void);
>>  #else
>>  void __init page_cgroup_init_flatmem(void);
>> -static inline void __init page_cgroup_init(void)
>> +/*
>> + * If we reach here, we would have already initialized flatmem mappings.
>> + * So just always succeed
>> + */
>> +static inline bool page_cgroup_init(void)
>>  {
>> +	return 0;
> 
> Could you please make it either int (*)(void) OR return true for
> success? :-)
I can return true, of course.

> 
>> @@ -78,7 +78,8 @@ void __init page_cgroup_init_flatmem(void)
>>  	}
>>  	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>>  	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
>> -	" don't want memory cgroups\n");
>> +	" don't want memory cgroups. Alternatively, use SPARSEMEM mappings"
>> +	" to defer initialization until actual use.");
> 
> Isn't that promising a bit much as long as "actual use" means "until
> we create the root_mem_cgroup during boot time"?
> 
If you look at this patch alone, then yes, maybe. (It is still correct,
though). Mostly, I wanted the message to change somehow, so if we get
reports about it, we can easily differentiate a flatmem scenario from an
older kernel, in which both messages are equal. And also inform the user
that he could be better of if using SPARSEMEM.

>> @@ -299,17 +300,13 @@ void __init page_cgroup_init(void)
>>  			if (pfn_to_nid(pfn) != nid)
>>  				continue;
>>  			if (init_section_page_cgroup(pfn, nid))
>> -				goto oom;
>> +				return 1;
>>  		}
>>  	}
>> +#ifdef CONFIG_MEMORY_HOTPLUG
>>  	hotplug_memory_notifier(page_cgroup_callback, 0);
>> -	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>> -	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you "
>> -			 "don't want memory cgroups\n");
>> -	return;
>> -oom:
>> -	printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
>> -	panic("Out of memory");
>> +#endif
>> +	return 0;
> 
> Ok, so this message will be replaced with BUG() in cgroup.c, right?

For the root cgroup, yes. When page_cgroup_init is moved to the
first-non-root, then it is just a normal ENOMEM situation. More
importantly, because it becomes just memory allocation, and not a
special boot-time memory allocation, then it just follow the normal
error paths whatever they are.


