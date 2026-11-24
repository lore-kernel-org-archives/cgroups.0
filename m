Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500563;
	b=vPjVkCL4E7YsnWD4kVkKdUZokZIQ6mmFycM3isLftt74w3hk5HguyKSk8zQIumsDj0L3
	 Gx4IqVCXlztt5EGnXssLUkVC9FhlQOtUyuwOzi0AuVOOq3Jy4ZGnVAz6RJ67fQn5pSDi5
	 YKZicLxODvG7Y/LpsBTgDDcJx3+HCC+u+8Uol4WaQQ8LhJDW2NzwN09T9TuLzc7J1E8ej
	 xj5+YpkEC6GONR4uusNChTSriphUgsLdQu6q2Ljcpxc/601LXh2NYSbm2A2XY4On2vNIH
	 gtAPzQwQPJp3uTXk9uXo+FVYiiPraV3tUZyW8ZWXNxT9AEYNc1Rgx0Of6g/5xugZeNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500563;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZiCXabKfHhYbZeIBFwG/TNKCYBFaBhpLKQ8XdiplvWI=;
	b=aIMqtHRPoE9cMfof1QTXNou3fQBGPQQexuL/vly8xisGUTakyS50VcFULHhcufTxALaA
	 4+uWowA33isLH0zOC6c7F/3KRMGpT3TYGH/g/xrKObLKVukbmEZWo9l3j5L0XIx2J1qK6
	 KPHyDO/65KMlrmBfU0P5pd1/G4hDTkog4Mc//Oa/m3MlTRrl1mcjmpC1AZuTY6HTq0B1K
	 /87Fc6+xAjIUlTIirrfRudS/6KPrb301JlmDrXyaUWB391zVaQnTDJsgYEogUJpEOFadT
	 w37X93PwNiaXVLWnyXWwnO/od5LaMz/nk16+ztcFwkLSZD/h7crMfGmN+nyRMBedtbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkZM8bPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D6606A321;
	Tue, 24 Nov 2026 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkZM8bPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA641F000E1;
	Tue, 24 Nov 2026 06:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795500563;
	bh=ZiCXabKfHhYbZeIBFwG/TNKCYBFaBhpLKQ8XdiplvWI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jkZM8bPGQJn73YwYo7UrRQ+QC0oGSM5Ly4453kMmQpMoMK8BxyvYjDHrAyBWdmv+z
	 g9lmt7iEfSkIX3oogPIVyTAbXqIYfikBGk24oY0/syyobZnVzt5zJRTn/8ngxuqa/K
	 SFrPA8+aNfrFvwnMorWWPUZuKCI0bde04/KyqBQcTk90+q+eDUTgjQp5ZQ7FPnPKWz
	 4N/aKUjEcoGpBsszm8Ls1+OalKMN53A2KCgxZ1yvf/h7PwDjP3E50TOWeYhCfCHo98
	 OT2WR27oqhizhJTs0i60w+FVKawaM15WJ6pfWzRwNF+Lt9vBcIgnhgd0SRabYA+yvR
	 n/3+VQ4r9t7Ew==
Date: Mon, 23 Nov 2026 20:09:16 -1000
Message-ID: <31830f3e8397a30033702d0769825573@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, Shuah Khan <shuah@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>, Puranjay Mohan <puranjay@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH bpf-next v2] cgroup/rstat: disable preemption in css_rstat_updated()
In-Reply-To: <20261124031642.40616-1-kmehltretter@gmail.com>
References: <20261124031642.40616-1-kmehltretter@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Applied to cgroup/for-7.4-fixes with the following tag added:

  Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks.

--
tejun
