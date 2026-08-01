Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2913CFF72
	for <cgroups@vger.kernel.org>; Sat,  1 Aug 2026 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785627444; cv=none; b=YsAZpXBkOxBKr32vmu6gD38wD/6prTdh4EChxoIQSXGF7fASNr3l2hYwTiJF1jGxa17PavKVBTzBK05UuQ7x3IY1NA/Pc2oya6U2b4qgr3O7pXzB0AehQ3dpg9thMwWY5fBT9h+sY84plrrhSep17APtzY/hHtauJ8sLSasIoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785627444; c=relaxed/simple;
	bh=d9xH5lAA4l9r3jUGCP7Funb112YY5QCYc/j4qc4xJcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gn2XtCyc7ZgiRDRRUjSK1BUuj2Km1Fkd6tHoT+9TdE8Zv1nBNlxG4zjlBZFQGyF88z4D+Mgvcf1db4oNcdZB5X/TgMnVOKLEI0g7ZKg4KYFr5wNIsjmb8ivyZRMEBW7J74MvlS7ycdWjQPDTAwUYM/Bru3Vvc7u1pDPjt0TtY8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/0htqbZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/0htqbZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785627442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JuytdfVV/Gs8HgjVlOB35d5JRq5wHR5+r0iMGF1DKq4=;
	b=F/0htqbZXCf1xFTHEUgt5nL5eTXZASNRNekgTaafK/+EFiDn7XbLiG0LDTpmUY3Lx4z6n/
	PEgrOVqFDHl3i2OFsybIByaEa7whOXhtsuRODn38IPEGgNwRN3Gvn5gdfSPyFiQVHph2cs
	0Toi1+D9niX0o5/N9d104kWfs6n/xVA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-2faUNrUKOC60w-L5ghLw2A-1; Sat,
 01 Aug 2026 19:37:17 -0400
X-MC-Unique: 2faUNrUKOC60w-L5ghLw2A-1
X-Mimecast-MFC-AGG-ID: 2faUNrUKOC60w-L5ghLw2A_1785627436
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A4EE195608A;
	Sat,  1 Aug 2026 23:37:16 +0000 (UTC)
Received: from [10.22.64.35] (unknown [10.22.64.35])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCC131800480;
	Sat,  1 Aug 2026 23:37:14 +0000 (UTC)
Message-ID: <8797e8b8-59ce-4934-ac0c-7f9731de454b@redhat.com>
Date: Sat, 1 Aug 2026 19:37:13 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup: drop unneeded semicolon
To: Julia Lawall <Julia.Lawall@inria.fr>, Tejun Heo <tj@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 8/1/26 3:09 PM, Julia Lawall wrote:
> When a function-like macro expands to an expression, that expression
> doesn't need a semicolon after it.  All uses have been verified to
> have their own semicolons.
>
> This was found using the following Coccinelle semantic patch:
>
> @r@
> identifier i : script:ocaml() { String.lowercase_ascii i = i };
> expression e;
> @@
>
> *#define i(...) e;
>
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
>
> ---
>   kernel/cgroup/cgroup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 38f8d9df8..f87fc4550 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -104,7 +104,7 @@ DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
>   #define cgroup_assert_mutex_or_rcu_locked()				\
>   	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
>   			   !lockdep_is_held(&cgroup_mutex),		\
> -			   "cgroup_mutex or RCU read lock required");
> +			   "cgroup_mutex or RCU read lock required")
>   
>   /*
>    * cgroup destruction makes heavy use of work items and there can be a lot
>
The RCU_LOCKDEP_WARN() macro is basically a "do { ...} while (0...)" 
statement. It doesn't have a ';' at the end.  So your commit log isn't 
right.

An additional semicolon at the end doesn't harm. By removing the 
semicolon, even if not needed, may make people wonder if it is right 
when reading the code wasting their time to figure out if it is all 
right. So I don't see any advantage in removing it.

Cheers,
Longman

