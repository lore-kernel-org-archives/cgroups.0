Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793123341;
	b=aKKB+Bfqhz/BLOeKs68hefs1Vl/+88NX5TK9gcK0qST0UvPFQBSXPPX7U2eI8E6orIBY
	 q5mSB0Zqvmq2UWxXgZE7uQi90irde9HfDgZjDaJQYFZ/YmDU5tKzEz2zB8hkVrMKoRJXG
	 IseOEcLi+JU1Icu7XyDDi00jvQc8gAJ0zD3akJDRoWg6tuExCsAPD+U1BekBioLhRuy/n
	 ppbNRKZ1zMSk5mSI18FGKD9xxR7dicd5lhKovpw5FGx5p8lSQPkCQkXXnDafH2Vw3eZnQ
	 5MD0goU5pOY9knG0xzI0SJ2A0g+ZSAaRp02cpfMyzI4wUIv+nBnLlDQrBu7wgNDtNdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123341;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=jqi1auo9K9QFj2FxvbzWio326a6K4gWSKU89eo3FMRE=;
	b=C+Ma3orCpF4fyRhWUXegmnULvQb2Stes8xcRtuxfea5jvPVu37UQGXD8stHqs8DeeQqs
	 Nu7eUhvV4KJIOwNvVgepgNctqhJZffn+p+g/Ad6pIM9OGm2RFf2PGrPNElPJ8JWKfpAyP
	 SHwXYhj/+HZKeN0ZHjkEXe+2OjM38tl0D7xxmTAxk9079I/eiUV70Tki1UC081Poe55rt
	 wIjHwKKFmD3m/OjMWAyw1Sj6dLDjsrgwW7dk1ThB9PA8S3Pj+oPjZNZU0i3RP56gOmhwO
	 ejSKiVPaJHhxazyofZHfSIp+2xkDR8zAQWQN47/6k/fFyNUDOpaCh/Y/LiIaHKZPC6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLB+Xfr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40396606A325;
	Tue, 27 Oct 2026 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLB+Xfr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967A81F01829;
	Tue, 27 Oct 2026 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793123340;
	bh=jqi1auo9K9QFj2FxvbzWio326a6K4gWSKU89eo3FMRE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OLB+Xfr9xSz+D8VkRbWWK8qC4pXjkffopxb3aIxs+jWitJbcbZhVFoXnC5OAJgajF
	 YkYK2JfDJUFKdpJ6z3ljk5GFANO2kHJigp0zfcQHbTh04pEXQnEprWHW/hO7hvcg/F
	 w04+tATHTEUtXXNmbjjRHgeoQqlDMJ1x3z3aRLIfziCFFDu+hJ+dD5Em6XOS/86tZW
	 kpLvxMJrR3sgZt71/aS08q1UoSXfENl4MSCUQXutaAK3O/qgzMNfy37q7q5kLkTufl
	 2cfWdik+OTKxzrpYhr/e1dEnw+4UFdrYXJWVdLLINJK5pSc9TvuuQ8coDzE+xlIM39
	 h70ZgFy2AmY0A==
Date: Tue, 27 Oct 2026 07:48:59 -1000
Message-ID: <d942cdc7ead8853943fc35f7b28baff0@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, Tao Cui <cui.tao@linux.dev>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Don't count cgroup.threads in test_cgcore_proc_migration
In-Reply-To: <20261024140933.315221-1-sashal@kernel.org>
References: <20261024140933.315221-1-sashal@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Applied to cgroup/for-7.5 with the Fixes tag dropped and the following tags
added:

  Reviewed-by: Tao Cui <cuitao@kylinos.cn>
  Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks.

--
tejun
