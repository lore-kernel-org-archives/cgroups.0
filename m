Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774138;
	b=4qJKzXmbWPRHsBb9ulffwfq3XGBGrQElcDXVtFoQlYNfH3jZKlMoBY2xQNZYKDsCQWZK
	 GJgkR9FlDRpaeaTRmRKbrIIxeE+SGId6Bvc7eM73ldmXQNyLwV3Q15gmddKMPknNMW+tU
	 ftSLChpthicGA2Bm77rTZh/g3P/ZAgZjPiZ5UvrVjuhc/l+B5Apk1mABtAe8ArRK19U06
	 JMMoMoY0g680Cv2C/n8nriNnK+PnbbrlitFQJ4dAyaTZehelT/bevPVeQkmVWcWfROsN7
	 jFRBgqxIDjIY/bwQ/CPhCPBkeugFv8v+8iH99TPl9hbWi6ig5YmU+PgF5S7rujwo81Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774138;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=ZePAjtHw+dvx8jOgEASja8qT5j8yO0Rlzo4LILUR3nU=;
	b=1Y2bMUjQaZtdF+ZQrq/lrtVh2KNDCanygI4tt1W9/giSAOxrwXblY4f2xV4Lnu0AyYhN
	 4YEoddZWUY8e74Z1u/e8NaY7I2b/jFRZ7zHjZ0JipkBPuzJ9f1WrLPeqQiMTlyW7oEgcF
	 N7ldqOpBbA8DffIR81G+xoMUzp79JS6Plb9ROjw9EPH2nUxBSUW/CWHBupgXZHlnJBztz
	 I/Lb/NELUbx4NDorAXNc6D+CDjB3Yktr1y/1RB+2L6qSiSpJp7OUc+/yXOuppbCmMw9aE
	 H0wx2nv2mAuM8hiB+yCdgsTbIr+anbCBl5o7DXmdtM4zcF3gE72u0Yni25Y8MTGl9Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S8VhC0nM;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DA5606A323
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 16:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5DA5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S8VhC0nM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792774136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZePAjtHw+dvx8jOgEASja8qT5j8yO0Rlzo4LILUR3nU=;
	b=S8VhC0nM5gTeVvJ2Nh2lXwSIzIPAbcDW+h/U7KpEhOc0B/RCs9fLHX1uuIZZdBVxM9/kuc
	+JrJSziIsLptBeqyXRS6U3a5Plz4FQ9kwj2l1VbL1sG1rcmqlJMpEMFLDbX3FAj8LmebqC
	4JCM/yAmy9mTJ9VVqqT0r9UknOzpe/Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-6bx0LM6CMqWXYCh5RBGlGg-1; Fri,
 23 Oct 2026 12:48:55 -0400
X-MC-Unique: 6bx0LM6CMqWXYCh5RBGlGg-1
X-Mimecast-MFC-AGG-ID: 6bx0LM6CMqWXYCh5RBGlGg_1792774133
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B3871954194;
	Fri, 23 Oct 2026 16:48:53 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8095E3000738;
	Fri, 23 Oct 2026 16:48:51 +0000 (UTC)
Message-ID: <54803571-5822-4f20-a9a3-883e1c19e08f@redhat.com>
Date: Fri, 23 Oct 2026 12:48:50 -0400
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
Subject: Re: [PATCH-next 1/6] cgroup/cpuset: Find furthest isolated ancestor
 for invalidated isolated partition
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-2-longman@redhat.com>
 <c0a4470f-ef81-47a2-9d4b-a28a7fe1a529@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <c0a4470f-ef81-47a2-9d4b-a28a7fe1a529@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 10/23/26 2:24 AM, Ridong Chen wrote:
>
>
> On 10/22/2026 11:16 AM, Waiman Long wrote:
>> Commit 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus
>> update in update_cpumasks_hier()") searches for the closet partition
>> root ancestor to determine if the isolated CPUs in a to be invalidated
>> isolation partition should be removed from isolated_cpus or not.
>>
>> As reported by sashiko, this method may not work when there is a deeply
>> nested isolated partition hierarchy. For instance, Consider a nested
>> hierarchy A0 -> A1 -> A2 -> A3 where all four are PRS_ISOLATED:
>>
>>    A0: effective_xcpus = 0-4
>>    A1: effective_xcpus = 1-4
>>    A2: effective_xcpus = 2-4
>>    A3: effective_xcpus = 3-4
>>
>> When A1 shrinks its exclusive_cpus from 1-4 to 1-2, A2 will update it
>> effective_xcpus to 2. A3 will find its closet partition root ancestor
>> A2 and decides that its effective_xcpus 3-4 should be removed from
>> isolated_cpus which is incorrect.
>>
>> Address this corner case by searching for the furthest isolated 
>> partition
>> root ancestor instead to decide if its isolated CPUs should be returned
>> to isolated_cpus.
>>
>> Fixes: 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus 
>> update in update_cpumasks_hier()")
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 36 +++++++++++++++++-------------------
>>   1 file changed, 17 insertions(+), 19 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 585a982249ad..7ead8c3b7974 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2156,22 +2156,20 @@ static void 
>> compute_partition_effective_cpumask(struct cpuset *cs,
>>   }
>>     /*
>> - * ancestor_partition - Find and return the closest valid partition 
>> root ancestor
>> + * iancestor_partition - Return furthest isolated partition root 
>> ancestor available
>>    * @cs: the current cpuset
>> - *
>> - * Return: The closet partition root ancestor cpuset
>> + * Return: The furthest isolated partition root ancestor available 
>> or NULL if
>> + *       not found.
>>    */
>> -static struct cpuset *ancestor_partition(struct cpuset *cs)
>> +static struct cpuset *iancestor_partition(struct cpuset *cs)
>
> Nit.
>
> iancestor is confusing.
> Can we renmae it furthest_isolated_ancestor?

Yes, I can make the name change. Thanks for the suggestion.

Cheers,
Longman

