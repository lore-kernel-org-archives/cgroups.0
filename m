Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868021A445;
	Wed, 18 Jun 2025 19:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750275927; cv=none; b=d02qrQHrSNMBhhgtmfcwHO/r2ArfQ4XBkOzkjrzX5fnu/rdjsYX19y/6yIPblnwCvqiP9YAPnWMAsV4z50sObDkYlzqXP5Af1tmCPzEZ8EaALmG0KPFa5bUZoyJYmi7olassEIyvnUyjn5iYJ5TGaS+ogiKNvGE3QQrKLurKS8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750275927; c=relaxed/simple;
	bh=00m/WV2STTJLUzYZUgLmAymPAtTfGkUJ4LXS3ZO+rQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGqdsnxEhBFmJNR/ofoZBMXUs+LPZedVZSzF5nIcT187sKIFbL2XD/4FSzXZPeDkNiGx8lJRJLLXuceUX6rSACncRJtx3t6/GdWnvzpX2ojFzUjLRbvAzoOEQjfJ/+ggS24AwVgAXbyVth01tgiAVbY7UoIaJnwfHdRQS845xXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnl2Qoi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnl2Qoi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1880AC4CEE7;
	Wed, 18 Jun 2025 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750275927;
	bh=00m/WV2STTJLUzYZUgLmAymPAtTfGkUJ4LXS3ZO+rQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lnl2Qoi6dscPBIEU91p0b+8As/dQITRwP0xMjzX/dmdldNJHcVtmIw6gOUtiZlcnT
	 m2poOqZ4RuJc0DGvWSRITu2gnELCthzf6JS6xQm9Q6+xkZ/Gpy0hxbngc1RcWZf1TT
	 9FEO6uyAGOVfNYLucgJOgOnmZ/h/BvDsEqUei53XvlCkKCRa/z2+uCQCMu7MPzYnNq
	 32BwwClZXnf++rjHU/osrlavpdZP9tCUycWZ6NXYkjqD14KfNnVjh6VCbW0VCxnNOf
	 s+GiS3Jr9u2/sI0s11vTDt0+ugzQ+zUBNwVRK7VNd1NipEh5BUVVD4ZGK9h5p+dU03
	 rNvVzAiTGUUpQ==
Date: Wed, 18 Jun 2025 09:45:26 -1000
From: Tejun Heo <tj@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, rafael.j.wysocki@intel.com,
	mingo@kernel.org, peterz@infradead.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huawei.com
Subject: Re: [next] cgroup,freezer: fix incomplete freezing when attaching
 tasks
Message-ID: <aFMXVsVKX8RAIYdD@slm.duckdns.org>
References: <20250618073217.2983275-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618073217.2983275-1-chenridong@huaweicloud.com>

On Wed, Jun 18, 2025 at 07:32:17AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> An issue was found:
> 
> 	# cd /sys/fs/cgroup/freezer/
> 	# mkdir test
> 	# echo FROZEN > test/freezer.state
> 	# cat test/freezer.state
> 	FROZEN
> 	# sleep 1000 &
> 	[1] 863
> 	# echo 863 > test/cgroup.procs
> 	# cat test/freezer.state
> 	FREEZING
> 
> When tasks are migrated to a frozen cgroup, the freezer fails to
> immediately freeze the tasks, causing the cgroup to remain in the
> "FREEZING".
> 
> The freeze_task() function is called before clearing the CGROUP_FROZEN
> flag. This causes the freezing() check to incorrectly return false,
> preventing __freeze_task() from being invoked for the migrated task.
> 
> To fix this issue, clear the CGROUP_FROZEN state before calling
> freeze_task().
> 
> Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
> Reported-by: Zhong Jiawei <zhongjiawei1@huawei.com>
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Applied to cgroup/for-6.16-fixes w/ stable cc'd.

Thanks.

-- 
tejun
