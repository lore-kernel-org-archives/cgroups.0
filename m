Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ADE4E4305;
	Mon, 21 Sep 2026 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790010715; cv=none; b=fbAtzXugILuzJUmJcq0Cz1S/gOuO14G5iCOoTqKuVsD7gfOMSHUa3wCmEs/ELxc5QwXoTMVhnPa88pFekOwfxCndJcNc3stIJN1Yb9NzHIkBrszGLaU6YOw3540R/QW8rkkIrREgDe2kSCZUM6uUvECdL+tB7SPJc2TBdYj9vc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790010715; c=relaxed/simple;
	bh=EwMRP6euCzd82FUgB7+MCDsPvYI6V2OzHSUDCeY0dJU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=qXSHEQGk/sqKvK8q3zqIimyj//V8Z9XOb1wvpzy1vc/rzPOoms7UWiVYRRP3iUvFZSZ6wOrWx/ALBQW/K1FqPRgGiw1gKiaWJnJ3CZKgTKzQUjg862EtPd6nA5gzdxF0YgdMLGImJ3vPvPO+yLKCd1Cx45JBOMHBCM7C2DMK5BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRduAX61; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRduAX61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5F71F000FF;
	Mon, 21 Sep 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790010714;
	bh=EwMRP6euCzd82FUgB7+MCDsPvYI6V2OzHSUDCeY0dJU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dRduAX617bwaGw48gdu6O6bK/HYaeVzJ30Ww6AfSxZQ1MLDTMme2qmDwYU0G5LDT6
	 pDuRoe1cgJ+hV+8hu1WQxPhxD/aAtElY2LnYp1Pc29BN76lVR5r28H3uc4TLLg0Axc
	 IY7hSzvV1dxWIhUth19bw98Et98USw2Dx0ECEkxbwV1WjOA6dk+jHraV1pUUst96QA
	 GTkFlCrk22LQ67pVtlttJDn/ksExVjQ8iQ/evwbArJ3UXZmgGQrZClI05+sBT/gUqT
	 w3bvbDipiGNswFuj5KPGK1xP8AKmW/neUEA2RDJulGevLQ3BSZz9ax5yqZH7TTglG9
	 GHvaN239LTCRQ==
Date: Mon, 21 Sep 2026 07:11:53 -1000
Message-ID: <2400d4f1f8aa6f94b5e28891f51adefd@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev,
	riel@surriel.com, kas@kernel.org, tj@kernel.org
Subject: Re: [PATCH v2] blk-cgroup: skip rstat flush for cgroups without blkgs
In-Reply-To: <20260921132058.2091567-1-usama.arif@linux.dev>
References: <20260921132058.2091567-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4 with the stray "i" line in the description
removed.

Thanks.

--
tejun
