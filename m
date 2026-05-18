Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F21EB5C2;
	Mon, 18 May 2026 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779147622; cv=none; b=RMqLS3pTwW0/WXLHIfwkJL3Q5+o8vq2DbiCT+UxjNeBNEiMDaQmDVvTea5w7a9UVv4yKawordS4z7459EYIIguSsyakYOvP/z+dj/p2jLx0fPwXZ9y/aJ0VrNf1UK54LYtoVjkQFRfWqlffNbucWzjTGgwY2xybmQpzhEKirN4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779147622; c=relaxed/simple;
	bh=C+JMDHUVVD60YcGR5zmrR9UL2s11oEuADwRAF7SCQWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuszwkLe9Edhl3OwfCTbBDPkXXZonuI/gjKnXTxUeI6VygOGyWUgqHot9NnmdYXZsCCY7i0J0yfNCv0kjMibn772NiuRPRnI9mNqOKGgju2mns2il7iTCF4lJlS/H/XRmtPQ+w/7h4jDKq2uqGIgO/H7noTkSX/oP9m120VfJdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+qmVCE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+qmVCE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC47EC2BCB7;
	Mon, 18 May 2026 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147622;
	bh=C+JMDHUVVD60YcGR5zmrR9UL2s11oEuADwRAF7SCQWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+qmVCE/3+9Znr3QmO2vIumpfiUM6icTB69SyrJ9ZYeM+2i3C/j+CGAFqyhQQwTQs
	 /xY/55qNdEkUeyVVj8FroHP4h2/bbJuJ+J82p8nSNslAZifUst94LkXHdmD03AQBiM
	 RIqMwWoykmJwf5qGtTs3UmkBwaK6xOVDJv1KpbGmKq03E0MWjKLXKoyXbO//NdMub3
	 SrrlVqM+/xZl2cM5NRqdd9PZ79B9wZlB1PQa2myFMucvBw7ed3TbrG7tJx480iY10O
	 Ak3CTyfHHx6KaXiuiM6JmnT1MUEjRWAUsRX7fVwUADqzz5C4u10JtVzLXhIxy1+LXa
	 ySbcTli2Z9Xvw==
Date: Mon, 18 May 2026 13:40:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qing Ming <a0yami@mailbox.org>, Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>, Hao Luo <haoluo@google.com>,
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/rstat: validate cpu before css_rstat_cpu()
 access
Message-ID: <agujZIpmHm8n6-ox@slm.duckdns.org>
References: <20260515122952.59209-1-a0yami@mailbox.org>
 <20260516070849.106141-1-a0yami@mailbox.org>
 <64f59b64664f769661a8b8cd587c85f8@kernel.org>
 <agubZePrBmStHxhH@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agubZePrBmStHxhH@linux.dev>

Hello,

On Mon, May 18, 2026 at 04:07:44PM -0700, Shakeel Butt wrote:
> On Mon, May 18, 2026 at 09:36:36AM -1000, Tejun Heo wrote:
> > Hello,
> > 
> > > Qing Ming (1):
> > >   cgroup/rstat: validate cpu before css_rstat_cpu() access
> > 
> > Applied to cgroup/for-7.1-fixes.
> > 
> > In hindsight, we should have added a separate kfunc wrapper from the
> > start instead of tagging css_rstat_updated() with __bpf_kfunc directly,
> > which would have avoided the rename. Oh well, it is what it is.
> 
> Is it frown upon to change the kfunc signature or remove __bpf_kfunc from a
> function? I am assuming we can but better not to, correct?

We can. It's just a bit gratuitous and causes unnecessary churn. Let's just
leave it be for now. We can clean up later when e.g. more meaningful
restructuring is necessary.

Thanks.

-- 
tejun
