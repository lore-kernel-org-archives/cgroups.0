Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F927FB0E;
	Thu,  1 Oct 2026 00:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813432; cv=none; b=jqKAlg7PdY6rFkjtxnckyGGGFNI7JA35Yq5zZQHOKl38dWOJ2U0AEtZ74/3Fyh4+dOmVo9r6vvIYpl3J+ovWYiAYNAmof5aPxg5Cp3ViLoBnvQPNaRgy2zjEvdDsaoyGJRm+AF1ya47LzPoRfEXy4gmReQT3QApB7v8H81PxKqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813432; c=relaxed/simple;
	bh=XjuAiMJAztJgCiIgOl4hFULrXpXad2APogIOYNOYV3A=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ckHA8DOjW10gV7YrfPICnxn4UtmOyMSXy57mPw8bPRN6B02KaPQaX2Fy8Zm/FlLNLEICXeIWy1q88t1JNR87GDCav9pPQlkn/+Ur7iEH089tjgKlEwFvzkIf5+sqtwETCVB2SUKohzcCTpL8hzAPdFE80l5bgjgImgOgMpUJKQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsQ+GElA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsQ+GElA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FD41F000FF;
	Thu,  1 Oct 2026 00:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790813430;
	bh=KIsuxP3W6/YmQbOsjJsgRMYI7q24H8jtnrb2VGKi4Us=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DsQ+GElAQB9GLk9GDe2qfYQjwA0YSgqbBlAPiZtA5sMJV9rqVr6d6XpKgEWvYjfQm
	 LeKRI6PTrDiTD7JOXnyC0yXOCQ9FwHNSWK8aG9MZ7SqScw9p/7fB50eRHPcFUFtsxs
	 qVo2RQC1Jv01SIN4uQFqtijm2wRoWvRQSXf5oUTV0UYy1ETt4ZtkupKFttONp64C2x
	 O3O63PJwfajSiCpFxMxfASxepbcNtycvzsY6/NnuP3N0NfTKJIN7mqU8smvBBCL2RT
	 j8rEJslUAkLZ6Y85gp8xhY5sOqoL5aXXnajA+ZZaF87mWp1SPq19IQezGmD0HJLqwF
	 HcIqwr0RztMUQ==
Date: Wed, 30 Sep 2026 14:10:29 -1000
Message-ID: <fab12a20719cfc85160709675e7af5cc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: David Vernet <void@manifault.com>, Changwoo Min <changwoo@igalia.com>,
 Waiman Long <longman@redhat.com>, Michal Koutny <mkoutny@suse.com>,
 sched-ext@lists.linux.dev, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 sched_ext/for-7.4] sched_ext: Add
 scx_bpf_cgroup_nr_cpus()
In-Reply-To: <20260930090049.1035813-1-arighi@nvidia.com>
References: <20260930090049.1035813-1-arighi@nvidia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Wed, Sep 30, 2026 at 11:00:17AM +0200, Andrea Righi wrote:
> Andrea Righi (2):
>   sched_ext: Introduce scx_bpf_cgroup_nr_cpus()
>   selftests/sched_ext: Test scx_bpf_cgroup_nr_cpus()

Applied 1-2 to sched_ext/for-7.4.

Thanks.

--
tejun
