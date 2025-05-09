Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685532397BF;
	Fri,  9 May 2025 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746811973; cv=none; b=TWGJVPgxWcSUc/lTYZi4+JESYRShvVESdHHFUM9DkI5UNZ5qjknnZv8xvu0/3KiRsPP6gXHMoMEQxom5lnM9ZRu9njeruMpZ4Tk4FuED+onpqQuiAOwbrze3RZshd68bjTidEgeGlJRwXJ/Yk6aN3FRmjyVtqFO8KVJ8ulQzfSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746811973; c=relaxed/simple;
	bh=67UmMEDOE0G0zLC+dYExmwq2C/6NRz/gbMuVhBj3ra4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nh4wj9nrmuH2iQGf540kLcfP/dRa/WVNl2RI7b3igUSfe08xpTL9+Xil/RIFIJb8o62azes25T9xBHgMA+XyTZnRVvm6f0+CBB9PXIyMYfBviSNDSiGASv0NvkiXOx6c0IXe1gWwYj5tP0XyYUzmhYMPAVeMiWrdb0l5eBmd01o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIz9ZetD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIz9ZetD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C514FC4CEE4;
	Fri,  9 May 2025 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746811972;
	bh=67UmMEDOE0G0zLC+dYExmwq2C/6NRz/gbMuVhBj3ra4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GIz9ZetDBP1/vOtR2drm2KQqi96gkfQIqcfOpVV7Dlij8YYnwgNRfxDCyvtweYVPu
	 YBzDt1488iU3PCfECP6J39x3LJQsEa91m25MrJfWBWNOxJUm5PMybgL5hki26SRiBY
	 V9VAz+s+9oxNTJXXeoyw1zl4aAPOQdJRz6FUp9qx0qgNYkYKMIz615GkgnCuD+ZLMW
	 VSBYisGYfeyxDclOsefJtE1KbXFHd9PUqDdB5DLo4oDqz9H6Q2kBccj7fp1ZQimYOL
	 RgKXtCtdsk0ZQ1nRZ+apofNzK8x15Nkc6OQiORBMPC852fLbAk+V9YnM5bQG+nH8W0
	 d+TQGzjOz3P8A==
Date: Fri, 9 May 2025 07:32:51 -1000
From: Tejun Heo <tj@kernel.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: drop useless cpumask_empty() in
 compute_effective_exclusive_cpumask()
Message-ID: <aB48Qw6-Vmczo-Xv@slm.duckdns.org>
References: <20250508193207.388041-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508193207.388041-1-yury.norov@gmail.com>

On Thu, May 08, 2025 at 03:32:06PM -0400, Yury Norov wrote:
> Empty cpumasks can't intersect with any others. Therefore, testing for
> non-emptyness is useless.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Applied to cgroup/for-6.16.

Thanks.

-- 
tejun
