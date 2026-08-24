Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1893DDDDA
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581104; cv=none; b=CAwES6Pq/9WDUfQyFCjZZElyEUmsrbFlB+278k7MXC35kNEpyFCIOq5MibPPRejuLZKVvnsHFyXjA2tsEIYoL0iFQp0lEHgmiqjCmqq7IwWAcuYqAfsLDvfiASfxh8uc2x7VKKv5OtPzlnVeIYBXqu3KuVtPdyq84qynon2ggpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581104; c=relaxed/simple;
	bh=l4PTOfxbRvUmPVCGXVpPh5Ds3L87oq4jzyuSsTgRMRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYge94oICNIkTEujEO6n64EV+Pp0BCjoOxNExfGP0VO9Dd2s0o0NrLOiZVVrdrZcxLA+WP2tuLGouzC7+xlyWS76xGCnsCjiY8kq5R667VPG7kWds8IyBcSsZjZpi67+Z646/aRPoXjOtV29ZOlnmyU6Ay2QUQ5dz+Q04pWCB9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S9G0vbCl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S9G0vbCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787581101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cHjkp5gkTrq47muPSzRETAaXl4TiwGDEwj6J9nUEvjE=;
	b=S9G0vbClmgvgKRTs1ozxeRhAyyn2zrhd3O17CHYBq9ni3jbPvBM8oUwf88htfWSSJt3Ngl
	uFiDKXYHTh6z5phtzO5LBMgCYWgwz+hpw2691fUO58qHqNVXpm6gXqc2o9vy2cNGtVyxdh
	04Z58rGXVX2EMFVhPoN6yvGhRwJV6Yo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-4DvsuhbnM0uzrF1B52B-kQ-1; Mon,
 24 Aug 2026 10:18:15 -0400
X-MC-Unique: 4DvsuhbnM0uzrF1B52B-kQ-1
X-Mimecast-MFC-AGG-ID: 4DvsuhbnM0uzrF1B52B-kQ_1787581093
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA1B619772C2;
	Mon, 24 Aug 2026 14:18:12 +0000 (UTC)
Received: from [100.91.18.181] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B069A1955F09;
	Mon, 24 Aug 2026 14:18:10 +0000 (UTC)
Message-ID: <9a81a131-0e2c-480f-95db-1a4919ee2e15@redhat.com>
Date: Mon, 24 Aug 2026 10:18:09 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/cgroup: Add test for preserving
 boot-isolated CPUs
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260824020140.21130-1-guopeng.zhang@linux.dev>
 <20260824020140.21130-4-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260824020140.21130-4-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 8/23/26 10:01 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> Put a CPU isolated at boot into an isolated partition, change the
> partition back to member and check that the CPU remains isolated.
>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   .../selftests/cgroup/test_cpuset_prs.sh       | 58 +++++++++++++++++++
>   1 file changed, 58 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index fdb3185570d4..131d8b4551ef 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -1155,6 +1155,63 @@ test_isolated()
>   	pause 0.05
>   }
>   
> +#
> +# Select an online CPU isolated from scheduler domains at boot.
> +# $1: test name used in the skip message
> +#
> +get_boot_isolated_cpu()
> +{
> +	TEST_NAME=$1
> +	BOOT_ISOLATED_FILE=/sys/devices/system/cpu/isolated
> +
> +	[[ -r $BOOT_ISOLATED_FILE ]] || {
> +		echo "$TEST_NAME test SKIPPED: boot isolation state unavailable"
> +		return 1
> +	}
> +	BOOT_CPUS=$(cat $BOOT_ISOLATED_FILE)
> +	[[ -n "$BOOT_CPUS" ]] || {
> +		echo "$TEST_NAME test SKIPPED: no boot-isolated CPU"
> +		return 1
> +	}
> +
> +	BOOT_CPU=$(echo "$BOOT_CPUS" | sed -e 's/[,-].*//')
> +	CPU_ONLINE=/sys/devices/system/cpu/cpu${BOOT_CPU}/online
> +	[[ ! -e $CPU_ONLINE || $(cat $CPU_ONLINE) -eq 1 ]] || {
> +		echo "$TEST_NAME test SKIPPED: CPU $BOOT_CPU is offline"
> +		return 1
> +	}
> +}
> +
> +#
> +# A CPU isolated at boot must stay isolated after it is released by a dynamic
> +# isolated partition.
> +#
> +test_boot_isolated()
> +{
> +	TEST_NAME="Boot-isolated CPU partition release"
> +	get_boot_isolated_cpu "$TEST_NAME" || return 0
> +	echo "Running $TEST_NAME test ..."
> +
> +	cd $CGROUP2/test
> +	echo member > cpuset.cpus.partition
> +	echo $BOOT_CPU > cpuset.cpus
> +	[[ $(cat cpuset.cpus.effective) = "$BOOT_CPU" ]] || {
> +		echo "$TEST_NAME test SKIPPED: CPU $BOOT_CPU is unavailable"
> +		echo "" > cpuset.cpus
> +		cd $CGROUP2
> +		return 0
> +	}
> +	test_partition isolated
> +	test_partition member
> +	check_isolcpus "." || {
> +		echo "Boot-isolated CPU $BOOT_CPU was lost after partition release"
> +		exit 1
> +	}
> +	echo "" > cpuset.cpus
> +	cd $CGROUP2
> +	echo "$TEST_NAME test PASSED."
> +}
> +
>   #
>   # Wait for inotify event for the given file and read it
>   # $1: cgroup file to wait for
> @@ -1226,5 +1283,6 @@ trap cleanup 0 2 3 6
>   run_state_test TEST_MATRIX
>   run_remote_state_test REMOTE_TEST_MATRIX
>   test_isolated
> +test_boot_isolated
>   test_inotify
>   echo "All tests PASSED."
Reviewed-by: Waiman Long <longman@redhat.com>

