Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794018077;
	b=EfYMTQDdPxv8NfDDqmZ25bKCtkfsDcsKV0i8Ck8a+1tsUQ6OARvekjboN42G0ll0CO7p
	 FwWwTOc9VVtJR74Xk6fr8DvgsyoCR1LJLTg0c6d7dnrbvDcs/4ZUr4yVfpCEDn3a4U4h2
	 OsdCcE4apjoy7UJDAblRdX3hTCHUAhO/wDWI3JMOjayNYgp66N1Vj24XppKM7tjzeWbyK
	 l413qwzWwFv28AsEWHcXEMLxcrPny7oYthB8vFfzHmc3Su/a6AuvHNt1b8Z0eQH4dkwu+
	 gUXlR+BAXzzznEOoP8rHhBIGhv5AYaRdtxqkyxcmAUjhkJhcr2NJRzcmPX+lPx8Hd9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794018077;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=HD+obUL6xMiqxy8e9+aOC8RDWR5JCbqjrG97tBKMlL4=;
	b=FCapfdqGjDPrp7BVWKFjAk/1XRl8hTzubbOG4UJsh/K2VFF2pS2SZPctsukjRs/nwrtT
	 mUja+HYkFfWpryLnuCTeh8/PN4Q6CEykOZrrngp1kl1QKqQEXmLAb68VshCtCVAgWrrbe
	 8BKAZ29V5UnZGclptAVcsjSKx9+F7rNMq+QIT/8ruLqgL2ZqsQ5EgJNuMoWj8ICE1MY1I
	 YkcYf2rGiDeJnVDemlGCYTUmWYdctXRn+a4oKSzS9OV5MJKjzRAhLBPP78R0czgsxA8bi
	 tSpSOmJJVu0pKgT0j7T11W4lOfb2WkpuNE5wywnhjDbwtwBE5927DB/40SO20j3clUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JO15Qv7W;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAF2606A326
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 02:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AAF2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JO15Qv7W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794018076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HD+obUL6xMiqxy8e9+aOC8RDWR5JCbqjrG97tBKMlL4=;
	b=JO15Qv7WMx3U4taUbWEB4vvvSvJYcpbwB/d9lddRUDwdvWRc3hHXfOLewslF6pDNAc+/E1
	4PJCzxTGn6mPgmdQTIvIYMJxG9sCWet0P9l/7EDDoIWgdX2szYzDYeD3EfNDhAoGTG3Co7
	IcrJA8ru2BbqDxSGohdUJQptVwgU4kY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-okoCnzkIMTWs6R3mKBKohg-1; Fri,
 06 Nov 2026 21:21:13 -0500
X-MC-Unique: okoCnzkIMTWs6R3mKBKohg-1
X-Mimecast-MFC-AGG-ID: okoCnzkIMTWs6R3mKBKohg_1794018071
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48B201956051;
	Sat,  7 Nov 2026 02:21:10 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DFDD3001DA7;
	Sat,  7 Nov 2026 02:21:07 +0000 (UTC)
Message-ID: <d4a2a258-ce42-4078-9d34-268b8ae84133@redhat.com>
Date: Fri, 6 Nov 2026 21:21:06 -0500
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
Subject: Re: [PATCH v2 2/4] cpuset: add early empty cpumask check in
 partition_xcpus_add/del
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
 <20261106105538.2915492-3-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261106105538.2915492-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 11/6/26 5:55 AM, Ridong Chen wrote:
> From: Chen Ridong <chenridong@huawei.com>
>
> Add a check for an empty cpumask at the start of partition_xcpus_add()
> and partition_xcpus_del(). This allows the functions to return early,
> avoiding unnecessary computation when there is no work to be done. With
> these changes, partition_xcpus_add() and partition_xcpus_del() can be
> called even if xcpus is empty. The caller no longer needs to check whether
> xcpus is empty, eliminating many conditional statements.
>
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index cf38e8708ddd..85e5b529d144 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1315,10 +1315,13 @@ static void partition_xcpus_add(int new_prs, struct cpuset *parent,
>   {
>   	WARN_ON_ONCE(new_prs < 0);
>   	lockdep_assert_held(&callback_lock);
> +
> +	if (cpumask_empty(xcpus))
> +		return;
> +
>   	if (!parent)
>   		parent = &top_cpuset;
>   
> -
>   	if (parent == &top_cpuset)
>   		cpumask_or(subpartitions_cpus, subpartitions_cpus, xcpus);
>   
> @@ -1342,6 +1345,10 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>   {
>   	WARN_ON_ONCE(old_prs < 0);
>   	lockdep_assert_held(&callback_lock);
> +
> +	if (cpumask_empty(xcpus))
> +		return;
> +
>   	if (!parent)
>   		parent = &top_cpuset;
>   
Reviewed-by: Waiman Long <longman@redhat.com>

