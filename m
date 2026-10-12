Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177F84C33F1;
	Mon, 12 Oct 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791827676; cv=none; b=JgATCM+mhX52NxmnPUBod4svm2TFxyGwmGj4hZC2dMEp6Mer21LmdtbNq4Akq5kXrrvKo7FTT2CM+Evk2mzvZe96s8eLv4dGp+4/A683J8GkMMJE1CphUBEDfpg6SnHIJ/WzYd7vYskOproCL3AZoTN6xsTGqesvRM5mI4u5rU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791827676; c=relaxed/simple;
	bh=B5RR7Ey4vV2Dlrj0MhG2cTVJB0KBVADu4Dn7PSMrVcM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=mj5TOtkAz0BL9gm1TX20u5yiM3vlrdWLljvQvVoVEETngqAv6KE1hsgUGCpKLpa72xWsQx0qk6AliugXCaMIK7w62TzquUhWpeKLGjnk6rXcyaDGjb6dv9NAS9XMtSLAIe9w1cXxe2F750u/gs3Tuk5bw7IkRnjrcA/HKxIgxHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1FbeeFF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1FbeeFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C5A1F008A1;
	Mon, 12 Oct 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827674;
	bh=I9xvBB0EtKpUtLwHcLsg7GSToVO2MIO1az/h4fxZuAE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=o1FbeeFFWmxOOA5cl2s9SM+1Y8td8Gx3+QJtIiSilityfthUAzLTcM1/H0+s/YNXt
	 Wg4ghxMw9pF9ehwollFtfq5218JUI+0v35w952+mcQxLWY3azT6iZqYOhTPvVMPFzG
	 fzVMQ2Wr2d54uW9g9+jEhVZSgJKlDD+MkafTMjg36rRRE8sjWpbLv4Fiahsrp+5Hhj
	 rZN+O2+vkO87Axs632TnLkmvOdYI9/XuGNsqzkTbQ7jURCGvVjYqkqsc+2UoLTse6G
	 xl2C8RsHS7EZ3DBEn+mxChgZEyZosOEWdjgfFZyVIH7Vfn64TmKprHy74TAU1am3CZ
	 BWFdpT42HwY7w==
Date: Mon, 12 Oct 2026 07:54:34 -1000
Message-ID: <a8c28761bfd1fe281b7ef4225464b708@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Amir Goldstein <amir73il@gmail.com>, "T.J. Mercier" <tjmercier@google.com>,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>
References: <20261011223358.2327625-10-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4 with the subject capitalized and the Fixes tags
dropped.

Thanks.

-- 
tejun
