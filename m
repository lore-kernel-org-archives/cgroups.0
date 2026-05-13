Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161E63A9D88;
	Wed, 13 May 2026 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698585; cv=none; b=nj8+04PCZvOkkr5xYdVrkNsPgpn/BHrncKSeA8ymD7TrA2HMc1kl5pwz5FqVBjw5WQYJYpxjaKWCpOzD2KfVxC9cz5ahfCl3km7yWdD2jya6mphUhsyI8+P1c9/7l5CG8CRKtX2yMbzx+cWCQ+LowtfzhtsWYVzHUc4i9DmFSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698585; c=relaxed/simple;
	bh=wTrLs54NJavpihFJmz9gK6TVNlsv2cRsIBg7e41SG4M=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=cRJnCxzk0BgXYf8XcPpEzTP88GxzB3LdH9aD3iu+Ryx6cRD4PnatWHDqlLCAmnOCzZT02TwE9bcYs6Gw4nXhIpM9ccdTE+3kmOlCO+Kd0K3YkGqM8u6sjalKBcpsfZBybWqP4e2snODM702QtSqHQ7uZIeVPcZvxdpVCv1fEga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4cJmax4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4cJmax4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96670C19425;
	Wed, 13 May 2026 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778698584;
	bh=wTrLs54NJavpihFJmz9gK6TVNlsv2cRsIBg7e41SG4M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W4cJmax4qpCr8ho3QRHfAOe9TTwxw9iQ73o0MaaFEy9bfV/004IBLkaxRKUmXLZEH
	 pz7AdgKC0dZ+BVFFP5eeDvim+qPfjK827wTfIq4qIe+iNPo5GjmukJNuRKCk2YsftL
	 bSMtsP/yIAuDAWiHrDcOqMQ1YqYPEBHQ7P/uuOZx+tHUxPiUWPMUmFu5FwrCkV1Hxp
	 3drrm6rmlxXgvXqWqyKUomSLaLWZVs+9QKAti2iS/Nts8H/vTS8BqWChGDOnEObfHK
	 3uciQ1ixgofA17q5nmX1VgQGFPeARw2gzQWZcs05Rv9fCRDx0Z4dwxt85zp64IPMBI
	 k7i5M1FvIxwag==
Date: Wed, 13 May 2026 08:56:23 -1000
Message-ID: <2b655b3d0a05c1ea21f39d7b10694ede@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yu Miao <yumiao@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Fix error path leaks in test_percpu_basic
In-Reply-To: <20260513023907.179097-1-yumiao@kylinos.cn>
References: <20260513023907.179097-1-yumiao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Wed, May 13, 2026 at 10:39:07AM +0800, Yu Miao wrote:
> [PATCH] selftests/cgroup: Fix error path leaks in test_percpu_basic

Applied to cgroup/for-7.1-fixes with the following Fixes: tag added:

  Fixes: 90631e1dea55 ("kselftests: cgroup: add perpcu memory accounting test")

Thanks.

--
tejun
