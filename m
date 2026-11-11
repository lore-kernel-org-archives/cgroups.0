Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794362481;
	b=g/RYDMq7OP1vlbJuVuT+exi1vpuPd/TrlcA5/XLuoZs9tUADNwQcL+WCwkS7L1naoXlS
	 zLV78Rxkl8eGw+8B55Mc8Xs+LWERDyJ0WAOEmAVFwLktTN0l6T1xr46ybE5UWgf6TEias
	 xxx/DyUzIzBy2RKCX6DnKKUZJ0WNGUF+uUgpni0M11Pd0XZ1GvsuY5bq97pqYBJtaBRf3
	 P26JWtwnZ95zSkNiKm7nTR0sfwFFWldy3r4iqEwL787y0yL9i6mxl/2rC90h2eLfXsdgV
	 BuKgIgmt3zFJwV9m2kQY0z6WmI1LwJqP6ersS+MwsIbZ7LUPY3x3bzBozCSFsnMq88Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794362481;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=OsWPDLq1wEo1BoziCE62yl+tVV1rVCRXzUhL5sSycqs=;
	b=qDROYHPKyHrffPeOASdcKw49aY3fd/HqWvSlexw0VgllzzR4fA/5evw0xOVKew3mpYnm
	 qghlMgTvMMMEhAg2Nmt81CsjTAt/+Kz2ytsUGq0u59LBOivWdGZrKv57vaugz3vpeWe64
	 73baGD6EW+sKgaykhc8xSVKVK3Nd8kMYLc23qA0F4NRzj83KBEeRP9J7IH+1Fera+g+AG
	 QzJP3cbxgrOhK9+49p+R45P8/TtS8jyH2XYQNmqtvHks1pqBTcEot8HPZt6QCor5AaXfO
	 pn5UCCakJmeS5SAkPtCoz58g1QlZORqDbjhYmj+XcV6JNr59MMDgNHmsMtCJnm3wPxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V08UthS5;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B281606A31C
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 02:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B281606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V08UthS5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794362479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsWPDLq1wEo1BoziCE62yl+tVV1rVCRXzUhL5sSycqs=;
	b=V08UthS5PPtfiPtZkwQEstkjzfsajFDue1MfEdSo+j46y6791CWFuHZBUfAiAVqb8CyYn1
	vlTddsaGVjiF8uUfqnqFY9LOs3j0JM/JLBhOFd6Lliguwwp1Ba5OfOz/8/JMDbcsd/2TBM
	iIoW35A9N+GPp9wpFnjVxxQObOMZv6E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-fnqDO5Z5MXWQUnRoyX0wHA-1; Tue,
 10 Nov 2026 21:01:13 -0500
X-MC-Unique: fnqDO5Z5MXWQUnRoyX0wHA-1
X-Mimecast-MFC-AGG-ID: fnqDO5Z5MXWQUnRoyX0wHA_1794362470
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 848A21800599;
	Wed, 11 Nov 2026 02:01:09 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C22A51966664;
	Wed, 11 Nov 2026 02:01:07 +0000 (UTC)
Message-ID: <c13526c0-50a4-4932-ab2d-5327a0313aa1@redhat.com>
Date: Tue, 10 Nov 2026 21:01:06 -0500
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
Subject: Re: [PATCH-next v2 2/5] cgroup/cpuset: Correctly set cpus_updated in
 cpuset_hotplug_update_tasks()
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261109190955.1398611-1-longman@redhat.com>
 <20261109190955.1398611-3-longman@redhat.com>
 <d66ec8aa-fb96-42de-a9a0-5b5aa29f1083@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <d66ec8aa-fb96-42de-a9a0-5b5aa29f1083@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


On 11/10/26 3:40 AM, Ridong Chen wrote:
>
>
> On 11/10/2026 3:09 AM, Waiman Long wrote:
>> When cpuset_hotplug_update_tasks() is called with the conditions that
>> either remote_partition_disable() or update_parent_effective_cpumask()
>> has to be called, the cs->effective_cpus can be updated such that it
>> matches what is computed in new_cpus. In such case, cpus_updated can
>> be incorrectly set to false leading to stale CPU afinity remained in the
>> tasks not matching the new cpuset value. Fix that by forcing 
>> cpus_updated
>> to true whenever one of these partition helpers is being called.
>>
>> Fixes: 4b842da276a8a ("cpuset: Make CPU hotplug work with partition")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: 
>> https://sashiko.dev/#/bug/linux-ab90f7e8-0d60-40ca-83e9-e405075b24d2
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 6074327c3477..3955d2d574cf 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -4002,7 +4002,7 @@ static void cpuset_hotplug_update_tasks(struct 
>> cpuset *cs, struct tmpmasks *tmp)
>>   {
>>       static cpumask_t new_cpus;
>>       static nodemask_t new_mems;
>> -    bool cpus_updated;
>> +    bool cpus_updated = false;
>>       bool mems_updated;
>>       int partcmd = -1;
>>       struct cpuset *parent;
>> @@ -4015,12 +4015,18 @@ static void 
>> cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>       if (!tmp || !cs->partition_root_state)
>>           goto update_tasks;
>>   +    /*
>> +     * cpus_updated should be set to true when 
>> remote_partition_disable()
>> +     * or update_parent_effective_cpumask() is called as 
>> cs->effective_cpus
>> +     * may have been updated.
>> +     */
>>       if (is_remote_partition(cs) && 
>> (cpumask_empty(subpartitions_cpus) ||
>>                          (cpumask_empty(&new_cpus) &&
>>                       partition_is_populated(cs, NULL)))) {
>>           WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>>           remote_partition_disable(cs, tmp);
>>           compute_effective_cpumask(&new_cpus, cs, parent);
>> +        cpus_updated = true;
>>       }
>>         /*
>> @@ -4045,6 +4051,7 @@ static void cpuset_hotplug_update_tasks(struct 
>> cpuset *cs, struct tmpmasks *tmp)
>>           partcmd = partcmd_update;
>>         if (partcmd >= 0) {
>> +        cpus_updated = true;
>>           update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
>>           if (is_partition_valid(cs) || (partcmd == 
>> partcmd_invalidate)) {
>>               compute_effective_cpumask(&new_cpus, cs, parent);
>> @@ -4053,7 +4060,7 @@ static void cpuset_hotplug_update_tasks(struct 
>> cpuset *cs, struct tmpmasks *tmp)
>>       }
>>     update_tasks:
>> -    cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
>> +    cpus_updated |= !cpumask_equal(&new_cpus, cs->effective_cpus);
>>       mems_updated = !nodes_equal(new_mems, cs->effective_mems);
>>       if (!cpus_updated && !mems_updated)
>>           goto unlock;    /* Hotplug doesn't affect this cpuset */
>
> I think the issue only happens in the remote partition case.
> remote_partition_disable() calls reset_partition_data(), which sets
> cs->effective_cpus to what compute_effective_cpumask() will return
> afterwards, so the cpumask_equal() check misses the change while the
> tasks still have the old affinity.
>
> update_parent_effective_cpumask() only updates the effective_cpus of
> the parent (through partition_xcpus_add/del()), and cs is skipped in
> update_sibling_cpumasks(). So cs->effective_cpus isn't changed there and
> the original check still works. If new_cpus is the same as
> cs->effective_cpus in that case, forcing cpus_updated just walks all the
> tasks in cs and calls set_cpus_allowed_ptr() with their current mask.
> Should cpus_updated only be set in the remote partition case?
>
> Also, as the problem comes from remote_partition_disable() in the
> hotplug path, should the Fixes tag be the following instead?
>
> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
>
Yes, you are right. Thanks for the review. Will send out a v3 with the 
suggested changes.

Cheers,
Longman

