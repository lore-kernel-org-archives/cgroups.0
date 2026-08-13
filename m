Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE4E448D0D
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 09:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614219; cv=none; b=E83tODLXCkzj/P4sJGgUGYUqoR28u+FlRvb6fO3+TBBTqIjVkpZcWmAoyZj4bch44Cx+BNtwlcprHfSsJ0Wk2mYOHU4WXXijf3ZwTbfilHu72idmVNvsc60dwsh9LtSFr4wDZrI72CXzz1JHtC84OhpUtnKUopnAEzguL50lyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614219; c=relaxed/simple;
	bh=OTRzmvvffm7aT3+VVHP4OIpeoThkQTqhAzsCjj7zWxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIh0ppwJIHEIfHbfjgzhYgOBgPTXSoleKjwuSU14PgRHL7vOmJlH1+VnXRhRePr5WalMwb0kSTJxD/nwn6pxae2q8jEOaeapn6XF/cKQZTeOhGNvZ+cJI0cQ0wAwGiRixbb3GOr2G2aiBSLE1kKqbdoQGGkcVwtopMBOUL6PMNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f97+rMSv; arc=none smtp.client-ip=95.215.58.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f97+rMSv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OTRzmvvffm7aT3+VVHP4OIpeoThkQTqhAzsCjj7zWxE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786614215; v=1; x=1787219015;
 b=f97+rMSvPB/LWssfBqiHhyCOJhp4KhabLKDJERjmluFw3rWs2Tful4D5fsGeNgQfk34uJIw8
 AI0/gHxJSnj1aGhgMGJttjd3ATSyFTpALbAtaST75ELvzAEbiLKB7gYhJ9HhGGOr6TLt8qbITWl
 NttWO0ORpZBUlNOmHCHyjkOU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id f185781b4bc5a6ac;
	Thu, 13 Aug 2026 09:43:25 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <d7129d5a-c9ec-421c-84e9-d227cd10ec32@linux.dev>
Date: Thu, 13 Aug 2026 17:43:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] sched/topology: Add a cpus_read_lock to
 rebuild_sched_domains()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Ben Segall <bsegall@google.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, K Prateek Nayak
 <kprateek.nayak@amd.com>, Mel Gorman <mgorman@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Tim Chen <tim.c.chen@linux.intel.com>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 "chen.yu@linux.dev" <chen.yu@linux.dev>, "Chen, Yu C" <yu.c.chen@intel.com>,
 Waiman Long <longman@redhat.com>
References: <20260813073855.ji2UrtVh@linutronix.de>
 <20260813074817.t8IQTgfx@linutronix.de>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260813074817.t8IQTgfx@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/13/2026 3:48 PM, Sebastian Andrzej Siewior wrote:
> + CPUSET maintainer which I missed because re-used the CCs from v1.
> 
> On 2026-08-13 09:38:56 [+0200], To linux-kernel@vger.kernel.org wrote:
>> A read from /proc/sys/kernel/sched_rt_runtime_us leads to backtrace due
>> to missing cpu_hotplug_lock with CONFIG_CPUSETS=n. The callchain is
>> sched_rt_handler() -> partition_sched_domains() -> sched_cache_set() ->
>> static_key_enable_cpuslocked(&sched_cache_present).
>>
>> sched_cache_set() itself is also invoked from sched_init_domains() which
>> is early during the boot, holding just the sched_domains_mutex_lock().
>> Here is no warning because it happens before user space is running (and
>> hotplug operations are not possible).
>>
>> There is also sched_cache_active_set() which acquires the hotplug lock
>> before invoking any of the _cpuslocked() functions.
>>
>> This is only a problem with CONFIG_CPUSETS=n because in the =y case the
>> other implementation of rebuild_sched_domains acquires the CPU-hotplug
>> lock.
>>
>> Acquire CPU hotplug lock before in rebuild_sched_domains(), before
>> partition_sched_domains() is invoked for the CONFIG_CPUSETS=n case.
>>
>> Fixes: a7660ce1590fc ("sched/cache: Fix has_multi_llcs iff at least one partition has multiple LLCs")
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> ---
>> v1…v2: https://lore.kernel.org/all/20260812095800.gl06ANul@linutronix.de/
>>    - Move the lock from partition_sched_domains() to
>>      rebuild_sched_domains() in the CONFIG_CPUSETS=n since this is the
>>      only affected case. Noticed by Yu C Chen and Tim Chen.
>>
>>   include/linux/cpuset.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index 65d76a38974ba..bf3999daa080a 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -273,6 +273,7 @@ static inline void dl_rebuild_rd_accounting(void)
>>   
>>   static inline void rebuild_sched_domains(void)
>>   {
>> +	guard(cpus_read_lock)();
>>   	partition_sched_domains(1, NULL, NULL);
>>   }
>>   
>> -- 
>> 2.55.0
>>

LGTM. Thanks.

Reivewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

