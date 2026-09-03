Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B94F0550;
	Thu,  3 Sep 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454061; cv=none; b=CaanzQfWjXpOgc/bL1bHSaDtF48y5k+nvprB5SV2rJRUWtHInFPYhY0/0HUiLqxksgsPjFfC88RlFwiXH6zaQCH/MgQ2oer6r/3uL+IfB1KYeXnP2rl/rU4Ei4UUZTf+Ge6vOJvdhlIiv03JhFk4Z1ccEkzBUdDbG2Uv/p3dKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454061; c=relaxed/simple;
	bh=3b5+Cs6CHn7vlf8K9FxlZwGN2oA0XVB0SqwZbE5JOuw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h+mPPva+tDsQxdMdGa8MP+GBi8SVxTV/2M+OhqlydyUJwhMJ59ir2TdMEmoGNJChG9KQDe7QjvVaTtStOSlywPGSo4eXVM6EgLKl9NPBrc/Q49hAgocBl4BRKytUWl86FQ67We/G8XT4siHuFjXlHMzxwlpKtVslGmxIrBYGZnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY77sR/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY77sR/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9BE1F000E9;
	Thu,  3 Sep 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454059;
	bh=3b5+Cs6CHn7vlf8K9FxlZwGN2oA0XVB0SqwZbE5JOuw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fY77sR/qzd6QDrxVIT16NBknECuQOntRjt7sV/MCiCyQbrxCn7gS5tQcIxfsT3a9L
	 wZTH7+YZYhHjYjSjeXOVV2cwv4sMI+Td99wtsDWWRaSxdDiNtqa3Jo2cRFoNECFG96
	 xVswdCqs5hj9MvSW0PmmtPU2mImbX+aqhIcnBVzrDJvA0rmgx6Ig5HXeAsnWhO6HgD
	 HA8cAt+mdZMriARBwP3FxM96MB9NC9xFRPxw4NzQe+GK1SD+Xde/nkVWYobphCunDM
	 QxGrd+6rpxWcvSa1QsIJZEMYc79h48MRFezNq0fLk09u/Jh/TYNnBCG+UQ7Z01vlUp
	 lo5n7NPrNFVLg==
Date: Thu, 03 Sep 2026 06:47:38 -1000
Message-ID: <6c1635e88679a7612ebbd9f0feaeede4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>,
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
 Tao Cui <cui.tao@linux.dev>,
 cgroups@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] cgroup: namespace: drop BUG_ON() in
 copy_cgroup_ns()
In-Reply-To: <20260903064828.126643-2-sunshaojie@kylinos.cn>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
 <20260903064828.126643-1-sunshaojie@kylinos.cn>
 <20260903064828.126643-2-sunshaojie@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

On Thu, Sep 03, 2026 at 02:48:26PM +0800, Shaojie Sun wrote:
> The sole caller, create_new_namespaces(), always passes a valid cgroup
> namespace pointer from the task's nsproxy. The other copy_*_ns()
> helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
> check either. Drop the BUG_ON() for consistency with them.
>
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>

Applied to cgroup/for-7.4 with Tao's Reviewed-by added.

Thanks.

--
tejun
