Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B92366806;
	Sun,  5 Jul 2026 21:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783285367; cv=none; b=oM5ec6G1o3FA/HKQR9kwn1GdnGjDAUoDlpVdGa63TeQrx3huCpOusv+3qHPMC0rCuKA4LgWqfFi3PY9ycMYqAuQykJPdwDAaxbajObl9YNDTzBvLltA0XH8smDJQGfU+D8RmL00e9PawXQCqOj8bheEV1oT6ZJcmFYZZCbBvJM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783285367; c=relaxed/simple;
	bh=qeHYPbFp2iiNuLYjQ8jAX0+Oeh/uY5TxePuOiHUoO1s=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Se0IIQa0soSNMwp/DmhxxgFtcJoG/iEx9ZhuMvXHhtAwiNQ/dhvPcxf5uMeJHYdyDK09IZLvgNkYyGNNsgwjeu1zhka5nLleSsRjE1F/UXVeGY0GhRAyVIiDuKDFza0cXjPiYz2gGW5tq7EzOd10vrj1BNRoaPn5qzc6aDUHuK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E41w9rZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E41w9rZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CD31F000E9;
	Sun,  5 Jul 2026 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783285365;
	bh=3gCHWKa4Bf1jecM+x/DY8mFkX1R2/+i0CVe4zKSjV2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=E41w9rZKWqcMtKADxjBWyRinhU1EDTBk02trbkitXaR5Py+y2r6IIWGCZ4QE9eOX9
	 zvKOQQCdsLIhG8oJDZwuDDyq2aTzWkw2N8B3ri1bCyw+vIUB4ah05nrijJAdmLvQhu
	 KXwnd0Kl744NfRIVbWFogyDhYHXhUKjWhXz8+uFo=
Date: Sun, 5 Jul 2026 14:02:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, Jiayuan Chen
 <jiayuan.chen@shopee.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcg: reset zswap settings in css_reset
Message-Id: <20260705140245.179017e8360490bc3c9f5ae7@linux-foundation.org>
In-Reply-To: <722b2c40-6d82-4eef-b3f1-245fba465bc0@linux.dev>
References: <20260702024827.353185-1-jiayuan.chen@linux.dev>
	<722b2c40-6d82-4eef-b3f1-245fba465bc0@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Jul 2026 12:07:23 +0800 Tao Cui <cui.tao@linux.dev> wrote:

> > 	# child/memory.swap.max and child/memory.zswam.max disappear
> > 	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control
> > 
> 
> Looks good to me.
> 
> One trivial nit on the commit message (not the patch):
>   # child/memory.swap.max and child/memory.zswam.max disappear
>   zswam  -> zswap

I fixed that in the mm.git copy of this patch.

> Reviewed-by: Tao Cui <cuitao@kylinos.cn>

Thanks.
