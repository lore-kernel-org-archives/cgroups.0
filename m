Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7676C480DC3;
	Tue,  7 Jul 2026 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783463432; cv=none; b=aJSnVZk9C8uMn2yiQ7q3nVHDPz81KbW/YMqfeQjXsRKsfq6kogNtubMrki0uG0afuHJ0knVIhuxHAUBaiF4tfY2zZzxej1vJv18imaU/AxwqQ6ADxGWHlicQX5LPdaChMYpyEHSJnqJNwV+xNzBK/frHOIC6hwIKEGpfJJmKaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783463432; c=relaxed/simple;
	bh=IGeK+fyE4j0wCGDvO6onUm1VTlMWGJhVl84IsAA4kuo=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=AjQ8f7LxEDkGrygs3Hkwy3ZIctJH/hY0OxeBWnGVxZJL1SqsvFDUcPQqmwhaFUWVqKtAnI9sscFC7sjW8xcOqMBbkz5XRE+ByLtj3v+B4h+dGoPmRxsyo/r+d5o/cvxszklri93hZoxnffjFoEpS4pNdbAHqy98Nag49GhTTils=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPqQ7t4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPqQ7t4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091981F000E9;
	Tue,  7 Jul 2026 22:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783463431;
	bh=IGeK+fyE4j0wCGDvO6onUm1VTlMWGJhVl84IsAA4kuo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WPqQ7t4ESnJ0OWSou9XVyo6TRQgNqvOpj6EwZenNAkFmZXHGURYNHoPnwy1YZxKLN
	 pazKE1g4swX0Qo1QLFgKTwtobpEA++4+5nmIuWw6547viDqCcWlacRpg/w9HLvmjA9
	 g72svX0577bOj9auWbUOitkXNQpo1i8TRxU/0pZDgYoWfKtvJRIrzuXZIFStV8JeEK
	 ZoT1BYLyAwLZgyRtNe4D97rLk2jCdlu/aY1vG0QNJYSCX8dFF/ZB/WJKy7DgdDblXu
	 WNmrzbnyenh+8Y8GW1oyLVnLxeMr39RbeiMDRpGe05KT8SAiVnc7PViQeiIxEhQpm8
	 7iRrijEsHfNSg==
Date: Tue, 07 Jul 2026 12:30:30 -1000
Message-ID: <f68eae4eb38e965331a0aa9306cce034@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutný <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH 0/3] Docs/admin-guide/cgroup: update controller interface docs
In-Reply-To: <20260707102148.692250-1-guopeng.zhang@linux.dev>
References: <20260707102148.692250-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Tue, Jul 07, 2026 at 06:21:45PM +0800, Guopeng Zhang wrote:
> This small series updates cgroup controller documentation to match the
> interfaces exposed by the current code.

Applied 1-3 to cgroup/for-7.2-fixes.

Thanks.

--
tejun
