Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78631349CF8
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 02:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787280499; cv=none; b=dGtEcd2jI3X8kLN1bKeBqt6ACHkTNy8FF2RLWh515kaIIpzXUAZYHcBSn2rD3dTQL/qBweAOK1JleShKS6VLvcME+quB6sy9We+cwC0SMIxCybbQHAOhGffbnDYg++mHYB+kPZyt3JEz5jDbw3p4rB9742g0Ccw/wtS79HYcaoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787280499; c=relaxed/simple;
	bh=HN4l2o3X7Q7dTMu7syr8JbTgShMRhh1OsYVQmi2xmoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oc2U/3chlQbarcbOhW/d/qV/64ENfAZZGX8NxHUcxKK/MRmTJ1GxpemCAYRr19d9Y2V9MrLaR3429UrO1p3TrVP/b1iUVxZvNm84Fldwh27Hco7Skh0j0CMDbsWGsFzL8rlApVdfQp8SavoOSCwG/ZLcvuRqzyCagRltmnJF3/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WZw3xiLk; arc=none smtp.client-ip=91.218.175.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WZw3xiLk"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HN4l2o3X7Q7dTMu7syr8JbTgShMRhh1OsYVQmi2xmoc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787280495; v=1; x=1787885295;
 b=WZw3xiLkoJnEpS+RA4Yg4FkRKIs6wHabAEI54gk5YmqbQDcTBNcZ/UHoryvPostvRGdo8BFg
 crHALe/UMdI4PpTz8HiIyFTrL6aWcvf3MNd061Ai+sZibEDsklabtpNM4eQ4NfSvbvbnnC6gOTG
 PCh+8yn0WvZR+jEJHQVdft9w=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 77b11ec9e3b54596;
	Fri, 21 Aug 2026 02:48:15 +0000
X-Mizu-Trace-ID: 77b11ec9e3b54596
X-Migadu-Flow: FLOW_OUT
Message-ID: <5a16ddf0-2b22-449d-84e8-1605c195ea41@linux.dev>
Date: Fri, 21 Aug 2026 10:48:08 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/17] cgroup/cpuset: Fix partition CPU ownership and
 isolation accounting
To: Guopeng Zhang <guopeng.zhang@linux.dev>, longman@redhat.com,
 cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/20/2026 8:41 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> update_prstate() uses effective_xcpus for isolation accounting and
> housekeeping checks when switching a partition between root and
> isolated. The mask also includes CPUs granted to valid child partitions.
> Such a type change can alter isolation accounting for child-owned CPUs
> or fail a housekeeping check because of a CPU the parent does not own.
> 
> A rejected type change can leave CPUs assigned to the invalidated
> partition instead of returning them to the partition that owns the
> invalidated subtree. When cpuset.cpus changes, child validation can use
> the old parent mask, and a remote update can observe stale cpus_allowed
> when it revisits a cpuset. Direct and propagated invalidation can leave
> isolated_cpus reflecting the released partition's type instead of the
> type of the partition receiving its CPUs. Releasing an isolated
> partition can clear boot-isolated CPUs from isolated_cpus.
> 
> Limit type-change checks and accounting to CPUs owned directly by the
> partition. Preserve boot-isolated CPUs when a partition is released,
> return CPUs after rejected type changes, validate children against the
> new parent mask, and publish cpus_allowed before a partition update can
> revisit the cpuset. Fix isolation accounting during direct and
> propagated invalidation.
> 
> Patch 1 removes an invalid selftest comparison that makes
> test_cpuset_prs.sh fail when boot-time domain isolation is configured.
> Each kernel fix is followed by a focused selftest update.
> 
> Guopeng Zhang (17):
>    selftests/cgroup: Drop invalid boot isolation comparison
>    cgroup/cpuset: Preserve boot-isolated CPUs on partition release
>    selftests/cgroup: Test boot-isolated CPU partition release
>    cgroup/cpuset: Limit type-change accounting to owned CPUs
>    selftests/cgroup: Test isolated CPU accounting on type changes
>    cgroup/cpuset: Validate type changes against owned CPUs
>    selftests/cgroup: Test type-change validation with child-owned CPUs
>    cgroup/cpuset: Release CPUs when a type change is rejected
>    selftests/cgroup: Test rejected partition type changes
>    cgroup/cpuset: Fix isolated accounting on direct child invalidation
>    selftests/cgroup: Test isolation accounting on direct child
>      invalidation
>    cgroup/cpuset: Invalidate children outside the new CPU mask
>    selftests/cgroup: Test child invalidation after shrinking cpuset.cpus
>    cgroup/cpuset: Publish cpus_allowed before partition updates
>    selftests/cgroup: Test shrinking cpuset.cpus in a remote partition
>    cgroup/cpuset: Fix isolated accounting on propagated invalidation
>    selftests/cgroup: Test isolation accounting on propagated invalidation
> 
>   kernel/cgroup/cpuset.c                        | 162 ++++++++++--
>   .../selftests/cgroup/test_cpuset_prs.sh       | 231 +++++++++++++++++-
>   2 files changed, 361 insertions(+), 32 deletions(-)
> 
> 
> base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969

Hi Guopeng,

This is a fairly large series, which may make the review process challenging. I 
would suggest splitting it into smaller, more focused patches. It would also be 
very helpful if you could provide a reproducer for each bug you are trying to 
fix, so that we can verify the issue and the fix more effectively.

-- 
Best regards
Ridong

