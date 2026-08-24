Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF762F7F07
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 03:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787541824; cv=none; b=OpGzPqA5ovqdEeu+7XzIncm6WAufVC+ONfLsjU7DQ7Sk2MfJILmdnkDeGq+GW/adEzXyvg4By3aQDuDuxMeoqeW2bbGKheg0eeYsgeChu1YkMzu+3J2PN8L+SDelGlilk4l+FZToosya8k9jo4WL3SEIU1DMIzp0j7Fur0Cgxaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787541824; c=relaxed/simple;
	bh=zSzxzmyO/fbt5TXO5SH7GheeONpcTwtNS2YgN0J1KMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F5ZS/vkllThz9lHwczdHzKgOlw4Ej4eEePWtgOLGmIbmv/WRa9X1A3FVsleHdF8CgtPuS0pe7DrqgG3KJFIFT4J74sVV1LzQhLiqySuCPidGdR7UW/fibQRLytePKOUx4nOXad+Yop9fWyxNzdV5iqlqdZU7nOUHc5GxXZNAVZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BTbSP6jL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTbSP6jL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787541822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dx3iauYGB2wh5SOGuiI8wNYp9ILiPQCebTLiJWu4GvA=;
	b=BTbSP6jL0OVTZrFWqiGVv+s234yKe2LcoujdgAx8zuhxn5sLCoOlXD1VkXJgX14b7HAp/i
	wz+WQCDFdqWGs8sjfcEtF2yrJlBB88lkhCIOvaU2HnMXyQgilzujTfCFC9FcriFoQHpTDx
	+fV27xM8JfJcA5d6Y4dMdvP7wT8dKDQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-fkp6jIw4MDKbEi1xftEUbQ-1; Sun,
 23 Aug 2026 23:23:38 -0400
X-MC-Unique: fkp6jIw4MDKbEi1xftEUbQ-1
X-Mimecast-MFC-AGG-ID: fkp6jIw4MDKbEi1xftEUbQ_1787541816
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04251195C24D;
	Mon, 24 Aug 2026 03:23:36 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 09CB018005BB;
	Mon, 24 Aug 2026 03:23:33 +0000 (UTC)
Message-ID: <69a0e8e7-199f-4e99-aa21-0c888680a037@redhat.com>
Date: Sun, 23 Aug 2026 23:23:32 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] selftests/cgroup: Drop invalid boot isolation
 comparison
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260824020140.21130-1-guopeng.zhang@linux.dev>
 <20260824020140.21130-2-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260824020140.21130-2-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On 8/23/26 10:01 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> check_isolcpus() clears ISOLCPUS before rebuilding it from sched domain
> data. Comparing that empty value with
> /sys/devices/system/cpu/isolated makes the test fail whenever
> isolcpus=domain is present.
>
> That sysfs file is generated from HK_TYPE_DOMAIN_BOOT and does not change
> when cpuset updates HK_TYPE_DOMAIN. Re-reading it cannot validate dynamic
> housekeeping updates. The cpuset.cpus.isolated and sched domain checks
> already cover the two dynamic interfaces, so remove the invalid comparison.
>
> This can be reproduced on a kernel booted with isolcpus=domain,15:
>
>      # tools/testing/selftests/cgroup/test_cpuset_prs.sh
>
> The test fails its first state-matrix isolation check before the change and
> continues past that check afterward.
>
> Fixes: 6df415aa46ec ("cgroup/cpuset: Defer housekeeping_update() calls from CPU hotplug to workqueue")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index da8f7b920178..fdb3185570d4 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -797,7 +797,6 @@ check_isolcpus()
>   	EXPECTED_ISOLCPUS=$1
>   	ISCPUS=${CGROUP2}/cpuset.cpus.isolated
>   	ISOLCPUS=$(cat $ISCPUS)
> -	HKICPUS=$(cat /sys/devices/system/cpu/isolated)
>   	LASTISOLCPU=
>   	SCHED_DOMAINS=/sys/kernel/debug/sched/domains
>   	if [[ $EXPECTED_ISOLCPUS = . ]]
> @@ -835,11 +834,6 @@ check_isolcpus()
>   	ISOLCPUS=
>   	EXPECTED_ISOLCPUS=$EXPECTED_SDOMAIN
>   
> -	#
> -	# The inverse of HK_TYPE_DOMAIN cpumask in $HKICPUS should match $ISOLCPUS
> -	#
> -	[[ "$ISOLCPUS" != "$HKICPUS" ]] && return 1
> -
>   	#
>   	# Use the sched domain in debugfs to check isolated CPUs, if available
>   	#

The /sys/devices/system/cpu/isolated had recently be changed to report 
the boot time isolcpus=domain value. So the check is no longer valid and 
should be removed. Of course the position of the check is also 
problematic. So it should be removed.

Reviewed-by: Waiman Long <longman@redhat.com>

