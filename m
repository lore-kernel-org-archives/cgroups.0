Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800096;
	b=me0D8re+J+LyxxkucXRUnqxaygE7tGxPv03IkpsMMn4ehyTbS+mai434bdvCjPMW/LlG
	 kmU+K47ZDSr4XVfPFmqytGwxr29y3BLWwr9GwEibRgI6YHZC3MfXDCJbkeX/ff8xdTkZj
	 7mjhAC3WbVMblT4iWVbntTNIFNtl0PTBLRge8OlkXtnd3DC+BX31fl+nbZBaxBbRPFPkD
	 iUOE91vTfgxMr49Oq+TwzYhmgWubQqAl0BqTJBA9zN6VBLhrczD4hu6asQ1Nm/O82lKn3
	 kXYaP6waTenE0AYviHCcObq4+7Pal1vpHBpPBmcXzCUyMh8arb8CQLydm4ey9H7iDcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800096;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=2Rg+vtDqosIKpsMtrfm0Ml7BNUuvarMYXqbb0/OYQdY=;
	b=g59uozgjlA8RKWYHfVSGQqczrWK7xEpBhNAVD0ZoFVt1nnbgbdHfnQNZETT7kjyMCvme
	 eYe5X4Gvmvi0HQBs0aceb9Ty0EUhiBO+63MZn1dUYfIpnPyAPYuPxi3ruBN1sQWqvMu/J
	 s40NNb839b2hqqXDerePBONRivEHOiq7VU6WNV58GjpxrwE+Rql0Qm33DTsAqPYTQrgei
	 HDVQFOlmnUyNKflYOw4TdkcPhNreLlI+fGPEpzHAjJcnHqG0nC8TZo6L/GDRkxpWQIuUn
	 cxAOQ6XyqiN8WNYOSL6RTbdLPBVrdEiTo858GAe4ZeuswSRtXP9cOOXl+SmSltIHOqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XYxjjTue;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8513D606A33A
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8513D606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XYxjjTue
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794800094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Rg+vtDqosIKpsMtrfm0Ml7BNUuvarMYXqbb0/OYQdY=;
	b=XYxjjTueJPmiCiyatbP+FxpGVrZtQkkaPq9xnxLXy249EtueWYLEH5RmIUo+WA6nrJLxei
	+wVUIz3tocLu7WqXQRev1D5SzRHmXz7h/W6tNJBfuIYCcV9MkqS7GUe3/PnOcz8Oks9Obv
	Vb89h27FRDKwwh5QqQIijRcyOj/tcJ8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-j0GydBKSNkyYYXTgLrnMfQ-1; Sun,
 15 Nov 2026 22:34:47 -0500
X-MC-Unique: j0GydBKSNkyYYXTgLrnMfQ-1
X-Mimecast-MFC-AGG-ID: j0GydBKSNkyYYXTgLrnMfQ_1794800086
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDD4119560B1;
	Mon, 16 Nov 2026 03:34:45 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90E05421;
	Mon, 16 Nov 2026 03:34:43 +0000 (UTC)
Message-ID: <eb3fd5e1-aafe-4bbd-a9ca-afcdb1554fdb@redhat.com>
Date: Sun, 15 Nov 2026 22:34:42 -0500
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
Subject: Re: [PATCH-next v4 2/6] cgroup/cpuset: excpus parameter of
 remote_cpus_update() must have at least 1 active CPU
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-3-longman@redhat.com>
 <e437ac79-7999-43da-9fe8-6cfd475a5196@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <e437ac79-7999-43da-9fe8-6cfd475a5196@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 11/15/26 10:07 PM, Ridong Chen wrote:
>
>
> On 11/16/2026 9:23 AM, Waiman Long wrote:
>> It is reported that remote_cpus_update() fails to invalidate a
>> populated remote partition when an ancestor cgroup update reduces its
>> effective_xcpus mask to only offline CPUs.
>>
>> When update_cpumasks_hier() updates a descendant remote partition, it
>> passes the new effective_xcpus mask (excpus) to remote_cpus_update().
>> Because excpus still contains offline CPUs, cpumask_empty(excpus) is 
>> false
>> and remote_cpus_update() only checks tasks_nocpu_error() when adding 
>> CPUs.
>>
>> With the partition left valid, update_cpumasks_hier() computes an empty
>> effective_cpus mask and jumps to get_css. The populated partition stays
>> valid with no effective CPUs instead of inheriting its parent's CPUs,
>> and its tasks remain affine to the online CPUs returned to top_cpuset.
>>
>> Fix it by invalidating the remote partition if there is no active CPU
>> available in the given excpus parameter.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: 
>> https://sashiko.dev/#/bug/linux-936b7155-f652-4146-a4ab-ec48fd392a1d
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 631fb449cef8..195d4e3a283c 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1810,7 +1810,8 @@ static void remote_cpus_update(struct cpuset 
>> *cs, struct cpumask *xcpus,
>>         WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, 
>> subpartitions_cpus));
>>   -    if (cpumask_empty(excpus)) {
>> +    /* New effective_xcpus must have at least one active CPU */
>> +    if (!cpumask_intersects(excpus, cpu_active_mask)) {
>>           WRITE_ONCE(cs->prs_err, PERR_CPUSEMPTY);
>>           goto invalidate;
>>       }
>
> This also invalidates a remote partition with no task whose excpus
> only has offline CPUs. According to cgroup-v2.rst, such a partition
> is valid: cpuset.cpus.exclusive.effective may contain offline CPUs,
> and cpuset.cpus.effective can be empty if there is no task in the
> partition. The hotplug path and tasks_nocpu_error() follow the same
> rule. How about only invalidating it when it is populated?
>
>       if (cpumask_empty(excpus) ||
>           (!cpumask_intersects(excpus, cpu_active_mask) &&
>            partition_is_populated(cs, NULL))) {

A partition can only be created if there are active CPUs in the 
effective_xcpus. However, such a partition root can distribute its 
exclusive CPUs down to child local partitions with the results that 
effective_cpus can be empty if there is no task there. IOW, 
effective_xcpus must have active CPUs while effective_cpus does not need 
to have active CPUs if there are child partitions underneath. I am going 
to clarify that in the doc. I will check the hotplug path and 
task_nocpu_error() to make sure that it follows this rule. Does that 
rule make sense to you?


>
> Also, it probably needs a Fixes tag, maybe:
>
> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & 
> make update_cpumasks_hier() handle remote partition")

Yes, I miss the fix tag. Will update that in the next version.

Cheers,
Longman

