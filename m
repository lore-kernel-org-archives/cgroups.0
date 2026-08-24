Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775424137BC;
	Mon, 24 Aug 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787591054; cv=none; b=Q3hE+5qbcr3Ce4uFZMkmHQ1Y0A/wfGuSl1vT8dVV+oMsvBkH7RkIj3P6veLZ+8dOTN45UeEcM/z/VbS0juJtSv1BMEBbIZCIHOmQyE1G4Fzb77QTNk/EDhzavcXy1meHl/ARkZNFUTcuJw1QfabQ8hFXA7ZE49OKKykm45SE1ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787591054; c=relaxed/simple;
	bh=oFTtaWMnzMpOEE6im6x6ZjGyax/q6imHiGKpOOXG5kc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Vlg2AZerWfQGDXWPHSh/Jmhk6qgMUcS8GHWZuTibVgyqXzr+I2x4i8fgw51yqBGKS9HQhBIcz5jtnjXQ5TYOEuoKPx3Z8M6W6a+gxYrdygIyDGYsp/lTXMb9YKP2RDkwLPHO5x8EunWk4XJU+c1LEVmsa7DZY9rw9lNfoUdpBsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+UX/xTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+UX/xTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B34B1F000E9;
	Mon, 24 Aug 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787591053;
	bh=EMpiPP0SDwY/vth3msJ1f8rYNf9dTRvfdYQQw89ig/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C+UX/xTYjZNmjcsE1mqiCV/03S12fdwJyrJabUeGILuAo/0aCbpgUH251RB4gR0OE
	 a6vQMDBsdQOoUz5aNT3iaIGJlRRZy40IVGjdvnq1uDdJS9K55muekehxN1oBhO39Mz
	 AfPuV6zJvBndWVGG6Mg7Qw/3zk7ur0PUJLpVTMjDFqR9X0zd7kr27jsA66gaNvCU+M
	 hvaDGRiOfp9DvQcWIrNOsZv1YCCJJSDcbnf3JmGFyDnuIzBmlOWP1DqBxJYFZO8SgJ
	 EbUREdRhGyvNuL6YuWOuZb7xzjpsSGYhRADmfbH3hXgsWQ544OuHBIAbI6YR2LKWCI
	 shKECZ7PvlC/Q==
Date: Mon, 24 Aug 2026 07:04:12 -1000
Message-ID: <147b518253c4b819164a9b36827a5c7f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 zhangguopeng@kylinos.cn
Subject: Re: [PATCH v2 0/3] cgroup/cpuset: Preserve boot-isolated CPUs on
 partition release
In-Reply-To: <20260824020140.21130-1-guopeng.zhang@linux.dev>
References: <20260824020140.21130-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Mon, Aug 24, 2026 at 10:01:37AM +0800, Guopeng Zhang wrote:
> Guopeng Zhang (3):
>   selftests/cgroup: Drop invalid boot isolation comparison
>   cgroup/cpuset: Preserve boot-isolated CPUs on partition release
>   selftests/cgroup: Add test for preserving boot-isolated CPUs

Applied 1-3 to cgroup/for-7.3-fixes with Waiman's review tags added.

Thanks.

--
tejun
