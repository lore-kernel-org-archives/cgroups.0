From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/12] memcg: don't need memcg->memcg_name
Date: Tue, 9 Apr 2013 09:28:12 +0800
Message-ID: <51636EAC.10307@huawei.com>
References: <5162648B.9070802@huawei.com> <51626584.7050405@huawei.com> <20130408142503.GH17178@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130408142503.GH17178-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2013/4/8 22:25, Michal Hocko wrote:
> On Mon 08-04-13 14:36:52, Li Zefan wrote:
> [...]
>> @@ -5188,12 +5154,28 @@ static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
>>  					struct seq_file *m)
>>  {
>>  	struct mem_cgroup *memcg;
>> +	char *memcg_name;
>> +	int ret;
> 
> The interface is only for debugging, all right, but that doesn't mean we
> should allocate a buffer for each read. Why cannot we simply use
> cgroup_path for seq_printf directly? Can we still race with the group
> rename?

because cgroup_path() requires the caller pass a buffer to it.

> 
>> +
>> +	/*
>> +	 * cgroup.c will do page-sized allocations most of the time,
>> +	 * so we'll just follow the pattern. Also, __get_free_pages
>> +	 * is a better interface than kmalloc for us here, because
>> +	 * we'd like this memory to be always billed to the root cgroup,
>> +	 * not to the process removing the memcg. While kmalloc would
>> +	 * require us to wrap it into memcg_stop/resume_kmem_account,
>> +	 * with __get_free_pages we just don't pass the memcg flag.
>> +	 */
>> +	memcg_name = (char *)__get_free_pages(GFP_KERNEL, 0);
>> +	if (!memcg_name)
>> +		return -ENOMEM;
>>  
>>  	mutex_lock(&dangling_memcgs_mutex);
>>  
>>  	list_for_each_entry(memcg, &dangling_memcgs, dead) {
>> -		if (memcg->memcg_name)
>> -			seq_printf(m, "%s:\n", memcg->memcg_name);
>> +		ret = cgroup_path(memcg->css.cgroup, memcg_name, PAGE_SIZE);
>> +		if (!ret)
>> +			seq_printf(m, "%s:\n", memcg_name);
>>  		else
>>  			seq_printf(m, "%p (name lost):\n", memcg);
>>  
>> @@ -5203,6 +5185,7 @@ static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
>>  	}
>>  
>>  	mutex_unlock(&dangling_memcgs_mutex);
>> +	free_pages((unsigned long)memcg_name, 0);
>>  	return 0;
>>  }
>>  #endif
