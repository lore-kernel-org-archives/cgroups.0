From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Add new cpus.partition type with no
 load balancing
Date: Wed, 16 Jun 2021 22:57:18 -0400
Message-ID: <557d7fdb-5dae-11e1-4f82-ae9f4334c06a@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-3-longman@redhat.com>
 <YMpjbCWpSDIz4bHt@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623898645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAFQKb5VrgrYV0k/wY/7SUmNCOTFhI8VI1aGDC5iIO8=;
        b=AP8T6SHQDGeFomIdbb08DwtDjya1XrU912FCSbcvr+nxCOcnfhNSjWIk+2ADqaVyljqOzs
        DL50lDaRJLdZDgrdZAN4WVX+s/v9Ll9ax8hQJFcrVMrzyNlJgYzKKLPrRoNeM/l8nDVyxn
        CyubUrjBOi9sicPhXVplhOuJ80PlV7A=
In-Reply-To: <YMpjbCWpSDIz4bHt-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 6/16/21 4:47 PM, Tejun Heo wrote:
> Hello,
>
> Generally looks fine to me.
>
> On Thu, Jun 03, 2021 at 05:24:13PM -0400, Waiman Long wrote:
>> @@ -1984,12 +1987,31 @@ static int update_prstate(struct cpuset *cs, int val)
>>   			goto out;
>>   
>>   		err = update_parent_subparts_cpumask(cs, partcmd_enable,
>> -						     NULL, &tmp);
>> +						     NULL, &tmpmask);
>> +
>>   		if (err) {
>>   			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
>>   			goto out;
>> +		} else if (new_prs == PRS_ENABLED_NOLB) {
>> +			/*
>> +			 * Disable the load balance flag should not return an
>                                   ^ing
>
> and "else if" after "if (err) goto out" block is weird. The two conditions
> don't need to be tied together.

Yes, the else part is redundant in this case. Will remove it.


>
>> @@ -2518,6 +2547,9 @@ static int sched_partition_show(struct seq_file *seq, void *v)
>>   	case PRS_ENABLED:
>>   		seq_puts(seq, "root\n");
>>   		break;
>> +	case PRS_ENABLED_NOLB:
>> +		seq_puts(seq, "root-nolb\n");
>> +		break;
>>   	case PRS_DISABLED:
>>   		seq_puts(seq, "member\n");
>>   		break;
>> @@ -2544,6 +2576,8 @@ static ssize_t sched_partition_write(struct kernfs_open_file *of, char *buf,
>>   		val = PRS_ENABLED;
>>   	else if (!strcmp(buf, "member"))
>>   		val = PRS_DISABLED;
>> +	else if (!strcmp(buf, "root-nolb"))
>> +		val = PRS_ENABLED_NOLB;
>>   	else
>>   		return -EINVAL;
> I wonder whether there's a better name than "root-nolb" because nolb isn't
> the most readable and we are using space as the delimiter for other names.
> Would something like "isolated" work?

Right. "isolated" is a better name and it corresponds better with the 
isolcpus kernel command line option. Will change the name.

Thanks,
Longman

