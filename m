Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE8544E055;
	Wed, 30 Sep 2026 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755904; cv=none; b=afmKHM3B+O92utvLp/37p6Is9OcAmwIhHc6W/ZPdV6OSHhPIn6r3oe5+TrmWkrsRZXp9L85KwlS4zR0ar3Nzu5P5e5SgFvJhQ7ORi17vgcABgJSyS2Y2GX+DeIahiVDuhhqqKFNvaYwywzdjZ5rgwdVIDHTaCXDXwMA1OSc29a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755904; c=relaxed/simple;
	bh=n6LqOCOL05LpmXLjZqV2F6/Qv/JfqGYo6fy5jnfWq9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfO+XjFUGiV7Q39+YKcC5l//+c85FZlBifs1nizzemk8VHpz84seTJgDvxs/IWYGAd+zHHQzNPLK0uvBK92BklgGJxHPBVM76AQ8cSdCRPkUGQIXrOkMdVifogMclzKje/BBzjioNkMH8zPKS1Uwp71zHv/p5i2t09xzq/7SQLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nw2M0uL1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nw2M0uL1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n6LqOCOL05LpmXLjZqV2F6/Qv/JfqGYo6fy5jnfWq9E=; b=Nw2M0uL14wIlEsHYUYs6yOzm3j
	+dKb5C0Kk3YlSidiL0Ba6JIcuRbWgH5asWlAeQ6RCIgUTxc8oiYwiaW9pTy1YcjraqGOvNuLBHXrR
	o6hn63cIpymrVnr+g8y2G3DqDw/KecId2PjM7AdgZpUfR5cMKrxcl+ElFJk6DeoSaXvarakfuClBG
	YUcAa5vqwPJiKioSUMjpt7VInDRpT/eTyDtuCJbY8saKmkBDjg9R/pkGHuEeyyQRGAmJTC7023SEp
	jLgLIIH8diWHICjaA6J7xsH8JAQC+ZoUOPBCRIWTUGyGPSuAfv/Z09DwpiGj9al/luT4ysuuPEirh
	s3odEgwg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1xBpPT-00000003Vu7-3kBu;
	Wed, 30 Sep 2026 08:11:28 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B93F4300673; Wed, 30 Sep 2026 10:11:25 +0200 (CEST)
Date: Wed, 30 Sep 2026 10:11:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <longman@redhat.com>
Cc: Andrea Righi <arighi@nvidia.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
Message-ID: <20260930081125.GF88198@noisy.programming.kicks-ass.net>
References: <20260929084124.626693-1-arighi@nvidia.com>
 <20260929084124.626693-2-arighi@nvidia.com>
 <20260929-making-language-254d9c6a6605@there>
 <af938567-01d2-4518-8f7e-974828e25d3e@redhat.com>
 <arv2-3-6-Ewv0gpb@gpd4>
 <b8f66cbe-bb1e-4148-b2e2-55bd95f1c8d1@redhat.com>
 <20260929190853.GE88198@noisy.programming.kicks-ass.net>
 <500cb19a-549b-4055-a807-c3c40da787ae@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500cb19a-549b-4055-a807-c3c40da787ae@redhat.com>

On Tue, Sep 29, 2026 at 03:46:23PM -0400, Waiman Long wrote:

> The cpuset_v2_mode mount option is only for making the cpuset.cpus and
> cpuset.mems behave like in v2. The cpu-cgroup and cpuset-cgroup can still be
> in separate hierarchies. If cross-cgroup transition is the main point, it
> won't work with the cpuset_v2_mode mount option. We should switch to use
> cpuset_v2().

Yes, the cross-cgroup transition is fundamental to how this works.
Without that you cannot reasonably talk about the CPUs of a cpu-cgroup,
you need to have cpu and cpuset aligned.

