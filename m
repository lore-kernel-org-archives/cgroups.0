Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792678171;
	b=mkCODIojvTmj6TY6QcLkigI3JUxN4pTND8Pn1oOZvE0QUKeBB6N3LaqkUA4g8Da8fM7s
	 1lcUtJ06Ue4WjCNR0w03WtKIo+yGa+XGDyi9MeLGtD0l0QOghT4cWAXoc9C9zaKt7//kn
	 3a+Ksrr7oJ2eGUPd+OmUSnscZkQ1xtAwiLjim8pWPmVxp/NuZiB4/wC8yThsViCJ/cboG
	 d26993cf9mRXZdG45e0i3M+GSH9nYFhUuAyZP6xCCIMXBAH995mqY35QwWqyCQMBSZin4
	 b6fI/RF2KuXzZ2j+KSuofEa9Z1Xzlrp0f7aiLCS6DDDubcna4pZ70TMbJ1f47Tk67VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792678171;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=G8eBv0gpB33N8/cz2LgEKMiVTAe8ZtCvm6RFrTr54RM=;
	b=HLf01L6pbURauyYDY9A72FhFgkRqoVDAzyL1nVrWHbKtv4GAlg2qbmmPJux425mWNQmC
	 tTDu0yxja/pYcDOp6wtyhvM0OZLuDREIRlgt0ctSsNnAbPetB1Pt5mJPhhjIwod28dGmV
	 ifcD95w9o6RAuVnpijGg8wl9VZmPGvHJY1/uR7qP2o2m5vr5W3mYWZCKZsCB0corH8zAs
	 irXi/hXPJ6wqIOe9PGBG8+FoLWRvo59TUI6V7J8d40onuotkm6CeoKNGVWQSa2fjKo0Of
	 7EwMjzkObhmcsgeSRsZ3ccCTvAk/uCmSP3zQ0oTvsuLMw2hf+f8qgxUnUicdZ+4gUsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Hv92zd/J";
	arc=none smtp.remote-ip=95.215.58.91
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895B5606A320
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 14:09:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 895B5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Hv92zd/J
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Fe7CT5c1Ji9lA2b4bgotlaNbgskgySBfznXCQQ0tVCc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792678167; v=1; x=1793282967;
 b=Hv92zd/JCUl7Q6QlHGeg8nuHLSKzfKb5rKXAopyT+ek58R+A7TBAkzSSyTnLv550tVnh4weN
 UizRQ0KDDeisagPi2CQYj7/rZfnVi31AU1mplxaHnhhCeiQ6lvsnvzUwJGwNXztuGp9eTKny2HR
 /K3Ut3reD6P2wzIHX8yb031k=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ee1a4f980c0ce69a;
	Thu, 22 Oct 2026 14:09:27 +0000
X-Mizu-Trace-ID: ee1a4f980c0ce69a
X-Migadu-Flow: FLOW_OUT
Message-ID: <553cb756-de36-4015-ad13-0c260dec675e@linux.dev>
Date: Thu, 22 Oct 2026 22:09:23 +0800
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
Subject: Re: [PATCH-next 5/6] selftests/cgroup: Check for a single range
 nohz_full CPUs before running test matrix
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261022031643.1351877-1-longman@redhat.com>
 <20261022031643.1351877-6-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261022031643.1351877-6-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/22 11:16, Waiman Long 写道:
> Commit 989ca25c10ca ("selftests/cgroup: Add tests for nohz_full
> housekeeping check") adds a nohz_full test matrix that will only be run
> when a nohz_full boot parameter cover all the CPUs beyond CPUs 0-7. The
> code looks for the first and last CPU numbers in the nohz_full sysfs
> file to determine if that criterion is met. However if there are holes in
> the range (i.e. has ",") the test matrix may be incorrectly run leading
> to unexpected test failure. Fix that by skipping "," and anything after
> that to make sure the first range will cover all the remaining CPUs.
> 
> Fixes: 989ca25c10ca ("selftests/cgroup: Add tests for nohz_full housekeeping check")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 8595b6b4b7bf..5bc144836bdf 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -111,9 +111,9 @@ echo "" > test/cpuset.cpus
>  #
>  # If nohz_full CPUs have been reserved at boot time, they should not include
>  # CPUs 0-7 as that may fail some of the test cases. On the other hand if the
> -# set of nohz_full CPUs includes all the CPUs except 0-7, we can run a special
> -# set of housekeeping CPUs exhaustion tests to see if the cpuset code will
> -# reject them.
> +# set of nohz_full CPUs includes all the CPUs except 0-7 in a single range
> +# <first>-<last>, we can run a special set of housekeeping CPUs exhaustion
> +# tests to see if the cpuset code will reject them.
>  #
>  FIRST_NOHZ_FULL_CPU=
>  LAST_NOHZ_FULL_CPU=
> @@ -124,7 +124,7 @@ NOHZ_FULL_CPUS=
>  LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
>  [[ -n "$NOHZ_FULL_CPUS" ]] && {
>  	FIRST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/[,-].*//")
> -	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/.*[,-]//")
> +	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/,.*//;s/.*[-]//")
>  	echo "Boot nohz_full CPUs: $NOHZ_FULL_CPUS"
>  }
>  [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" -le 7 ]] &&

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
