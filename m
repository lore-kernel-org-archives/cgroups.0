Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A97C22A4EE;
	Sat, 26 Sep 2026 17:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790444391; cv=none; b=a61VG2SEapAmnu+lqIm13f7fM2Wztuc1x9/AtijS7gmD/A2jlJbG6uoguHjkUbbnPAM1X/dYChvwp6bYSBqola5UpxiTgqHK7OCwPgssZa1nnSm82N16vM4W6rZGrfY9Pc/SOiYM+XBngmdxhcYBvNEBAr546t5R8h0E1IlhKww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790444391; c=relaxed/simple;
	bh=6VXBl+dg48Wzs7F2J03HnAfQe99PVhtegOAPb7dVQzQ=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date; b=af6gtkVzxc36imbyeYTeN19+xG94boMjwleGW29V2y8hiHHuruae7KxC5iX42ITQNj1OFTSrn4oCp6RLu8rutytS/ateNqw+nNOi46g3KVl5KYwxognwQ9PbEwirXlaW3EkUmWekGY7XcxaRmiKC0IqrHC2EOfZXT1MwxlFpOPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkZGht7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkZGht7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA061F000FF;
	Sat, 26 Sep 2026 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790444390;
	bh=XhgrofmQAGQvZgR98O4k+vp88XndiOafP36SFSUFMyM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mkZGht7x3yNd3LS6HcTIumQBc4oHtTr5FsserxdVmDrHPqDgV8QzPEWdXhecPQEVC
	 zerj8jXPhpNaPkGzeBDimp4zBwy5xgzypxKNEccZaw0bOqUBWM9LbygLoHxKNDvttw
	 /l1lvQHtq/7eFI85v9XQBaT5s6PRIDG7FOT9/4S7vzAMeP4uSg/Ua67JbX5O8nAiWf
	 fvUinYlzmmXHVvzrD6twYYzeMHf0DZCUjEJfFYI75FeqNDyUkVDWWdPOqn88LreKCc
	 orZhLzHyPBAV5agnTHP7+Nncgro8gykxG4ezRsaMwbqPxeIKXgnWIUugzh0Mv8nDRx
	 gBV+bw0LVQYIg==
Message-ID: <2edc9a06c00cc96958723d0e09803104@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] cgroup: export cgroup_e_css()
In-Reply-To: <20260926063328.257023-2-yupeng0921@gmail.com>
References: <20260926063328.257023-1-yupeng0921@gmail.com>
 <20260926063328.257023-2-yupeng0921@gmail.com>
Date: Sat, 26 Sep 2026 07:38:12 -1000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Peng.

On Fri, Sep 25, 2026 at 11:33:27PM -0700, Peng Yu wrote:
> The nvmet invokes the cgroup_e_css for each bio and under
> the rcu protection.

cgroup_e_css() walks up the hierarchy to find the effective css, and I
don't think we want to do that on every IO. Can you update cgroup core to
track the effective css in each cgroup and make cgroup_e_css() use that
instead?

Thanks.

-- 
tejun
