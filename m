From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Thu, 08 Nov 2012 20:45:30 +0800
Message-ID: <509BA96A.2070701@gmail.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277696-21724-1-git-send-email-handai.szj@taobao.com> <20121107221709.GB26382@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=KtYdqF01zVEXq75YwvSOdJg9WLmftFK2KYtUyrEZtd8=;
        b=aieS0j6FoG9VjBH+z/Del5gBu3rzAwJNC9TeoCSIXKDg2Ws/dcTEevQ0I2dYa8r7+v
         Cg+KH0OFnyKzXF9RNFpZcJGvgyQcm7um+TLNEAMPVKlDjpK25l3x1kbTKImave1M9Rmz
         vp/V2xesVYu9RIpH6BuSzCW+C5LdXdIABkQSif/mnPC/MtNWBfRSk5sU2VaTHJKZK8Gi
         IYZYEy+pv8zmWKqczFbnq93RUJmIiQHPMGLm3Ubir1liAGv6KKxBaAxeDi7Jfx5P1WsL
         tRZDfl2kan8OI7Xm3JHZjZxsLF/2gquZzG5m4gn0rOPV1RjG7jgmXsRbUN7ErCdfBis8
         +O6g==
In-Reply-To: <20121107221709.GB26382-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 11/08/2012 06:17 AM, Michal Hocko wrote:
> On Wed 07-11-12 16:41:36, Sha Zhengju wrote:
>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Current, when a memcg oom is happening the oom dump messages is still global
>> state and provides few useful info for users. This patch prints more pointed
>> memcg page statistics for memcg-oom.
>>
>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> Cc: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Cc: David Rientjes<rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Andrew Morton<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> ---
>>   mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>   mm/oom_kill.c   |    6 +++-
>>   2 files changed, 66 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 0eab7d5..2df5e72 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> [...]
>> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>>   }
>>
>> +#define K(x) ((x)<<  (PAGE_SHIFT-10))
>> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
>> +{
>> +	struct mem_cgroup *mi;
>> +	unsigned int i;
>> +
>> +	if (!memcg->use_hierarchy&&  memcg != root_mem_cgroup) {
>> +		for (i = 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
>> +			if (i == MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
>> +				continue;
>> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
>> +				K(mem_cgroup_read_stat(memcg, i)));
>> +		}
>> +
>> +		for (i = 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++)
>> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
>> +				mem_cgroup_read_events(memcg, i));
>> +
>> +		for (i = 0; i<  NR_LRU_LISTS; i++)
>> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
>> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
>> +	} else {
>> +
>> +		for (i = 0; i<  MEM_CGROUP_STAT_NSTATS; i++) {
>> +			long long val = 0;
>> +
>> +			if (i == MEM_CGROUP_STAT_SWAP&&  !do_swap_account)
>> +				continue;
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val += mem_cgroup_read_stat(mi, i);
>> +			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
>> +		}
>> +
>> +		for (i = 0; i<  MEM_CGROUP_EVENTS_NSTATS; i++) {
>> +			unsigned long long val = 0;
>> +
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val += mem_cgroup_read_events(mi, i);
>> +			printk(KERN_CONT "%s:%llu ",
>> +				mem_cgroup_events_names[i], val);
>> +		}
>> +
>> +		for (i = 0; i<  NR_LRU_LISTS; i++) {
>> +			unsigned long long val = 0;
>> +
>> +			for_each_mem_cgroup_tree(mi, memcg)
>> +				val += mem_cgroup_nr_lru_pages(mi, BIT(i));
>> +			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
>> +		}
>> +	}
> This is just plain ugly. for_each_mem_cgroup_tree is use_hierarchy aware
> and there is no need for if (use_hierarchy) part.
> memcg != root_mem_cgroup test doesn't make much sense as well because we
> call that a global oom killer ;)

Yes... bitterly did I repent the patch... The else-part of 
for_each_mem_cgroup_tree
is enough for hierarchy. I'll send a update one later.
Sorry for the noise. : (


Thanks,
Sha

