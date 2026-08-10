Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEC23546E2
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 03:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786332155; cv=none; b=A4RvI4rKVcjw5hUjyX9lodjY2IhEj9w3Q5wPyYhX9V+v7LkSIU3e8ZlNO1lQQ6gUyVIPLh1VDKKUugoeVQYqrW4AdwHm/Iv0JX5QIRqIGTCPLbSlvH4Jxsmm/fC2qBsxXYlL7KcXJqGfBznw+eIF3bai4BIhtLIE4IDUeytL6Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786332155; c=relaxed/simple;
	bh=eS6Wsn3XGvqPzcyKo1bop3nIFNKEEsspEPQc2FIbYas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qeJX9IEXEruBQsbExehD5GMUKTM5F8HuGR3WEBgLehwSuH5A2sRKdew051wZLhlTAj6MHA8R24uZ9l0oApxaRMH9qLM9B1jtjbB11NfTmv9DBIyS5ZDzpTBwm5OCm4MXUqAPzIFtPs8H50FTTlDT6oYpzcslvdRoJ+g5KkY2PGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YiXxB3XI; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YiXxB3XI"
Message-ID: <be900e96-7bfa-48ed-94b1-8c96e2396cd1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786332151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA8FZ75BLt1WHizu9gDg8oamQXrNVDgymrMxqjah/hE=;
	b=YiXxB3XI+eEAyP5xgfoYHxPnNTxT6kJeDHROCkbLYbmiKMMyz2kbdnlGKwqX9ScJAaQ2Vx
	TdMX9c6gLoRtgKp6tya451VVODIqyKPK2VBnWyLVP+Q4ALyonj3y584r/X4aHpvZa97hUr
	eYCFj2Bz7iq1HLFvdR5Qhx176o0ghRQ=
Date: Mon, 10 Aug 2026 11:22:25 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] selftests/cgroup: Preserve CPU hotplug write errors
To: Rui Qi <qirui.001@bytedance.com>, Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260809082111.3827531-1-qirui.001@bytedance.com>
 <20260809082111.3827531-3-qirui.001@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260809082111.3827531-3-qirui.001@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/9/2026 4:21 PM, Rui Qi wrote:
> The cpuset partition root state selftest checks several CPU hotplug
> transitions. If writing to a CPU online file fails, the helper still
> runs pause afterwards and returns the status of pause instead of the
> failed write.
> 
> This hides the real hotplug failure and can make later checks run
> against expectations for a transition that never happened. Move the
> write before the bookkeeping and return when it fails, so callers can
> observe the hotplug error and the test does not record a CPU as offline
> unless the offline operation actually succeeded.
> 
> Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
> Signed-off-by: Rui Qi <qirui.001@bytedance.com>
> ---
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 16c38eb11e63..a2f7208633bc 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -412,6 +412,7 @@ write_cpu_online()
>   	CPU=${1%=*}
>   	VAL=${1#*=}
>   	CPUFILE=//sys/devices/system/cpu/cpu${CPU}/online
> +	echo $VAL > $CPUFILE || return 1
>   	if [[ $VAL -eq 0 ]]
>   	then
>   		OFFLINE_CPUS="$OFFLINE_CPUS $CPU"
> @@ -421,7 +422,6 @@ write_cpu_online()
>   					sort | uniq -u)
>   		}
>   	fi
> -	echo $VAL > $CPUFILE
>   	pause 0.05
>   }
>   
> @@ -493,6 +493,7 @@ set_ctrl_state()
>   			eval $COMM $REDIRECT
>   			;;
>   		    O*) VAL=${CMD#?}
> +			COMM="write_cpu_online $VAL"
>   			write_cpu_online $VAL
>   			;;
>   		    T*) COMM="echo 0 > $TFILE"

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

