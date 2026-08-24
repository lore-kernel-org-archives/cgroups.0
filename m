Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B30439340
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581061; cv=none; b=ASBB/tSISq8mBB6vXSYha2OIwEZfObjkw/rvtP3hFHeVsOaWrpUpfyt1zfCGCBvL/BmNnwQj81kshjIHtlj0MgKjwuYa0OmpI4NxF/RLfmLMV56IDTXP4NBx7cUN9J2Vc9MTnCA1ZsZXXLKFyvn/w+xUckbCcLOsecFZNhpxTNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581061; c=relaxed/simple;
	bh=YmP3Jv+tlFO1n2NsgJBGJTknFHjb8fXGnOLSMlQix9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKtycxJDRjENPbt29rOCDO/cS1qSkLpFAa8IyWN0UA99qXZIXdiPvFEgBGk1AgxhhitGHhzTzVtDP5NytpXfZczUxkFEDxWXV1gxmr0NXrBhEap8hpGKPa+EHzA5fC7Gi1Jgl/7Mbb1DeFSSAKbrcaF8JeMQKyAPSDv9GXHw/3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GkQgr8DZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GkQgr8DZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787581059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zz5zuW0Fg/LEU/nkt26abjQFjnL5MpCZTx6jlv3wYM=;
	b=GkQgr8DZk7LeOkKqYt7C0JBI13ACB5WHUVXMHBgiTWOnMc0+H+I1RfMlnAZkrrZoihh8fX
	vHsMuvLQeEnpLRDgk/7NLoRVVqeeAVKAB3ZTj/Utgds9hB6W6jbdpa5xK/KnyzXZjTNX3L
	eImFzUikfNKS+00RxitorvmrUEDetBg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-aLhJmAeKPkmkOls9DNtkdQ-1; Mon,
 24 Aug 2026 10:17:34 -0400
X-MC-Unique: aLhJmAeKPkmkOls9DNtkdQ-1
X-Mimecast-MFC-AGG-ID: aLhJmAeKPkmkOls9DNtkdQ_1787581053
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FE6A18600C6;
	Mon, 24 Aug 2026 14:17:32 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 666B418005BB;
	Mon, 24 Aug 2026 14:17:30 +0000 (UTC)
Message-ID: <c0b5bc99-c1e4-4cf1-bd51-f71cc391c03c@redhat.com>
Date: Mon, 24 Aug 2026 10:17:29 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] cgroup/cpuset: Preserve boot-isolated CPUs on
 partition release
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260824020140.21130-1-guopeng.zhang@linux.dev>
 <20260824020140.21130-3-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260824020140.21130-3-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 8/23/26 10:01 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> isolated_cpus tracks CPUs isolated with isolcpus= as well as CPUs in
> isolated cpuset partitions. When an isolated partition is released,
> isolated_cpus_update() removes its whole CPU mask. This also clears CPUs
> which were already isolated at boot.
>
> This can be reproduced on a cgroup v2 system booted with
> isolcpus=domain,15:
>
>      cd /sys/fs/cgroup
>      echo +cpuset > cgroup.subtree_control
>      mkdir cpuset-repro
>      echo 15 > cpuset-repro/cpuset.cpus
>      echo isolated > cpuset-repro/cpuset.cpus.partition
>      echo member > cpuset-repro/cpuset.cpus.partition
>      cat cpuset.cpus.isolated
>
> CPU 15 is absent before the change. It must remain in
> cpuset.cpus.isolated after the partition is released.
>
> Update isolated_cpus one CPU at a time and keep CPUs outside the
> boot-time domain housekeeping mask isolated.
>
> Fixes: c188f33c864e ("cgroup/cpuset: Account for boot time isolated CPUs")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   kernel/cgroup/cpuset.c | 39 +++++++++++++++++++++++++++++----------
>   1 file changed, 29 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index d100634fa12b..2538faac9aba 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1259,6 +1259,28 @@ static void reset_partition_data(struct cpuset *cs)
>   		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
>   }
>   
> +/* Return true if isolated_cpus changes. */
> +static bool isolated_cpu_update(int new_prs, int cpu)
> +{
> +	lockdep_assert_held(&callback_lock);
> +	lockdep_assert_held(&cpuset_mutex);
> +
> +	if (new_prs == PRS_ISOLATED) {
> +		if (cpumask_test_cpu(cpu, isolated_cpus))
> +			return false;
> +		cpumask_set_cpu(cpu, isolated_cpus);
> +		return true;
> +	}
> +
> +	/* CPUs isolated at boot must remain isolated. */
> +	if (!cpumask_test_cpu(cpu,
> +			      housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)) ||
> +	    !cpumask_test_cpu(cpu, isolated_cpus))
> +		return false;
> +	cpumask_clear_cpu(cpu, isolated_cpus);
> +	return true;
> +}
> +
>   /*
>    * isolated_cpus_update - Update the isolated_cpus mask
>    * @old_prs: old partition_root_state
> @@ -1267,19 +1289,16 @@ static void reset_partition_data(struct cpuset *cs)
>    */
>   static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus)
>   {
> +	bool updated = false;
> +	int cpu;
> +
>   	WARN_ON_ONCE(old_prs == new_prs);
>   	lockdep_assert_held(&callback_lock);
>   	lockdep_assert_held(&cpuset_mutex);
> -	if (new_prs == PRS_ISOLATED) {
> -		if (cpumask_subset(xcpus, isolated_cpus))
> -			return;
> -		cpumask_or(isolated_cpus, isolated_cpus, xcpus);
> -	} else {
> -		if (!cpumask_intersects(xcpus, isolated_cpus))
> -			return;
> -		cpumask_andnot(isolated_cpus, isolated_cpus, xcpus);
> -	}
> -	update_housekeeping = true;
> +	for_each_cpu(cpu, xcpus)
> +		updated |= isolated_cpu_update(new_prs, cpu);
> +	if (updated)
> +		update_housekeeping = true;
>   }
>   
>   /*

The code is technically correct. However, handling it one CPU at a time 
is less efficient from my point of view. It can be handled more 
efficiently from the cpumask level. I do notice that the new 
isolated_cpu_update() helper is being used in a later patch in your 
larger series. Maybe that is the reason why you do it this way.

I am OK with this change.

Acked-by: Waiman Long <longman@redhat.com>

