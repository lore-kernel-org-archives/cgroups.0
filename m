Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C673F9A0B;
	Fri, 21 Aug 2026 19:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787339693; cv=none; b=davGzg36A0ajtiSYu1ZICBgKF2iuwAwvhWMtcy3NqKTxO9RnBBAKCkKmvYBZpGhpI4nqNzEOAddwz7BZDUon7OT+GUIUKYnF8ct7hHS9Xp6qEllI6HAB4srXOJ8oqAGahSRPlOMz+O7OaO/6Syre/8zFN0OKia5IbIwyvrO3zIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787339693; c=relaxed/simple;
	bh=AHZ78J/jdqJKDRZZX0e5eRNA+CX3Mqn2fRrhkMhXnVY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Xcc9/0Gra6Ac7qF4YdFrDw+TZMak6EJJlqZ7vfxkxw4mTRpIF7Ole7dzFcnL2f87agcO0HY16faRUd4wuEatSK9LgIkgQMQR2T9ELFU1923IEqaqypHEo1UYSrxmtCyPjjfRwpSG5QuA/0omg0Cg27Y3dWNRDVnkQXmBi40mK04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXaZ/gSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXaZ/gSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8001F000E9;
	Fri, 21 Aug 2026 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787339686;
	bh=AHZ78J/jdqJKDRZZX0e5eRNA+CX3Mqn2fRrhkMhXnVY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RXaZ/gStHdGcS4pps/13zxlpsYLmiX59pSek/ap95VIeGmzZC8vIzCxpIblqicyVa
	 EUb7R9Es4XuM3WLfTKWPAJ+ho2ac2AJMmRD0LB/XprR0qErvRBOBNE+oF5HxQBp1ZT
	 J0dvCJ6Oab3otKsri2V/VGX/5eSVSxzOprAET9KujjOKk0KEDQe/xHTskRI4S2QmFD
	 ZWlLrQsK+ZoVQxWmj7yT6Q4v2xGyrIdj6tCxn1IdgNLE4gn4gidV8GkY4dFY9cIeFM
	 vVdpsH5cI/mxrDnhtofdreKr9KUrwWWisOUZ6JEPjWvYabPQ+ZAeXPKC3jheTvi8Vk
	 jBitfWypOFW4A==
Date: Fri, 21 Aug 2026 09:14:46 -1000
Message-ID: <85217eefcd770d6e4e0ffc6048e14a9a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 muchun.song@linux.dev,
 mkoutny@suse.com,
 shuah@kernel.org,
 akpm@linux-foundation.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg
 parameter
In-Reply-To: <20260820070944.31451-1-hongfu.li@linux.dev>
References: <20260820070944.31451-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3-fixes with Michal's Reviewed-by added.

Thanks.

--
tejun
