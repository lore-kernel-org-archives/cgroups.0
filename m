Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F354F3BD638;
	Fri, 28 Aug 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787943219; cv=none; b=Z4pbBNS19nCk+SnogNOL1JeRn0sqHQ7zfq9Hp0VEzj11sh08ef9+H7A9QCI3x+APj/pxNzWzLJU6jnWlp38A/22bwGVGJ3OxDLjxc1MJ9scn9gV1M4lb6mTuZcMkgvxi/gslQoFLEkWr3mUwcp0ke1cfmLuLyVKDQcHqg46184o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787943219; c=relaxed/simple;
	bh=NvZ6zF6kTuMB9njp0C1XvnHSNiEPGgZyGxCgECFMZWs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=qkdOqNTVne5Nh4vCdotQha4lOaZDl4+d/6tmA9m1/UqJIoLLhfuLa1vWRIX8tlBE/aQZOLEF2SLQxzOM/lYpWF81Riwk3+5mZjxvtPcNOiOq/y3hXWhVkw8lfP5UvA2I+2kIOOpSWceEUqyeFoE751I1u7sygnRTE9xX0MmB9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z0hlIj1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z0hlIj1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA4F1F000E9;
	Fri, 28 Aug 2026 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787943217;
	bh=B9mdNfhFcUO2gJ0ktoY/zaGQbPahFjeEg5bz/X1VOZA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z0hlIj1mp6THUJEgNkV5IGHjWaaFGD20ZZqph4GrZV16OoVYRFjB42P09sbRzr6tC
	 mGilmF6zeByyib7ZNL7MlsbQ7Ib2e7S8pM6l2c6XPq+rprEpRwNg72OqVKKEE5qSS9
	 g536fmH75N3r0a608t+GaPafLgU3nv8hP28sIFbE=
Date: Fri, 28 Aug 2026 11:53:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?ISO-8859-1?Q?"Michal_Koutn=FD"?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] selftests/cgroup: fixes for test_zswap on single
 core VM
Message-Id: <20260828115336.6ef439268af56dce797d2aba@linux-foundation.org>
In-Reply-To: <20260828033741.2184560-1-wfelipe@google.com>
References: <20260828033741.2184560-1-wfelipe@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Aug 2026 03:37:30 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> This series fixes two test failures in test_zswap observed when running on
> a single-core VM (-smp 1) with 4GB of RAM.

Thanks, let me queue this for test and additional review.

There might be an issue on 32-bit:
	https://sashiko.dev/#/patchset/20260828033741.2184560-1-wfelipe@google.com
