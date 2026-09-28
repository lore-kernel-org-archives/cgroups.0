Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B44C400969;
	Mon, 28 Sep 2026 20:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790628022; cv=none; b=mYfE+/5PQvQ2Iu2xkgkETT80qRyIeMLKxPNCt3b/N6Sq9eRwvBQ3SO1lJRu9ksWDcQ/BQCuXpJaI5XJGngCEB1fPlUk0zueUqnbsRuZbT9FH8aFSwBQ6/AXzvg6EpDK7cVQ/jfGLiLjgi6Fx9tBX261NuXgZgvjIMjafmXVe7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790628022; c=relaxed/simple;
	bh=CoHoRxjQ6xpgpQCcQ4DIDavYf4+oiU0CnmGBD4CzMNc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=RI0mfFWtSaJqGX5obVdXWn9xgwat2yZhj9lJpYSFwtmjhQJhYor16GnQNzOSe80zAVWW+WkCbzq+bs5WMi6ZBZldMNG1AGz0rmOaC1fxSxOFIZNqmv96KfF0tzOLqgKlHZ/aefVdR2O1u4Ex6JE5zW/Q25gwVqX5xb7I8PdvtSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwpH/rQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwpH/rQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0621F000FF;
	Mon, 28 Sep 2026 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790628021;
	bh=m8gNHGeN9x3rygoOMPou+J30yRI3f3dCJdb5tsXJA8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GwpH/rQqVv024QcgJ6u3+OLqasWshPI5N2UHnxjNm/VTJaZ5eseSEUd7CIaE1i3i6
	 opCPfoiVnbc0CRgpybqTMVFg/t4qbQwgFsGNMa7sPUQCgf8rjhmuFCg6wnWW3qahi6
	 0dg4qW44ZgyNlBqrHCoGiNOqtTAtwUN0ex+qMG/LkEmSebCBiLp3Bm0iwB1PJHYuZx
	 zK0qcQn+9qJ5Zk9zA+Yr03TNNmYKenX+OVMA6xHKilAq9+bV/deI2pILyTX5b340GF
	 2GU8Mq6lZDmRRG3+Roaam4mTC4PXjouQQFDQC4NOPa4yxx6X+RIh50zw9BSScy1TED
	 aI2x/noyxexCA==
Date: Mon, 28 Sep 2026 10:40:20 -1000
Message-ID: <bda525506b3fb3e61da28a112f28abba@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Shakeel.

On Mon, Sep 21, 2026 at 12:25:55PM -0700, Shakeel Butt wrote:
> try_charge_memcg() calls __mem_cgroup_handle_over_high() before it returns,
> which reclaims and can throttle the task.  That happens wherever the charge
> happens, so a task holding a kernel lock can be stuck there, and everything
> waiting on that lock is stuck behind it.

Why not just raise the lazy bound high enough that most charges never
enforce inline, and maybe annotate the specific paths that can allocate a
lot so that they do? Inline enforcement should be the exception, not the
rule. Flipping that and then trying to reverse it with custom BPF policies
doesn't make a lot of sense.

> One concrete scenario which can be resolved by this new feature is the
> kernfs notify worker. It delivers notifications with the cgroup2
> kernfs_rwsem held for read, and the charge for the delivery allocation goes
> to the cgroup that set the watch, usually one already under pressure. So
> the worker reclaims while holding the lock, a waiting writer blocks every
> later reader, and anything touching cgroupfs stalls for seconds.

Slowing down the kworker inline doesn't make sense. It's charging on behalf
of the watcher through set_active_memcg(), which already tells us whose debt
it is. Wouldn't it make more sense to defer the debt to that cgroup instead
of slowing down the kernel thread?

Thanks.

--
tejun
