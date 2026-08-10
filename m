Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA3941612A
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373638; cv=none; b=l6coSodAzHrFkH5xyHlThcHth/VG+LZ9P49TdHf/Fpi2h91PoUYj+uED8n3ui7YRGf2CB76A3NagMW6j8RDgklm3ZMQriZWV8DDwOra7N4JpoTmFNii0mhTSHr9oy0FnDnhVffztP1NrCpTlLAjATSmU6C/6sSio8rBlteLqsyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373638; c=relaxed/simple;
	bh=v+hWlRb/+2ON5x+WLGELLJ58XLHiL6oW14FeOg5Rr6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X81gDPod/wb7ZWWnsXwO8eTrt+87+IgLVj5OhQYlMUmnamBUShLPFP8yalxFY/21XFXIlVUVdUJofMICicHVVUDzPykYoeDCGqlBxRdGfU1nsv/YBS6Rs+IQZhqrYlkTQdYjBQh2bZcStDrNxIEJ44WurE+ZVfktihcIFtS9AlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFWqtpZw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFWqtpZw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rae3SwcibOQ9VkUJPLO5/hVfp6x6hrWcHH6YJPE5fhE=;
	b=HFWqtpZwn9+8vFgeOSV6PQ5cg8s4K6KqsKowMPXwZdyDmhaBK7BK+9IFzKF4YOZ2s+gDwG
	QLeh1rpo82A444pT6KYg2ulHt8pDv32lXkGwbEeVw64uslD+4aDMW9xmzRSL35Sp7nU9yc
	Kst/fQB5BPL6y0VMVIPm//awAu1gcMk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-zGtsHuKMMEeN6SuTaS29hQ-1; Mon,
 10 Aug 2026 10:53:51 -0400
X-MC-Unique: zGtsHuKMMEeN6SuTaS29hQ-1
X-Mimecast-MFC-AGG-ID: zGtsHuKMMEeN6SuTaS29hQ_1786373630
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E992E1800643;
	Mon, 10 Aug 2026 14:53:49 +0000 (UTC)
Received: from [10.22.80.220] (unknown [10.22.80.220])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3DE4D1800348;
	Mon, 10 Aug 2026 14:53:48 +0000 (UTC)
Message-ID: <1ddd2e4a-ef12-4e9d-b589-28ddb4f46fb3@redhat.com>
Date: Mon, 10 Aug 2026 10:53:47 -0400
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
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260809082111.3827531-3-qirui.001@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 8/9/26 4:21 AM, Rui Qi wrote:
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

I am aware that on x86-64, cpu0/online may not exist. Other than that, 
under what condition will the write fail as only root is allowed to run 
the script?

Cheers,
Longman

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

