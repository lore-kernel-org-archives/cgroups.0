Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F63939A2;
	Sat, 26 Sep 2026 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790449890; cv=none; b=iuI4SAMGmPYAeH8XbZfiQynz08/EupUO+f+IMJtXHSynFtNkIYh/jk5J8AEn/KF01G9cpXRvvCU7lBY1zG+8f04EiAETC4kc2Ar5fpjwFVTB8dn+BQ+dsu1nlHI/D8dIRyFHxSyf0L/sju9/RE0PXPWVLJeRdqMIRt+ZQcBmmEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790449890; c=relaxed/simple;
	bh=ihFKsX/vJoSq7lYMit2JJR+V1FjHdQmJDxu0UPO2u7U=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2v6kg0dOQpaDtCT/V2O6mKrWZjWPCsGYu1a06o5uV9TyJz7JgJhjxqYc+C5cOuGaZI9DhXAqSPwOmtb80BNT5B4v783dYW/U5BIHP8uW/HJX1o7APGBVtAa15EG2ejIPFE6dxyVOGKzCJNO3sTyCLGglB9Pt0HyVTvUzBFDrMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c72E1Od2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c72E1Od2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA831F000FF;
	Sat, 26 Sep 2026 19:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790449889;
	bh=OaghCDPwcxLoA7MpS5jytLRvPbqoY2rVn1FVgllZsvM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=c72E1Od2iG+UoBdPH0x9MqsqoPFyIHsPrcXLt6HozPJTMUfSYpbNhWxWagrTbCKAh
	 CW/pK4bQE7Ij+amMhSYdeEmLEtd9vsb3AnCBnN48D+gKAgOgXZEWBVILxLCRR9jdg7
	 42JxQpdPvrR16tFSirimss/r107Lw1VV0Mumfhou8tlx6kUw2C107ygSKQQ3bzH59P
	 +eXuzBUUf5y8bfPIawPK03sTPwWBy5L5EfTSz86D2w/FsmYWUyYoqSqlXx7auQSsED
	 tl4OYm3IL+9N+P6jcA+JdGNbIV8QgBeasD86/BdBbdx1CRTj6wn6o3x+UwgHr0olt5
	 c2+SFYvdcmzCg==
Date: Sat, 26 Sep 2026 09:11:28 -1000
Message-ID: <be258eeace58448b38d7e6ad39923aa6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Peng <benquike@gmail.com>, Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] cgroup/cpuset: return PERR_NOCPUS in
 remote_partition_enable() on subpartitions_cpus conflict
In-Reply-To: <20260924042729.1908863-2-benquike@gmail.com>
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-2-benquike@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Applied to cgroup/for-7.3-fixes with the subject capitalized and the
following tag added:

  Reviewed-by: Waiman Long <longman@redhat.com>

Waiman, I kept the original Fixes: tag. 181c8e091aae ("cgroup/cpuset:
Introduce remote partition") added the subpartitions_cpus intersection
check that rejected this configuration in remote_partition_enable(), and
the check stayed through v6.15. 86888c7bd117 ("cgroup/cpuset: Add
warnings to catch inconsistency in exclusive CPUs") turned it into a
WARN_ON_ONCE() and let the enable proceed, which made the overlap
reachable. Tagging the remote partition commit would also send the fix
to stable trees older than v6.16, which don't have the bug. Do you
agree?

Thanks.

--
tejun
