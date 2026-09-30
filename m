Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDA936B923
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 02:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790735714; cv=none; b=ZPxXtuatOPTPQF0NEUjnZd2Zrh/QcYErTcCWuzxXhfzk8sia8+0QoYRcAuYRF74mdDi+F1xhe7AVO6lda0vrEVi+X3oHZllrzB+YskBFCY27ROuo6BxOtaQy9K96H2gpzc0cEwgD9HHgRV4J3HLSz04kwHfGjy42lWuBRH1idxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790735714; c=relaxed/simple;
	bh=6Fm1hrW8GcdgbI8/in+Y45X3mEFMoh0CZutLsdzo3iU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OpZaBFCuK3MORyICxq+QfAMRFNVSDxg4cHoXiC76LAtEdADeyK7Q+/v+gsVpnPlcz+lGT1mqEtIT9ZE6m3bq977SXOg7yZuPlXUnjVawuoJwwtvaHNpH8HNoxOcLvKAi3JaalCQC0edkON0S+yrPyykYWxWqWn5KpWdReUkSYO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEyvHELj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEyvHELj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790735705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPjDiKF3Gp2wU9dStbsk1lLM1BlDbYH3eJKB6sUim38=;
	b=MEyvHELjhi3K7dGKKzZtwDNRAW9991LKIGEg+Zs45+eOxSdxq1tU/Zt4wwM7oJxipNEm1T
	Yo4HaV/1rewkn2/8hxBJ+fsvuQwFfbH1aStmca0DnX5EQkWBqK+LllxDdNNRlofeQSYpsv
	ow9abWJ/akxij/ZMhHCYgRCepAjCjM4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-46rR9Kk2PdiGqJ4IvhjDDQ-1; Tue,
 29 Sep 2026 22:35:02 -0400
X-MC-Unique: 46rR9Kk2PdiGqJ4IvhjDDQ-1
X-Mimecast-MFC-AGG-ID: 46rR9Kk2PdiGqJ4IvhjDDQ_1790735700
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 546A41954232;
	Wed, 30 Sep 2026 02:35:00 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2E261800361;
	Wed, 30 Sep 2026 02:34:58 +0000 (UTC)
Message-ID: <bf0f64d7-88e4-4a72-9c1b-7cb9fc07e379@redhat.com>
Date: Tue, 29 Sep 2026 22:34:57 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in
 is_in_v2_mode()
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrea Righi <arighi@nvidia.com>
References: <20260930012819.651526-1-longman@redhat.com>
 <3d8bbe2c-8baa-43a6-9926-66669b96bfb9@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <3d8bbe2c-8baa-43a6-9926-66669b96bfb9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 9/29/26 9:57 PM, Ridong Chen wrote:
>
>
> On 9/30/2026 9:28 AM, Waiman Long wrote:
>> After seeing the patch [1] to guard is_in_v2_mode() with RCU, it makes
>> me realize that is_in_v2_mode() may be called in a context where a new
>> cgroup filesystem is being rebound with stale cpuset_cgrp_subsys.root
>> pointer. Avoid this potential UaF situation by adding a new 
>> cpuset_v2_mode
>> flag which is set when the cpuset_v2_mode mount option is used. This
>> flag is written into only when cpuset_bind() is being called with a
>> stable cpuset_cgrp_subsys.root value. The is_in_v2_mode() helper is
>> modified to read the new cpuset_v2_mode flag instead of accessing
>> cpuset_cgrp_subsys.root directly.
>>
>> [1] 
>> https://lore.kernel.org/lkml/20260929084124.626693-2-arighi@nvidia.com
>>
>> Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 19661df6244f..266ce17d1af0 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -147,6 +147,11 @@ static cpumask_var_t subpartitions_cpus;    /* 
>> RWCS */
>>    */
>>   static cpumask_var_t    isolated_cpus;        /* CSCB */
>>   +/*
>> + * Set if "cpuset_v2_mode" mount option is used
>> + */
>> +static bool        cpuset_v2_mode;        /* Unprotected */
>> +
>
> Nit.
>
> `Unprotected` is wired here, will it be better with:
>
> /* Cached at bind time; accessed via {READ,WRITE}_ONCE */
Unprotected just means it is not protected by any lock. I should have 
said "not lock protected".
>
>>   /*
>>    * Set if housekeeping cpumasks are to be updated.
>>    */
>> @@ -439,8 +444,7 @@ static inline bool cpuset_v2(void)
>>    */
>>   static inline bool is_in_v2_mode(void)
>>   {
>> -    return cpuset_v2() ||
>> -          (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
>> +    return cpuset_v2() || READ_ONCE(cpuset_v2_mode);
>>   }
>>     /**
>> @@ -3664,6 +3668,8 @@ static void cpuset_bind(struct 
>> cgroup_subsys_state *root_css)
>>       mutex_lock(&cpuset_mutex);
>>       spin_lock_irq(&callback_lock);
>>   +    WRITE_ONCE(cpuset_v2_mode,
>> +           !!(cpuset_cgrp_subsys.root->flags & 
>> CGRP_ROOT_CPUSET_V2_MODE));
>>       if (is_in_v2_mode()) {
>>           cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
>>           cpumask_copy(top_cpuset.effective_xcpus, cpu_possible_mask);
>
>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Thanks.
>
Thanks for the review.

Cheers,
Longman

