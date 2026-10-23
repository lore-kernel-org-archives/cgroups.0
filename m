Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774629;
	b=BxRz6GHx2Xp1t2bxByZYYsPDl59rGYayyrlhyiQpUrYU2XigUBSnhGXWEjkzz1tGmm9+
	 jGN/oxG+JbkOJQyAibI50QRz2jro0gnbb+u8cql+XWX5Q61CRbHJf7TRvXn+qh+6zytap
	 VX/V153io0lo0yxr+vKEss3/Ha4VXhmJTon29NyzsooS/UbZDnYXramFUDtqkfTOQ1yC9
	 bQkuyNAa1TIfahjx/I6KEC9L5GD5iGjM3anS+z5pyeeQFR8F0orGUljP1Phoqu6gHD/ep
	 HZkDm/ukRy0vBiJYbJe+YmifCpciTbJoKBnT81to74TuTRI6wz9V0YMD5lkwq8mSzGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774629;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=VNW6u+2D4YHZ7igxJ6xR3IWLm3wxx7zC4IY7nBuwiEQ=;
	b=TunqywBUdr0qRZriAQQe5MBqHBRDgI9lJpP62bxceqlvN+xzzvOvdmcJL+QB/kwrxYmr
	 93mMx2E7KQR4Q7ff53eybcRGnzuHBNvPi7qtXwoRyiOYi2d8HOxl6ZOwJS8kT1NQIIKD3
	 KDWZfy/5UMlVvY6T9N/zFmaauOgH1JA2YuJOBBtk4bL3Q9CoNfe7x8enFNk0sv89sLsKH
	 k0VqAzlssWGfu3e7b5kCLsthob0jrDhG6lJpp6YVWfrGwGA1ezOjV2F727ACJxuxaSR4I
	 uXjc9eAZ14VGovxT+S5WgXUjLcL4a3lEH0/8O+WGoJtenZoynoQ0DDp0DGtfFdBC4cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Cmlgts29;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182B7606A31E
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 16:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 182B7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Cmlgts29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792774627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VNW6u+2D4YHZ7igxJ6xR3IWLm3wxx7zC4IY7nBuwiEQ=;
	b=Cmlgts29hn1HqH2wIOTvmUD+m53rhUVwnCuOx8ItG4QPF8kCaLLeAWFaWeo7OKNa6sWvn4
	zus/cZ0VY+wvJ8CdJosnIihujBiVNnq0QjXBYMkr6y8l13K+WJqJVX6bnzcyoKgAdULbtM
	4wgaDsW/WnfSfVTn+y0eIOyre+gU3tQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-kpdgEFPGO1OWciwIGZSOzw-1; Fri,
 23 Oct 2026 12:57:03 -0400
X-MC-Unique: kpdgEFPGO1OWciwIGZSOzw-1
X-Mimecast-MFC-AGG-ID: kpdgEFPGO1OWciwIGZSOzw_1792774622
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3151180063D;
	Fri, 23 Oct 2026 16:57:01 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F5DE195608B;
	Fri, 23 Oct 2026 16:57:00 +0000 (UTC)
Message-ID: <057b3c65-430c-42eb-adfe-02579fdd7360@redhat.com>
Date: Fri, 23 Oct 2026 12:56:59 -0400
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
Subject: Re: [PATCH-next 2/6] cgroup/cpuset: Properly compute effective xcpus
 in update_parent_effective_cpumask()
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-3-longman@redhat.com>
 <d4ce3eba-b48a-4e63-af0f-87cd27d04e4c@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <d4ce3eba-b48a-4e63-af0f-87cd27d04e4c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 10/23/26 2:45 AM, Ridong Chen wrote:
>
>
> On 10/22/2026 11:16 AM, Waiman Long wrote:
>> Since the introduction of cpuset.cpus.exclusive in commit
>> e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2"), a
>> compute_effective_exclusive_cpumask() helper which is later renamed to
>> compute_excpus() is added to compute the effective xcpus of a partition
>> root. However update_parent_effective_cpumask() is not updated in all
>> proper places to use the new helper to check if a given cpuset should
>> remain a valid partition root. This can cause a cpuset to incorrectly
>> remain a valid partition root even if no effective xcpus is left.
>>
>> Fix that problem by using compute_excpus() to compute the effective 
>> xcpus
>> into delmask in all cases except partcmd_disable and partcmd_invalidate
>> and use it for tasks_nocpu_error() check as well as checking its
>> emptiness. This enables us to catch invalid partition root more
>> accurately in update_parent_effective_cpumask().
>>
>> Some test case are added to test_cpuset_prs.sh for invalidating a
>> partition root due to its effective xcpus becoming empty as well as
>> making sure that an invalid partition can only be revived when exclusive
>> CPUs are available agin.
>>
>> Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c                        | 36 +++++++++----------
>>   .../selftests/cgroup/test_cpuset_prs.sh       |  6 ++++
>>   2 files changed, 22 insertions(+), 20 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 7ead8c3b7974..db6e4663f4be 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1798,7 +1798,6 @@ static int 
>> update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>       int deleting;    /* Deleting cpus from parent's 
>> effective_cpus    */
>>       int old_prs, new_prs;
>>       int part_error = PERR_NONE;    /* Partition error? */
>> -    struct cpumask *xcpus = user_xcpus(cs);
>>       int parent_prs = parent->partition_root_state;
>>       bool nocpu;
>>   @@ -1841,30 +1840,29 @@ static int 
>> update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>       if (!newmask && xcpus_empty(cs))
>>           return PERR_CPUSEMPTY;
>>   -    nocpu = tasks_nocpu_error(parent, cs, xcpus);
>> +    /*
>> +     * Except for partcmd_disable, use delmask to compute the current
>> +     * effective xcpus value and use it for tasks_nocpu_error check.
>> +     */
>> +    if (cmd != partcmd_disable) {
>> +        compute_excpus(cs, tmp->delmask);
>> +        nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
>> +    }
>>         if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
>> -        /*
>> -         * Need to call compute_excpus() in case
>> -         * exclusive_cpus not set. Sibling conflict should only happen
>> -         * if exclusive_cpus isn't set.
>> -         */
>> -        xcpus = tmp->delmask;
>> -        if (compute_excpus(cs, xcpus))
>> - WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
>>           new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
>>             /*
>>            * Enabling partition root is not allowed if its
>>            * effective_xcpus is empty.
>>            */
>> -        if (cpumask_empty(xcpus))
>> +        if (cpumask_empty(tmp->delmask))
>>               return PERR_INVCPUS;
>>   -        if (prstate_housekeeping_conflict(new_prs, parent_prs, 
>> xcpus, NULL))
>> +        if (prstate_housekeeping_conflict(new_prs, parent_prs, 
>> tmp->delmask, NULL))
>>               return PERR_HKEEPING;
>>   -        if (tasks_nocpu_error(parent, cs, xcpus))
>> +        if (nocpu)
>>               return PERR_NOCPUS;
>
> update_parent_effective_cpumask is only used for the local partition. 
> So I'd suggest adding a local_partition_validate helper, which can be 
> used for both partition enable and update. For now this logic is 
> spread out, and many corner cases would easily be missed.

I am thinking about breaking up update_parent_effective_cpumask() to be 
more like what we are doing with remote partition to share as much 
common part as possible. This cleanup work will be in a later patch 
series. Since this is a fix patch, I don't want to make too many changes 
to make it hard to backport to earlier releases.

Cheers,
Longman

