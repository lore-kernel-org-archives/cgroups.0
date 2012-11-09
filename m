From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3] memcg, oom: provide more precise dump info while memcg
 oom happening
Date: Fri, 09 Nov 2012 20:09:29 +0800
Message-ID: <509CF279.1080602@gmail.com>
References: <1352389967-23270-1-git-send-email-handai.szj@taobao.com> <20121108162539.GP31821@dhcp22.suse.cz> <509CD98B.7080503@gmail.com> <20121109105040.GA5006@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=fmvzApWzoB/Jr1geeHVUkK/NJUUmZYJ0yjmVrDJP1O0=;
        b=OM8GE66tHiAKIV8FnRRDLP67JXjHI6IO4N93H7qu3F9k/Esq+OotqinPHovLqANSXC
         9L+xBFRv6lwYKp92G91k1JUfPJiMbJZDrXeNJkcxruyzSq9GXxfj2UI9nYYgQrH/VGUY
         ZVzZQHKcbhKwUQuA9bRC1Rru5nT0VijciBSd59IEvxtdXPmUKW64+lWijX4YEPtlRW/Z
         swwducKXOkRpivM0N8NsqnAjHw53UiZVnvNBAC544A4i28CIU6/xoP2mUiunhZ+7/qlh
         YzwLHy73u2AEb4QtraBfIEFljcR1+rTzWzIirz2L0/SfgP/JmcUC5vHKqTeFSdZV64TB
         V7cA==
In-Reply-To: <20121109105040.GA5006-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/09/2012 06:50 PM, Michal Hocko wrote:
> On Fri 09-11-12 18:23:07, Sha Zhengju wrote:
>> On 11/09/2012 12:25 AM, Michal Hocko wrote:
>>> On Thu 08-11-12 23:52:47, Sha Zhengju wrote:
> [...]
>>>> +	for (i = 0; i<   MEM_CGROUP_STAT_NSTATS; i++) {
>>>> +		long long val = 0;
>>>> +		if (i == MEM_CGROUP_STAT_SWAP&&   !do_swap_account)
>>>> +			continue;
>>>> +		for_each_mem_cgroup_tree(mi, memcg)
>>>> +			val += mem_cgroup_read_stat(mi, i);
>>>> +		printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
>>>> +	}
>>>> +
>>>> +	for (i = 0; i<   NR_LRU_LISTS; i++) {
>>>> +		unsigned long long val = 0;
>>>> +
>>>> +		for_each_mem_cgroup_tree(mi, memcg)
>>>> +			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
>>>> +		printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
>>>> +	}
>>>> +	printk(KERN_CONT "\n");
>>> This is nice and simple I am just thinking whether it is enough. Say
>>> that you have a deeper hierarchy and the there is a safety limit in the
>>> its root
>>>          A (limit)
>>>         /|\
>>>        B C D
>>>            |\
>>> 	  E F
>>>
>>> and we trigger an OOM on the A's limit. Now we know that something blew
>>> up but what it was we do not know. Wouldn't it be better to swap the for
>>> and for_each_mem_cgroup_tree loops? Then we would see the whole
>>> hierarchy and can potentially point at the group which doesn't behave.
>>> Memory cgroup stats for A/: ...
>>> Memory cgroup stats for A/B/: ...
>>> Memory cgroup stats for A/C/: ...
>>> Memory cgroup stats for A/D/: ...
>>> Memory cgroup stats for A/D/E/: ...
>>> Memory cgroup stats for A/D/F/: ...
>>>
>>> Would it still fit in with your use case?
>>> [...]
>> We haven't used those complicate hierarchy yet, but it sounds a good
>> suggestion. :)
>> Hierarchy is a little complex to use from our experience, and the
>> three cgroups involved in memcg oom can be different: memcg of
>> invoker, killed task, memcg of going over limit.Suppose a process in
>> B triggers oom and a victim in root A is selected to be killed, we
>> may as well want to know memcg stats just local in A cgroup(excludes
>> BCD). So besides hierarchy info, does it acceptable to also print
>> the local root node stats which as I did in the V1
>> version(https://lkml.org/lkml/2012/7/30/179).
> Ohh, I probably wasn't clear enough. I didn't suggest cumulative
> numbers. Only per group. So it would be something like:
>
> 	for_each_mem_cgroup_tree(mi, memcg) {
> 		printk("Memory cgroup stats for %s", memcg_name);
> 		for (i = 0; i<   MEM_CGROUP_STAT_NSTATS; i++) {
> 			if (i == MEM_CGROUP_STAT_SWAP&&   !do_swap_account)
> 				continue;
> 			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i],
> 				K(mem_cgroup_read_stat(mi, i)));
> 		}
> 		for (i = 0; i<   NR_LRU_LISTS; i++)
> 			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i],
> 				K(mem_cgroup_nr_lru_pages(mi, BIT(i))));
>
> 		printk(KERN_CONT"\n");
> 	}
>

Now I catch your point and understand the above... It's smarter than I 
thought before.
Thanks for explaining!

>> Another one I'm hesitating is numa stats, it seems the output is
>> beginning to get more and more....
> NUMA stats are basically per node - per zone LRU data and that the
> for(NR_LRU_LISTS) can be easily extended to cover that.

Yes, the numa_stat cgroup file has done works here. I'll add the numa
stats if you don't feel improper.

