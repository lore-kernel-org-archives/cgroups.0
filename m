Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1031C5D72;
	Sat, 29 Aug 2026 02:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787971405; cv=none; b=cOgfaPlON6v2bu342yZJZERARMG51T+QEyep4Wcj3ACkQZHV5tAZeHa0Y2A9wetwJoNVaVUTaV+vDM6EgO7kl+9Tgz2Cj1taSHaDPplwsySNXPgRg5WjWQ4plHzfrwVOndgbWSXbuVlRPV7jNDJzIAjVYFfY0iHbiQudsZNy+68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787971405; c=relaxed/simple;
	bh=thP91mX7wqWMMxEyUu4iTH0+5STX7OCArkhdBDmoR0E=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XRMBQikLXLZsCLVjjK7lhGcez1rFx1fgBbIxVHeIabDdOJ1K8Qmoq09Oac98z5s4tu/XlEDnlCVWYB3xsjvZulaX3iN6nVRcBxrvxN+CJNX+48qDRuiKsbBmvK6Cg5NLvaWbH5sK0C/qeC0HN8CbAPsBOKMQzD34OrF7n+wYEQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IB77iyYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IB77iyYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D681F000E9;
	Sat, 29 Aug 2026 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971403;
	bh=ZbdBpOVVjZYRbR08NMFYy3lM8LyPK44ueETY+0xcqms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IB77iyYKD6owUschePt6VzG+y2xpsaYWgTocU7aVh4cUSVWCugOJKlVUDpt+eK/Xo
	 uzKreizUhB4hGXW3yK1UUk49uOqddCkT2Ijk4AkbfPr0MqMWTs7b1u7nKZIXlnp5hu
	 P4fGuPEf2sg39h5c7GiBDTCHsDv398Y0Aj2914N4=
Date: Fri, 28 Aug 2026 19:43:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-Id: <20260828194322.0556dcbd1c261c23a1f6efec@linux-foundation.org>
In-Reply-To: <apJCb-8RK0azF8_h@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
	<apJCb-8RK0azF8_h@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Aug 2026 19:23:19 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> > Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> > reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> > target memcg set, and thus the only way kswapd can reach
> > lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> > mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> > reclaim. Do not reuse for anything else." comment and a priority hack,
> > and it simply never got taught about MGLRU.
> > 
> > Rather than teach it, let's delete it. The v1 soft limit was deprecated
> > in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> > soft limit"). Nobody has reported depending on it in the ~21 months
> > since, and v2 has covered the same ground for a long time with
> > memory.low and memory.min.
> > 
> > Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
> 
> Andrew, should I resend this series (without the first patch) or will you pick
> it up?

I added the series, thanks.

The [1/9] has already been queued in mm-hotfixes as a backportable
hotfix.  So I added it as an 8-patch series.  Because of this the cover
letter of that series is now irrelevant, so could you please prepare a
brief replacement for me to paste in?

Sashiko suggests that there's more that can be removed:
	https://sashiko.dev/#/patchset/20260811203203.3456029-1-shakeel.butt@linux.dev

So maybe an 8-patch v2 series is appropriate, your call.
