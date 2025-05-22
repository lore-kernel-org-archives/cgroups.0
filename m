Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C085654640
	for <cgroups@vger.kernel.org>; Thu, 22 May 2025 01:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747878951; cv=none; b=RiwAUBvX7bjy2UmOpIITsYREQkOAcEQREaGJkV7hHXL652jL8uzdJJvx71mp7qHhTqkovtmlza8vZ/rutcpDoeVNML8BRrwFk8aSRp8ohYIbqZkWH8n29K/exhulBIYPHUlP2pIMFXnhe4b4lzunPdmP36ayUxhlizHL4B7ah4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747878951; c=relaxed/simple;
	bh=D/XieUwNrYeDo+GKSdl8qxo6d1tieILHG7g3I2qJ6Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZwR4AXSIabFnUhG5/RmVWY84KvbYonE0p+FmsjykXAGDClt5sL+pNmE4kaUrQluhFHAj+Bw+2sIxZFV9uubduIqS5Y3SGAL5YM2AqwB1D9R9Kbbv79M0gnID/7R9rm7BZqZBNTXsJcUtdfFCXGNvEfXsMFdaKtOLPVWMFQkbZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDGlgTnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDGlgTnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F1EC4CEE4;
	Thu, 22 May 2025 01:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747878951;
	bh=D/XieUwNrYeDo+GKSdl8qxo6d1tieILHG7g3I2qJ6Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rDGlgTnkXiuY9KvkfEDU0gx8sbwujdppo8tkrsV3bdTwU31apa0+t0Ah81F5pgQ4o
	 O5lCPMGUzM7nGqbAXJFzs2iHmeIVyfxJVSiz/eaq/YnMEBGY+6gzw2PS0H8oJKYKht
	 u0gdNsQIkCy6rGlZCHR1dd2XDCj9iLx5uffqQP1Lto8CRzyabZxkP1aBYDtB0Rgyed
	 7313XDwj+8BfZEtXXMM2+hHDaNK5P6LGprrtj90SLYEZc7wiNQpyvuJgmWDK4hMJBx
	 WRx4zIG+BqHwyqf/VxvJiinFWQA8gZiqzU0lLb7ebYOGSJGAOwxCkyU+rhTrOEMXeE
	 qS5Kyms4a3FDQ==
Date: Wed, 21 May 2025 15:55:49 -1000
From: Tejun Heo <tj@kernel.org>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: klarasmodin@gmail.com, shakeel.butt@linux.dev, yosryahmed@google.com,
	mkoutny@suse.com, hannes@cmpxchg.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH cgroup/for-6.16] cgroup: avoid per-cpu allocation of size
 zero rstat cpu locks
Message-ID: <aC6EJRUDPMoMA6Y3@slm.duckdns.org>
References: <20250522013202.185523-1-inwardvessel@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522013202.185523-1-inwardvessel@gmail.com>

On Wed, May 21, 2025 at 06:32:02PM -0700, JP Kobryn wrote:
> Subsystem rstat locks are dynamically allocated per-cpu. It was discovered
> that a panic can occur during this allocation when the lock size is zero.
> This is the case on non-smp systems, since arch_spinlock_t is defined as an
> empty struct. Prevent this allocation when !CONFIG_SMP by adding a
> pre-processor conditional around the affected block.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Reported-by: Klara Modin <klarasmodin@gmail.com>
> Fixes: 748922dcfabd ("cgroup: use subsystem-specific rstat locks to avoid contention")

Applied to cgroup/for-6.16.

Thanks.

-- 
tejun
