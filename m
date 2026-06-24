Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A4308F26;
	Wed, 24 Jun 2026 20:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333195; cv=none; b=jKd9i1gBiwgMYlwOOPAIuB3hlmZEoCjVI5couTylbzPEqPo0ahstFTC2Thk1LWX3jC/4zhfgS9uEQRRSBsM2rP2XnWYBfGKciPNaeB2mSJy0DZAJcpuWBcy6PmanvRVNJBG1MbP+4y7d0NfBzFE3avNJrpjFgelHETgHQ7Cd9ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333195; c=relaxed/simple;
	bh=quBsAGvcYsSCgnkwdbNoJkYFKOEC802izVMjR3799/w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Message-Id:Date:
	 MIME-Version:Content-Type; b=Bn3wreEzQYLWDtxveGUmmioV5u1mvWTroe4cmkrzKaMvpnKjaBw//WOMJ86l5P+IEiCjYu1dW4p1YW7SrNGaPpbLS300m73iRt6ACzLoPiTGYntX3JFdsTvnbrQBv+3Z5DZvf7IPUrYXPG0pr6hrnxpwimnYQqOKDgfzsM7RzqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n12ytX9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n12ytX9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6041F000E9;
	Wed, 24 Jun 2026 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782333194;
	bh=sNbg4tuYvmM3+Ihbku9IYrXjnBwh4AlGNJ0Hy7sTAPQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=n12ytX9bp7B7eI5XhPx5eIpZyFQBjhoN9SxthB7R+cVXD+8iRiTqgmtRKLhu5HQwR
	 ILrBypL56rtKgZ0h0CkPGgcBSk+PoaOuFaNF+5NmG7piFQ8j7cLl/a8wMUOIIR24IQ
	 mhB7PwPrxUVmbTl8WdQ6XL4zpeDjXWZZcMLbWtT22Yy29vThSv1BxGSJexUfDJK3H/
	 uhzKGgGUtbgNdXdiaXBlM6qbwRN0QyWfPGUmvfUFY04Nkz6EJEqfcne4v0V9rvs28V
	 lS27wM4uRi88V7upkRFh/+K5k1FGnV4j3yALm+A0Gdh8zDHD4gZYkzDO9FcRNY1p23
	 duMatNWv8327g==
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>, Tao Cui <cui.tao@linux.dev>
Subject: Re: [PATCH] cgroup: Use READ_ONCE() for task->flags in task_css_set_check()
In-Reply-To: <20260623022946.525885-1-guopeng.zhang@linux.dev>
References: <20260623022946.525885-1-guopeng.zhang@linux.dev>
Message-Id: <20260624202644.877fae40488c@kernel.org>
Date: Wed, 24 Jun 2026 10:26:44 -1000
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 10:29:46AM +0800, Guopeng Zhang wrote:
> -		((task)->flags & PF_EXITING) || (__c))
> +		(READ_ONCE((task)->flags) & PF_EXITING) || (__c))

This only feeds the CONFIG_PROVE_RCU lockdep predicate, so it's a
diagnostic-only read. tools/memory-model/Documentation/access-marking.txt
recommends data_race() over READ_ONCE() for those:

	(data_race((task)->flags) & PF_EXITING) || (__c))

Please update the changelog to match.

Thanks.
