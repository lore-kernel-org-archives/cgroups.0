From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Wed, 25 Feb 2015 16:21:47 -0500
Message-ID: <54EE3CEB.20502@redhat.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-3-git-send-email-riel@redhat.com> <alpine.DEB.2.10.1502251254110.18097@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1502251254110.18097@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On 02/25/2015 04:09 PM, David Rientjes wrote:
> On Wed, 25 Feb 2015, riel@redhat.com wrote:
> 
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index b544e5229d99..94bf59588e23 100644
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
>> @@ -1704,6 +1705,20 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>>  	return retval ?: nbytes;
>>  }
>>  
>> +static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
>> +{
>> +	cpumask_var_t my_isolated_cpus;
>> +
>> +	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
>> +		return;
>> +
>> +	cpumask_and(my_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
>> +
>> +	seq_printf(sf, "%*pbl\n", nodemask_pr_args(my_isolated_cpus));
> 
> That unfortunately won't output anything, it needs to be 
> cpumask_pr_args().  After that's fixed, feel free to add my
> 
> 	Acked-by: David Rientjes <rientjes@google.com>

Gah. Too many things going on at once.

Let me resend a v3 of just patch 2/2 with your ack.
