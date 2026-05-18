Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF9B38236E
	for <cgroups@vger.kernel.org>; Mon, 18 May 2026 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132704; cv=none; b=ktWzswmax0kBXSd+ozFulD0w4QdZrCZninsgwKKeuQ9nx8+sAGISkItVyHeATAvemClApDg54ew586icC+nM01fkHxmzhygR3Xo6APb76c47tNIVjObcxpNHhKTR+eZ7dtWqKT2ez7AQchDRaBysHQUgQ2EWU/frdWNergLRdxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132704; c=relaxed/simple;
	bh=a9qOPPQYY4qXhSwEqg53rkjYr/e7ZHzt53P4oBBXSO8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To; b=fnSpGDTJ6adTB169Iwo8ScQ2zV6i0a/y6xodvEUhCrCq7eNx/4l4c5ES6avpTN6eiiJbMZ/qug7FAGZWCGCe5usul/pO3Vom+YnIuXm0tYuntMEFRjYfbruDJvbfiWPUlSNfeG8OAZ9/6o/1RUZU24Sd7lshcpgdOrMteNvT7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKxu6o4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKxu6o4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66FEC2BCB7;
	Mon, 18 May 2026 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132703;
	bh=a9qOPPQYY4qXhSwEqg53rkjYr/e7ZHzt53P4oBBXSO8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=GKxu6o4mR9Rc3Um+1fFNi9egVIOFzmN82fgPR7euZrBrFzJrkk2PE3m6fySEcx/Sw
	 YfWpxlDjjk5FMGmrafqP2MnGvoDkQPayKwySwubzjQV/kXerlFXfrcW02Ip6wjOwcb
	 6vgGD/tii5towLNC/V7IauYG2XuITBPmsSqCoaljGnuLU+ostFpKm1ErGwebEbJxS4
	 9wcWTixE0NVPLqN2ueRTN2zDV1OXygg1K3ymMgnW9UL2DMpzeqwRFIoRkiXJJZok/C
	 jabtGRh2lbwq2v3YSrnabuESv4d+yGh3/JhWG5wr5kCXOYGE+x1+SEPliS0REprKae
	 fZQ4TUVo0wE+Q==
Date: Mon, 18 May 2026 09:31:43 -1000
Message-ID: <c591dc1a28e7cf20789003636e51dca1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org
Subject: Re: [PATCH] cgroup/rdma: drop unnecessary READ_ONCE() on event counters
In-Reply-To: <20260516052537.450732-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Sat, May 16, 2026 at 01:25:37PM +0800, Tao Cui wrote:
> All accesses to the event counters are serialized by rdmacg_mutex,
> making the READ_ONCE() annotations unnecessary. Remove them.

Applied to cgroup/for-7.2.

Thanks.

--
tejun
