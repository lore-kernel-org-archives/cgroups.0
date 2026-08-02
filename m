Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64703002B9;
	Sun,  2 Aug 2026 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700376; cv=none; b=VvGp80Si36PPdA32xdYlgnjBNkHaNesU586MW7KMuosSstb6kGXtAANZaMUheYyKLDGoqPwkIXwvNBzExmnTFMnsLH7N8wOSqBuyUcOtfTcEi3ogIZrImVEDoi8YmIMZ3O9/uogzZIe75TZUv19uz54MsyFq9Q4ZW0/EkBFCsQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700376; c=relaxed/simple;
	bh=80f55MEymxJ97xahmuJNfm39fzyieNdHdP5Dzw2Po3E=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ewWZ8KDZs5C3CHXMAMQvolI8+tzCDC/FZYH6/vviO8DdeQn/SsSKC0GVvmSiOPaEla95OUbuwnKW/Fn9HYCRa+7oxSir9gFNVXm7dM0E35xLCbru3kk6yMCc88vWGh6dkqXTh4xSDdH9rNyB+a3tT4Zq7HZ6hfWMvwRF+0SlB5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrLw+Dhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrLw+Dhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227AB1F000E9;
	Sun,  2 Aug 2026 19:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700374;
	bh=80f55MEymxJ97xahmuJNfm39fzyieNdHdP5Dzw2Po3E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HrLw+DhcLDZqpKcSVtt0YzF/3MKEvRCxlmxZxO9x3X9goVJLj1jT5bV99ebwS7IFE
	 +bksg0TR3JdbGhm2Nu3wdiJ+KXSojbdp08nSnAecr5Yu3JHDrfLkTMrlqkYADU/VJu
	 kZmrHfot/hNnpxjvYup3wT4KFE3t/NMLwl7nFdXgZwfZw/TfDrNQeAuNcYlsx0O9vx
	 +rP65cQsEQu3ZnH51SrMjouaJhIsFOwMLNC/ZCxa7EMfvitPVt7mSCW3XsHMnD5eEA
	 URz1w5stMckDsolMhQDb8xrTiDKNj7v4HcRLxjurq4to+fVVJDly2HmD0ticBmJwDR
	 SrLLC0hX4BdLw==
Date: Sun, 02 Aug 2026 09:52:53 -1000
Message-ID: <67759a7fcfb75858ffa0aeef43977f59@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: mkoutny@suse.com, hannes@cmpxchg.org, shuah@kernel.org,
	cuitao@kylinos.cn, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: add user_usec sanity check in
 test_cpucg_nice
In-Reply-To: <20260730130717.1236233-1-sunshaojie@kylinos.cn>
References: <20260730130717.1236233-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Thu, Jul 30, 2026 at 09:07:17PM +0800, Shaojie Sun wrote:
> In test_cpucg_nice, after the child process exits, user_usec is
> read from cpu.stat but the value is not checked. Add a sanity check
> to ensure user_usec > 0, analogous to test_cpucg_stats(), so that
> the test fails early if CPU usage wasn't properly accounted.

Applied to cgroup/for-7.3.

Thanks.

--
tejun
