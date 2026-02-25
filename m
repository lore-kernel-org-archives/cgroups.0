Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21353D3481;
	Wed, 25 Feb 2026 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041254; cv=none; b=iigIltzULw6Vgb0giPYaafKdLPIt0Y9elbVk1Cl6/2ElMH+UDQDRfzjDXrm9fOcc5GFqc04ZH4MwNszuH4jywgiq6fX7ZNc4DqxbuP0bco9wo8BGl2qafgDydRxypADIFW5XxmjQ3MnARRAPj5m32yyAGCAp7tD1vbS/0hL4kq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041254; c=relaxed/simple;
	bh=BKB3rI1qnbcBlftiZQ/yeMMmOuQNLAFDO9LsBpm+w7A=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=D2RLKooVEfnRemnf29Ke1a/lKhBDGMunIYk9Va8MXhRA7dCSG2UtQ8Uq7PLE1hVxmajM7/MynEak+xXFA4H/pP13Q8zaVWKL/8KRlCvGuR/4xvMFW3eCxAVd12oPrZJ51GFXeN8gUw2kG2YEDRWjllDBLfYDARGiqrP7gGTd6VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqQefBOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqQefBOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7474DC116D0;
	Wed, 25 Feb 2026 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772041253;
	bh=BKB3rI1qnbcBlftiZQ/yeMMmOuQNLAFDO9LsBpm+w7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hqQefBOgZoR2pioEhBrW05GMfAM3KhK3Vj7URcpbC5YQd+hfnadJEL2bD2nQg2uvC
	 vP9ERt2sczc9LPK1mwDN3ccfwZDcxmt9UHj6FopGj6fIgLANoVfZ23O96AzRn4M8Tb
	 lfh7HkCzP4GR3ouez1R1R4/YO/qJ8ib6+FjM5pgte2N0NksoYYlC1E1ClPuQchpm3l
	 mmPmCpwn1bav2Qz/pm9x3JCSU+wDTeE5G0mfEjPTGjQjEOykPbM0tnvP/DsceDnT07
	 bryVtsftvAbk/akW+lMu/cOGbqoJNbJKBsVG7D92XguQKrOpdr6h8sAswiCV5V1yPU
	 imvnB5LItaZSg==
Date: Wed, 25 Feb 2026 07:40:52 -1000
Message-ID: <89dca74185416ed487717aa8ef82a222@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: longman@redhat.com, hannes@cmpxchg.org, mkoutny@suse.com,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com
Subject: Re: [PATCH -next] cgroup/cpuset: fix null-ptr-deref in
 rebuild_sched_domains_cpuslocked
In-Reply-To: <20260225011523.51365-1-chenridong@huaweicloud.com>
References: <20260225011523.51365-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.0-fixes with the following modification:

- Moved the NULL check into the for-loop condition per Waiman's
  suggestion.

-	for (i = 0; i < ndoms; ++i) {
-		if (doms && WARN_ON_ONCE(!cpumask_subset(doms[i],
-					 cpu_active_mask)))
+	for (i = 0; doms && i < ndoms; i++) {
+		if (WARN_ON_ONCE(!cpumask_subset(doms[i], cpu_active_mask)))

Thanks.

--
tejun
