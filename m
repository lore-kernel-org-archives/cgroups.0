Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793039221;
	b=jyTB3MeUQ0IMYYjbJIWAYs3c1NEPOnmFn8vtSxBCfbgS030rxdhv/PHq8+bBJhajQbrs
	 6H7TxA6Gf1QMTlGEpoNN0blJQlUhtKqR+lrVXcQKSIqvRPtFbyVp95mbPPFPSce7zd916
	 THvr9cXTDCCFbV5X6uCzbVTvVGeHfWcRkh0BVkEn2HpmI8b6qm+HYLEwdSqAYPaI+Cn6E
	 oZ5DUlLI0J4euAYfMJYpMkNhhITyCnA/HjGkKq5lspsdg2Ux5m8ImaEmfsb97EvuxuUtF
	 kPrXHJa9EdwhuQAhj1YlHlLvjskA06WMMWoSjJxLwKdXpUh7/fHtIvquYOcNuHM32wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793039221;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gmGjTOcwCQP+x5rWVLuBwQSCtTyjHX1UkLBLw7X91GY=;
	b=1B/hfJUfH9BsJRWqMLlfPqXd5pIqHEPBfMGmIH6/m+zJIggegqLaLZ68L3kiySPemoCe
	 Nh0GI4cfA2fVnffsX4vABl/RkkNyXOXY8nxiIRqF2xBlHVGDI7qJWiKj51Nza+QsPm9Nm
	 Pvf6AB9UUWfu1V1x4HpsJv/jfAW/YMOo+Knw6yuFIGMYLQ048KEj6Ob7TssuT/zZwvvQV
	 tvBDYLcNaJJXsuPBUhAlrC4oOSy5um4+EQnrgPZQxp7CjCzXI8kIiH3EbJRSj4dQRUjLk
	 hmwxDA+yp6X19VDH8uKmh/N3gc1NmLYP+nQ2WoZ3+/S9+SLTL5mlPlkWrtHO6vI42XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jcj5fpo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C42606A31A;
	Mon, 26 Oct 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jcj5fpo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7E31F01825;
	Mon, 26 Oct 2026 18:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793039220;
	bh=gmGjTOcwCQP+x5rWVLuBwQSCtTyjHX1UkLBLw7X91GY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Jcj5fpo54226qhZ9Y0V+ZJjRIMBctGO4K0pTFgDZJmZOuhbYjOt1MwAL1+5v7elaI
	 w4cJ7kyeDar25h00276YpvQ/rn+gMmu5f2pSNQuGynDaR20OxHAs+1xXcR8Jq88hT9
	 kAdC89oybheUlgh+GES2r18nwsd8ooF1R872qISexoSaKxqnjmoxD8uEO9PBCVfbrA
	 m7lc3bjQX/VbOUr3ACAT8Sw15BSzWQRRRfcNO4BkhVC/rGerAqesJ77108AartTM8r
	 sf0TcWchcUr7x94Pr393Nkljrivt1ZcvlFphKwdloM+RqILNlHcf7ct+FCFprYu31B
	 EPYh/T711R39A==
Date: Mon, 26 Oct 2026 08:26:59 -1000
Message-ID: <5e2e1243e837e2b73dcfe8217f521b0f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>, sashiko-bot@kernel.org
Subject: Re: [PATCH-next v3 00/11] cgroup/cpuset: Miscellaneous bug fixes & cleanup
In-Reply-To: <20261025214449.310715-1-longman@redhat.com>
References: <20261025214449.310715-1-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

>   cgroup/cpuset: Find furthest isolated ancestor for invalidated
>     isolated partition
>   cgroup/cpuset: Properly compute effective xcpus in
>     update_parent_effective_cpumask()
>   cgroup/cpuset: Fix incorrect effective_cpus bug in
>     update_cpumasks_hier()
>   cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()
>   selftests/cgroup: Check for a single range nohz_full CPUs before
>     running test matrix
>   cgroup/cpuset: Prevent recursive call of remote_cpus_update() via
>     update_cpumasks_hier()
>   cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only
>     called for valid partition
>   cgroup/cpuset: Release invalid isolated CPUs in
>     compute_partition_effective_cpumask()
>   cgroup/cpuset: Release invalid isolated CPUs with a shrunk root
>     partition parent
>   cgroup/cpuset: Relocate compute_*effective_cpumask() and
>     compute_effective_nodemask()
>   cgroup/cpuset: Integrate compute_partition_effective_cpumask() into
>     compute_effective_cpumask()

Applied 1-11 to cgroup/for-7.4-fixes (9 as v3.1) with the Fixes tag
dropped from 5 and the following tags added:

  Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn> (1-4, 8, 9)
  Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn> (2, 8, 9)
  Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn> (7, 10, 11)

Thanks.

--
tejun
