Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C62D6E44
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 03:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785641508; cv=none; b=LNkxd/3xUiwbxHzCKSJ+HSJepemG8B/TqoVWDb1kWHgpCHJphVk5eRHv2X3hiV/xb812ZmhPOCGol42HR6FqKRR6/M3+CR9T0pR1vBOVwbtEAGU5pD4AK5HWo8yljRoIl8bQFGh3NXYujGTuBxCplwu3kxEfqQe5q1RwIzX70J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785641508; c=relaxed/simple;
	bh=NKN3pgkQpNdrfAJS32Gf8l48y997BO/qEHloE2C7ZaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kq2aG6ollSv9t6IJQ2+UeyC1Gw51VPQbIXlOvWPHIq/Evd78JsldnwEjWTaymAUs+62wKex+0cq2Sw94Nr2FZfYQz3UcqRT/MJXwNDofdUOkVna0aiAKkmzIAGcnlPnj+FnRzCRBeLrsJu32zFW9h0Bsmalwai9PMxbTbd46N5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/RBrrC6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/RBrrC6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785641506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QB9uwRN6mIl04CeidLK6qsbyyZo4iJRSFelhNDIPRHY=;
	b=f/RBrrC6Bhc0CcSxdoWLOvob04GrmqoF8EenzscjQpQabKvEzK19pN/nhTjmoQb8ff1RzN
	QObLWHOOaO1CsRCIkKoG/rK0B/AKL7cO8i6F23dxIcFMfacmeQ5mzFRIlbaXUXkJcXkSVW
	0FCWa9zUs+8kgm+U1yBXvhPa5AM1n84=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-380-U51kSW0XMVy-qTw_Kmb0gg-1; Sat,
 01 Aug 2026 23:31:40 -0400
X-MC-Unique: U51kSW0XMVy-qTw_Kmb0gg-1
X-Mimecast-MFC-AGG-ID: U51kSW0XMVy-qTw_Kmb0gg_1785641499
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9AC8195608E;
	Sun,  2 Aug 2026 03:31:38 +0000 (UTC)
Received: from [10.22.64.35] (unknown [10.22.64.35])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7AD7A180044F;
	Sun,  2 Aug 2026 03:31:37 +0000 (UTC)
Message-ID: <9e592ea7-126f-49c8-8731-1e8e1619e373@redhat.com>
Date: Sat, 1 Aug 2026 23:31:36 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup: drop unneeded semicolon
To: Tejun Heo <tj@kernel.org>
Cc: Julia Lawall <Julia.Lawall@inria.fr>, kernel-janitors@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
 <8797e8b8-59ce-4934-ac0c-7f9731de454b@redhat.com>
 <am61eHsfLMfPCSsE@slm.duckdns.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <am61eHsfLMfPCSsE@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 8/1/26 11:11 PM, Tejun Heo wrote:
> Hello,
>
> On Sat, Aug 01, 2026 at 07:37:13PM -0400, Waiman Long wrote:
>>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>>> index 38f8d9df8..f87fc4550 100644
>>> --- a/kernel/cgroup/cgroup.c
>>> +++ b/kernel/cgroup/cgroup.c
>>> @@ -104,7 +104,7 @@ DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
>>>    #define cgroup_assert_mutex_or_rcu_locked()				\
>>>    	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
>>>    			   !lockdep_is_held(&cgroup_mutex),		\
>>> -			   "cgroup_mutex or RCU read lock required");
>>> +			   "cgroup_mutex or RCU read lock required")
>>>    /*
>>>     * cgroup destruction makes heavy use of work items and there can be a lot
>>>
>> The RCU_LOCKDEP_WARN() macro is basically a "do { ...} while (0...)"
>> statement. It doesn't have a ';' at the end.  So your commit log isn't
>> right.
>>
>> An additional semicolon at the end doesn't harm. By removing the semicolon,
>> even if not needed, may make people wonder if it is right when reading the
>> code wasting their time to figure out if it is all right. So I don't see any
>> advantage in removing it.
> I think the extra semicolon can hurt. Imagine something like this:
>
>          if (blah)
>                  cgroup_assert_mutex_or_rcu_locked();
>          else
>                  something else;
>
> This should work but with the extra semicolon, it doesn't. I don't see why
> we wouldn't fix this. It's obviously wrong.

OK, I think I have misread the patch. Right, the extra ';' should be 
removed. Sorry for the noise.

Cheers,
Longman

