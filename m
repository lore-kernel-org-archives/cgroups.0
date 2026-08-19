Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6D639B94D
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787165604; cv=none; b=fApyN/NK+WnkYsHZqeWmnp55LLrTAQ1tRKOjj9BzgRxvmzoTfM2/MpxjOltllIs3ILjxzOO7cnWPTHNHNVZQ1jNkjEzN0LhAtAZzdK15aI6rDj/PYOyBQnDzVv3TUmXLHzrJTSXAv88Xef7OsKd2Qb3PTmaW8E9rXKapefq2a5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787165604; c=relaxed/simple;
	bh=6V7kSHDVdejjQ9J5MUmrLNxONHd+z1TilbT3my3as6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZVqZlL0ofH44XoPuJIQVeB9k/upOieVJEie48i4Lprf9qHlW1PGrtHrHNIS3VIaWN8pwaylcoHbBq60IMf/bX2vow4IqIoWZ3BCopC6rEAoOP3KfUCH/DKPd5dFy4IAi7UD9AX4Rx6k4+FNg1t11IdopieniQnndo2RsIea4lH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6VBZpT0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6VBZpT0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787165601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fB55icsl4Xs/74ud6OFgLo3hi1STNoEUJRhf4EaiYYo=;
	b=E6VBZpT0WhsSN9vNrubdn6aABWfhcPk2tG+q1O5t9u4PRBheHNwhOTAj3KSwQaVgfeixe/
	FpWEbaWK4gU9k49XXyhkUBN11MjXnh+SNbsOYtQHC+X+dSK6xOBhBTVk1qYui22dA/AbvO
	Ntkq2SM+PogOzB/ZN6FfKYuIzQvstz0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-GKFzCwnOMTOxqxqKTYBwGQ-1; Wed,
 19 Aug 2026 14:52:11 -0400
X-MC-Unique: GKFzCwnOMTOxqxqKTYBwGQ-1
X-Mimecast-MFC-AGG-ID: GKFzCwnOMTOxqxqKTYBwGQ_1787165529
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96BB71956096;
	Wed, 19 Aug 2026 18:52:08 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 38DED1956044;
	Wed, 19 Aug 2026 18:52:03 +0000 (UTC)
Message-ID: <042e0ea6-1e3e-4cb9-aa93-32f155e40fb3@redhat.com>
Date: Wed, 19 Aug 2026 14:52:03 -0400
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
 Ridong Chen <ridong.chen@linux.dev>
References: <20260813073855.ji2UrtVh@linutronix.de>
 <20260813074817.t8IQTgfx@linutronix.de>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260813074817.t8IQTgfx@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 8/13/26 3:48 AM, Sebastian Andrzej Siewior wrote:
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

LKTM

Reviewed-by:  Waiman Long <longman@redhat.com>

