Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451772;
	b=ih0FtiU0uOWTQxuTkKVMQbNFG8kcGaNZcAP1KwkS2Vau2TOQcUcao79jGHdJLohLuz6r
	 4pMho2h6jG5wUuMo42kaHkyaaC4zDRtkxkJJEwQeLjbXrZVw6Mkqd+7YK1d3P7PfyNE+Z
	 5cPqWYxDCEZxjKXHindZ8ER3+5XOgmJDPC9TPA3muDPHURi2sxpjaxN3AQmkUDlu3xro2
	 Fur8XwXlcmRE3hl/cvAlMJchcpGNDWjTEgY7lB3d5xPOQtXnb6SHoOe0d2HdVj4RPY5Bx
	 eMO2xvqDI5jCvTrLeVuo1d4J9ZLIpHxF7W6uSGzWZBYAo15ae9s5Ig1s90U6k8L8JYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451772;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	b=zZkxyDem7W7XxCQMJ8jhibMehtVlFR3dgAz2T/txu7iLWHpDee97UbSHf+ZhAM+iPFS9
	 /XW5IsRPgw6KDg31WUdtMj2Xx6+ItTvDPRiVB0BXhMtt/dYBkqibUxK16zsi5KlnWlOqk
	 z2hy05JnNmci11M1ojoIq/BkuedJLzQnBb/p9VyG+tnjwlochHD7FAXxgpSRylRF9UrMT
	 PZdicXIw4vKmnXZ5SuhO1a44+OeViP8r15Iwk0lhCeob8HcM/l9TTyIHMFN89JNLc5Pho
	 R1TyaQNF6EAQHxkTMYeTGiMyCVfjUw1J2m91fPfKtFIppCFRO7zxSH4+KqM+xa/EFTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yj8E0Mt2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D163606A32F;
	Mon, 19 Oct 2026 23:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yj8E0Mt2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7365F1F000C8;
	Mon, 19 Oct 2026 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792451771;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Yj8E0Mt26r1hlorHXSU7tIS3zEuH6CJ2trD9UNv0d7P89ZdHP8HSCUejkaiS1sXdW
	 MWLlFUlif73r1EH1IC7pGUNthKqupAy/YM13xhfLdavHqsdbemvhUU8DO4KCImK4GK
	 PnyNAQh6sknDfiiBIdpLYOSJOCzWkJpIvvZkZvt669vs6DrdmBHagHl59jfF+Y/VPE
	 7nFiN3O4KU16R+RWep+MX1ErOP0F4aneaB2Qk4JoFN1SqFURD3w03/Aw/uodp3oMWq
	 hfVp3xtFGMKalcSrOnUJFpwMH9Ye1oDjKs6CatsPqr7Ranx1P73oIzny/IWpXNdUBM
	 nReOVvd5asnbg==
Date: Mon, 19 Oct 2026 13:16:10 -1000
Message-ID: <cf56648504bd10e4024dfd72d29d01c4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com, ridong.chen@linux.dev,
	hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org,
	mgorman@suse.de, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
In-Reply-To: <20261019162138.3271947-1-gourry@gourry.net>
References: <20261019162138.3271947-1-gourry@gourry.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Applied to cgroup/for-7.4-fixes.

Thanks.

--
tejun
