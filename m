Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB513515C0
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 04:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789965004; cv=none; b=lgYjlFdv08M2BiBYfrAq4jjFMyk7mgFfzoSI08zxWgPadCs61SnSbdVxAlX4ffyFZvVs3yhAbSAhW35PAeNSTfrAwJdmFqPnM1rOt8YtwMBW6hgAVaqhUHbB2mLRzEGx0DsAzPsJHTuFinMuLX0rCPE6+v6g/DpJa7a/oJ0Nf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789965004; c=relaxed/simple;
	bh=6x0eZsGKzJtoQZApFrmCO+KSgQlm2l3S/T8VLvOzJbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhxFyFDsIl4tdnCdntYxISCLscfTFAaSqhuCgIvhj6ckJhFhBLz8iW/RRN6LZ8CexC2MmIoFsBRP1b1F5TkrP+ocuFtB21kJUmAGZHyMrv7337iTyYNDYuEYNrVInmB/gnY+afv2BwZcfetCNNtV+Csys0X2GNUpo2QvHApSFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rJuT9EoS; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rJuT9EoS"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6x0eZsGKzJtoQZApFrmCO+KSgQlm2l3S/T8VLvOzJbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789964999; v=1; x=1790569799;
 b=rJuT9EoSjkWnJtuNco+aMnP9HrWUlTrzRc9ZUXuW+MuZ34Pz/lOHNjCrIPFpuKQ7B8Sim4KB
 Z/EjqICAFapz4ok3KQ8wjs34rK2LFqytEW7CPWF54XK3J8Z3LDHf9nYv6Fv2F10vU9Sz7uMS15u
 yIw/oiogv1YP6v0MYoESIRZY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ddd30009a9c5d337;
	Mon, 21 Sep 2026 04:29:59 +0000
X-Mizu-Trace-ID: ddd30009a9c5d337
X-Migadu-Flow: FLOW_OUT
Message-ID: <ae7daed1-8fc6-408f-8201-756efc8c5c7d@linux.dev>
Date: Mon, 21 Sep 2026 12:29:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs: cgroup-v2: Describe boot-isolated CPUs in
 cpuset.cpus.isolated
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
 Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260918102359.71826-1-guopeng.zhang@linux.dev>
 <20260918102359.71826-2-guopeng.zhang@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260918102359.71826-2-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/18/2026 6:23 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> cpuset.cpus.isolated is documented as empty when no isolated partition
> exists. This is not true when CPUs are isolated at boot with
> isolcpus=domain. cpuset_init() adds those CPUs to the isolated mask,
> and isolcpus=<cpu-list> uses domain isolation by default. They remain
> listed after a partition using them is released.
> 
> Document the boot-isolated CPUs as well.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>   Documentation/admin-guide/cgroup-v2.rst | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 2ec582985b5b..272e9f2432bd 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2625,9 +2625,11 @@ Cpuset Interface Files
>     cpuset.cpus.isolated
>   	A read-only and root cgroup only multiple values file.
>   
> -	This file shows the set of all isolated CPUs used in existing
> -	isolated partitions. It will be empty if no isolated partition
> -	is created.
> +	This file shows CPUs isolated from scheduler domains by
> +	isolated cpuset partitions or at boot with "isolcpus=domain"
> +	(including the default "isolcpus=<cpu-list>" form).  CPUs
> +	isolated at boot remain listed after any partition using them
> +	is released.
>   
>     cpuset.cpus.partition
>   	A read-write single value file which exists on non-root

Could we keep that terminology and avoid repeating "isolated"? Something like:

       This file shows the set of all isolated CPUs used in existing
       isolated partitions or isolated at boot time via "isolcpus".
       The latter remain listed even after any partition using them
       is released.

With that:

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

