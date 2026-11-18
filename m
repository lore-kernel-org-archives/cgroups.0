Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022174;
	b=MaoM3FnnFYLvS/+XYpdscZj6srYcC4UlMs8yVLfG+xFcpiRYZifLu0reiOX6x3sUYk9r
	 kj4eKje0qzWJySDfodGf/SDW/TwmWrOTvCM5Aahv8zHZtUpxy5gTogUAXtrYETGkv7oje
	 uQeS6/04NCb+Eh2U2mFm++Snu5PGPdp9ZJWM7z8mnCW/nurLAUDMgzv44bTv1zVUwqi3G
	 cG2BfGelvYs/VbN8kyKuijYL+Xqx2yQ4pg8fw5nwlhHWD64YQQ3nF6dR0+EqVuJ07HRHR
	 Jbcb3803Mp7E4sxrjC2sOAY3KuzyxKZX5BTGa0WK30gBMt6oJipFvlcq0HvVSzGG77A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022174;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=uQgs/LnSsb7T5Yqdh//B4nhVbzY1sGg8qFnrYeg3TTk=;
	b=c18+boqsqaatcFGks0WfauRVDHtQJJm5oeHEBEAS3pysh1Z6BxRu7ogguwm2W27Ks6GR
	 Zpry9XHgzGHaagLsZbhDx5tB0RnN68l6GK0Tc1DX8vaJrnJzDDIT2r1PmrDKyH+F/KOSB
	 Oq/ljvor2otlkbCDngIFpP9iqtGRly28Y0GVdyoKfOPi0s85FyWWvB9LV5tG1yD4XMRDH
	 cHc5htSiKDiAPvILZJK+t8nSdHoh6m5+IJEo6ydhZ8O99lFg2n9V/YDm+S3a6e7HJPADi
	 VeLIwm6nkh5X0fU4ODRg+TVgEFNIvqaBbul19YGFnFewSJWofgQzV/Jb81r7UNxCnjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iiTjJUjV;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130BF606A330
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 17:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 130BF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iiTjJUjV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795022172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQgs/LnSsb7T5Yqdh//B4nhVbzY1sGg8qFnrYeg3TTk=;
	b=iiTjJUjV0siAR1LiqPb/KhNZ0l1qyfO2ZH6mpm4+QXolFfqOdSX+N/sfBJ4kX/nkBAVvRW
	u0cr+wwCgfqbba2tskzznFESWu1wQ16nRP3IoUlZSPg3NVt6kmZeUxVycvjg5OVxHcvaWJ
	2Zw45nywK/v5MTQlu2aRn2NYC9RK3yo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-V9WYMYi8MFSwRBdgCDsq2g-1; Wed,
 18 Nov 2026 12:16:08 -0500
X-MC-Unique: V9WYMYi8MFSwRBdgCDsq2g-1
X-Mimecast-MFC-AGG-ID: V9WYMYi8MFSwRBdgCDsq2g_1795022165
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D79B919560B1;
	Wed, 18 Nov 2026 17:16:04 +0000 (UTC)
Received: from [10.17.16.204] (unknown [10.17.16.204])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 361F31956088;
	Wed, 18 Nov 2026 17:16:01 +0000 (UTC)
Message-ID: <a27dac16-f5c0-459b-9153-7caec3feb8a1@redhat.com>
Date: Wed, 18 Nov 2026 12:16:00 -0500
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
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under
 cpuset_mutex
To: Frederic Weisbecker <frederic@kernel.org>, Ridong <ridong.chen@linux.dev>
Cc: tj@kernel.org, peterz@infradead.org, mingo@redhat.com,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, hannes@cmpxchg.org,
 mkoutny@suse.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 guopeng.zhang@linux.dev, mathieu.desnoyers@efficios.com,
 Ridong Chen <chenridong@xiaomi.com>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
 <av20QrLUdOC_ysS0@localhost.localdomain>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <av20QrLUdOC_ysS0@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 11/18/26 9:20 AM, Frederic Weisbecker wrote:
> Le Tue, Nov 17, 2026 at 04:39:15PM +0800, Ridong a écrit :
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
>> holding cpus_read_lock") calls housekeeping_update() after dropping
>> cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
>> switched and freed outside of those locks. But readers holding either
>> lock may still access it without rcu_read_lock() as allowed by
>> housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
>> for them:
>>
>>    CPU A                                  CPU B
>>    rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
>>                                             mutex_unlock(&cpuset_mutex)
>>                                             cpus_read_unlock()
>>      mutex_lock(&cpuset_mutex)
>>      p = housekeeping_cpumask(DOMAIN)
>>                                             housekeeping_update()
>>                                               rcu_assign_pointer()
>>                                               synchronize_rcu()
>>                                               kfree(old)
>>      access p <- UAF
>>
>> Fix it by moving the pointer switch into housekeeping_publish(), which
>> is called before dropping the locks. Then CPU A either finishes before
>> CPU B switches the pointer, or only sees the new cpumask:
>>
>>    CPU A                                  CPU B
>>                                           cpuset_update_sd_hk_unlock()
>>                                             housekeeping_publish()
>>                                               rcu_assign_pointer()
>>      mutex_lock(&cpuset_mutex) <- wait
>>                                             mutex_unlock(&cpuset_mutex)
>>                                             cpus_read_unlock()
>>      p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
>>          <- new cpumask                       synchronize_rcu()
>>                                               kfree(old)
>>
>> The rest of housekeeping_update(), including the workqueue flushes,
>> still runs without those locks.
>>
>> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Ok that should work but, IIRC this whole locking puzzle is there because
> cpuset_handle_hotplug() can change isolated partitions. Why is it the case
> since cpuset.cpus shouldn't care about offline CPUs?
>
> I remember Waiman said it could be fixed in the long run. I don't remember
> the details though.

cpuset_handle_hotplug() has to remove the newly offlined CPU or to add 
back the newly online CPUs to the effective_cpus of all the cpusets that 
include the affected CPUs whether it is in an isolated or root partition 
or not. In the worst case that the last online CPU in an isolated 
partition is offline, we have to disable it. That is the main reason why 
hotplug can affect isolated partitions. I don't remember saying it is 
something that can be fixed long term. Perhaps, it is not something 
related but not exactly this.

Cheers,
Longman

