Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793803883;
	b=wxBARkWG7nSDk6j0Xs24OI9dAGnxERmGeaf2fcxKAv1Egp7u4OGSwTC9DAMvCZlNcUNV
	 jmtD09RO9vpZQJ5uL75l+LRezkB5T4qaA3WXn/AbP7146j8oe6GGNYyp/oPgqrL8/zs1Z
	 bXOfZbnYRPjIAi45nxLd+sXhr8beucEhQICSFupXV1Zd3hfqVKvxKOP1XJp3bB4WOND8G
	 P7ZEmaeA9TQzZhGQA2MDidUfTnlp1LxQUTojVKXYjkIruLh8pPYYsXsq+7gVZEXI0vOB5
	 BSPX08kWBc+m5JiNHal8fENmRgnDxuEzxRwGAfA4spQVIUkEUXsEiBhCSd629JKAZLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793803883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=G02WW4a+pnsj4Xew0EG1BLUmC46o+u7VzGgK76hwDrM=;
	b=kMRxB4UIxi9vtKb+JilH9WtrSXXFeaMRcl0FXkvZbjk1ZOdd1kXOotasvpJDj4p/b8YW
	 s5fDWEuh6G8bAs4kY5BrxxnCsV+kt5WL3K9sjdXx81gIp6FbaxTQEi9O1huXHAhvvklmh
	 guAP0rfx18kn1jSV4fpfkOWxS5EbgoGfDfjaJyyA5g9CbWZy5Lao2gAZRa1gsnstglVn7
	 4/XX8e5nYt0LtJTwtSleSg5/338YQYAD8nkJL0YKaRFMmBXB1jSQ/O30oCElrHvu/AiOu
	 gxWsBptESX9xhk74tDYO1AHXbOjLYZXVy5s5mYU4tcumB+qVn8eOfv/b+a8GKsuVXJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y54fUfDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAD6606A31B;
	Wed,  4 Nov 2026 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y54fUfDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860061F000C1;
	Wed,  4 Nov 2026 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793803882;
	bh=G02WW4a+pnsj4Xew0EG1BLUmC46o+u7VzGgK76hwDrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y54fUfDFAQrOERrbEmmDGyONtEjxV7NTUFGA4jt0noaGH1QxTVGPopcQ5mZ8qDWUK
	 By1vSyiX2o7SFTzrey5CiXT3eZvr2jSfz9Gki3PrdwZOBpi+Q1BAgMNWrBv8IGzio3
	 cN441jq2bIQ9zp7H47Jr3vVCExi9HFu1mJM0HXs6IDibH3KpyAdMMV19Qx135qk2zi
	 qozlbpiYZiZO1NiAmAo/RPonKUo2fPR+3nv82kaePMtoNin11it4cIfs4efSU5fXYd
	 BQdYu/Y0fBxfp7LyFZmt1zZzxpxqKMfTaYlyJANnBugtho8oE3zOJxmDNQPlDoIKyc
	 BG5dIrKL4OQfA==
From: Sasha Levin <sashal@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: test_zswap: use the total RAM in bytes
Date: Wed,  4 Nov 2026 09:51:20 -0500
Message-ID: <20261104145120.3806026-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0fd8f5aa-2636-4171-9300-3e04ab98d393@linux.dev>
References: <20261103163919.641249-1-sashal@kernel.org> <0fd8f5aa-2636-4171-9300-3e04ab98d393@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 09:22:31PM +0800, Tao Cui wrote:
> One small thing: could you add a Fixes tag? The issue seems to date
> back to a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem
> bypass test"), which introduced the sysinfo block, and 6f615890b848
> later reshaped it into the current GB(4) comparison with the warning.

Yes, the original check against 5000000000 could never be true on
32-bit either, and it already used totalram as bytes:

Fixes: a549f9f31561 ("selftests: cgroup: add test_zswap with no kmem bypass test")

--
Thanks,
Sasha
