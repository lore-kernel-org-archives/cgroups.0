Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E092B3C37A5;
	Mon, 20 Jul 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784533021; cv=none; b=k7LkvJrYdP9KCuZqy8gzVS3whnr9Ed0Ol9aLH08+sD5gV1FFt4tScBQgC8sVhTIcn6eOCNqY3UUiZ8J4fQA8WvJg+LOn++PqGO8dRsWfVjR35zJkykn2WNz0yR6PiFoQKvmJx7XD0XeMqo33vAM1wFk+pzap5/liPZD622SEBy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784533021; c=relaxed/simple;
	bh=Q01x6K/IfTWIPdxuHwB9zpJPvXg8aRbwgWrBeyvO3wY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=SNTUo/92HCdwCKM9wVf8NeOuo1xvFzpLTszvHSKMhbgMlkIvrQzzXuM7SNEDPPhKmYhZeN3CwHx6bnFA9j9ubI2M8mX43pm9/IR/+5M/RO+lYMNkLODJBEypavzqXHBYbsGHH4gp7xWMpNJfOV8I82SJfdO06Bn0+MGsjJO1t6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxGncjnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxGncjnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C0D1F000E9;
	Mon, 20 Jul 2026 07:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784533020;
	bh=Q01x6K/IfTWIPdxuHwB9zpJPvXg8aRbwgWrBeyvO3wY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hxGncjnxOyTRkc43Y8V/m1V+Ho0QmOHxQ5yHEWAZs2QohviuvpIJndKkv8swEcM4j
	 B/VEnDqgfTSt3Oxc5qNZfvioTFSnyIRdlpr3y8n1hIHMsGvXSgu5WHicYwoywQ4n0K
	 NcFPg9lzHcn1O6lELIJVvGRE/EwguUCqUNhH7iOkExAA5zFFYrwyYQwdSxXJCXrkop
	 NBDLChHA9w6SdvQOlrqYW0p2BOgfC8TdoOTOrbNMfywnfAVDQcuwKmLQ/TUGDG1mhc
	 9N8Qpk/vsshxgw38+RWQDPsKcb1aRruwq+W+qSTpYCI08P6nyru7GHl8k/XJQw0lFI
	 UZmDjlBlL/Img==
Date: Sun, 19 Jul 2026 21:36:59 -1000
Message-ID: <9700455e41e59e49c615dbc8f627f494@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev, Emil Tsalapatis <emil@etsalapatis.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET sched_ext/for-7.3] sched_ext: Cgroup migration and op delivery for sub-schedulers
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
References: <20260718081727.582037-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied 1-8 to sched_ext/for-7.3.

Thanks.

--
tejun
