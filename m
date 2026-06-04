Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60576388E64
	for <cgroups@vger.kernel.org>; Thu,  4 Jun 2026 14:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780581703; cv=none; b=jToGp7uSthEUnfleEYDZcYYnjC4AeCXZIuSPUxdcd6G7c9u9b9f+ed/ZHu7ZWtPlIBfjHExDvpRBO1yibj6JKZfIeN0NgX5l8T/6s/reWdahCs+63sTxPKjI+/X7jb597WoOQQtUPuo1uGlBFiiN7+EWiW0/StWxFVXf28V2gSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780581703; c=relaxed/simple;
	bh=D451ygHIzVM1uZMJR2jBtNVXfXya+bWc233wPuiCby0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7Ox3IoDf+SO9lBtyiIVXk6k5RPefCxJlrNEVBKzTICIz2dlj9oyMKyvRlBUMxIeUbgBhzmJ0ovhITXQYTC8kxqap3ONeK5y2OgZRtR3snDzS+DiQHZWU/NAqNuT8ozMhJ8BlgSUQop30cIhRi8R19h+UGsGFS4uxiwmAvSeenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NEv7KS8Y; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NEv7KS8Y"
Date: Thu, 4 Jun 2026 07:01:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780581689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h+zIBXCKO/oX06loH2iD7dO3/BmxxF4yAbeS+B4E8Lg=;
	b=NEv7KS8Yk6sEcTFnudCS+03flc8fd1Ov7H+pai87DuvhwhTi+GLWSGYyP6kB5H3T2D6G7n
	3WmHH/0OXnVuXJYNQu6HNgP4LQGRDUZcLnvmnFFsNQpPYy9dU9M50WFmf80DzRdIZMflar
	4XqR/KLhCaWRwIemjSaxlpQMfRUJLPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aiGFEQE5Vsw5XAtB@linux.dev>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > >> But doesn't it make more sense to specify the compressed size, which is
> > >> ultimately the amount of memory you actually want to reclaim.
> > >>
> > >
> > > I personally prefer compressed size to pre-compressed size. That's
> > > kinda what user cares about, no?
> > >
> > > One thing we can do is let users prescribe a compressed size, but
> > > internally, we can multiply that by the average compression ratio.
> > > That gives us a guesstimate of how many pages we need to reclaim, and
> > > you can follow the rest of your implementation as is (perhaps with
> > > short-circuit when we reach the goal with fewer pages reclaimed).
> >
> > Got it. I will change it to use the compressed size in the next version.
> >
> > Yosry, Nhat, should we continue using the zswap_writeback_only key to
> > trigger proactive writeback?
> 
> I *really* want the memcg maintainers to chime in here, it's
> ultimately their call.
> 
> Michal? Johannes? Shakeel? Roman? Anyone? :D

Sorry for the delay, I will take a look in a day or two.
