Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CC53911C9;
	Sun, 31 May 2026 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780247347; cv=none; b=ECOSVK4fVYG4oL8fN2ugB/lbYHBdgNfbJdRYbjfoSmP9FytVD50irPsOIuUt3blzAE65iPEuAr8BGmyqDPrrRq7smX9Chl0Zj61adlQD1u/e/r/fi2v/TZXtFJBxEaixalSxjxjLXs4zrUZu3nl81qBw/raNnOaUJu/G7RMpRm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780247347; c=relaxed/simple;
	bh=SVEJL4GEwkXkrp6OsZZkCybl5z2/KKltadlzYqj29wI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=uGew4Z0169J43ksRPKFjHo9U7K22extxftF3PWoxFdQOf7ng4Em4S5m5SV2aTQDSNBlPi5yX4w+GGyht0qD9KdiXjBlD5u44l/vgQ7gnnYSyeKX67m2ps6kgkQsKDdtwbTfoVUj6Y8aSE4s5/0xkY1jRklW+3GZyNXx4n6VqVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIJE5abn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIJE5abn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897FF1F00893;
	Sun, 31 May 2026 17:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780247346;
	bh=SVEJL4GEwkXkrp6OsZZkCybl5z2/KKltadlzYqj29wI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VIJE5abn5CItq56HmUAdW+Knc3RYlzlx17YNtux49HXAuFoZ5mrgTdG42OZxZ20XW
	 zfe/XXcBnZAMbDuWNIh2CNnXDOB9QtCMdDlORVJtZiOa2f7KFhI5ZsQ+QVbwgrokbi
	 BzQdroh8CHBXMyQ3RM0lCTErePv+oXad+PA4DrKKE12M79hS8nnabqO++Ml7MRi/jk
	 876Tt8TcYO/m5XbWAShgoX2dVkCpKp5ZTSaTG+RyLOn4z/pw5g4lqnxYSW32tuKZuN
	 +mnja4ml2mMwSkQo9K2R6ai1tO83yq9cgZQdfdMLSgaVA/zzJIh7+CVm7vpe3MfznR
	 Eklpd0LVEZ1Rw==
From: Tejun Heo <tj@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>,
 Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Natalie Vock <natalie.vock@gmx.de>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6] cgroup/dmem: implement dmem.high soft limit via prioritized eviction
In-Reply-To: <20260531-feature-dmem-high-v6-1-20563ecd6dc7@gmail.com>
References: <20260531-feature-dmem-high-v6-1-20563ecd6dc7@gmail.com>
Message-ID: <20260531070612.GA03193@kernel.org>
Date: Sun, 31 May 2026 07:06:12 -1000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

I don't think we want to define dmem.high (or dmem.max) in terms of a
specific reclaim mechanic. These interface files should express a
generic resource-distribution concept that stays valid regardless of
how the underlying reclaim works. As written, dmem.high comes down to
"evicted first in the high-priority eviction pass". It isn't consulted
on charge and dmem has no proactive reclaim, so the file does nothing
until a dmem.max hit elsewhere triggers eviction. That's an
implementation detail, not something I'd want to commit to in the
cgroup interface.

It also reads as a way to work around dmem's reclaim behavior rather
than a soft limit in its own right. A dmem.max hit doesn't just fail
today: the charge returns -EAGAIN and TTM already falls back to evicting
buffers and retrying before the allocation fails. So the question isn't
"max fails immediately, add reclaim via high" but which buffers reclaim
should target and when, which is a property of the max reclaim behavior.

If we work around that with a high knob whose meaning is the current
eviction order, we bake an implementation detail into the ABI and make
it harder to give dmem.high a proper soft-limit semantics later.

I'm not against a dmem soft limit. I'd rather improve the max reclaim
behavior so it makes sense in general, and then define high as a concept
on top of that, rather than the other way around.

The whole max-vs-high distinction and what a soft limit should mean has
had a lot of thought put into it on the memcg side, so adding the memcg
folks for their input.

Thanks.

--
tejun
