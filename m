Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7691AAE28;
	Fri, 27 Mar 2026 20:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642980; cv=none; b=LANr0PIuMXuQwwqAc9aSVth0XHSlA0hq3KQQe/rCPdelYilyRhF/YKqfnONXU/+MGNVaxacarmFJHoyKm1Scbyvdx7L1ClfPyeKHU+BsUqkaA1DjHrxsSbsDjJYs1zysIr1GKTuYDZHakgkxuaDwdj6RL3YIQU5KD3kB6NgHjtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642980; c=relaxed/simple;
	bh=MxC+Xuv4NLv/joNSqRmP6GEKENw6AfHHBXhz0BBGATI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQ/VIf/v7TRf2tQFK+/kj0qBQUZohdUn73HNw/XmcJC415mI2YPqzmvKrCovoZ2wDwkaeVsYzreB4MeSb1AxJc+MPFl54qq8V4TzxTlJUE+B1cW7nJ1G4mwvczidRpnNMGbcnyz4+ueQpUL/uYqi3bSRyv7Ye5j0HkRYAD4AWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cs5btly7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cs5btly7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C7C19423;
	Fri, 27 Mar 2026 20:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774642980;
	bh=MxC+Xuv4NLv/joNSqRmP6GEKENw6AfHHBXhz0BBGATI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cs5btly70FXOrdhUtbcbIZRLGtH29Z0hdSXQr2zcpb0XUx9KhO1KAeKb9ncwIiuma
	 /F3rUyjkRewSJkwVzixqOcpnNmSyn90chxj6KwuYtw0aoG8PALdef4OlVZyc8jGk4i
	 6PE94krFoVhC1JUeQkXEKBlvYdjqja0fNxKoCkHli55/etbOpOu2kmnzoOLbngY6Tm
	 UGgr1rZPVszQTlYJqSTUkG+jQVmccpbXqF667dhV2M0+qzUvHqh0evCr2R4/BZRxoi
	 TAAmQfioHpPAuMFc0w6z2feAqF4gdVkz3eJcdujYPaq/UyORwZgGA/mSZajbKT8lUU
	 1XjZTe0npSBXw==
Date: Fri, 27 Mar 2026 10:22:59 -1000
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Chen Ridong <chenridong@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Skip security check for hotplug induced
 v1 task migration
Message-ID: <acbnI21DC-W_uE2F@slm.duckdns.org>
References: <20260327201546.2463644-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327201546.2463644-1-longman@redhat.com>

On Fri, Mar 27, 2026 at 04:15:46PM -0400, Waiman Long wrote:
> +	/*
> +	 * Set to true if a kthread is moving tasks away from a v1 cpuset with
> +	 * no CPUs
> +	 */
> +	kthread_move_task_from_empty_cs = !cpuset_v2() &&
> +					  cpumask_empty(oldcs->effective_cpus) &&
> +					  (current->flags & PF_KTHREAD);

PF_KTHREAD test seems odd. Can't you pass this in as a flag from hotplug
handler?

Thanks.

-- 
tejun
