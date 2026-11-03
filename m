Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722643;
	b=UQCHqA3CE5uzGOign9JXr/Mk2WOdz+qSqxoh5C3Gk/ewBcfslfNPIpNzu0oZMG7/78Wt
	 9kr5DjXVpd+MOy1UcJMPsu9J4mX8yAh6yy2IRF+dptUfsoWACPoWT8ea6rnNAWtHwZWDk
	 oDtJkjvaHctEczBRYeoUw9W15IrpRoMQ2uRWrtINd6J9CFIxXasbU/JeFhxxfQ/ScI6Ob
	 mAViYv2N3bA36RkRJM7OFcW7rkUo8RNBXHXBIH1oLNmABKKs204mzONwDn12qlGJ66G9H
	 ku9yXK5RBfQxXtJHuxzufy3HTLNiw7mk7AQ3RYkhYrqDqj4FJa+9pjDRqPf6xqRT2pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722643;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	b=Rgl3tE4nn1+Bj9PlqrcsDpi3X76XjKLsaOrtYsUnqVRcM1+SJ2Lm+/tjha85umAKcZwS
	 5jQMdF3rxHS7B/1wVbkRXzNGsUWfTSX7o0lD9M+JBTIN+l0KHhd28N1LN/BG2ILT4yES1
	 ckzf4saE9Q0GIuU4WkCLRJj0Ftksq2dUD/U1K03f0gXqmPrgZ9YPBP6v6F/4qWGakqX7q
	 Wtj7fIL+D5avmiJrYIglgHngXq5zYkfPjCPGRkFrxZvymN+qIIP7gXG6DpyVJHUtgMqL5
	 MGhpiR/xfeNx1XRBhhfb36LNYEIjht3FLx0JCsDj+yeoCqwJMP8l3zLg7E0BzeVMOgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCxnCtMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C332606D825;
	Tue,  3 Nov 2026 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCxnCtMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7C81F000C1;
	Tue,  3 Nov 2026 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722643;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fCxnCtMvmols8l2UoWEtSEoz31l6QReTQ3w3+tw4CDZ7RWZeIU7e6Ox+mOVQz3Hfo
	 ptHPiSHAcAuJz69eDvWdRbYnVRJhsRW2FrdtBdG3QUkK333ENIAO0bMe9XjpgQf6/a
	 ZvoGNhZW6PLcfg8419V0Gy0sympMA2xw4/FS8U7/QKydi38Gjo4mFlaQ88CigPEsad
	 TTAiMoH5V/pCRmzQVIoLsUzPChEIlprteHlZEqFFr/IWogJEcefigWGk43//LTptvf
	 x5SWFLYLLGbpG3DY3KuLMqCoDIdQQtL23DNKyGAdigkqQ0DFNWJU/a74YSA5ozXkFn
	 MmWfymy8ObE9A==
Date: Tue, 03 Nov 2026 06:17:22 -1000
Message-ID: <54f916d834d4fde5a50d09e8eb57bbdf@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: read and write size_t with %zu in test_zswap
In-Reply-To: <20261103155456.534684-1-sashal@kernel.org>
References: <20261103155456.534684-1-sashal@kernel.org>
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

Applied to cgroup/for-7.5.

Thanks.

--
tejun
