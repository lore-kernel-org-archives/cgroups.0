Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E623358396;
	Wed, 25 Mar 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774459820; cv=none; b=qfTE5m2Yw6lv7L+yjhzcT16g+/Ja5mTEHvPyG+J9YDbNcgLGP6j27gGMy6NjwaePlnAqsGG0/t5oINT20N0S/WrY3q/R+O+6ObyojAxefAre5oN9gEsU58qF8jCl0cj4J1rSRr7cRU6giDUHCEApb81KwsSmeEjaQdY4AaBnimc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774459820; c=relaxed/simple;
	bh=zOI9GZI2n3CyQFT3K1N1BzSlK56JOnhMJVh2CZEhibU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SIw85kCbbMcpsmV14tJzOtCDcZbwcL/DBExm8y0+fTFwEOqiDgEr3jncP0I3s/3sZoDeJIOJZMnni/2r7DhTvx3gsl3Tb/rmTtSutNAy7U5/FzoJQcX56I7CCriZj+RNn/2P67LVevsyWPKGEuNRMBlNRQvPGafTBYfi2c4CXpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNn7qG2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNn7qG2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F8DC4CEF7;
	Wed, 25 Mar 2026 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774459820;
	bh=zOI9GZI2n3CyQFT3K1N1BzSlK56JOnhMJVh2CZEhibU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PNn7qG2rx2MvQDtIJsO+hgOeMPkxWNbnefHuh+KMTULERgWyDkvmDBQeF9YHIn5dT
	 GkzEf3ppyqTZV/kzXQjh8SHRyNH2CAx+RvCe9OU4ONdBfSzsOQ2nxHiJpq1PvqXWF0
	 zz6VXxp97NLp3SCTauM64jmglbqqNsR1eKVnLzUVDLzv5cO1048fPamuP27Nwdj4Xz
	 seFlz7RnTk2bX5aSm/5vmYzGN4zZOwfOudY/ZtmLJr+0ZbEEX9ngd0nzCURAhYyI4B
	 BR+lxgfIShL7IjlxH12WXRy7azBrhH6vpn6CPp8dTWOTISn0WUv+xgtUd/qjRYsrV6
	 0kWq8fde1wo4g==
Date: Wed, 25 Mar 2026 07:30:18 -1000
Message-ID: <9b3d00b53a91c592e07cb1c8d2eca15b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bert Karwatzki <spasswolf@web.de>,
 Michal Koutny <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3 cgroup/for-7.0-fixes] cgroup: Fix
 cgroup_drain_dying() testing the wrong condition
In-Reply-To: <68d8881fd985a410c0f619f009334c28@kernel.org>
References: <68d8881fd985a410c0f619f009334c28@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Please ignore the v3 tag in the subject. This is a new patch on top of the
already applied v2, not a new version.

--
tejun
