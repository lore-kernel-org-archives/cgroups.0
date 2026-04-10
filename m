Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5F13AA4FE
	for <cgroups@vger.kernel.org>; Fri, 10 Apr 2026 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775811254; cv=none; b=QRMZeN1HlUPcHuuIi1nlJzcJm3+20bj19GEptrdIgiww0Hv7nhoQIAVVpQbrLhOUaCE8zkjyGq2vFwUzKAmILR7Z9froPfaHwVWGY9JWrP4hxF0rSwjaf/sdI9eZvJfboTbxjI7bGC8cO8W4TRCSjFyUgF/J47uHrJgoC+B6eb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775811254; c=relaxed/simple;
	bh=PU0Z+l/L8EkFgM8fWTr/0CHrDJyAbsZsILrA017p6Yc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=jhilHgfbhz69tadwIfAa9T1c9JBZGzBVbLtEgdUAgvzRzSQ7X7LP+qu5YRvaDMRO21JCy7gSY8H+k9ELPs5rLF50tmTQ5tIRMbKF2nm14PfoXwh5qxxgZCCHficVgvvumD7MXwKACxa37o1OlNu4InLRgtbSd3dv/hyPYbn1gEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHoiU3pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHoiU3pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2AC19421;
	Fri, 10 Apr 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775811253;
	bh=PU0Z+l/L8EkFgM8fWTr/0CHrDJyAbsZsILrA017p6Yc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aHoiU3pnuSYAk3brQtLUnzS8StcqB//li1o+Tr0o+BCMZPPFn6oaCtO0aJjD5Sr91
	 yHk7nGk9EWExv96Qd5bUyOiJQsW0yLqipT15rkgXOUlwaVB9Aareea7Zsf/DnEP2N3
	 1oFUYMhFKAz4lYMvpkjdOmQKe7RJ96S0lcbBx5NrmRLHheSGPAmlv4un50cGgUC87w
	 ljOuqa6/XmuZGdUxd0jSILTTc9mlA8ZXsY4JTAMvXALXmd4R5YFRDhu+4+kEufjU6H
	 eNHSGYCkZMFe7/Yjvt/cDhy1OCYAFCJlGTpwydBVzKIP4Am8xKwVUteEeSZ2KJwQnX
	 nIekTXkD9ttgg==
Date: Thu, 09 Apr 2026 22:54:12 -1000
Message-ID: <d5e8c523fa7dcab3b870c7cd71e42cd8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: cuitao <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org
Subject: Re: [PATCH] cgroup/rdma: fix swapped arguments in pr_warn()
 format string
In-Reply-To: <20260409052135.37811-1-cuitao@kylinos.cn>
References: <20260409052135.37811-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1.

Thanks.

--
tejun
