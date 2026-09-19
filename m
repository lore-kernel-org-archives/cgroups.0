Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC50368D40;
	Sat, 19 Sep 2026 00:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789779287; cv=none; b=q83w4uw+nM068vrIPS+6NrbALKzV3/cCh2WMzcpnidm4V7aZB41LDYDwAE6UpQdNtLsc98YIVZ5DDFLe12pOT/PFG8wZm+OJZUYSP+SXkzzRtsNuX6B3MtoBC6jB8FGt1PZfgPcvqrGFD6QNwGQc3Vv5TrAbDaq2MpLIpvJBy1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789779287; c=relaxed/simple;
	bh=IwBsmTUbuuGAia1irSsv7QexvDhvkp9EOgiEBMMJjBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyxosv8wfxBORZ0GBc8ChK6HfdLmYE6GcIhagEWMFVZ4D2HtSr7b1WXlyQ1nd7l+PH4WL6xVDnqBRACLdgtEGzH7JP3EM4jVQJQ+fvjAD3OjnsUtX9wh5x5NmpH/G/4eov5XB9PGJQPJjsxMbyUa78uw37lg2lkYhlfZDq3Lfg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbKXm6GM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbKXm6GM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2445B1F000FF;
	Sat, 19 Sep 2026 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779282;
	bh=rj4ybuE76WuF89f1n+gXLecWdMn9NDviS9spf9nLa4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbKXm6GMPcpzlVpDWfLpRuHsropA3OOvGBk/dC9HOxo9dJIshBc40hoFsxVom6EQh
	 cX0dSOe7uxseZ1viRL9fHJXKX+sKtLgqSgo/UvXHXQBRLToZ904Hov63N3XncL8oIJ
	 oTQDxDWDvz0Kad8zgq4+9b7u9b6DfDL662O8adLCMtTSNzUdO64vcu7LvL6gyeiE3g
	 o2q47THez9vdeDOWen3+xn2E7BGB8qCK+KCB0tDzkJ5oeQhTCAwcTgnXEw3OzEGojz
	 elp8IABXkmM/W/vfVbnxCxoPZ+I8ckrWKtE4zpBboHALfO6iNJOh7EHKDkp/Xi55Xn
	 LLQrpdbz3/sJg==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 1/2] memcg: remove unused page_memcg_check()
Date: Fri, 18 Sep 2026 17:54:34 -0700
Message-ID: <20260919005435.87535-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918165601.1014666-2-ekffu200098@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 19 Sep 2026 01:55:57 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
> avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
> callers.
> 
> So remove it.
> 
> No functional change.

Nice cleanup!

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
