Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794513711;
	b=IAD0WpewKW7k0DH3FUsKAip5gy+kaO70HI94IgTNnUYls6KsTSDs0dAI2miGTEkQETh2
	 xBcicrblm/WNGfrrrHcvdJ8VKVzqhUA3ksB6yP4RoG8YhX7CVbirS1/2rLrTjOwFzum8P
	 cZF6RMsFRk1a+NubxGOzvwqB7IH75/3UxOpWLMdWl/l0S1i3MT6Suy+SDpaiElm/MzhAp
	 F2dQcybN9jGkHedhCzXnOOq5RnRZhpt0u5cVOrBJbQp05lHazhXpV1Gc2cWqrFETnZVgU
	 EWZ2sJKm2s9ctUNZoNnj/+c9ZgmReY2I/Ukj22o8x8Dj5rzcUftJZePeSbHcCUJkQzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794513711;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=y2HwTF1YMo0f9rY3awZ8X1TzkkuJLbUU0MmU+IWgVZ4=;
	b=Q+TcS0lQ//uOCDNrHMpCYRX2VOpQ/6xOe4Wj43Khz/Az69/9GBEGnuj0Q+BEgMu7N78i
	 2C6XzLdaLZChwsfxw2/BtTNhnJQaS4cu3pivPN0xvb9XstEFl0adxBx63K+R/tg3PCwmn
	 NeUVVrs2cd/Oo5lMnhcJDIwci6yJQt1vIps80c7qmh3wvojP1V5oA8OwT43KMqK2KpmKY
	 8WTDgfYtiST39nbD/ZBv/JCG7kYDGEZsTDWzIFY8NYm82fZJxw/lOe12pyhdx2uqAJ8x4
	 VRUU0ULiKc8yZgYQTY4AFXQXpmC4unidcwNkln0ruSDr8xTCdcFipLHFmlnYW08URvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=P1ChTVlW;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ABD606A334
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 20:01:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6ABD606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=P1ChTVlW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794513710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y2HwTF1YMo0f9rY3awZ8X1TzkkuJLbUU0MmU+IWgVZ4=;
	b=P1ChTVlWkmsj0nYVVCSXGoBBqbp3R9/hUL4vMNRJpOSwcypRNNgSfxPLIxEKS92SYeHQ47
	R1k+hzkJL329JF1ljj+uZYZ/q0ZCQrKz8cdE9bNFy82uSp5VnVrhJ/J0Ndec8t9xtedxGW
	tXevfRxqLxC1FX5KS42w+SI7BX6I/Xc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-DC2VcjLZPSy1gaYdteKPtg-1; Thu,
 12 Nov 2026 15:01:46 -0500
X-MC-Unique: DC2VcjLZPSy1gaYdteKPtg-1
X-Mimecast-MFC-AGG-ID: DC2VcjLZPSy1gaYdteKPtg_1794513704
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9888D1800352;
	Thu, 12 Nov 2026 20:01:44 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 161501800446;
	Thu, 12 Nov 2026 20:01:42 +0000 (UTC)
Message-ID: <a13ef6be-fa53-4d80-b768-2d8a16467fa4@redhat.com>
Date: Thu, 12 Nov 2026 15:01:41 -0500
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
Subject: Re: [PATCH-next v3 3/3] cgroup/cpuset: Check remote partition
 underneath before making an invalid partition valid
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261111020204.1660055-1-longman@redhat.com>
 <20261111020204.1660055-4-longman@redhat.com>
 <fe7aa630-d323-4981-9f89-0958cb6204a2@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <fe7aa630-d323-4981-9f89-0958cb6204a2@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 11/11/26 10:27 AM, Guopeng Zhang wrote:
>
> 在 2026/11/11 10:02, Waiman Long 写道:
>> When re-evaluating an invalid local partition via partcmd_update,
>> update_parent_effective_cpumask() does not check whether a descendant
>> remote partition is using its exclusive CPUs, promoting the cpuset to a
>> valid partition root over the remote partition. This condition should only
>> be possible if parent is the top_cpuset and exclusive_cpus isn't empty.
>>
>> This leaves an active remote partition underneath a valid
>> local partition root with overlapping exclusive CPUs, breaking
>> scheduler domain partitioning and triggering warnings in
>> compute_partition_effective_cpumask() and generate_sched_domains().
>>
>> Fix that by checking the effective_xcpus against subpartitions_cpus
>> when an underneath remote partition is possible to make sure that all
>> the exclusive CPUs are available before allowing the invalid partition
>> to be switched back to valid.
>>
>> Also make sure that effective_xcpus is non-empty before swtiching an
>> invalid partition back to valid.
>>
>> Add a test case in test_cpuset_prs.sh to verify that an invalid partition
>> with a remote partition underneath cannot be switched back to valid
>> with a hotplug event.
>>
>> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://sashiko.dev/#/bug/linux-47715b89-d5fb-4731-b7c9-070773c6ff75
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c                        | 42 ++++++++++++-------
>>   .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
>>   2 files changed, 30 insertions(+), 16 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8b684361c94e..af5fd543fe88 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2034,11 +2034,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   		 * tasks_nocpu_error() with this very mask, and a failing
>>   		 * write is routed to partcmd_invalidate instead.
>>   		 */
>> -		if (is_partition_invalid(cs)) {
>> -			adding = false;
>> -			deleting = cpumask_and(tmp->delmask,
>> -					newmask, parent->effective_xcpus);
>> -		} else {
>> +		if (is_partition_valid(cs)) {
>>   			cpumask_andnot(tmp->addmask, cs->effective_xcpus, newmask);
>>   			adding = cpumask_and(tmp->addmask, tmp->addmask,
>>   					     parent->effective_xcpus);
>> @@ -2046,6 +2042,17 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   			cpumask_andnot(tmp->delmask, newmask, cs->effective_xcpus);
>>   			deleting = cpumask_and(tmp->delmask, tmp->delmask,
>>   					       parent->effective_xcpus);
>> +		} else {
>> +			deleting = cpumask_and(tmp->delmask,
>> +					newmask, parent->effective_xcpus);
>> +
>> +			/* Check if a remote partition may be underneath */
>> +			if ((parent == &top_cpuset) &&
>> +			    !cpumask_empty(cs->exclusive_cpus) &&
>> +			    cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
>> +				part_error = PERR_REMOTE;
>> +				deleting = false;
>> +			}
>>   		}
>>   
>>   		/*
>> @@ -2126,34 +2133,37 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>   		} else if (is_partition_invalid(cs)) {
>>   			struct cgroup_subsys_state *css;
>>   			struct cpuset *child;
>> -			bool exclusive = true;
>>   
>>   			/*
>>   			 * Convert invalid partition to valid has to pass the
>> -			 * cpu exclusivity test when cpuset.cpus.exclusive is
>> -			 * empty as well as the housekeeping check.
>> +			 * following tests:
>> +			 * 1) housekeeping CPU conflict check
>> +			 * 2) cpu exclusivity test when cpuset.cpus.exclusive is
>> +			 *    empty.
>> +			 * 3) if parent is top_cpuset, none of the effective_xcpus
>> +			 *    (tmp->delmask) are in subpartitions_cpus, if not a
>> +			 *    remote partition may be underneath.
>>   			 */
>>   			if (prstate_housekeeping_conflict(cs->partition_root_state,
>>   							  parent_prs, tmp->delmask, NULL)) {
>>   				part_error = PERR_HKEEPING;
>> -				goto write_error;
>> -			}
>> -			if (cpumask_empty(cs->exclusive_cpus)) {
>> +			} else if (cpumask_empty(cs->exclusive_cpus)) {
>>   				rcu_read_lock();
>>   				cpuset_for_each_child(child, css, parent) {
>>   					if (child == cs)
>>   						continue;
>>   					if (!cpusets_are_exclusive(cs, child)) {
>> -						exclusive = false;
>> +						part_error = PERR_NOTEXCL;
>>   						break;
>>   					}
>>   				}
>>   				rcu_read_unlock();
>> +			} else if ((parent == &top_cpuset) &&
>> +				   cpumask_intersects(tmp->delmask, subpartitions_cpus)) {
>> +				part_error = PERR_REMOTE;
>>   			}
> Hi,Longman
>
> I think this check can still miss a remote partition during hotplug.
> When CPU hotplug leaves no active CPU available to the top partition,
> cpuset_handle_hotplug() clears subpartitions_cpus before walking the
> descendants. The remote partitions are still valid at that point.
>
> An invalid parent is visited before its remote descendant. Since the
> mask is empty, this check allows the parent to become valid and add
> its exclusive CPUs back to subpartitions_cpus. When the remote
> descendant is visited later, those CPUs are already back in the mask,
> so it passes the subset check and stays remote. We are then left with
> a valid remote partition below a valid local partition, and
> compute_partition_effective_cpumask() warns about the remote child.
>
> Could we check whether there is still a valid remote partition below cs
> before allowing cs to become valid? subpartitions_cpus may have been
> cleared by hotplug, so the lack of overlap does not tell us that the
> remote partition has actually been disabled.

Yes, this is a corner case that I am aware of. Thanks for letting me 
know about that.

Right now, only invalid local partition has the ability to switch back 
to valid when the condition is right. Remote partition has no such 
capability at the moment. So a remote partition should always be 
invalidated when top_cpuset run out of active CPU. One way to handle 
this situation is to switch back to chain all remote partition in a 
linked list. We can then work the remote partition linked list when that 
happens and determined if we can their effective_xcpus back to 
subparttitions_cpus or has to disable it before going down to do 
hierarchical cpuset walk. This will avoid the corner you are talking 
about. It will be a separate patch. I will update the patch description 
to add this limitation and a todo item.

Cheers,
Longman

