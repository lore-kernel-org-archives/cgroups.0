Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FDC3C73F7;
	Mon, 20 Jul 2026 07:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784533260; cv=none; b=GaxRyPDmUR4igm6YTyTGducdar7fR7diDA5UD7n0MEtGgUX7Sdj3dRHXLJ+9oCN/PZJw9y/53k3K2y7iUqxwRrpptcGG6Fh3FdAHkzU8t/acpFaoiwaklDKWZQZqzxz/9MkrLdyiZKFAduycYtj6GtwWSG5faT+nVT0eTapDSPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784533260; c=relaxed/simple;
	bh=SKNpSl5Qy1kWHXmO/afSd6Bdt/vK3IOAdbZwQLkQjLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PG4kPUB/ML2j8sGb+TDwseSHCJn6YWlXj5mY3fGs9AbMnY869yoEXqiMZXicOMKbBH5EWsCm1vN2TpHPkMD8JJO2E3QDOhf7qXdpm1QDiEqJTUuIa8dsAaojVVnbF95uc1W412eSzmVqqb/Fl0bvWEa8zgokSAfYko0aN+i1zMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQbsCe/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQbsCe/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899E71F00A3A;
	Mon, 20 Jul 2026 07:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784533258;
	bh=7h2oV46WmfewbLsUNGB57fnvExAtqs4/sZj9YHeIWD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PQbsCe/4kizuPPjM/glzO+IONFKBPxBaferEb8MMnWZgZ90U9IxA6xtWSQ+t/w0N2
	 OfZnIvdfgZdDDzWEkKDpFx/Eap5kuahhoHL0b/lVbMlGjBqTysXlHrd7zJQUYe3fhV
	 LeEqT0/J6yfvsYeLq4fCq3kpGbJhqORxxgvDzl15+OSmNiLx96Ww1klWzSpZZEXuW0
	 Xs5L+i4LxqFYFU0xtx4PTk/AeBna/pMvYzQN+CcPow+A0ehK/FegEPlzdrqoLUZtzA
	 pH/81uSqBKnGzLWjXPHLTMXBtAsSIj1Fmiz06+MUah6T8kcvJ4Pq4MriigNVrZjVXR
	 3UDbWH0u6cnVw==
Date: Sun, 19 Jul 2026 21:40:57 -1000
From: Tejun Heo <tj@kernel.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: David Vernet <void@manifault.com>, Changwoo Min <changwoo@igalia.com>,
	sched-ext@lists.linux.dev, Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched_ext: Re-home tasks on cgroup migration
Message-ID: <al3RCfmqImr8mNaN@slm.duckdns.org>
References: <20260718081727.582037-1-tj@kernel.org>
 <20260718081727.582037-5-tj@kernel.org>
 <al24GoeqoJhGS4_H@gpd4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al24GoeqoJhGS4_H@gpd4>

Hello,

On Mon, Jul 20, 2026 at 07:54:34AM +0200, Andrea Righi wrote:
> Should we add:
> 
> Fixes: 337ec00b1d9c ("sched_ext: Implement cgroup sub-sched enabling and disabling")
> Closes: https://lore.kernel.org/r/alnxrsexEe_nQwqL@gpd4

I added Closes but skipped Fixed. The feature wasn't complete anyway and it
still isn't fully complete (the restricted affinity problem still needs
solving), and there's a lot of code churns and dependencies inbetween. I
don't wanna tag Fixes and trigger stable backports.

Thanks.

-- 
tejun
