From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC PATCH 0/2] memory.low,min reclaim
Date: Mon, 23 Apr 2018 11:38:10 +0100
Message-ID: <20180423103804.GA12648@castle.DHCP.thefacebook.com>
References: <20180320223353.5673-1-guro@fb.com>
 <20180422202612.127760-1-gthelen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=uo/T7MGC6UOejKfnT6X/Yk2QNZg/2HstxKjwdUvVyxA=;
 b=UtWjBaj9SJbkufYCPPjGKUt/NYmbfFpHKwX4FFu+78lD1/EO5xnzdN0FaIihuKdc7ZIp
 E41kiIgmVVXomUM3ZvLCBTAbHK80Yj3Yt5zK4NWBMrha/OmPiukmaQlmDLlxhJ2OqGpm
 BGANOUTYxrKf0PiZ6T+9W7U51byVRZ2TBdw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uo/T7MGC6UOejKfnT6X/Yk2QNZg/2HstxKjwdUvVyxA=;
 b=ItLJG2uR7LHC1PY2mnrHNJermMPLbEf1wXaO1Ph7tzRsU6Zw0i+OMSypDDmjUvhwjqWnvsKhcpnnb25CIN+3PZ7C7+e9673pRwbqHoWnjTsNbnwLOFw+MkSBTk9NJOkAJi8vKsvNG6tk1QaK8s5TqYzcGdP5hfKEJGlTsudNdpo=
Content-Disposition: inline
In-Reply-To: <20180422202612.127760-1-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>, kernel-team@fb.com, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

Hi, Greg!

On Sun, Apr 22, 2018 at 01:26:10PM -0700, Greg Thelen wrote:
> Roman's previously posted memory.low,min patches add per memcg effective
> low limit to detect overcommitment of parental limits.  But if we flip
> low,min reclaim to bail if usage<{low,min} at any level, then we don't need
> an effective low limit, which makes the code simpler.  When parent limits
> are overcommited memory.min will oom kill, which is more drastic but makes
> the memory.low a simpler concept.  If memcg a/b wants oom kill before
> reclaim, then give it to them.  It seems a bit strange for a/b/memory.low's
> behaviour to depend on a/c/memory.low (i.e. a/b.low is strong unless
> a/b.low+a/c.low exceed a.low).

It's actually not strange: a/b and a/c are sharing a common resource:
a/memory.low.

Exactly as a/b/memory.max and a/c/memory.max are sharing a/memory.max.
If there are sibling cgroups which are consuming memory, a cgroup can't
exceed parent's memory.max, even if its memory.max is grater.

> 
> I think there might be a simpler way (ableit it doesn't yet include
> Documentation):
> - memcg: fix memory.low
> - memcg: add memory.min
>  3 files changed, 75 insertions(+), 6 deletions(-)
> 
> The idea of this alternate approach is for memory.low,min to avoid reclaim
> if any portion of under-consideration memcg ancestry is under respective
> limit.

This approach has a significant downside: it breaks hierarchical constraints
for memory.low/min. There are two important outcomes:

1) Any leaf's memory.low/min value is respected, even if parent's value
   is lower or even 0. It's not possible anymore to limit the amount of
   protected memory for a sub-tree.
   This is especially bad in case of delegation.

2) If a cgroup has an ancestor with the usage under its memory.low/min,
   it becomes protection, even if its memory.low/min is 0. So it becomes
   impossible to have unprotected cgroups in protected sub-tree.

Thanks!
