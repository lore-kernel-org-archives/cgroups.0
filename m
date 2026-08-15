Received: from mta1.migadu.com (out-96.mta1.migadu.com [95.215.58.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D4017B50A
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 00:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786754198; cv=none; b=IndKp8M1doCODrfnBxLjPrsPmhUAk1XBzoO1cWvmbtCSn2BJh0SAVDVw4YJRpzZDJ6K5FDVg1jxG3i14Ye4iuWEuT/O0w5LhY4szj50pd5KUXXhRyGQdEvk+z1aEzruzkzgc+klK7vc38g9QAXS9UfxiO1s0UDtd5iegSBZiW/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786754198; c=relaxed/simple;
	bh=tQFdd/qDklLAKb6V+af2UY+3ml4uiTf2rWfzA7UGu7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDhAlTBG21hVQniCA8RtFfb6O4j+og8Y4NKYgPjEEIcq6Qo6yQ638S9BASyLhvcvhuXbFJ6DbSoWkhplvyJs5acBmJwLYKm9JxWQBebaHL1wjsRh87iJw+4whdAEwMrAvezgWD4bTNpSU10c+6xPcrNcQY5+UtcdmQkhfQUde2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZXtZQSeP; arc=none smtp.client-ip=95.215.58.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZXtZQSeP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tQFdd/qDklLAKb6V+af2UY+3ml4uiTf2rWfzA7UGu7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786754194; v=1; x=1787358994;
 b=ZXtZQSePINP6hmH8ZHrgbAbxxJ2mLa41IjkEm2dUXKLUcHfyBWppffUu/E0xWfmOvbyNqyjl
 PMkAD5Vn2TlQSod2eMCZxJVzzu/dffreRYPoVDTYh2IlWXVKeV4T66p8x4by9Bnx6lFNO6eGS19
 /HpysRbRvp2+SrfXcqgXh5EE=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:6::)
	by smtp.migadu.com with ESMTPS id eb90bf85938a14c4;
	Sat, 15 Aug 2026 00:36:34 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:36:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: mambaxin@163.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, 
	akpm@linux-foundation.org, david@redhat.com, v-songbaohua@oppo.com, hughd@google.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, jose.fernandez@linux.dev, stable@vger.kernel.org, 
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com, David Hildenbrand <david@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Sasha Levin <sashal@kernel.org>, chenxin <chenxinxin@xiaomi.com>
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id
 on swapless host
Message-ID: <an-yt4a6td75VvHw@linux.dev>
References: <20260814074705.939721-2-mambaxin@163.com>
 <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>

On Fri, Aug 14, 2026 at 07:23:41PM +0800, Barry Song wrote:
> On Fri, Aug 14, 2026 at 3:48 PM <mambaxin@163.com> wrote:
> >
> > From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
> >
> > [ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]
> >
> > lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
> > __swap_cgroup_id_lookup() without checking that the type was ever
> > registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
> > is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
> > swp_offset().
> >
> > Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
> > zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
> > lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as a
> > real swap entry, without first validating it against swap_info[].  A
> > single PTE corrupted into a type-0 swap entry takes the host down at
> > process exit.
> 
> Thanks for the patch. However, we have a strict check to ensure that
> this is only done for valid swap entries:

This patch is already in the upstream linus tree.

Mambaxin, what do you want to do with this patch? Are you requesting to backport
this to stable tree? Which one? It already had stable CCed, so I would expect
the stable tree maintainers would pick this up automatically.

