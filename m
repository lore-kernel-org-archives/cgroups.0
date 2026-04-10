Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE41D33D51B;
	Fri, 10 Apr 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775848446; cv=none; b=snc6LrG/JENC3ME4r3h2fQ3XDJ6Ovoas9oGG0LHKrw+fdDtAixx47D82SwEpagibDIfBqvAt5oOPyAYdyNr2FmEfgbLlG/hoy5kBH8Ng4Timi3+QzlQjdS5ygN+i8oMnI85DSxkD6DWW6cGf8ivwa1GGrcNtGStcWQ8gQWCaPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775848446; c=relaxed/simple;
	bh=kev1Y9d1IaYRLUIqEs1w6qDnHancs5KYjE9sWMg1L5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkXyRLgMvY8xnpZr3CxSpWz8/UNAV9f4FnVb3Zc6aKO3P+xU2IE0ZBu/myWRvCnLBM2YvbOZBGId/y9MQy8qWXwsNwqncwchSKgd3GF9aAZ5uiwLopojoNKfrL2qwoOvMnZ8DSQiD8yPKgqVXdE2i6/SfcAKPOOVQHNu3TI2rCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nytV5s2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nytV5s2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4EDC19421;
	Fri, 10 Apr 2026 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775848446;
	bh=kev1Y9d1IaYRLUIqEs1w6qDnHancs5KYjE9sWMg1L5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nytV5s2biuAZjPjTTovN3EJl1z+4XLWO8NDmDP5WR+k+w123TeeXCVo5ZQi79gWK3
	 tj6dtQHD4mF5/vW19aJ5s0W7PlanvfGA29lFEwueOJ2Qxbb9q+XJ9YoJ7c3wflOeJs
	 SGvVo6v11CpRFthvh+hk+TLZLb8dFH4MH314K5LjT7BsyhaM1EhktJZ0Hfb6hK4gqp
	 +0LXd3sNs6BmG6/MxwpOe/PbtNLOOY+yGs0YF78J8gnRLZbLPtKB7pqIXZSuP4ZO3w
	 225PddvEC146EvqQPvkIjjTb9GFtlxa82hz0LG7o110Hs1+YG1qc8i2yEPAwD+lko0
	 kqaC1YzhL9tfQ==
Date: Fri, 10 Apr 2026 09:14:05 -1000
From: Tejun Heo <tj@kernel.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: cgroups@vger.kernel.org, chenridong@huaweicloud.com, hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org, mkoutny@suse.com,
	syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] sched/psi: fix race between file release and pressure
 write
Message-ID: <adlL_QXVAgCBH9L8@slm.duckdns.org>
References: <tencent_90482DC16CB494F8EB1AEDE6CDD87B3A6F0A@qq.com>
 <tencent_6F3C1F36BA97BA37AA4A2C7403766F675A09@qq.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_6F3C1F36BA97BA37AA4A2C7403766F675A09@qq.com>

Hello,

On Fri, Apr 10, 2026 at 08:39:45PM +0800, Edward Adam Davis wrote:
>  static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
>  			      size_t nbytes, enum psi_res res)
>  {
> -	struct cgroup_file_ctx *ctx = of->priv;
> +	struct cgroup_file_ctx *ctx;
>  	struct psi_trigger *new;
>  	struct cgroup *cgrp;
>  	struct psi_group *psi;
> +	ssize_t ret = 0;
>  
>  	cgrp = cgroup_kn_lock_live(of->kn, false);
>  	if (!cgrp)
>  		return -ENODEV;
>  
> +	ctx = of->priv;
> +	if (!ctx) {

This test likely isn't necessary but that's pre-existing.

> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
>  	cgroup_get(cgrp);

We don't need get/put if we don't drop the mutex, right?

Thanks.

-- 
tejun
