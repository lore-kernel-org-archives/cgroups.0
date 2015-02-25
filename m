From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Tue, 24 Feb 2015 22:30:19 -0500
Message-ID: <54ED41CB.2040401@redhat.com>
References: <1424727906-4460-1-git-send-email-riel@redhat.com> <1424727906-4460-3-git-send-email-riel@redhat.com> <alpine.DEB.2.10.1502241811020.19547@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1502241811020.19547-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/24/2015 09:15 PM, David Rientjes wrote:
> On Mon, 23 Feb 2015, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> 
>> From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> The previous patch makes it so the code skips over isolcpus when
>> building scheduler load balancing domains. This makes it hard to
>> see for a user which of the CPUs in a cpuset are participating in
>> load balancing, and which ones are isolated cpus.
>>
>> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
>> isolated CPUs.
>>
>> This file is read-only for now. In the future we could extend things
>> so isolcpus can be changed at run time, for the root (system wide)
>> cpuset only.
>>
>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/cpuset.c | 27 +++++++++++++++++++++++++++
>>  1 file changed, 27 insertions(+)
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 1ad63fa37cb4..19ad5d3377f8 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -1563,6 +1563,7 @@ typedef enum {
>>  	FILE_MEMORY_PRESSURE,
>>  	FILE_SPREAD_PAGE,
>>  	FILE_SPREAD_SLAB,
>> +	FILE_ISOLCPUS,
>>  } cpuset_filetype_t;
>>  
>>  static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
>> @@ -1704,6 +1705,23 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>>  	return retval ?: nbytes;
>>  }
>>  
>> +static size_t cpuset_sprintf_isolcpus(char *s, ssize_t pos, struct cpuset *cs)
>> +{
>> +	cpumask_var_t my_isolated_cpus;
>> +	ssize_t count;
>> +	
> 
> Whitespace.
> 
>> +	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
>> +		return 0;
>> +
>> +	cpumask_and(my_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
>> +
>> +	count = cpulist_scnprintf(s, pos, my_isolated_cpus);
>> +
>> +	free_cpumask_var(my_isolated_cpus);
>> +
>> +	return count;
>> +}
>> +
>>  /*
>>   * These ascii lists should be read in a single call, by using a user
>>   * buffer large enough to hold the entire map.  If read in smaller
>> @@ -1738,6 +1756,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
>>  	case FILE_EFFECTIVE_MEMLIST:
>>  		s += nodelist_scnprintf(s, count, cs->effective_mems);
>>  		break;
>> +	case FILE_ISOLCPUS:
>> +		s += cpuset_sprintf_isolcpus(s, count, cs);
>> +		break;
> 
> This patch looks fine, and I think cpuset.effective_cpus and 
> cpuset.isolcpus can be used well together, but will need updating now that 
> commit e8e6d97c9b ("cpuset: use %*pb[l] to print bitmaps including 
> cpumasks and nodemasks") has been merged which reworks this function.

I will take a look at that changeset. It was not in the
tip tree I worked against.

Expect a v2 :)

> It's a little unfortunate, though, that the user sees Cpus_allowed, 
> cpuset.cpus, and cpuset.effective_cpus that include isolcpus and then have 
> to check another cpulist for the isolcpus to see their sched domain, 
> though.

Agreed, but all the alternatives I could think of would break the
userspace API, leaving this as the best way to go.

-- 
All rights reversed
