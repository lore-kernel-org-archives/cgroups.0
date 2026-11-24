Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492592;
	b=2XPf4UCoCAWDkypsR3Stqeeli6/BjpRn5CXAsrGc8GmPowd6l6HjX+uYCDycmz/wecJD
	 uB5q0OOUa1oYjLxKjG0KKvpC86UEudraiaeq+anlXsNltUP1htDC3/tIUW+VgOlU5Vxus
	 cIFK0cXMGJEZU6S9Zv+jpjHC8netb5XoIRbVXDeXhDhnNhFfa42IYqSExdKib+ibjGpHg
	 iqWhAvjHXQJJVEQJqkDtHNfBj13hS0JYuz3qg+/o/s4eXi+bcbMHcOaJUU5GnbjEPX+9T
	 QgV87IYn240WvX9doPi5K9rM/X/35s4lUxbhbbMiv1MhjbTwUmkCYgAltwSZ5gaGZpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492592;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=EIBmlYOi3ApaAiATtJHu4JtR5iiov1p7BtaCf5Hg4Pw=;
	b=0jN8dGZEqqrNU7B9aNloodKtvWCqAhOidImQM3egeUlAdoXYzcEyAWInVUgIf60jhAYF
	 XfnjJEwK/YDBrXe+NOfJO+4BLW08dOW9VJ6fbYMKYhNzACDLZX+52bp8lxxhTAsd9O1Mp
	 Y3fH4cfNppbk6khrVHCGxZolktTJT7sKOl6wfL6KYDCviUdim6Rnih16+msXXAjA69Gkf
	 b6K0e0OF81ZM5oA0trttA5DWSGNM8cdJ6qCTzcll4cccFnMcZnhHl4Mo8OYMuqZxQm5X+
	 moF4rSoGPDZfiA/agvbWx4hRt6KzhCrDoievGOiANk/r2jF8jB3AqBBU5XJLtLhre4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LydSVxDX;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4A4606A68C
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:56:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A4A4606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LydSVxDX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795492590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIBmlYOi3ApaAiATtJHu4JtR5iiov1p7BtaCf5Hg4Pw=;
	b=LydSVxDX5oNI2oP+vlu2t0HMtY/UzvEZ+tI381IOcRkjl3Ehlt/vyRJQeU4QZOiJLg0Pfp
	fGgt1jZnBOabsf3Zf5RIz9QObF54VYV2H35kd3hOCwDsnqkCFUiUNxtVE7Yj9vmLUTL2qT
	hUksywJefFrCWpC35vE4byXFqgzrQ1U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448--VzRuqE8PEOi6MGeA_xtQA-1; Tue,
 24 Nov 2026 03:56:25 +0000
X-MC-Unique: -VzRuqE8PEOi6MGeA_xtQA-1
X-Mimecast-MFC-AGG-ID: -VzRuqE8PEOi6MGeA_xtQA_1795492582
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F71819540C5;
	Tue, 24 Nov 2026 03:56:21 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E848F18004FE;
	Tue, 24 Nov 2026 03:56:16 +0000 (UTC)
Message-ID: <790b34ba-17da-47c8-8416-ad0b7d721415@redhat.com>
Date: Mon, 23 Nov 2026 22:56:15 -0500
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 2/3] sched/isolation: Forbid the boot CPU from
 being domain isolated
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <guopeng.zhang@linux.dev>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-3-longman@redhat.com>
 <7dbec7f4-35d0-4351-a61d-ab0a649c41d6@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <7dbec7f4-35d0-4351-a61d-ab0a649c41d6@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 11/23/26 10:27 PM, Ridong Chen wrote:
>
>
> On 11/23/2026 12:12 PM, Waiman Long wrote:
>> It is reported that with CONFIG_CPUSETS=n, a kernel booted with
>> isolcpus=domain,0 hits the BUG() in select_fallback_rq() during boot
>> [1]. At boot time, cpu 0 is the only CPU online and an unbound kworker
>> cannot be run on a domain isolated CPU causing kernel panic.
>>
>> Sashiko also reports that domain isolating the boot CPU can break system
>> suspend and trigger a BUG_ON() [2]. So it is problematic if the boot CPU
>> is domain isolated.
>>
>> There may be other kernel subsystems that have problem if the boot CPU
>> is domain isolated as most of them won't take into account the fact that
>> boot CPU is currently allowed to be domain isolated. Given the fact
>> that the boot CPU is likely to be disallowed from the nohz_full list,
>> it makes sense that we should not allow the boot CPU from being set in
>> the isolcpus boot parameter as well. This will also avoid the kind of
>> problems listed above.
>>
>> Do that by clearing the boot CPU from the isolcpus range when it is
>> specified in the boot command line. A warning may also be printed when
>> that happens. If the users want to have boot CPU in the managed_irq
>> or nohz isolation list, a standalone isolcpus boot parameter will be
>> needed instead of combining domain and other flags in the same isolcpus
>> boot parameter.
>>
>> This is indeed a change in behavior which is customer visible. So the
>> kernel-paremeters.txt is updated to mention the fact that boot CPU
>> cannot be isolated.
>>
>> [1] 
>> https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com
>> [2] 
>> https://sashiko.dev/#/patchset/20261108180849.1268263-1-longman%40redhat.com
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>
> This fixes a boot-time BUG(), so it seems worth a Fixes?

The boot time bug reported by Mathieu requires a rather special config 
that is not common and I doubt it will be used at all in production. So 
I don't intend for this to go to stable and it is also a slight change 
in user visible behavior. It is also a long standing issue that is hard 
to pinpoint a Fixes tag.

>
>
>> ---
>>   .../admin-guide/kernel-parameters.txt         |  7 +++---
>>   kernel/sched/isolation.c                      | 22 +++++++++++++++----
>>   2 files changed, 22 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt 
>> b/Documentation/admin-guide/kernel-parameters.txt
>> index 930cee4de79a..1c8bf3583b0b 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2954,11 +2954,12 @@ Kernel parameters
>>                   You can move a process onto or off an "isolated" 
>> CPU via
>>                 the CPU affinity syscalls or cpuset.
>> -              <cpu number> begins at 0 and the maximum value is
>> -              "number of CPUs in system - 1".
>> +              <cpu number> begins at 0 and the maximum value
>> +              is "number of CPUs in system - 1". However boot
>> +              CPU (cpu 0) cannot be domain isolated as it
>> +              may cause problem with some kernel subsystems.
>>                 managed_irq
>> -
>>                 Isolate from being targeted by managed interrupts
>>                 which have an interrupt mask containing isolated
>>                 CPUs. The affinity of managed interrupts is
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index c0c8b8862cbd..de8152351450 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -231,6 +231,7 @@ static int __init housekeeping_setup(char *str, 
>> unsigned long flags)
>>   {
>>       cpumask_var_t non_housekeeping_mask, housekeeping_staging;
>>       unsigned int first_cpu;
>> +    int boot_cpu = smp_processor_id();
>>       int err = 0;
>>         if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & 
>> HK_FLAG_KERNEL_NOISE)) {
>> @@ -253,12 +254,25 @@ static int __init housekeeping_setup(char *str, 
>> unsigned long flags)
>>         first_cpu = cpumask_first_and(cpu_present_mask, 
>> housekeeping_staging);
>>       if (first_cpu >= nr_cpu_ids || first_cpu >= setup_max_cpus) {
>> -        __cpumask_set_cpu(smp_processor_id(), housekeeping_staging);
>> -        __cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
>> +        __cpumask_set_cpu(boot_cpu, housekeeping_staging);
>> +        __cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
>>           if (!housekeeping.flags) {
>> -            pr_warn("Housekeeping: must include one present CPU, "
>> -                "using boot CPU:%d\n", smp_processor_id());
>> +            pr_warn("Housekeeping: must include one present CPU, 
>> using boot CPU:%d\n",
>> +                boot_cpu);
>>           }
>> +    } else if ((flags & HK_FLAG_DOMAIN) &&
>> +           cpumask_test_cpu(boot_cpu, non_housekeeping_mask)) {
>> +        /*
>> +         * If the same isolcpus boot parameter covers both domain and
>> +         * managed_irq/nohz, the boot CPU will also be removed from the
>> +         * managed_irq/nohz isolation list. Users have to use a 
>> separate
>> +         * isolcpus boot parameter for them if they want to include the
>> +         * boot CPU.
>> +         */
>> +        pr_warn("Housekeeping: Boot CPU must not be domain isolated, 
>> clearing %d from isolcpus range\n",
>> +             boot_cpu);
>> +        __cpumask_set_cpu(boot_cpu, housekeeping_staging);
>> +        __cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
>>       }
>>         if (cpumask_empty(non_housekeeping_mask))
>
> The code change itself looks good to me.
>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Thanks.
>
Thanks,
Longman

