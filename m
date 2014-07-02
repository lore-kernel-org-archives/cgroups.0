From: Chai Wen <chaiw.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: pretty format of /proc/cgoups stats showing
Date: Wed, 2 Jul 2014 16:52:39 +0800
Message-ID: <53B3C857.9000409@cn.fujitsu.com>
References: <1404289478-5554-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <53B3C712.1090807@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B3C712.1090807-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/02/2014 04:47 PM, Li Zefan wrote:

> On 2014/7/2 16:24, chai wen wrote:
>> Just make /proc/cgroups have a better appearance, the original is a little
>> misleading as its print format.
>>
>> Before:
>> #subsys_name	hierarchy	num_cgroups	enabled
>> cpuset	0	1	1
>> cpu	0	1	1
>> cpuacct	0	1	1
>> devices	0	1	1
>> freezer	0	1	1
>> net_cls	0	1	1
>> blkio	0	1	1
>> perf_event	0	1	1
>>
>> After:
>> #subsys_name       hierarchy          num_groups         enabled           
>> cpuset             0                  1                  1                 
>> cpu                0                  1                  1                 
>> cpuacct            0                  1                  1                 
>> devices            0                  1                  1                 
>> freezer            0                  1                  1                 
>> net_cls            0                  1                  1                 
>> blkio              0                  1                  1                 
>> perf_event         0                  1                  1                 
>>
>>
>> Signed-off-by: chai wen <chaiw.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> 
> Someone posted a similar patch long ago, and it was rejected, because
> there may be userspace programs/scripts depending on the current format,
> and this change will break them.


OK, it's reasonable at that point.

thanks
chai wen

> 
>> ---
>>  kernel/cgroup.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 7868fc3..54c839e 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -4883,7 +4883,8 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
>>  	struct cgroup_subsys *ss;
>>  	int i;
>>  
>> -	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
>> +	seq_printf(m, "%-18s %-18s %-18s %-18s\n", "#subsys_name", "hierarchy",
>> +		   "num_groups", "enabled");
>>  	/*
>>  	 * ideally we don't want subsystems moving around while we do this.
>>  	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
>> @@ -4892,7 +4893,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
>>  	mutex_lock(&cgroup_mutex);
>>  
>>  	for_each_subsys(ss, i)
>> -		seq_printf(m, "%s\t%d\t%d\t%d\n",
>> +		seq_printf(m, "%-18s %-18d %-18d %-18d\n",
>>  			   ss->name, ss->root->hierarchy_id,
>>  			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);
>>  
>>
> 
> .
> 



-- 
Regards

Chai Wen
