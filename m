Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA8B29D294
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 02:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649204; cv=none; b=lnJVP7cVS2Vz0yvNi10IczndSU1NndPIGAB201drJBCmGvuGktSUQ1RL8QE1gHd5ZeZmQ53Uxry61BKwkShzePpRqmgFj83nKc1+GtWMMK23YHdMVynseArv3hNl3BXB2934VN8+Er+fYTuyLbHOSDiyMHw967p9Cb6kPNO9uGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649204; c=relaxed/simple;
	bh=Gu5yHS65dhVH/p46qgUJfWxS/h6ydn962EOVADsvkyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FadDLNiDELALnLOdsO4mWtVO7dC0ndEkmInQ1IrUE/frvVXOOQfe3QLYd4xlaTyZWMXFlULt7yM8uyvowrc4Ls7H6Nxh+nW0S5hL66GZkUiQRQUX/BraAEQDdyo5YKlrvt1T5ZucsCn7B36t1Y/idVe0kMruTcRj9pVTfWiQBPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fhMtNgrz; arc=none smtp.client-ip=95.215.58.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fhMtNgrz"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Gu5yHS65dhVH/p46qgUJfWxS/h6ydn962EOVADsvkyY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790649200; v=1; x=1791254000;
 b=fhMtNgrztPhrhALa3UUOGYYU5cmLasPfMC5j/JUL8Y2ptUuhthQDqmPfphB9CDzil6PUNtbJ
 nhqTdY0lHe4WfUjMW34uPne028YPEVbUygPyc+XRO+PVu7dcJCfpw7f8UoAJazU8ZvVbzseO0vz
 wZB2yX3BVm/UX/vr9p5x2xbc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 060f2ea0ef6ca05a;
	Tue, 29 Sep 2026 02:33:20 +0000
X-Mizu-Trace-ID: 060f2ea0ef6ca05a
X-Migadu-Flow: FLOW_OUT
Message-ID: <c4dcad59-bca3-406f-b726-74813bbcdfc2@linux.dev>
Date: Tue, 29 Sep 2026 10:33:16 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
To: Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260927095722.70660-1-guopeng.zhang@linux.dev>
 <7f4c57b26ad120ab30adf35653f1dd94@kernel.org>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <7f4c57b26ad120ab30adf35653f1dd94@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/29 02:44, Tejun Heo 写道:
Hi，Tejun

> Hello, Guopeng.
> 
> The following is a Claude-generated review.
> 
> On Sun, Sep 27, 2026 at 05:57:21PM +0800, Guopeng Zhang wrote:
>> +	bool updating = is_remote_partition(cs);
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return PERR_ACCESS;
>> +
>> +	if (!updating &&
>> +	    (!cpumask_intersects(excpus, cpu_active_mask) ||
>> +	     cpumask_subset(top_cpuset.effective_cpus, addcpus)))
>> +		return PERR_INVCPUS;
> 
> cs->remote_partition can be stale when remote_partition_enable() is
> called. If a root <-> isolated switch of a valid remote partition fails
> in update_prstate(), the partition is made invalid without
> remote_partition_disable(), so the flag stays set and its CPUs stay in
> subpartitions_cpus. A later enable then skips the PERR_INVCPUS checks.
> With isolcpus=domain,4:
> 
> 1. A is a member with cpuset.cpus 2-6 and cpuset.cpus.exclusive 2-4. B
>    has cpuset.cpus 2-4 and no cpuset.cpus.exclusive.
> 2. "isolated" to B's cpuset.cpus.partition. B becomes a valid remote
>    partition with effective_xcpus 2-4.
> 3. "root" to B's cpuset.cpus.partition fails with PERR_HKEEPING.
>    effective_xcpus is cleared but remote_partition stays set.
> 4. 5-6 to A's cpuset.cpus.exclusive. B's excpus becomes empty, which
>    matches the cleared effective_xcpus, so update_cpumasks_hier() skips
>    B.
> 5. "isolated" to B's cpuset.cpus.partition. This used to fail with
>    PERR_INVCPUS. Now B becomes a valid isolated partition with empty
>    effective_xcpus and the WARN_ON_ONCE() at the end of update_prstate()
>    triggers.
> 
> This is from reading the code, not reproduced. Maybe have the callers
> pass whether it's an enable or an update instead of deriving it from
> cs->remote_partition?

You're right. I'll fix it in v3.

Thanks,
Guopeng
> 
> The stale flag itself is a separate, pre-existing bug. Switching B back
> to member after step 3 trips the WARN_ON_ONCE(old_prs < 0) in
> partition_xcpus_del().
> 
> Thanks.
> 
> --
> tejun

