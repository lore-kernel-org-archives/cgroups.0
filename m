From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Thu, 08 Nov 2012 21:12:00 +0800
Message-ID: <509BAFA0.4010604@gmail.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277696-21724-1-git-send-email-handai.szj@taobao.com> <509B7658.1020807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=o3sovKB/3dZN9LoVgKBxiKGrbrvjX1wvYss2U921ObI=;
        b=aqSq4cOGs5mEjAfayTg8C4t/9ra8Jf7TiVb/ZHpRV1mxoxz8/ZShdiaLaBGeOScvzq
         Vz7sb8RmWwPYLQNUZZBeg6WzhVJscs+kp/zpQ1b40M/J6l6b0yaUR1LS0eqMBLTFFfsU
         lKizbJJbsC7uKE/L5+iS686Sh33FYVu0Wj++flGrcD2oXEsZP/yjnpz1zN9bqYUdCX4Q
         63YryifPGjF/dJ1TI5MXxXzOzCyS5VLOr9sq1WefYDjiE51MR6HWBMnRH46WQQbyKQMj
         L9ZNPAnIFeTYgDASmLZwB+W6MCj2pYI3dB7ANKjq1XlEppv9fCIN32BKzxb4TfXdiiWk
         E1PA==
In-Reply-To: <509B7658.1020807-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 11/08/2012 05:07 PM, Kamezawa Hiroyuki wrote:
> (2012/11/07 17:41), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Current, when a memcg oom is happening the oom dump messages is still global
>> state and provides few useful info for users. This patch prints more pointed
>> memcg page statistics for memcg-oom.
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> ---
>>   mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>   mm/oom_kill.c   |    6 +++-
>>   2 files changed, 66 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 0eab7d5..2df5e72 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -118,6 +118,14 @@ static const char * const mem_cgroup_events_names[] = {
>>   	"pgmajfault",
>>   };
>>   
>> +static const char * const mem_cgroup_lru_names[] = {
>> +	"inactive_anon",
>> +	"active_anon",
>> +	"inactive_file",
>> +	"active_file",
>> +	"unevictable",
>> +};
>> +
> Is this for the same strings with show_free_areas() ?
>

I just move the declaration here from the bottom of source file to make
the following use error-free.

>>   /*
>>    * Per memcg event counter is incremented at every pagein/pageout. With THP,
>>    * it will be incremated by the number of pages. This counter is used for
>> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>>   }
>>   
>> +#define K(x) ((x) << (PAGE_SHIFT-10))
>> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
>> +{
>> +	struct mem_cgroup *mi;
>> +	unsigned int i;
>> +
>> +	if (!memcg->use_hierarchy && memcg != root_mem_cgroup) {
> Why do you need to have this condition check ?
>

Yes, the check is unnecessary... I'll remove it next version.

>> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
>> +				continue;
>> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
>> +				K(mem_cgroup_read_stat(memcg, i)));
> Hm, how about using the same style with show_free_areas() ?
>

I'm also trying do so. show_free_areas() prints the memory related info
in two style:
one is in page unit and the oher is in KB (I've no idea why we distinct
them), but
I think the KB format is more readable.


>> +		}
>> +
>> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
>> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
>> +				mem_cgroup_read_events(memcg, i));
>> +
> I don't think EVENTS info is useful for oom.
>

It seems you're right. : )

>> +		for (i = 0; i < NR_LRU_LISTS; i++)
>> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
>> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
> How far does your new information has different format than usual oom ?
> Could you show a sample and difference in changelog ?
>
> Of course, I prefer both of them has similar format.
>
>
>
The new memcg-oom info excludes global state out and prints the memcg
statistics instead
which seems more brevity. I'll add a sample next time. Thanks for
reminding me!


Thanks,
Sha
