Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793720146;
	b=UKUVZ7Pnukb86MbjCs5BDHuK575iUuHtv7KsSTsWQJTjdz0v0EwaTr5h9d3YQ7ZC1vkY
	 TjNTvv/T89dJVrCJl7y1GaPdxBbsWuhVdNymq9ZIyNmTnnSKDft9Rd/+GjTRlPpUb+wyc
	 gJDglJcyg2Y64jBvfjhTEI5DLSIlJLlABepiZqIMec88/QHiTDs47ZW3qCYIxRlRoSY27
	 8CCpQaNy/j396CbyK/wRc6oJenc+bs4sbac0f2u0GrAIv7tnW/jSCl7hluxO/9wj2BB8r
	 QA42vkCyre8WVXxTaCE7HV7asAXTt4kPGZ86mbG/hargNwoIyjzLEf/XNtOGYxlx+ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720146;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=t6wyycITGM5Nn6DuWAdjmdZN88p+e9N8YZxCzAqrnCY=;
	b=jeDevCJSw0rkHiZhn9QTAfJHJ4VaCh0Ty3YQhqKqRO4r5Z8Za9TiV+r2SGb6MIHRvHCE
	 N1HFB5im5lvn8hgG3glcPJ2DiRfioPF0BSL+lBOa/YHrspsAH4AjTXNXmVpZ3hVjz/xm1
	 ndq4kSzM0TtzMvA/a9W7EcTxiHQrSNrvioDQjtswgOpLDnqKVGE4GjIb8vxvnF84nTs3T
	 gLiunh3gWhYX2aCbpQi9KEL8kwEJmj6GuUtT+hRNfaFiVomPAzWpIYW6xT4tMl+kkLX8k
	 0FUbO1ccbq6PsQKAoW91Jsq53zfvPm4kiERS2qbUjHmdR0z/BgrjI8zoXrBjBQiryXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZlVsRUzz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDBE606A326;
	Tue,  3 Nov 2026 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZlVsRUzz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C771F00919;
	Tue,  3 Nov 2026 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793720146;
	bh=t6wyycITGM5Nn6DuWAdjmdZN88p+e9N8YZxCzAqrnCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZlVsRUzzXc7EhIVSSpAnEcekuGlj9t5O2vlBUWsfHUu3XCRlARdmuZjj9KUBDFt8C
	 4D9qpQB10CES9LdTJ0f/T3kOm0jh3WlscidBhQWW5At79k3YmpNBPPRDbanvom15dO
	 Sg03W2POIYjbFNdXUBdp920OCQPnA3dIveJQ68MdkGEZ1ptII4Ze5MBY7ztAEbaeZg
	 ZqHje8q4OAPZ8g4IDtlm1s8C+d1XaKio9YNLVLoyAVDYiJhBxkQYoM31fSZn7QS3pa
	 ygnd4/m45Sb8T+ILFW3t9XfFQ2yADvtQ45d9BYrzHGHFOGcB4jR0mwvH5TF35eoWmq
	 6/EUy3FR67Yxg==
Date: Tue, 03 Nov 2026 05:35:45 -1000
Message-ID: <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, ziy@nvidia.com, joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
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

Hello, Zhe.

On Tue, Nov 03, 2026 at 08:28:13PM +0800, Li Zhe wrote:
> MPOL_WEIGHTED_INTERLEAVE currently has one system-wide weight table,
> configured through sysfs or auto-derived from node bandwidth. This series
> adds an optional BPF control plane that lets privileged BPF syscall
> programs install manual weighted-interleave overrides for individual
> cgroups.
...

I don't think this has much to do with cgroups. Weighted interleave is
already a per-thread/per-VMA policy chosen through set_mempolicy() and
mbind(), and the weights are parameters of that policy. I think this
should be tied to the memory policy instead. This is different from
the per-cgroup NUMA balancing kfuncs. NUMA balancing has no per-task
opt-in and acts on memory with no task context.

Gregory Price's mempolicy2 series already proposed set_mempolicy2() and
mbind2() with task-local weights:

  https://lore.kernel.org/all/20240103224209.2541-1-gregory.price@memverge.com/

Thanks.

--
tejun
