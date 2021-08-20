From: Andrey Ryabinin <arbn@yandex-team.com>
Subject: Re: [PATCH 1/4] cputime,cpuacct: Include guest time in user time in
 cpuacct.stat
Date: Fri, 20 Aug 2021 12:37:28 +0300
Message-ID: <dee3d594-65bb-ffa2-f009-7900a4cf3f89@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <87wnu5l9e6.fsf@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452239; bh=8C0XPCFK1m41WAoGmXo4jkHrx/HebMDhC1R+WddLGDw=;
        h=In-Reply-To:References:Date:Message-ID:To:Subject:From:Cc;
        b=MY+DCvNp3wVLhqDJWngDFhowGQ7U9CB8IPRgLwesNuxJMSf0IR+vHk2KGbmSy9lA/
         SD3rf8kjh2BTmXUPXv0ZKuYNn6+N3671nB3MSyMOBz8T0H8Cl8WblhHOuHrLsxktCl
         B6xep+hTFm4jL4LuU4mOUXNWOkRyzN/JlJxhzbow=
In-Reply-To: <87wnu5l9e6.fsf@oracle.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Boris Burkov <boris@bur.io>, Bharata B Rao <bharata@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org


Sorry for abandoning this, got distracted by lots of other stuff.


On 3/18/21 1:09 AM, Daniel Jordan wrote:
> Andrey Ryabinin <arbn@yandex-team.com> writes:
> 
>> cpuacct.stat in no-root cgroups shows user time without guest time
>> included int it. This doesn't match with user time shown in root
>> cpuacct.stat and /proc/<pid>/stat.
> 
> Yeah, that's inconsistent.
> 
>> Make account_guest_time() to add user time to cgroup's cpustat to
>> fix this.
> 
> Yep.
> 
> cgroup2's cpu.stat is broken the same way for child cgroups, and this
> happily fixes it.  Probably deserves a mention in the changelog.
> 

Sure.

> The problem with cgroup2 was, if the workload was mostly guest time,
> cpu.stat's user and system together reflected it, but it was split
> unevenly across the two.  I think guest time wasn't actually included in
> either bucket, it was just that the little user and system time there
> was got scaled up in cgroup_base_stat_cputime_show -> cputime_adjust to
> match sum_exec_runtime, which did have it.
> 
> The stats look ok now for both cgroup1 and 2.  Just slightly unsure
> whether we want to change the way both interfaces expose the accounting
> in case something out there depends on it.  Seems like we should, but
> it'd be good to hear more opinions.
> 
>> @@ -148,11 +146,11 @@ void account_guest_time(struct task_struct *p, u64 cputime)
>>  
>>  	/* Add guest time to cpustat. */
>>  	if (task_nice(p) > 0) {
>> -		cpustat[CPUTIME_NICE] += cputime;
>> -		cpustat[CPUTIME_GUEST_NICE] += cputime;
>> +		task_group_account_field(p, CPUTIME_NICE, cputime);
>> +		task_group_account_field(p, CPUTIME_GUEST_NICE, cputime);
>>  	} else {
>> -		cpustat[CPUTIME_USER] += cputime;
>> -		cpustat[CPUTIME_GUEST] += cputime;
>> +		task_group_account_field(p, CPUTIME_USER, cputime);
>> +		task_group_account_field(p, CPUTIME_GUEST, cputime);
>>  	}
> 
> Makes sense for _USER and _NICE, but it doesn't seem cgroup1 or 2
> actually use _GUEST and _GUEST_NICE.
> 
> Could go either way.  Consistency is nice, but I probably wouldn't
> change the GUEST ones so people aren't confused about why they're
> accounted.  It's also extra cycles for nothing, even though most of the
> data is probably in the cache.
> 

Agreed, will live the _GUEST* as is.
