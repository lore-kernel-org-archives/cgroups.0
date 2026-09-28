Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6B3470429
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639780; cv=none; b=ahJRRdCjJKjfnRTaMi2fR1hqL8VC9P4OAZHk+AdXj+rpyWsUcJXmwwQvh7FQpk0Ge/W24V/WC8A68e8Nthup/N2CrCmUAWxvXLjM9YDolgWZVHmAhchBXQxHytvfHkiC1qmRe08uUUUisbJjfMv/VaY05EOMn1bzfDb88JYB5uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639780; c=relaxed/simple;
	bh=IUzkJe7E2I+7iIA+Hf+NS+6dXXddmPQQJyCxBlmf+yE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XGaBcFgzEpikpWusFhxSwV2WUHZzX2Sb19+S+iZBaxuFYbLENJOBFe39sffsTeALpFoJ4oVWURiBcpgYpJC10UW+rwwOB11QbBzrRJ7uFUOYXHgq95BB3bvoyjV8K+jSJYuGewa93IYwFLdkdQS1eWDTOBuX83VxNkM1Abt5lkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XzYNOKXQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzYNOKXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790639778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3OWddXProFqB61LokMw/W+fAhbCgqprBFmOTTSgo40E=;
	b=XzYNOKXQqifSKa3/mP8FJr/4H+M1KNVnspIfNl35yVPkYcSUNjIZ0R3BI69SYUmR+WIwnu
	Rvs7HXGuM2vrhRXcRYRfvaEaXHYkIgsygSpKctrUkBI+TlLuEVqIoQkHWGiKBqj0kGsKLT
	bbyAbsx4w6fKIeDEuZxpmxF6gc3ffv0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-zfFkeGlKNNG0C7s-FFwMHw-1; Mon,
 28 Sep 2026 19:56:13 -0400
X-MC-Unique: zfFkeGlKNNG0C7s-FFwMHw-1
X-Mimecast-MFC-AGG-ID: zfFkeGlKNNG0C7s-FFwMHw_1790639772
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 786EB1801377;
	Mon, 28 Sep 2026 23:56:11 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1FB2F180036E;
	Mon, 28 Sep 2026 23:56:08 +0000 (UTC)
Message-ID: <ac493a53-378f-4c06-b2cd-e0a27ec64957@redhat.com>
Date: Mon, 28 Sep 2026 19:56:08 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
To: Tejun Heo <tj@kernel.org>, Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260927095722.70660-1-guopeng.zhang@linux.dev>
 <7f4c57b26ad120ab30adf35653f1dd94@kernel.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <7f4c57b26ad120ab30adf35653f1dd94@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 9/28/26 2:44 PM, Tejun Heo wrote:
> Hello, Guopeng.
>
> The following is a Claude-generated review.
>
> On Sun, Sep 27, 2026 at 05:57:21PM +0800, Guopeng Zhang wrote:
>> +	bool updating = is_remote_partition(cs);
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return PERR_ACCESS;
>> +
>> +	if (!updating &&
>> +	    (!cpumask_intersects(excpus, cpu_active_mask) ||
>> +	     cpumask_subset(top_cpuset.effective_cpus, addcpus)))
>> +		return PERR_INVCPUS;
> cs->remote_partition can be stale when remote_partition_enable() is
> called. If a root <-> isolated switch of a valid remote partition fails
> in update_prstate(), the partition is made invalid without
> remote_partition_disable(), so the flag stays set and its CPUs stay in
> subpartitions_cpus. A later enable then skips the PERR_INVCPUS checks.
> With isolcpus=domain,4:
>
> 1. A is a member with cpuset.cpus 2-6 and cpuset.cpus.exclusive 2-4. B
>     has cpuset.cpus 2-4 and no cpuset.cpus.exclusive.
> 2. "isolated" to B's cpuset.cpus.partition. B becomes a valid remote
>     partition with effective_xcpus 2-4.
> 3. "root" to B's cpuset.cpus.partition fails with PERR_HKEEPING.
>     effective_xcpus is cleared but remote_partition stays set.
> 4. 5-6 to A's cpuset.cpus.exclusive. B's excpus becomes empty, which
>     matches the cleared effective_xcpus, so update_cpumasks_hier() skips
>     B.
> 5. "isolated" to B's cpuset.cpus.partition. This used to fail with
>     PERR_INVCPUS. Now B becomes a valid isolated partition with empty
>     effective_xcpus and the WARN_ON_ONCE() at the end of update_prstate()
>     triggers.
>
> This is from reading the code, not reproduced. Maybe have the callers
> pass whether it's an enable or an update instead of deriving it from
> cs->remote_partition?
>
> The stale flag itself is a separate, pre-existing bug. Switching B back
> to member after step 3 trips the WARN_ON_ONCE(old_prs < 0) in
> partition_xcpus_del().

You are right. It is a bug that has to be fixed. I have posted a cpuset 
patch to fix that partition state switch bug.

Cheers,
Longman

>
> Thanks.
>
> --
> tejun

