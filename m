Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32442DAFBB;
	Sun,  7 Jun 2026 07:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780816933; cv=none; b=r0BOeIbzyCKSZnPfewWc/ziVotvq/dlXDg7W4x7gdtuAAoxHuafmH2XpnAGDaUsLv9Z6jkeQHUrzIS7KB4PjPoEDdAtsj6K/7/bxUS2yhmtkigxgvv+z7lAZIu+sIjMhhbR4+CCgacoeTfU1iutc1WYgiOzDRLx58Zt0csETfy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780816933; c=relaxed/simple;
	bh=77vUVBReLj0hE0y4YxlqD0gASb4eaSrhpoOcuiTmtA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfXAnk4izKsgzFdi9UxIUvqvoy4iosH8FAc1omq+WZ4z0Anv1bT4X7lmciLWDU5FGjPe+2sqWNb3lN/KYIq8j7EuoJq3sM5xQ/PauKuG9YW0ek7gWzBu2gzQPBDvLaXIQMZbRoLDtN5H8N771m7QY3Hp6lsrI+YWyc710jKsLxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z03Y2FEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z03Y2FEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219DF1F00893;
	Sun,  7 Jun 2026 07:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780816932;
	bh=Nuzco7IGxuavqKddyKcXIMXeEDthh+2UWERv5CPzuzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z03Y2FEaj1Mch29pSYOg5Li93jqLfUgDDV7tkuRMFPaasz+06uzr3fnLPsCvh4pW1
	 HV4fV3GIn/yq3019PsgiB7ZYjdEWKi74fpxV6xor4I8PPGcEr3BVJFCGYcWDDus1WU
	 r6b1UCk8DHolRXQNZ2tOKHDVVJ22Pv1TMmirnXvPQ4XFw0K6nz83xO0t7HmQBa1PDD
	 L6/VejkjGoxldWsZtc6anVd4VZz70ujDPF/IlLNHk6j1Er9JiVZNN1OqAZvpSCvOkT
	 gU29YJKxvgzNoLtX1YxHyy/eg/PuNH2Tk9MKjjcyr3CHEux2TvLDfdrntUGg+fPObe
	 9HRz3t12jBu3g==
Date: Sat, 6 Jun 2026 21:22:11 -1000
From: Tejun Heo <tj@kernel.org>
To: Maarten Lankhorst <dev@lankhorst.se>
Cc: Natalie Vock <natalie.vock@gmx.de>, Eric Chanudet <echanude@redhat.com>,
	Maxime Ripard <mripard@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH] cgroup/dmem: accept only one region per limit write
Message-ID: <aiUcI8Ecsc7I8N41@slm.duckdns.org>
References: <20260605-cgroup-dmem-write-single-region-v1-1-9137f296579c@redhat.com>
 <271b1c16-3c3c-4a1e-b09e-c4361c63814c@gmx.de>
 <f00e7771-cd70-4c86-9fac-149897e02b12@lankhorst.se>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f00e7771-cd70-4c86-9fac-149897e02b12@lankhorst.se>

On Sat, Jun 06, 2026 at 11:44:10PM +0200, Maarten Lankhorst wrote:
> > As I see it, we could go down one of two paths:
> > 1. We go ahead with the patch as proposed, and I make sure that the users I know of adapt. Could be a bit icky wrt. "do not break userspace" rules, but since the already use non-merged UAPIs in one place, you can argue that these users kind of have to expect breakage.
> > 2. We use the old handling allowing multiple lines for dmem.min and dmem.low only. This preserves compatibility but uglifies the code by quite a bit.
> > 
> > All things considered, I think I personally would prefer going with 1. and taking the patch as proposed and just having one codepath handling every limit file. Just highlighting this so we don't do it on accident.
> > 
> > [1] https://patchwork.freedesktop.org/series/163183/
> > 
> 
> I prefer option 1 as well, but would like an ack from one of the core cgroup maintainers too,
> and what Maxime's opinion on this as well.

Yeah, if at all possible, please drop the multi region write support if at
all possible. This shouldn't have gotten in and yeah it's on the boundary
but the fact that users need external patches works in our favor - both
qualitatively and quantatively (the usage is likely tiny).

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
