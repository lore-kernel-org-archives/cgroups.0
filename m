Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA11E367B72
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 02:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117300; cv=none; b=VFNQ+L2F6RdUNkRPfIZmvWlBKMSgNYGh6tkfgjHRuXVzfBW9y8nbQHS8d+LEKR3q2ZrPcBQwa8G6vbVbAckXDDRl52TqLuB3WJeM3B4sUDcbGOtuLnLEjuX/yw3Uzoqy5Wuyw3NSEIlrS/vU83eEZFQb6PT9FZzw4WenA4l51qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117300; c=relaxed/simple;
	bh=PbYYqHT+SMzVvR20Bp7GT5klw4B03JQJwWV5oZSWtrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBDH2ZxO3DmeLb6esltshNoTSdrEegONL5695nmzyn+6oTEUyJE4BdU8UX43ahAHv8aoBjRmVV5WKLzx3wXyrQlauy8WOMWljmz6VVdmEqNWD3wh367V7XgX0iPN3Vd4uGjqWoB0Ob2MbpM+0A39SoDqRdt9ufMdfNtfiQuOSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w0DHwpZc; arc=none smtp.client-ip=95.215.58.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w0DHwpZc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PbYYqHT+SMzVvR20Bp7GT5klw4B03JQJwWV5oZSWtrM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792117297; v=1; x=1792722097;
 b=w0DHwpZcEqR6+2IzYSLFmIMc8ub4Z42xReLIFcmrPcoS2kYul96SMet7h1A+CxXK7cdwmCxQ
 WZleEP5LQoPifAprnuuXapAHPOaSrcEGNK5ed7xctcr5VAZNkIo/kCHDnfKeXILepHYeElwx+9c
 RFPOyggaHEq0dEECNx2k33HU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fc4319408f98a987;
	Fri, 16 Oct 2026 02:21:35 +0000
X-Mizu-Trace-ID: fc4319408f98a987
X-Migadu-Flow: FLOW_OUT
Message-ID: <a6153a50-26a8-45ed-984c-532bab4edb06@linux.dev>
Date: Fri, 16 Oct 2026 10:21:31 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v3 4/9] cgroup/cpuset: Do housekeeping check before
 converting invalid partition to valid
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20261014140548.575122-1-longman@redhat.com>
 <20261014140548.575122-5-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261014140548.575122-5-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/14 22:05, Waiman Long 写道:
> When a hotplug event happens or when update_cpumasks_hier() is called, an
> invalid partition may be converted back to valid. However check against
> housekeeping conflict isn't being done which can lead to a partition
> state that violates the housekeeping rules. Update the code to allow
> reviving an invalid partition only if it can pass the housekeeping check.
> 
> Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b2684c98d8c0..51723c299ca5 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1959,9 +1959,14 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  			bool exclusive = true;
>  
>  			/*
> -			 * Convert invalid partition to valid has to
> -			 * pass the cpu exclusivity test.
> +			 * Convert invalid partition to valid has to pass the
> +			 * cpu exclusivity test as well as the housekeeping
> +			 * check.
>  			 */
> +			if (prstate_housekeeping_conflict(cs->partition_root_state, xcpus)) {
> +				part_error = PERR_HKEEPING;
> +				goto write_error;
> +			}
>  			rcu_read_lock();
>  			cpuset_for_each_child(child, css, parent) {
>  				if (child == cs)

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng

