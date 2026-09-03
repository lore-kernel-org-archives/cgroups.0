Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2E83655EA
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406191; cv=none; b=aC5yy3Qb+59v4ARbihitWUf7rSchsg8TTK9dEgbN1Klu/kDIfSkelT/cxHghode/n5M+qkRPtBO4loAP9QttZcoQNYDVnlU0akjLO9/TawjqwjV8XRqInmGN2tQuLcNcIjB29pkqDL3GZYdiUH7JNibx+57IWwdb5N8PpC/IhxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406191; c=relaxed/simple;
	bh=joE8kO9v/f9BQEH9ifxEms+kQ7kJk6lnsVm/NZLnDM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KBlMasSuiqAUr+OjO2BXUqMFjapb2Ru8d+4baE52IN8HAFe/eft++JUEJW/z7k9p3xPC8p86JnOAfREZXu6ASonSKr6M9wO7oTfQOEF0vH0ri8lX5PhbgfOCRrgn1UT80xKajFwEMrUbcYu3jv2uUQgIpXFY5fGf21dE3uYWzoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvEEGJ+G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvEEGJ+G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788406188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7RoM7uAUzcvJDJLLqQgasYrLIMEII37o4yhCAkc1RA=;
	b=cvEEGJ+GMLQJFqwELMa2ZhiMr3PpcZdqZPKidjvimI0dJsXkQv3/t9gAuHiKOGzi54zp+F
	Brvh2hIkS0HnP7scc+7itA1+u0vAuDSQwiiOj6tkzuemzrN8MTw/EPrfuCX/c945g9I+zq
	ROd/A4IWhpuzqQPrJkcrgTvM/VWszWc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-6eKHUyGFOQaXlkdI0bhd3g-1; Wed,
 02 Sep 2026 23:29:45 -0400
X-MC-Unique: 6eKHUyGFOQaXlkdI0bhd3g-1
X-Mimecast-MFC-AGG-ID: 6eKHUyGFOQaXlkdI0bhd3g_1788406184
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B8931944B03;
	Thu,  3 Sep 2026 03:29:43 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07D063001D3F;
	Thu,  3 Sep 2026 03:29:41 +0000 (UTC)
Message-ID: <fda9189a-93d1-44bc-8c69-766c687c0ed5@redhat.com>
Date: Wed, 2 Sep 2026 23:29:41 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Handle cpu hotplug race in
 guarantee_active_cpus()
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260828180322.730419-1-longman@redhat.com>
 <ba138f23-6972-44c8-8ce5-80de1f50891c@linux.dev>
 <85411b3f-bcbd-4a7e-99a5-49a465ca2df8@redhat.com>
 <CA+0ovCg3BcogTUuqZwboEaZW41dkcsAV3nWjENOHc5ZFGaEarA@mail.gmail.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CA+0ovCg3BcogTUuqZwboEaZW41dkcsAV3nWjENOHc5ZFGaEarA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 9/1/26 4:55 PM, Farhad Alemi wrote:
> Apologies for the delay in response. Upon our run, the patched kernel
> 388b607d107c07aaade04c7f22f344cab6bdccd3 no longer panics when facing
> the attached reproducer.

Thanks for verifying the patch. Would you mind if I added the following 
Tested-by tag to the patch?

Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>

Thanks,
Longman


