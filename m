Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642B0387348
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642800; cv=none; b=fKPHyAUpQN37v955TshOvV9VB8C/jlu9zYKAPpu2JnjJec/551solBYR8Kp/Qi8kisUqRwkxj6v7WzQPcpz9WvlOuuDexvl6FeU+nHYm+z6oGyCugfrsuApMje77hB9urk23WD6hZ5arDX8wrjdEKHrrvpPBBS3qZmjKkhLJPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642800; c=relaxed/simple;
	bh=TMyVY2Yjtx2vzXBqZP98/9o4YPOopQg7n6FlQVMtaE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jeb7lyxdfoTokfgwQ1X8UXkSoIUyly7mSUGMc+D6PEND9jxBM/49EPO7Sx6ymUcz1j+ffnLlDnGToc83oEp5NDN4WPTrrM6CebzNAXbH+wEYyLwBgyj4Jjb5hVDGZhm78tFN1DngUbHBGU1ZQiBsRY7v/A8UeWoKEwZTTbCHyzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W+B0WKJH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W+B0WKJH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786642797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tf4bBsiUF4uMHfT/1INPqkz0hIrJY4UyX/JZyBTN9hs=;
	b=W+B0WKJHd7Spi8xoboopg1WKE1k+MEqSmx+poqfSkrJ7ippNc/sDDVoovp8TOOuzY/nJqW
	pXMrlyC4JOJ6+qaKtO/MukGjvJ8FclVAfFqHkQUBnu75EmqxSIOkBLKB76g0u0zCGJdn2D
	haCnIL+5J6mjWJstkuET1NgG+AE5r7A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84--VWWd4S2Mi2PPrXHBoWNRw-1; Thu,
 13 Aug 2026 13:39:55 -0400
X-MC-Unique: -VWWd4S2Mi2PPrXHBoWNRw-1
X-Mimecast-MFC-AGG-ID: -VWWd4S2Mi2PPrXHBoWNRw_1786642794
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6CC5195609E;
	Thu, 13 Aug 2026 17:39:53 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25018195DF98;
	Thu, 13 Aug 2026 17:39:52 +0000 (UTC)
Message-ID: <5cb4fef8-536e-4124-9678-0cafe1aa1228@redhat.com>
Date: Thu, 13 Aug 2026 13:39:51 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/cgroup: Preserve CPU hotplug write errors
To: Rui Qi <qirui.001@bytedance.com>, Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260809082111.3827531-1-qirui.001@bytedance.com>
 <20260809082111.3827531-3-qirui.001@bytedance.com>
 <1ddd2e4a-ef12-4e9d-b589-28ddb4f46fb3@redhat.com>
 <45c558ac-8397-46a7-b3c9-755f272be685@bytedance.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <45c558ac-8397-46a7-b3c9-755f272be685@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


On 8/10/26 11:25 PM, Rui Qi wrote:
> On 8/10/26 10:53 PM, Waiman Long wrote:
>> On 8/9/26 4:21 AM, Rui Qi wrote:
>>> The cpuset partition root state selftest checks several CPU hotplug
>>> transitions. If writing to a CPU online file fails, the helper still
>>> runs pause afterwards and returns the status of pause instead of the
>>> failed write.
>>>
>>> This hides the real hotplug failure and can make later checks run
>>> against expectations for a transition that never happened. Move the
>>> write before the bookkeeping and return when it fails, so callers can
>>> observe the hotplug error and the test does not record a CPU as offline
>>> unless the offline operation actually succeeded.
>>>
>>> Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
>>> Signed-off-by: Rui Qi <qirui.001@bytedance.com>
>> I am aware that on x86-64, cpu0/online may not exist. Other than that,
>> under what condition will the write fail as only root is allowed to run
>> the script?
>>
>> Cheers,
>> Longman
> Hi Longman,
>
> Right, the failure I wanted to preserve is not the normal permission
> case. Running as root only gets us past the sysfs file permission check;
> the write can still fail in the CPU hotplug path.
>
> For example, cpu_down() can return -EBUSY when trying to offline the last
> online CPU, when CPU hotplug is temporarily disabled, or when offlining
> would leave no housekeeping CPU. cpu_up() can also fail if the CPU is not
> possible/present, if hotplug is disabled, or if the CPU is not bootable
> under the current SMT control state. Arch or registered cpuhp callbacks
> may also reject the transition and return an error.
>
> The current helper hides all of those cases because it does the write and
> then calls pause(), so the function returns the status of pause rather
> than the failed sysfs write. It also updates OFFLINE_CPUS before knowing
> whether the offline request succeeded. So this change is mainly to avoid
> continuing the test with bookkeeping that says a CPU was offlined when the
> kernel actually rejected the hotplug operation.

Thank for the clarification. You are right that cpu_down() can be 
blocked in the hotplug path. That should rarely happen, but I agree that 
we catch that special case too.

Cheers,
Longman

>
> Thanks,
> Rui
>
>>> ---
>>>    tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>>> index 16c38eb11e63..a2f7208633bc 100755
>>> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>>> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
>>> @@ -412,6 +412,7 @@ write_cpu_online()
>>>    	CPU=${1%=*}
>>>    	VAL=${1#*=}
>>>    	CPUFILE=//sys/devices/system/cpu/cpu${CPU}/online
>>> +	echo $VAL > $CPUFILE || return 1
>>>    	if [[ $VAL -eq 0 ]]
>>>    	then
>>>    		OFFLINE_CPUS="$OFFLINE_CPUS $CPU"
>>> @@ -421,7 +422,6 @@ write_cpu_online()
>>>    					sort | uniq -u)
>>>    		}
>>>    	fi
>>> -	echo $VAL > $CPUFILE
>>>    	pause 0.05
>>>    }
>>>    
>>> @@ -493,6 +493,7 @@ set_ctrl_state()
>>>    			eval $COMM $REDIRECT
>>>    			;;
>>>    		    O*) VAL=${CMD#?}
>>> +			COMM="write_cpu_online $VAL"
>>>    			write_cpu_online $VAL
>>>    			;;
>>>    		    T*) COMM="echo 0 > $TFILE"

