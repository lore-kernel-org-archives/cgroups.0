Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21991336885;
	Fri, 17 Apr 2026 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776452617; cv=none; b=VMLuQz0EGtSHBumJTenxt/++tNScedxElNsN3dxSJ7DmHd1KpSDvHvMLHQ6HPZydoMztMrGyY+maThTdbQFt8M3BaAD7YBMh4uadtqv+oASxkuq5qmkziyISAOj5RqmXfuLIALBk8NKh0OR2iDQ47/5LwmyWCxXBpggc0yiVWKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776452617; c=relaxed/simple;
	bh=tGJfU+st4c+IvAb9jMxieKe2Chz2L7uF5SmgG3NCsJA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=RHK20YgS/7mioKVBaQlrdWIxrx9tUN9DG3zDcdzJf/v62SBgHwlQLYNj2Mx4GDOpJR6EukQRmu8QTzOQqEL+3BAsEsqFjg7JeuoF1xMgYN+Ep1O21528M4p1sVDIVea60Wx7OploDgayB0dsD5a4wc1myWk7zaH5e696JBjW/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xo/UdkuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xo/UdkuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF99FC19425;
	Fri, 17 Apr 2026 19:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776452615;
	bh=tGJfU+st4c+IvAb9jMxieKe2Chz2L7uF5SmgG3NCsJA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Xo/UdkuQR/6vf44xljKkdORs9J3vy3xXNg1Lr1i4ykHFLDeylgf6KtjAoeBIYSbgB
	 aG2bjtsSb+oD4PboTRuW9jcA6VvLFvDqDEFE4FdoSNrhf7/TaK4gXh9m3V/DAhpMyJ
	 C8RT4YKSkRLx29Z9tseqxJ4XdXWh8sxAQwZctdtnznKOgWlom/fFnUgFmORcgGYUaH
	 RQ7RFYfPYUxwUWlnqt6uVrBTEPzZGUIw1e44/13Vbn9/J61Eu1tM7EWa8w6+6IU4GF
	 jvlQ0giswF+gCcq+rigCPNh/UHVriomHb+rCiMyuDFxh3QUnT61DynmweAgc7uC8cm
	 MMP8RAdQJ5g3Q==
Date: Fri, 17 Apr 2026 09:03:34 -1000
Message-ID: <3bccc1e5c1f5518cd140245956b0360e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: longman@redhat.com, hannes@cmpxchg.org, mkoutny@suse.com,
 void@manifault.com, arighi@nvidia.com, changwoo@igalia.com, shuah@kernel.org,
 chenridong@huaweicloud.com, cgroups@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] cgroup/cpuset: fix DL rollback accounting and add a selftest
In-Reply-To: <20260417033742.40793-1-zhangguopeng@kylinos.cn>
References: <20260417033742.40793-1-zhangguopeng@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Fri, Apr 17, 2026 at 11:37:40AM +0800, Guopeng Zhang wrote:
> Guopeng Zhang (2):
>   cgroup/cpuset: record DL BW alloc CPU for attach rollback
>   selftests/sched_ext: add cpuset DL rollback test

Applied 1 to cgroup/for-7.1-fixes.

For 2, a cpuset test doesn't belong under selftests/sched_ext, but
selftests/cgroup doesn't have the machinery to host a sched_ext-based test
either, so there's no good home for it right now. If the rollback path can
be exercised without a BPF scheduler, please rewrite it that way and resend
targeting selftests/cgroup.

Thanks.

--
tejun
