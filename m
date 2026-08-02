Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E152D8DA8;
	Sun,  2 Aug 2026 19:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785697328; cv=none; b=siVoqC05whZKRlyASf4OW7Lfw3XZF+AlV+/sz3vm0yL7kymwhDa7sEWHLT+/bkuBkhhYr2k3GpN2JZAoYhFeXaI4Wup6+p1qk2EdvRs5vEBfilycNczUh4X4SUYdsaJ+KvQO0izRWFKBMLMerM5lbZdCSQbfeMBK7b0xXA1ra5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785697328; c=relaxed/simple;
	bh=j81PfHVe3b9Xv/5l4yjSOJWV/a6C8p+zEU1hbw7X7hU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=GVeUtpTd7VvYBZo1JLOQlC460eBzf+2nE6tvGCo73b018g726TMBpqI8Rkz36yuJKQgJDbTIFoUkc9AWj7Sc0A3Oly1w/jh1QXoTxZqH7UKjm309MuWBsVOKxq23yd2ze5VhaWxC7LjAVpEJw1x0wEgdo6Z1PoRhx5GW8sbT3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCPbWJl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCPbWJl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A891F000E9;
	Sun,  2 Aug 2026 19:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785697327;
	bh=9LjIL49lJ8GTcSWX4hsT0es2Kgu8LgkuvjJCEEcVoDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RCPbWJl92C/UZ6jd5hlgRofS4KjdP6PawjPlJ2FkMzUqoMcnEJW2DefUrZ11X82bb
	 ifw7LM8rOs+YB8Gz/0Thg4OQfT/UPNxnxP8ZSF7GTsJ9+1GgQRmDGj9bk7QdVAFbjM
	 nxZov1dBSdnMtWvyfLFqSUU95qpW781d/Htm2nXbsDXb+2R4wKCUGHo9BmFaikroGx
	 e9EtY+Hsi3OlxN+AXQZE5d0C+Em/FoO8SrI1Bk90eCTjbMH+I/h49xKKpxh8jmtuLl
	 2Z/t0neqQ+syoycfn8q+ElgQDzbrcsd2U2HGugOARqT7aVHPQd4hmj7lIHH7muwIs1
	 UnOChRCvoe7gg==
Date: Sun, 02 Aug 2026 09:02:06 -1000
Message-ID: <0b2b6806a23aa30ddec65253764bb014@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: Waiman Long <longman@redhat.com>, kernel-janitors@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: drop unneeded semicolon
In-Reply-To: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
References: <20260801191002.1383835-9-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3 with the first paragraph of the description
updated to:

    The trailing semicolon belongs at the point of use, not in the macro
    definition. All uses have been verified to have their own semicolons.

Thanks.

--
tejun
