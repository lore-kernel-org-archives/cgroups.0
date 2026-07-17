Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C248339B41;
	Fri, 17 Jul 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309023; cv=none; b=FchXGXXjWdN5xKkVEvTCdQ+azmnj0bEWCJL5uk5XqUYU2ZyAXenPkID/ZLS6+worhvly1Fml11g26V74xqd+gO0hg8mwM5R/CZmf6kHfvSOfiRx9rDdw+TCqsi6MyQYwK4KOTM+/6FvMdWOOoap4BS0MBLLB0x0LKRqUM0LsaHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309023; c=relaxed/simple;
	bh=OHU1Dt6rnLky5d4YYQ1SB1DFpdaduja1T91LUb15Ff0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=lP3RtTUN9eqy8HmpqivPQOHnpoaXRDv2gDD+0AxJUWqZUQ+p6211gjZBEQFvX0mcHIr+9PDpRbu2IGHcqDRo9N/IwFG7bTa03qsagaZ5RjRQQQYE/WmIKzQUkGoReKYuU6chzIHYKcvvB6d3qAW/ip0A1QWK/dlxyGtHRQT2jsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bx4kdARn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bx4kdARn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8231F000E9;
	Fri, 17 Jul 2026 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309022;
	bh=mhci8qXePtrkO+jt3cGA7av3a3lIPMRjLuMwgl3RWSo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bx4kdARnzqbjooiiq6Y3TouaaPSKwxa78AZAyoxYAP5ClTcArt3+DSRiA+MuG8FGx
	 qYA7SUz8T4ThNF3XfkuBj1F5Vb6YBfQ6e3hlS7uzJ2grhEWniLMDZUpxeCyvuLWFQz
	 keEjqf++YO6TmU2dNNJIk166OPkn9wfJB4Zwf25KXW84FpEBc8vn7mv6JbQT27Misd
	 xav9XOca3QDJjTQ501n+XpxXhdAMnHyF3dfbPnswl9ZzAwA6d4EO4P751u9Rxl+WnX
	 Z3+79uZiQx8kfpHZgXXSm61hh7/1HMbaKTEDzxjo4yHw71iPYlFdZ/ewdPQwGI1433
	 M3peHhw0dnbPQ==
Date: Fri, 17 Jul 2026 07:23:41 -1000
Message-ID: <b1dedf3df2c26540c3b44359acdf7e22@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Michal Koutný <mkoutny@suse.com>, Tao Cui <cui.tao@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/2] Docs/admin-guide/cgroup-v2: document io.latency
 rotational vs non-rotational behavior
In-Reply-To: <alpADmJBLHpHAS_G@localhost.localdomain>
References: <20260717060225.2019764-1-cui.tao@linux.dev>
 <20260717060225.2019764-2-cui.tao@linux.dev>
 <alpADmJBLHpHAS_G@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Fri, Jul 17, 2026 at 04:48:40PM +0200, Michal Koutný wrote:
> I would not bind to the exact value in the docs and put the explanation
> to the "missed" stanza.

I'll wait for an updated version.

Thanks.

-- 
tejun
