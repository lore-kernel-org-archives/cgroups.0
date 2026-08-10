Received: from out-171.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFA6356762
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 03:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786331261; cv=none; b=ufixsolAsWb+Dvv4FBk3KdUL9nB38UHQnk5y9gFHniAi/yIKTerJfG064MsclgUjAVs2bAwePAIVRhUqcFSYLiSPMXAZ8Uqdo5eLso9BPpAQg7oc47+YmUgWrFJw/sBXqVzOhSXQmJzZEBK/VnXmUysqPeGq/LhdMP9v09Ibd7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786331261; c=relaxed/simple;
	bh=+RsgpMp9YhI5qE4OtlGKLdupHUj6YaWI99WnpPeb2RY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bOZKHS2skLOp1YFnkeqgTakMTZPRblkVMMANmpTBB/iyEGU2sULN+GwtqMeKJdVCWW2cu8CalbuAyKKi/aDgC0Cl4oXnySSHtJjvKAqqVZ5o0JvvQfjoJps/Mpj4g2X0L9aMX7hrxf3lJLkMC0TIZbMnr8ks9Bc7JDoe+3YiUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HsCPcdGq; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HsCPcdGq"
Message-ID: <7eb471c1-e30c-48cf-8639-28ecb5a17734@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786331257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/DSE2urStIQIpSbLrk51AXy14cPdEPeJYoXg5FqJJ4=;
	b=HsCPcdGqV2hYqsGnP7Xryf3GCatOVeNoAbYinuFeVfXqSCKjyMjWGTTg/Vf8zHx9pgewgc
	pwPll3qurSz16Q9CHYbR8Zyobctijl5V3MCe1brxp2YAIq3qSItQMoYBE/hJVLBsPJVOuQ
	ARjKEtUQJOnU3sRFazvcwtxJhyOWGSE=
Date: Mon, 10 Aug 2026 11:07:18 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] selftests/cgroup: Avoid awk -e in cpuset tests
To: Rui Qi <qirui.001@bytedance.com>, Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260809082111.3827531-1-qirui.001@bytedance.com>
 <20260809082111.3827531-2-qirui.001@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260809082111.3827531-2-qirui.001@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/9/2026 4:21 PM, Rui Qi wrote:
> The cpuset selftests use awk -e to parse cgroup mount points. This
> works with gawk, but mawk rejects the option. In test_cpuset_prs.sh,
> this leaves CGROUP2 empty and causes the test to skip as if cgroup v2
> were not mounted. The same non-portable invocation exists in the cpuset
> v1 hotplug test.
> 
> The scripts only need to pass a single awk program. Use the standard awk
> invocation without -e so mount point detection works with awk
> implementations that do not support the gawk extension.
> 
> Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
> Fixes: 812c5945bdb8 ("cgroup/cpuset: Add test_cpuset_v1_hp.sh")
> Signed-off-by: Rui Qi <qirui.001@bytedance.com>
> ---
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh   | 2 +-
>   tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 400a696a0d21..16c38eb11e63 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -20,7 +20,7 @@ skip_test() {
>   WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
>   
>   # Find cgroup v2 mount point
> -CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
> +CGROUP2=$(mount -t cgroup2 | head -1 | awk '{print $3}')
>   [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
>   SUBPARTS_CPUS=$CGROUP2/.__DEBUG__.cpuset.cpus.subpartitions
>   CPULIST=$(cat $CGROUP2/cpuset.cpus.effective)
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
> index 7406c24be1ac..da97f1643f9a 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
> @@ -14,7 +14,7 @@ skip_test() {
>   [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
>   
>   # Find cpuset v1 mount point
> -CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk -e '{print $3}')
> +CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk '{print $3}')
>   [[ -n "$CPUSET" ]] || skip_test "cpuset v1 mount point not found!"
>   
>   #

Looks good to me.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

