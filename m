Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D1B2580F3
	for <cgroups@vger.kernel.org>; Sun, 11 Oct 2026 09:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791709252; cv=none; b=mTSIuWB6mzupPsFNN25wusKZ09znD9OJps9/miUCsOnp8829wZ1hNd0pUUiN3tQxngtTvJ6QGJXoXcHD77/F3x5x3WGhrL/Ib9hPXo3BmXc8TH27mfd+/9Uecnb7ivxYy8jWE1qYRi7vizrPaLyLbD8bUf9aGvj/Pc0Zvh06v9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791709252; c=relaxed/simple;
	bh=GimW/7CEFiCKhboqu/b2eNEnPKN7mF5y4AbHMtDQ22M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e8Ghyy3R+93v5jvTDkCoLauo3YM67cM+x70/TU/l7CalMFneGWjahUHYsC6BwPHbdsXfgLvLS+CTrHey3l8cniIiUlCTaBKLNsGWM9N+wjIZ5XmiUA3R8U2Da2khAYNxWUJye8MYpIO0E22Hm9UWImYKeACpHq4Jc8ZPDPr1W78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mPmzsYf6; arc=none smtp.client-ip=91.218.175.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mPmzsYf6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GimW/7CEFiCKhboqu/b2eNEnPKN7mF5y4AbHMtDQ22M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791709247; v=1; x=1792314047;
 b=mPmzsYf6hDDkgKhWIKSa8wOGvFEeQBqWOUsPWH/Ul22mVh7IJUHCHmucFV6bx8+NMcUhX4tM
 ntnKjErmS+0DOE/ooI6rTw3TRHyqnH3m45aHBSCbzc1NLcVFAOVwJ7yq61al9ia290gt6iKPObC
 4Evp5h0Dc/aG+++M7CnQ/twQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0b271059adb7be95;
	Sun, 11 Oct 2026 09:00:47 +0000
X-Mizu-Trace-ID: 0b271059adb7be95
X-Migadu-Flow: FLOW_OUT
Message-ID: <27675c88-061c-4f84-9387-324071a16b45@linux.dev>
Date: Sun, 11 Oct 2026 17:00:37 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 6/6] selftests/cgroup: Skip test_cpuset_prs.sh
 test if some required CPUs are offline
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>
References: <20261010221938.243859-1-longman@redhat.com>
 <20261010221938.243859-7-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261010221938.243859-7-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/11 06:19, Waiman Long 写道:
> The test_cpuset_prs.sh test assumes that all the relevant CPUs being
> tested are online. If some of them are offline, some of the test cases
> may fail. So skip the test if the required CPUs are either offline or
> not present.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  .../selftests/cgroup/test_cpuset_prs.sh       | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 3d392e8c66aa..f57971ebb90e 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -118,6 +118,26 @@ TEST_ISOLCPUS=
>  		skip_test "Current isolated CPUs ($CURRENT_ISOLCPUS) don't match boot isolated CPUs!"
>  }
>  
> +#
> +# This test assumes that all the relevant CPUs being tested are online.
> +# If some of them are offline, some of the tests may fail. So we are going to
> +# skip running this test script if some of the required CPUs may be offline.
> +# The required CPUs include CPUs 0-7 and the first boot time isolated CPU if
> +# present. However the check below is not exhaustive and can be a false
> +# positive, but users should not run this test if some CPUs are offline.
> +#
> +ONLINE_CPUS=$(cat /sys/devices/system/cpu/online | sed -e "s/,.*//")
> +ONLINE_FIRST=$(echo $ONLINE_CPUS | sed -e "s/-.*//")
> +ONLINE_LAST=$(echo $ONLINE_CPUS | sed -e "s/.*-//")
> +if [[ -n "$FIRST_ISOLCPUS" ]]
> +then
> +	LAST_REQUIRED_CPU=$FIRST_ISOLCPUS
> +else
> +	LAST_REQUIRED_CPU=7
> +fi
> +[[ $ONLINE_FIRST != 0 || $ONLINE_LAST -lt $LAST_REQUIRED_CPU ]] &&
> +	skip_test "Some of the required CPUs are offline or not present!"
> +

Could this check run before the setup that creates the test cgroup and
changes sched/verbose?

skip_test() exits directly, and the cleanup trap hasn't been installed
here. We have already created test; with -v, sched/verbose has also been
set to Y. This exit leaves the cgroup behind and bypasses restoring
verbose.

Thanks,
Guopeng
>  cleanup()
>  {
>  	online_cpus

