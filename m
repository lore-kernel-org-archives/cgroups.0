Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9813C09F7
	for <cgroups@vger.kernel.org>; Tue, 12 May 2026 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608146; cv=none; b=jHkMX17YOpHd18LCKRr8Qgw7PeyWu15rVKp1NgYFY6KD9pN39eOoUFM0kJpm0jKcCYe9VAOzhhrFppQw9JGNQy1QTdhivaLIeRavXLIQlP/FX6AwF+a2OItgHhsfhUNZQPn0B/5kIPKqzcMFEMu0+iF6HNbGmX90hEVzvau4Mj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608146; c=relaxed/simple;
	bh=Z5+kxEKRAMlWehZixemGOI302b8t3FuEq7M1QlnLDms=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=qM6T7J1EbYhOvDcoUZTHmHP4LoETwpCO7K17fXiAbc1XJiHv0RUIJRldQKg0osGoYbwm/EENaNOxo8hadLKkktX/W1tPUtB8nArN3ObIwBrEAmNU49XodjyHdDIK/X5L9G4ArHHG+phOSqlhBXch3cCSXNxEtK9yRmtwCj4T1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMXi0X3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMXi0X3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BAFC2BCB0;
	Tue, 12 May 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778608146;
	bh=Z5+kxEKRAMlWehZixemGOI302b8t3FuEq7M1QlnLDms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kMXi0X3JAOgHblGv6H5CZbjToOQRhRB88YHo3Iy+vC9Ws3AN9yp6tFXqTv+HG8VtV
	 qN3x2ipRG6VzzVZFzZLF3kLhUXBNDeRMP7m/cae35HwD0hvftLLwkKIRqkkGCCBL5K
	 vHBAR4tvCuq8l328BCqdVmZAt5n5MPTsNjkWD/n1pqmLBcQk/DdNIg+fX2uAORjqpa
	 1uMUA4BrOxJzT2aAMTCDp4HMgJZlbeSWAhO2Vb/sJcwj0P/EnDS51oWriJXdjnPGIs
	 L0ccQN1e3EbTheR6lNr8XURh0+dKGrNCgxSI/aPfhTP8yq1h518a/tYFWBNfKiSKtz
	 lbt17SSUWRhXQ==
Date: Tue, 12 May 2026 07:49:05 -1000
Message-ID: <8545cad8e29f27e927e76c7bbe1334ea@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 0/3] cgroup/rdma: add rdma.peak and rdma.events[.local]
In-Reply-To: <20260512031719.273507-1-cuitao@kylinos.cn>
References: <20260512031719.273507-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The list below is from an AI-assisted review with some input from me.

* Patches 2 and 3 don't extend the rpool-free condition in
  uncharge_cg_locked() and rdmacg_resource_set_max() to the new event
  counters, so a "set limit -> hit limit -> uncharge to 0 -> write
  'max max'" sequence frees the rpool and zeros the counts.

* rdmacg_event_locked() creates rpools in ancestors of over_cg via
  get_cg_rpool_locked() just to host event counters. Those rpools have
  usage_sum==0, num_max_cnt==max, peak==0, so the next real uncharge
  through any such ancestor frees them.

* Patch 3 says failcnt covers "this cgroup (or its descendants)" but
  the code only increments the directly-requesting cgroup. Either the
  description or the propagation is wrong.

* rdma.events / rdma.events.local print "mlx4_0 hca_handle.max 5
  hca_object.max 0 " (trailing space). That doesn't match any of the
  formats in Documentation/admin-guide/cgroup-v2.rst. rdma.current and
  rdma.max are nested-keyed; the new files should be too:
  "mlx4_0 hca_handle.max=5 hca_object.max=0".

* Please document rdma.peak / rdma.events / rdma.events.local in
  Documentation/admin-guide/cgroup-v2.rst.

* "failcnt" is cgroup-v1 vocabulary; pids.events.local uses
  "fork_fail" for the same role.

* Event counters are atomic64_t but all updates are under
  rdmacg_mutex. Plain u64 with READ_ONCE on the read side would do.

* Patch 1 reflows an unrelated comment ("No user of the rpool ...");
  please drop the churn.

Thanks.

--
tejun
