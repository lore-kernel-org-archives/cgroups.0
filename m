Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0027E37AA78
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 01:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784078729; cv=none; b=aPLubijOQTu47VVfy2FtPF8LjJbbxX5talN79+2TixZhLWRCLQE2mU8vPGtS87XqwsVpq1dddznAXiOAHYDC9xh3I17mJJ1XygnlVU+vlMQ/+Bhz+ooH17FxS40RqnkUV12y1teTE1Mr8ZrXW4b3fqCKUJ5mLmP9+XkFJwVhFKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784078729; c=relaxed/simple;
	bh=0hVRqmDAGBmc+K2tVTNOodwSWISji+6SQljSAkLXt5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=or0soM2Qapv1gEWXwJsqsW+wU5vAIGj9Ow0ZaRn5QX5lQV5jLLEHG+MyLYjETqHUDWUNOHofKuSomfzT4ZSH+iIKWr33wH9hJ9NRUajFtuBnelQVV07spmqR2ruSR2LBeBpmFGJsNM3yxDjXUCwDrOEcULIQnIImLR99sr8I5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMLjojmj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMLjojmj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784078726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IsvswVfYoyusYXMLMx2fiSiHKgoP07k7egLqvGzTRX8=;
	b=FMLjojmjaRdMg/EYEF6RrRWaFsyRtCfQoeaXnQwtolSNBzfXNw2reYW4PDRf6h5X6KxZpI
	LVd/TVkp/vYNIObY3TPXZCD7bmgh4vNqGD2BXT2h4iS34z9ZHSxz2be3AC09thwItk2yJW
	+dy5AXQ0+SJb3OxJRNuf67IE0L/kpIg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-lijdt0kLNzaSKyfhdOm0Aw-1; Tue,
 14 Jul 2026 21:25:21 -0400
X-MC-Unique: lijdt0kLNzaSKyfhdOm0Aw-1
X-Mimecast-MFC-AGG-ID: lijdt0kLNzaSKyfhdOm0Aw_1784078720
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10BE918005B6;
	Wed, 15 Jul 2026 01:25:20 +0000 (UTC)
Received: from [10.22.89.63] (unknown [10.22.89.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B37351800591;
	Wed, 15 Jul 2026 01:25:18 +0000 (UTC)
Message-ID: <5789e2ca-9490-4f3c-8dab-614a6167aaab@redhat.com>
Date: Tue, 14 Jul 2026 21:25:18 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/cgroup: Fix intermittent test_cgfreezer_ptrace
 test failures
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260714183125.521650-1-longman@redhat.com>
 <4ae04b8055b7145e182380a46f92c26e@kernel.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <4ae04b8055b7145e182380a46f92c26e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 7/14/26 6:09 PM, Tejun Heo wrote:
> Hello, Waiman.
>
>> +	usleep(1000);
>>   	if (cg_check_frozen(cgroup, true))
>>   		goto cleanup;
> A fixed 1ms sleep only hides the race. On a loaded machine or a slow arch
> (you mention ppc64) the refreeze can take longer than 1ms, and the test
> reads the unfrozen state and fails anyway.
>
> The freezer test already has a way to wait for this properly.
> cg_prepare_for_wait() sets up an inotify watch on cgroup.events and
> cg_wait_for() blocks until it changes. cg_enter_and_wait_for_frozen() shows
> the pattern: loop cg_wait_for() then cg_check_frozen(). The cgroup always
> ends up frozen, so looping until cg_check_frozen() reports frozen is
> reliable and doesn't depend on timing.
>
> Can you respin using that instead of usleep()?
>
> Also, temporaily -> temporarily, in both the changelog and the comment.
>
> Thanks.

Thanks for the suggestion. Will revise the patch as suggested.

Cheers,
Longman

