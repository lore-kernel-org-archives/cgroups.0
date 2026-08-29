Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF0B3314DE
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 03:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787973227; cv=none; b=KbXbjnryOhdoxKftWKI5ZBsOAaPRH2gx1HAnwmVGgFjiMna2MlByClPbhn7/FYFQ66HPXz4tPeJ5qwFNslJwctlzj9ToHNb2saXJTmGZ0UEmdu5w8FMdlfuH2GvjNWov50waf9K7v7wZA1QkUuEMLUQ+yU11KFrjJ84UBSVReH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787973227; c=relaxed/simple;
	bh=cDW6ej3nsOtAs9UhYM6om1L/1lvDe6jcM4V1q9Oa8bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crlM2M4NzwC2ttEXMcqfKA4tMts7RUVSHvbNazgTGxkTLZCuFE+mFlVFFokl1+exORmU65K7Lv8iq4Ipn2nKt4MItc0BmAOlpEMfmIJLhSFRX/FP6/GMXgdGgzLzlp6gJG7+YIQvO9l+qjXG7UwMgqHcq0KYQHJT8DJINkEEU98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aZLBTCbX; arc=none smtp.client-ip=95.215.58.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aZLBTCbX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cDW6ej3nsOtAs9UhYM6om1L/1lvDe6jcM4V1q9Oa8bw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787973223; v=1; x=1788578023;
 b=aZLBTCbXkU7d/zoBiSkVOZ78BoDyWbRzDyQh1tkWdy4wjUXmdrdbiy2oZ/wr3B6PZg2VgGon
 W9cXn+PfriyEh2EkV4myEHx0XS9mc7u+7hz2s/AYLpqomFxJU218OHYdfpItrPR3ztXMht0Vgom
 d6AlUFpCOevcXhCKxZEhiuRY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6e5a30d5d232ca82;
	Sat, 29 Aug 2026 03:13:32 +0000
X-Mizu-Trace-ID: 6e5a30d5d232ca82
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 20:13:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <apJOJ2PWwmo7KMYW@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <apJCb-8RK0azF8_h@linux.dev>
 <20260828194322.0556dcbd1c261c23a1f6efec@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828194322.0556dcbd1c261c23a1f6efec@linux-foundation.org>

On Fri, Aug 28, 2026 at 07:43:22PM -0700, Andrew Morton wrote:
> On Fri, 28 Aug 2026 19:23:19 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> > > Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> > > reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> > > target memcg set, and thus the only way kswapd can reach
> > > lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> > > mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> > > reclaim. Do not reuse for anything else." comment and a priority hack,
> > > and it simply never got taught about MGLRU.
> > > 
> > > Rather than teach it, let's delete it. The v1 soft limit was deprecated
> > > in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> > > soft limit"). Nobody has reported depending on it in the ~21 months
> > > since, and v2 has covered the same ground for a long time with
> > > memory.low and memory.min.
> > > 
> > > Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
> > 
> > Andrew, should I resend this series (without the first patch) or will you pick
> > it up?
> 
> I added the series, thanks.
> 
> The [1/9] has already been queued in mm-hotfixes as a backportable
> hotfix.  So I added it as an 8-patch series.  Because of this the cover
> letter of that series is now irrelevant, so could you please prepare a
> brief replacement for me to paste in?
> 
> Sashiko suggests that there's more that can be removed:
> 	https://sashiko.dev/#/patchset/20260811203203.3456029-1-shakeel.butt@linux.dev
> 
> So maybe an 8-patch v2 series is appropriate, your call.

I will send 8-patch v2 series with Sashiko's comments resolved by next week.
