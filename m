Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EB825B090;
	Wed, 13 May 2026 21:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778706120; cv=none; b=F/2O3vQxeABzyFbG6/zI4TxS/m6FtOADZkGyJsGS7ZTO3xFAvTbhreJWRCFc42R9XOB+ObjRxIx/0UuqjegH/WmUQf5TT9eAS5WpyruHV8fK1oZ6pnC88xZ44/qFpcSMiHJDnrK/24gdlfPsRyMLlLWDQK/1DjFJDx/Re+xbInk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778706120; c=relaxed/simple;
	bh=MefVyzu5xSTXaF2TqFH8xe4uK4dGoM7ULjBiWwjxeAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVwmt9WRlBl7eFtoFOI1udSEF2X7eVUq4zWtdrBMcfVS3UMrWiKmrPxL/DoktN8Tj8ZOwfHtL+iwbqSKlOJarRIwV5TbQ+GD+RDgBAbA8W0LdacpuPNRdCXXZm9BB5CHeolSQRMqD1/Pil0dSIpqcQ9p0zIb9KDmNSKmVhNZtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COTeppWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COTeppWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FE0C19425;
	Wed, 13 May 2026 21:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778706119;
	bh=MefVyzu5xSTXaF2TqFH8xe4uK4dGoM7ULjBiWwjxeAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=COTeppWYpsO1+tl+6pGpHRoY4hemu874+5P+Z8bpvcEjJZ+8wjSD6H78VpfAwCGPU
	 MNHYPT3nYdbz8Q1vFZb5gc9hb5pMQtnfO2a8hc0EsnMxbhNKusZKp2RIKulyojuI/9
	 IXHkU3rt5pV2+ydhWmNki3n+jdnTxBEO27gl46o35s2LfBNRWEFkvB0qOzxwhFeMYy
	 5iTN0pZMVVHUDqcUSmQ+oKQslipbdHvjaK7mUI1RMDM3X16Nz+iez7xb9eQHGTcM0w
	 G5zgkMEt19qIh9XabQfCNuV5BE+lpT9I5942t/HBkYAO66i0uXazbx3lSMtlgmaJhr
	 6818MhA35EXYg==
Date: Wed, 13 May 2026 11:01:58 -1000
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Malat <oss@malat.biz>, Bert Karwatzki <spasswolf@web.de>,
	kernel test robot <oliver.sang@intel.com>,
	Martin Pitt <martin@piware.de>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-7.2] cgroup: Per-css kill_css_finish
 deferral
Message-ID: <agTmxoVWzRn09Els@slm.duckdns.org>
References: <20260505005121.1230198-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505005121.1230198-1-tj@kernel.org>

Michal, any thoughts?

Thanks.

-- 
tejun
