Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A573195980;
	Tue, 10 Sep 2024 19:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725996755; cv=none; b=rG2TXdhodrTdrtKQi/QAErR+dRRQQH1WVGwAy1l2s0zAkUUdkD0k2RcRT5ljizeoLvx7FI2yJUUeOpRh7m9kIjd6DRGmafUwmmSR1ToC8DXHRuy+rK9eoQBygee5Hq6BPGJAmBJuTJWv6AdlzMMP662as+5LuR0ZBDEH9h87kjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725996755; c=relaxed/simple;
	bh=8KNjWThaQ/M3fiK1yel9ljDbzc7cSpc+av0Szx/QNK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bgap+w5LfUo1e3TF6os6P+Api+DewHCYaD6F1Tn9E/rthjYKAHcJCQ7m2EQAvKhADWUG4JA2j+PPQXbM013E2BBdTdDjCmsdIjZ6oqp61uGsyflTejV9zwyrPyj5t4QOA5URbD+KyTApsAwvsmaxQOm5NnQ8/6FeSdx+q6aJkHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTU3h1P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTU3h1P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25EBC4CEC3;
	Tue, 10 Sep 2024 19:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725996755;
	bh=8KNjWThaQ/M3fiK1yel9ljDbzc7cSpc+av0Szx/QNK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kTU3h1P1cZjXXQQjPVUPIAi4dUuLWtQzOYk2uZvP7icuLgD1bn9+GoqlGRLpyQKQI
	 Z0j43QFw0pUvoBYi5waO50EYeo9dN5X4omuAC+xDYVmop+kn4NaPF4p1PyIPSOjx+N
	 vNC5j9eVUKL8TYT/ueUQyWrjK6Vcee4I48zg+erA+NGT4H8ARaCg83+qCAtvcShJY+
	 3MBsMI5bUM3ddzNX6QdeBP1NLmzVoSolYnL0W0IC0VixcG1FYEe+YiweDVdKwWDvZy
	 lfLG02SbqeXuKzHfYOcBRmdBmJU26Vn+QoicgXihboQSyx3ZFcrdSw6J4iNbf6AfoC
	 DNUzyOr359Nxg==
Date: Tue, 10 Sep 2024 09:32:33 -1000
From: Tejun Heo <tj@kernel.org>
To: Liu Song <liusong@linux.alibaba.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched, cgroup: cgroup1 can also take the
 non-RUNTIME_INF min
Message-ID: <ZuCe0U1Kwr0hYoOz@slm.duckdns.org>
References: <20240910074832.62536-1-liusong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910074832.62536-1-liusong@linux.alibaba.com>

On Tue, Sep 10, 2024 at 03:48:32PM +0800, Liu Song wrote:
> For the handling logic of child_quota, there is no need to distinguish
> between cgroup1 and cgroup2, so unify the handling logic here.
> 
> Signed-off-by: Liu Song <liusong@linux.alibaba.com>

It doens't make much sense to change the interface for cgroup1 at this
point. Let's please leave it as-is.

Thanks.

-- 
tejun
