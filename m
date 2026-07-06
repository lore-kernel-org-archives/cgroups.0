Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0440E3D811C;
	Mon,  6 Jul 2026 19:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783365912; cv=none; b=O3EyCQwmxzSVdBeY88xsie7Al9RT8TBE/ItMnLbEDV9MDsWu0qXi28RZ6hARGPfTPd6wm3au8atunphuzQN1wEdwYgLBemD3U/Af3bYwRytBEgI5mRJd2xwurqOfK3vWqBMWfRGKqy/w5+bzSY/j8iaBgH1tobSGC/5mgpNcLzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783365912; c=relaxed/simple;
	bh=JeP+SfukuBwOqjun+wT5LvNkpjB19xTqoJZuLWWpF14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JM2mkVEciUNH9b1hlWbibOa9J/5ugWhAb0nfxONV1J6ko9/WgGlC59GU0fj++FfVaBFYuPJTumwRf1NnGr6fO6nJB2oBRFXlFhp5d2tCICpiRqHj3M/o5l6qMVnLIw87XDUK3Lq2Dzv8iNIgeOhh10Ixn7t+moN8of5I/XaGEDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJ6k21O3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJ6k21O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D231F000E9;
	Mon,  6 Jul 2026 19:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783365911;
	bh=u6Ou0jbsdMUOvdHXYTkqyWBUsmGQD9nbdqqr1UFdWDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GJ6k21O3aLYCNuYZdTOtBHnjVXv/pe0UdV/Lc9MyMQv3HtYcIoQhUXqfWzMizCkvP
	 lWU0cLU78OXeUOjZjAU3cpK52hRZ4JRIqFth+2DjhHQQBYtmyrlpAQ+6Dtwyg3ZcDP
	 nu7itkPJ3bzH2PYkoKq6HptUbsDvF942k1fF+XOcKUqE+EBsDqWak0ae86rXQqzFuv
	 wUtNBUbJCpVZ3sXJzSAAx5mhKvdf/oz7LXclw152Vq+gcV/tCrMuNZ4k/t9riXn9LR
	 GnbTfrwT3jPjdVbgmq5HK8a/+xpXOVTjrbBQXdLnyZDxNaliTrbxG0jRYTBf5yyGvN
	 e1KkYjuXt4l0A==
Date: Mon, 6 Jul 2026 09:25:10 -1000
From: Tejun Heo <tj@kernel.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Natalie Vock <natalie.vock@gmx.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona@ffwll.ch>, David Airlie <airlied@gmail.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/6] cgroup/dmem: Add reclaim callback for lowering
 max below current usage
Message-ID: <akwBFlw8MwhrwsRu@slm.duckdns.org>
References: <20260703130541.2686-1-thomas.hellstrom@linux.intel.com>
 <20260703130541.2686-4-thomas.hellstrom@linux.intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703130541.2686-4-thomas.hellstrom@linux.intel.com>

Hello,

On Fri, Jul 03, 2026 at 03:05:38PM +0200, Thomas Hellström wrote:
> Also honor O_NONBLOCK so that if that flag is set during the
> max value write, no reclaim is initiated. The idea is to avoid
> charging the reclaim cost to the writer of the max value.

Is this really necessary? I'm not necessarily against it but this is trivial
to work around from userspace and feels like a gratuitous addition. What's
the use case?

Thanks.

-- 
tejun
