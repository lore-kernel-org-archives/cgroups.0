Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123783876C1;
	Fri, 18 Sep 2026 05:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789708359; cv=none; b=QWvDY/bWWdj5vo4hID5g8yFBEgPcuMvbB19FgoDQsjrqLyfgJfJIsavwBD4Tid9u5v5EaixNG96PBtNkI2EwDXDQLnoyCVgcWKwfEWK+eW1KMkyTkq6qzRLHhq5Gy4YAgbpShl1qhyX9ATxiApNsOkvHvRoy5tCfer08BYiveVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789708359; c=relaxed/simple;
	bh=6Dc7IQeI2bV2jn+6UAQMvCMtYbUSTJLmpwKNXDztLtg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=O7aw1J1fs5CIgSCMkL/w1SXS9CygucZJgRwB8d5e+/mEvK+KmmCfg+ZYe/EOdT6dF5vchxikm9qtn1gdRCcnp0v/H+eHQmCQB1OXvgDlqYkKS9QbC6+AiONXggdOiVlEE6WU3hIuMtrYFdHEZ19H2/MwrpDW3/BK0xUmiGe3aI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftGD2pL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftGD2pL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2CC1F000FF;
	Fri, 18 Sep 2026 05:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789708357;
	bh=v8DAjgtMpLNxk2yHd6b1u5Q/Jby6PVUAZD7m3pX+Fo0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ftGD2pL6l8DDm3npLoR/clYJ/KIxDffb7DMi1jjtu+pKopAvRHU/ymA+va6vw+Q+c
	 igu0P3dUUXSU/Y3JSDQT7BNUsGDapsFCjEZZmapi7ToJZzF+N+SN6oeeu6DSzasJ5T
	 uP2JVig55N4OVaxNIfzj7zIv3A9Cf4amT85F31wo=
Date: Thu, 17 Sep 2026 22:12:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
 jack@suse.cz, tj@kernel.org
Subject: Re: [PATCH v6 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260917221236.c9044ddf154e1b757b54d8f6@linux-foundation.org>
In-Reply-To: <836b5192-ef11-4f16-8c90-049d570959a2@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
	<20260917155305.7a63e01ba3ed34ed0aea537f@linux-foundation.org>
	<836b5192-ef11-4f16-8c90-049d570959a2@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 12:57:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> > Also, and most importantly, what the heck is "frn"?  Would the world
> > end if you did s/frn/foreign/g?
> 
> Emmm, the naming follows the existing code. I'll rename the new uses
> of "frn" to "foreign" in the next version. Renaming the existing code
> would be a separate cleanup patch; I'd prefer not to mix that into this
> fix series.

Well crap.  Let's stick with "frn" then.  Renaming everything can be
argued about much later.

Shall consider the rest of your email soon, thanks.
