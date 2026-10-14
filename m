Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D2B21FF2A;
	Wed, 14 Oct 2026 20:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792011048; cv=none; b=CrFgX3g7nIRmUggsX5+Tzjsy0vmcbyv/mw6B33CQyyXtFwy8OXwn2aO48wbKprtgiuAp3EGRxX35s6/bZQAavi3WSutjQ06AJaiXHcKQ5kLEUN/dOEJt+XAA6w1OYUCEvlN4biy0hoS5zfNYYZU616S8nUMevqn5bOjtXnH/FRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792011048; c=relaxed/simple;
	bh=i8D9yZb0UWHBI+Xz9EO0l4dYQOFG+MxhK8G5yv4G2uk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HFbDQzUPBxoMy+0HX8Dgl9H3gnNqezLzhCedOUbE8oIy6LOpvCAKOBWAJPb9E6kHvhIT4M18cX52qiCEOVZ39oVFVLBU3Ju1bjLoiqk27Bkji2yRQffAxM3gDTeSyv4EPu2Y3qgbyZaU7YgdtGeDTxFBBs02xLhw+LbSAureyk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyiO+vuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyiO+vuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16E61F000C4;
	Wed, 14 Oct 2026 20:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792011047;
	bh=rNJFLvF4P3aKAioyvIs7zgjS8vYuL/AIz3xW41h4cLI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iyiO+vuzRlgKW3K1+bkEDfNzcyr9AHOBWIzMxQ1JJ9NF+heBdAq0HOnL41UTjtTY8
	 FkidymqWCHajYKrqOO0SRueiqUsp3+mGTkOg1/h/g/92TfwnFYDheZUZRBpg0eMrdm
	 4FpCdLiozbcVSwj3Iwyeam4uS9XXt0v+SCn2uG6A=
Date: Wed, 14 Oct 2026 13:50:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units
 cheaper
Message-Id: <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
In-Reply-To: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
> ever charges an object to those shrinkers. Every superblock registers
> such a shrinker, so the cost is
> 
>   memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
> 
> because the unit is 520 bytes and comes from kmalloc-1k.

So we could almost halve this just by using a dedicated kmem_cache?

