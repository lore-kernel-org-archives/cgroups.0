Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB80121638D
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 20:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782334638; cv=none; b=gW14lZSQuq9SV/OG0gt88X+HRG9peZRtJs8DHjgAk7TBixJzV10vrFLcuqSN/r69fSjnNk9ci8rTKk979GZI18ZoyykNHMxptUx9t0htFFa0+tZMTQaburiwDv6j1od/yimc0svylhi4IKvbITXQ/beAaM8fLe8lrnmW9dvvaRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782334638; c=relaxed/simple;
	bh=04VIXOksKkDx6Sq3RxhffV+Olp6ZzGcGctFUuOt9TiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=At3mGes2NXoM5BxJB54n11zRxCaWgjjX6nD2vKfdnPr8IceNjQSST97avbtgpQN0oxorrHgqwWYk8tqyVJnA3ekehXUJaWIBdYwvTDFDeABtIOsLlxkvnOYhIzAR+1STx6k6rf9yXzjm7a2kkoWQEtRnIu+Vb4XbqjczHuj5mnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZCVha9DC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZCVha9DC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782334636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMU3iG232OKcRHz+ruKPI8K5NJ5RGAsFaG+2rycxIsU=;
	b=ZCVha9DCGElxQa2Xh2Wn3HQXpIcPzF/vFr/NFKHYex/WRLd+1Eq6PJFpFDl3qtKXb3fTFH
	RkAENTKBme1TlpsKFZUW34ohgpWqAGh7VtWWGwOH4X0l8cHSmpOURfLAiFIWYHaG2+GaaY
	CVKyrfhUbl+CqBX8SV6Kr5wlymgDEvY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-A1jy18ZdOKSaZvGGK2Ei1Q-1; Wed,
 24 Jun 2026 16:56:04 -0400
X-MC-Unique: A1jy18ZdOKSaZvGGK2Ei1Q-1
X-Mimecast-MFC-AGG-ID: A1jy18ZdOKSaZvGGK2Ei1Q_1782334562
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D349C19560BE;
	Wed, 24 Jun 2026 20:56:01 +0000 (UTC)
Received: from [10.2.16.72] (unknown [10.2.16.72])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 149F11956094;
	Wed, 24 Jun 2026 20:55:58 +0000 (UTC)
Message-ID: <2bf8bb78-3da3-4d2d-9b1a-451214c1a50f@redhat.com>
Date: Wed, 24 Jun 2026 16:55:57 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] cgroup/cpuset: Miscellaneous fixes and cleanups
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Ridong Chen <ridong.chen@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260623230413.1984188-1-longman@redhat.com>
 <038bfbbc34714676b7a672b7f748aee4@kernel.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <038bfbbc34714676b7a672b7f748aee4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


On 6/24/26 3:47 PM, Tejun Heo wrote:
>> Waiman Long (2):
>>    cgroup/cpuset: Avoid unnecessary cpus & mems update in
>>      cpuset_hotplug_update_tasks()
>>    cgroup/cpuset: Rebind/migrate mm only for threadgroup leader in
>>      cpuset_update_tasks_nodemask()
> Applied 1-2 to cgroup/for-7.3. I folded in a few minor fixups: a
> changelog typo, the compute_effective_nodemask() kerneldoc parameter
> name (new_cpus to new_mems), and the comment and doc grammar nits Manuel
> noted. Also added Ridong's Reviewed-by to patch 1.

Thanks for the fixups.

Cheers,
Longman

