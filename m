From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Thu, 26 Feb 2015 10:24:57 -0500
Message-ID: <54EF3AC9.3060808@redhat.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-3-git-send-email-riel@redhat.com> <54EEFE15.3010005@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54EEFE15.3010005@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On 02/26/2015 06:05 AM, Zefan Li wrote:
>> +static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
>> +{
>> +	cpumask_var_t my_isolated_cpus;
>> +
>> +	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
>> +		return;
>> +
> 
> Make it return -ENOMEM ? Or make it a global variable and allocate memory for it
> in cpuset_init().

OK, can do.

I see that cpuset_common_seq_show already takes a lock, so having
one global variable for this should not introduce any additional
contention.

I will send a v4.

>> @@ -1733,6 +1748,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
>>  	case FILE_EFFECTIVE_MEMLIST:
>>  		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
>>  		break;
>> +	case FILE_ISOLCPUS:
>> +		cpuset_seq_print_isolcpus(sf, cs);
>> +		break;
>>  	default:
>>  		ret = -EINVAL;
>>  	}


-- 
All rights reversed
