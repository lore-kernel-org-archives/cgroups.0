Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0982B3D76;
	Fri, 17 Jul 2026 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784248792; cv=none; b=HulN0HeiNpAoIew38EavSCpcm1iVKWSo1mtbJS31/eVEfutvbAJSV3m3Su4JkBy7J20H5th7zmw07mr7TqwYIpt9C4JHDEwCz7b5i6Xjn3RF76rNE7b6lb9qfmu4NKdnV4+WJVWKeARtKDOBA5ZB9hzP6FHEN7UkFEBREHKr8tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784248792; c=relaxed/simple;
	bh=FK7CzkkxNOWY2tZd5acQugSYRcIFkzQ6YnY8Dbkty84=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HpaT6Rvu09VzkOb7YSJUP4ifO+KknqDw5JTqMt4e+fxrF+0dwsZ2d/Tmd4XKKupv3xe22mpMsNlDYp8K25HWMyXl7Tx0IeLI2v+46qwsLOlnjdo/jQM1/owNrDZ6JlKTx4BO495pu3cLxqbIje0ODc9yF6i4LSUXWq7FkXP29/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfhikE3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfhikE3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340471F000E9;
	Fri, 17 Jul 2026 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784248790;
	bh=bSW5HxEFq+ITIVQonZ02kyA5U7MyDuFVOxWZi2QyV6k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XfhikE3guLBwj8Z869Wij09nEwSan5JaooHiPLP4Leq6MO2SJc831atjD+F4Q0D1s
	 41WE4V2Pl3izSM02t9EfoEDrHbrKeZ+TWGGtTCqViezWxjdxI208UscWhFL1jtvKr8
	 aRMzuCx5ZLfmFhzFUnLCD6z3enncwoeprrTN1qGk=
Date: Thu, 16 Jul 2026 17:39:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Michal Hocko
 <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org,
 Joshua Hahn <joshua.hahnjy@gmail.com>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v2] mm: memcg: initialize *locked in
 memcg1_oom_prepare() stub
Message-Id: <20260716173949.0f87d0ab30c5eecb01067fce@linux-foundation.org>
In-Reply-To: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
References: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jul 2026 06:42:18 -0700 Breno Leitao <leitao@debian.org> wrote:

> mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> and reads it back in memcg1_oom_finish():
> 
> 	bool locked, ret;
> 	...
> 	if (!memcg1_oom_prepare(memcg, &locked))
> 		return false;
> 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> 	memcg1_oom_finish(memcg, locked);
> 
> This relies on memcg1_oom_prepare() setting *locked whenever it returns
> true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> CONFIG_MEMCG_V1=n returns true without touching *locked, so
> memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
> is reported by UBSAN:
> 
>   UBSAN: invalid-load in mm/memcontrol.c:1932:27
>   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> 
> Initialize *locked to false in the stub; with cgroup v1 compiled out
> there is no OOM lock to take.

Thanks.

Sashiko, as is its wont, reminds us that we all suck:
	https://sashiko.dev/#/patchset/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org

Does this potential memcg issue look legit?
