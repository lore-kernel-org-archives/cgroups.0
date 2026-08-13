Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774AD265623;
	Thu, 13 Aug 2026 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786653844; cv=none; b=VeIg0xTPeDPG2wLsX628UDcV3vd1HzDW4syeCYPMJAeP7sQst74c6ltkEmfSU2Tcj54xJ9bctTaOu2zPf/O1dzTRnWD4UdB8lEYjdTyGg1h8lRAWb8N16CyfbAtULLkP6Otl+0i59+wCtgekInp+9fDVfRSlVDaOGa/VfohJg9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786653844; c=relaxed/simple;
	bh=3AShb515nOmomKD0kEjIxXwrFAoCA3XtQ9eLyQepbew=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=corEBG02aYroTDrEXi7lpQm9vJExyg2wDdKN3aWX9/SsgNLn+n9bKAe+xyfMVXZAsjPEB2eB3gnGTVQC/IonJfmUO1DK9e51GfhAif7OaC3RUXo1X4f4pNqUYZObq6Tyq5tObQ6t6D9A61mXziOtNdJhXzeT2Jr7BqPwvgaBRT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLm+lc4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLm+lc4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562421F000E9;
	Thu, 13 Aug 2026 20:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786653843;
	bh=fdWp8ueXb6s+udO8FKONy4G9LfKlB2Cu4K/pOBUgXWU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tLm+lc4VMjulDbH3IDfdYTiLafdXv9KILpJPabAUWZJZVA8g25lUIoxGD0Kmhx4+7
	 p1OBHCB+Ri3CblTvUY6PUxsfXxdBNA2u4XtPy+C56SeMZfObAnyKd9/JmEp1B5aK5m
	 9TJMEYD3C02tSJpsr8oJgCBOI2C3ptY1DsqUC5bg=
Date: Thu, 13 Aug 2026 13:44:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, baohua@kernel.org,
 hannes@cmpxchg.org, ryncsn@gmail.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ljs@kernel.org
Subject: Re: [PATCH v6 0/4] mm: avoid large folio splits when swap is
 unavailable
Message-Id: <20260813134401.a1fb632936fa3b91e454c82d@linux-foundation.org>
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 13 Aug 2026 15:50:21 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> This is v6 of Barry's original RFC patch, "mm: Avoiding split large
> folios if swap has no space":

Thanks.  It looks like a nice patchset and it comes well-reviewed.

However it's super late in the cycle so I'd prefer to defer this until
after 7.3-rc1.

The changelogs aren't very clear on the overall benefit to our users
(please address this), but I'm thinking "minor".  If I'm wrong then
lets consider -stable backports and suitable Fixes: targets.

