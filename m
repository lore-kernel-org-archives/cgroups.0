Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783827;
	b=TlpmLPykWcHAbvcJRgbgoz8jL2TD6PswnBIEyqm+v+lP4XA9JtSHugWJFCSopqGagamc
	 hzaZXKMkDNBDS8yDwg3ajPkLsnGNdlCOjxr4vL9LdV1WVhHg730TyLsn1q/SQXez43Jyf
	 HX6fWGSdjXjWnPpqBEtHDeYPY91NSoRSGSGgPd6d9T7d1Uh2MuWXHrXAgaCdbLMGjTi/u
	 rI3SzNHOdU3oEKObaFqrqipIKJpRVb8ArwmesnAWBOSTcudt5dROzZsjv/xu1bhZinLKB
	 X8nca+gfNTPZOuNCdo+Fc8opLiNh595j35ZQ03VmfaZy+1d59oKrU8siRhFfhG5HmFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783827;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gNcYiHbnUKnGMp+XdKstFrD3BQFTKmnEmBHxnqTFnYU=;
	b=s5B7p/WpBCJaB7oYpPNQKX8kMzwVDHU3+V99OFDMN54qtG6OztnUX3AvT3vWIMab7KRc
	 O016Q+RuC0du3u5Wocej94l+QXi9z6U54tc6dwBqwq4G9I7h1QAOgG+OK5WLGsSi1T5CE
	 QZficLLunOXWYqNBLcokcyz7HCOApLm2ZYslslrNPCTqcUZzOYBxn0RhYWdg6644OjU1z
	 y6AdUYkVXiz5/h9j2/TvTWYD9S+07WBHmCxe2z3wlPEBYZL7CoQTY846r8O5v7WlJhCaJ
	 c9i5tZqSA3KaXZCG6/OrymFpOztqmjvaHvdgLGELqSdRI5GMCQ/kd/5TXKMiNy5tH9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T64HVIJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CC4606A31E;
	Fri, 23 Oct 2026 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T64HVIJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570DD1F01825;
	Fri, 23 Oct 2026 19:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783826;
	bh=gNcYiHbnUKnGMp+XdKstFrD3BQFTKmnEmBHxnqTFnYU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T64HVIJH0WbgUIO0rG/DEMr+jHGYumMazUTOaePjh6Qa9uuonMskXJ11BzqhE3jSw
	 OyYyTYUFpJmd8BNmlOna2Q1peoJrTtmVJjcnpukvCnNBm4uBtU4hu8nOSeMCr9LTYg
	 DpCOXXuq4V6zno/FHHB90dIwleLbOLZ+z01rPK0gahwSzsZfJHTBaK1QVvLKg6fdlJ
	 0dLc4oOswj1MWVT2ZHjaWR6jBDJ2iN2AWYgBlbPM9CgXUCD0kc/SQ8f8xFPe4eVWi9
	 n1Dje0eELtVe/JhMqhgRT7VhOiwQMNRgUWsduuD4gS4CUgZOdKyjvRD4D5ZrpWEF4i
	 jkr9bfTeRyXWA==
Date: Fri, 23 Oct 2026 09:30:25 -1000
Message-ID: <728bf75360d1b37bcfb94d5441049f3b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, feng.79.tang@gmail.com, mhocko@suse.com
Subject: Re: [PATCH] cgroup/cpuset: check effective mems for a movable-only configuration
In-Reply-To: <20261022043943.3125239-1-gourry@gourry.net>
References: <20261022043943.3125239-1-gourry@gourry.net>
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

Applied to cgroup/for-7.4-fixes with the following tags added:

    Reviewed-by: Waiman Long <longman@redhat.com>
    Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

Thanks.

--
tejun
