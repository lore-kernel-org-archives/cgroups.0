Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52A6380FCF;
	Mon, 28 Sep 2026 18:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790621082; cv=none; b=GSpxl9UeUeE+afi1IJSA+MvCRXrrQgRvt0FVS+W09WxiVHHhuFPbxUwQpKs59ssbtej28Z4oFqmHiJHpIhfYgb4AYYa/s+RFWpIpNUXiLLZX6nO4+fFDV5udFC1bHcTmVB/JSCtJDoefSwqnhAiLM9Gv52r1H7+9KE9Bnjg302I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790621082; c=relaxed/simple;
	bh=RJ6Fq24d/7hGk0qZr2yJH3/pE7vmJFFF7o9EYI+0iBg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEw1I5x/M/xDaHSmzMWB24RDUfITeLb3EDQxEmLx+E51hReWNTyVpu9xt7MYGG7X4koAYbDsFud4Ee46mWAY1Vk57mfr800hAhx9t/H6R7nt4xisYtovJinlq/OxnWc1XOm21lMTfYB1/289qVh9QpLfGcc6q3N1OU3e+vl6TY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5Tvij0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5Tvij0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631821F000FF;
	Mon, 28 Sep 2026 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790621081;
	bh=DcgMX0HJpEAJ3K/p/lHFYWlG8Zs8BJeb4wFz0L27lRM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=j5Tvij0bAOP9BdxKdep/dbLEs1KltE6l2kG7DAWf3xlrJd6tYTPJLAoMcVyb9yrQs
	 2A2ifvrZ7249ViqHiNIcRNAecUci3p7hBcoAKmFyZAcNq9/mqFQ6GKPL3Z3qMx7Fe6
	 p7P5gnibUkyqIBwYpUCyfC0zrjq5ryiEuy942amaVV07KOkI+Co8uiME2K8afWgze9
	 VtRMOpVhSaYeWmU5edGMVWv02ZrNvO44Dfo9TSDtPGDqXvE5gjAS1j33t1F8J4FlpJ
	 dt0J0BMHxp7hy9AJfyTiwsfO5Xl2gNDX0lBSEetpbIca/wEKNPrMOSX9C6zRmsaUc7
	 j07U54Y1QfgUQ==
Date: Mon, 28 Sep 2026 08:44:40 -1000
Message-ID: <7f4c57b26ad120ab30adf35653f1dd94@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
In-Reply-To: <20260927095722.70660-1-guopeng.zhang@linux.dev>
References: <20260927095722.70660-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Guopeng.

The following is a Claude-generated review.

On Sun, Sep 27, 2026 at 05:57:21PM +0800, Guopeng Zhang wrote:
> +	bool updating = is_remote_partition(cs);
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return PERR_ACCESS;
> +
> +	if (!updating &&
> +	    (!cpumask_intersects(excpus, cpu_active_mask) ||
> +	     cpumask_subset(top_cpuset.effective_cpus, addcpus)))
> +		return PERR_INVCPUS;

cs->remote_partition can be stale when remote_partition_enable() is
called. If a root <-> isolated switch of a valid remote partition fails
in update_prstate(), the partition is made invalid without
remote_partition_disable(), so the flag stays set and its CPUs stay in
subpartitions_cpus. A later enable then skips the PERR_INVCPUS checks.
With isolcpus=domain,4:

1. A is a member with cpuset.cpus 2-6 and cpuset.cpus.exclusive 2-4. B
   has cpuset.cpus 2-4 and no cpuset.cpus.exclusive.
2. "isolated" to B's cpuset.cpus.partition. B becomes a valid remote
   partition with effective_xcpus 2-4.
3. "root" to B's cpuset.cpus.partition fails with PERR_HKEEPING.
   effective_xcpus is cleared but remote_partition stays set.
4. 5-6 to A's cpuset.cpus.exclusive. B's excpus becomes empty, which
   matches the cleared effective_xcpus, so update_cpumasks_hier() skips
   B.
5. "isolated" to B's cpuset.cpus.partition. This used to fail with
   PERR_INVCPUS. Now B becomes a valid isolated partition with empty
   effective_xcpus and the WARN_ON_ONCE() at the end of update_prstate()
   triggers.

This is from reading the code, not reproduced. Maybe have the callers
pass whether it's an enable or an update instead of deriving it from
cs->remote_partition?

The stale flag itself is a separate, pre-existing bug. Switching B back
to member after step 3 trips the WARN_ON_ONCE(old_prs < 0) in
partition_xcpus_del().

Thanks.

--
tejun
