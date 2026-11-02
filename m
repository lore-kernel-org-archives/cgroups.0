Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606680;
	b=xINWoqEShLNG/YM7rHsP7S3xVP4n4H4aG7ja6FD9JRGtQObiC7Z8tcPTRyd1SOmVbVyF
	 jPGGnzQbwFkqwmPiyHMLleSSrJ86vi/rsA6lg20WguXaDVVceOa44Z1HbZ3aFsv8/TbWZ
	 5vjIm4yklabn5HjNgDPhREhG6Jv0qxQzlzTTxQkIQcY/8DY/oWb0ItQnsIKJLG9LA2a5Z
	 zZoLM/o8hLfaFu9y7eLfyc9DZ5/Nl+6xTQeCLuWHZ+QZvRmhxg9uhNfjtC1m8OMb4ZvIG
	 5nKm6lkuDqkAtJWJ9yKzQy+ZZVZas0Z8FmVDeiaQ/4dnsRRxRanSczs0dWOeppmH9cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606680;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2L+ohgxyjbLh2g6cH+17iLDMyNDlNDzKguTVvdoexPA=;
	b=r8Y3XWe0H4WHCNhYJjLBAEpm7M5NTrNufJXbNpS7f8xaAtf4mVdbvRw4KC3iWZN50IkL
	 SWRO0wQoUIj3yyjjZG3bQ0zgeOfnWk5zskrj2L9O3elqQp2GvBTAxfKJO2ZkVQ/xxOmSp
	 oGhx0oFTDZ1AbI+r2Eg19zHW1s3KY0xdI95vvudl3y+2s3SOq6PdND2VdGrd2UJTdEcJN
	 KEnfMfS8cgvdFI2MKmIHz5gxJszXDsti3IGpqZzrg/wUhvp2tUEeFPJrYddIEpsTMn8ph
	 KgKUkZtSreg8NUWBzKqDTZ+0Rykgu1cyV/JlJlHBXhCP7cSfxwdPdygtZzuqI8Tm//g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RT2oYpab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01743606A324;
	Mon,  2 Nov 2026 08:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RT2oYpab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7583B1F00919;
	Mon,  2 Nov 2026 08:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793606679;
	bh=2L+ohgxyjbLh2g6cH+17iLDMyNDlNDzKguTVvdoexPA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RT2oYpabxXY/4vMDFJ+vIncngyCnSSTQb7Ezv7/QHraEgmTlhwJKluwQ4ntwq5S6u
	 ia1bNFZH/fKhmhaR4es0Axs/ufa0kn8FhIlRaOEKp9+K9u8EzXRtuH4djC9cs0clQg
	 oRwff6/j/JEGD/v9fO/ELc0cDEb0ch+DZH4IMiQK8acuVjeiSxANhXMCCqScCkQihh
	 MjFjd4avOZVEj1lhAbNHpNZ7mSM91cqe8HnHXsRBa9hWUP0nY8kVmwNC9ID4RC/RDv
	 Ab5CuVJzHi39gVG0lqlzmxvN6P3d9zTGv/oPHMQHrAo65mndf8hz99WN2e5+vJDULe
	 Ad40IQP3tohig==
Date: Sun, 01 Nov 2026 22:04:38 -1000
Message-ID: <886a562b52b1c5094142d547a8336457@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH v2 0/3] cgroup/cpuset: Fix some more bugs in cpuset partition code
In-Reply-To: <20261030190701.78308-1-longman@redhat.com>
References: <20261030190701.78308-1-longman@redhat.com>
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

>   cgroup/cpuset: Fix incorrect CPU accounting with parent's
>     effective_xcpus expansion
>   cgroup/cpuset: Recompute effective cpumask in update_cpumasks_hier()
>     after calling update_parent_effective_cpumask()
>   cgroup/cpuset: Do housekeeping check when isolated child with root
>     parent may get more xcpus

Applied 1-3 to cgroup/for-7.4-fixes with the following tags added:

  Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
  Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Two issues I noticed:

- Three of patch 1's new TEST_MATRIX rows end with A1 as a single-CPU
  root partition, which has no sched domain, so they fail the ISOLCPUS
  check when the script runs with -v.

- The comment at the end of the "partcmd_update w/o newmask" block in
  update_parent_effective_cpumask() still says there is no need to
  adjust the parent's effective_cpus. Patch 1's new expansion branch now
  does exactly that.

Thanks.

--
tejun
