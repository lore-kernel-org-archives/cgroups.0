Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B46A48B386
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784130442; cv=none; b=PV3VVBwrGt6BwbcxcSMXeXhVQhM8t5lWJB5s3+HNX45yKvyPZdH8LIqA5PLOi6hSDMvNxR0y7EyVBBE1aE3M+d+g0VUQi0bQQFzwXC/mN7EzF2q/Tb+bRGA+/Wtd477xzo+vxGbmkoQoY0w7WHbg+M0jMb1AyXgiQCr2d+i1DFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784130442; c=relaxed/simple;
	bh=uXKii3249bwX7TaBdPYgYiFbDVsswYSDgNZHix3FQtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JF2wR3Aei8Qcqrs5s3ifZtyP92Vo2WymeapQZRBUV/EDSo+DnfKVEtx90hx8yY7mHcL7rMZzkBQpN/U86NRGQE46+ZXUupQ3xiXftaXgXxAuh9DKyoGTxgvDjUzdgeFoBGezgvuFeTY56dw3KgCn6VOQphrl/jGD0BLEuUJu4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AtwRaQ63; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AtwRaQ63"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784130438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=53ToRPoItWXCe4fnxBfQI8EvVQIHrJzVrRIqwgxe0z4=;
	b=AtwRaQ63DhKnCRRcEbGyVFFMvj3XFtSZU1giS9OqEcTzITJR6Y1da0Q/kt0NyyRHH8KCRE
	YtPlq5muUmKVa5oygfCZxTXbKA7F53hFaImXq3LTzAzdc4G5OMegkDZPlotysBuauZTpsX
	bjGADr9hcuzU6Iiyx3huQe90TXDzl5w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-8l_y5NGxPuyK0asBHJIthA-1; Wed,
 15 Jul 2026 11:47:14 -0400
X-MC-Unique: 8l_y5NGxPuyK0asBHJIthA-1
X-Mimecast-MFC-AGG-ID: 8l_y5NGxPuyK0asBHJIthA_1784130433
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD8981955F2C;
	Wed, 15 Jul 2026 15:47:12 +0000 (UTC)
Received: from [10.22.89.72] (unknown [10.22.89.72])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7E711800347;
	Wed, 15 Jul 2026 15:47:11 +0000 (UTC)
Message-ID: <47ae1970-b7a7-478d-b0d0-2110428c2ee3@redhat.com>
Date: Wed, 15 Jul 2026 11:47:10 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/cgroup: Fix intermittent
 test_cgfreezer_ptrace test failures
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260715035446.565625-1-longman@redhat.com>
 <aldSsQAboD6g2Sso@localhost.localdomain>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <aldSsQAboD6g2Sso@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


On 7/15/26 5:36 AM, Michal Koutný wrote:
> Hi.
>
> On Tue, Jul 14, 2026 at 11:54:46PM -0400, Waiman Long <longman@redhat.com> wrote:
>> It is found that the test_cgfreezer_ptrace test of test_freezer can
>> intermittently fail on some architectures like arm64 and ppc64.
>>
>> After further tracing of the mechanics of the test_cgfreezer_ptrace test,
>> it is found that the ptrace(PTRACE_DETACH) call will spawn another process
>> to perform the detach
> I'm reading kernel/ptrace.c and cannot find a new task creation.
> I'm curious what is this "another process"?
I should be more clear about that. It is not exec'ing a new binary. It 
is just spawning a child process/thread which still has the same name 
but different pid as well as running on a different CPU which are what I 
am tracking.
>
> (Or is it referring to the child_fn() process from
> test_cgfreezer_ptrace()? Then I'm suspicous about the transitional
> unfreezing of it after PTRACE_DETACH. Wasn't it rightful expectation of
> the test that the cgroup remains contiguously frozen?)

As said in my reply to the v1 thread, the detaching process includes a 
call to ptrace_stop() which will unfreeze the cgroup temporarily and 
then go back to frozen afterward. It is this transitional 
unfreeze/freeze that may cause the test to fail if it detects the 
transitional non-frozen state. My patch is to make sure that it can see 
the final the frozen state and avoid reporting failure.

Cheers,
Longman

>
>> by temporarily unfreezes the cgroup and then freezes
>> it again afterward during the detaching process. The reading of the
>> frozen flag from cgroup.events is done by the main test_freezer process
>> running probably on a different CPU. As a result, racing is possible and
>> the intermediate unfrozen state can be read leading to occasional test
>> failures especially on architectures with a weak memory model like arm64.
> What state would the task be in during this window?
>
> Thanks,
> Michal

