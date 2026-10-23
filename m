Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787213;
	b=cMjsIXeXcEdhfU4Pq5bxqdMgV8BcN/bp4zokPsvXJHEj6FjAK1EZWxly4aNwELGb3ogd
	 WhlU5zyLGv+Mmpn1hJv/hlE5OyVQKoudnM0uVsDsLPDAw6KImhxGvelVzGMnHxzn84fqH
	 nfJmRSdr7bnjtBC2S50VD8tTF8yVP1pMukW01fyDXEVbv2C8/jctkkkPKhKesF4FuERp+
	 3bAZ1D3x898mvfl57ib3XYpheVyBC3oupDkpSqSA8K56shU/hy13uXBq+7C9zW0qZc2DB
	 LzZB8mRSAFJoMjTtnOcyp5F4pVEl2pSOtc8szG2J2E2lFt4lLhUmRsLwg0M/camzRNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787213;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2iKkxq+UqNqHyLV+THXMg5WkUFKVICQa0CuIV+OZXMg=;
	b=nxe5BkpuaIIEmqkeMOWRcDlD0Z1/UQ2OR9rWtxLzcYqg8dimTIhbnH75ui4otaX3IxCr
	 ptC4Sk5HAfkGlqxkwJiV2yjqDp4z5QD8efZ3PFnuB6yIKEYCeKqK8DROpFYa/Niney7N0
	 Vqpm6DdEI9Ea0KgsN71h2kZVrYt5q3WxYN+C6qhoYWbA16wJSySu1YpCvI3wMomjphZ0+
	 J+AhFsR5ZXGSXv0CTmUdR+jQIu1DjtfQDN7E+ctbCt6BakC/DOpU1kDHNFoduAJdoYm88
	 6QMPFuHZkaxwXjpARodzVaRmyLXbS8a76EydJTML8eMRdHUo5wp2FFMgaEPPx159dLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWVCDR5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2E606A31B;
	Fri, 23 Oct 2026 20:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWVCDR5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C671F01825;
	Fri, 23 Oct 2026 20:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787213;
	bh=2iKkxq+UqNqHyLV+THXMg5WkUFKVICQa0CuIV+OZXMg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZWVCDR5cy/lndYOyGOhplC6Lx+7RDonEGRapmpGv60UxxsNruAEycqp5I9F3SqZDO
	 FGrEeZw/IJRn6KSQVPjCjoEfdQVewjB4itxUJkAIo3lPysogcN/Q0o9TyS7pBvcsBR
	 Tu72O8VA7FgnPPrqXoOFbS/cGBBrCLgGBlTfoN5aOEfp1+m8mO7pcKIBa9u/A4Tb17
	 pT/p6z7dOen2/8CpNfsHGUrNPePOf0F2NeM2bK6iAZ3VmSf6yE4NkSwEE+8Ia3Cu76
	 CahK7B1Ddu+z6EqtfkR74A7L3+3uFtXVSLYSGbBbKm9oGr8MzXvjaRiQo39eHzc3zy
	 x+bJbkH+VymQg==
Date: Fri, 23 Oct 2026 10:26:52 -1000
Message-ID: <340edb95789c7c6803f50bb1ac2fb5fc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Kir Kolyshkin <kolyshkin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: don't kill migrated processes through their exiting threads
In-Reply-To: <20261023194623.3566511-1-sashal@kernel.org>
References: <6cfe7cba3720e25400118d43643e55a6@kernel.org> <20261023194623.3566511-1-sashal@kernel.org>
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

    Cc: stable@vger.kernel.org # v5.14+

Thanks.

--
tejun
