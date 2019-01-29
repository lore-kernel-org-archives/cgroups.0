From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: Expose THP events on a per-memcg basis
Date: Tue, 29 Jan 2019 17:15:49 -0500
Message-ID: <20190129221549.GA13066@cmpxchg.org>
References: <20190129205852.GA7310@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cjPKJoHf3Gll+qk80dZ1zwwaf8+ItgdBe9DjCPAWJDM=;
        b=Wplr7vFthNztMxNfahA1bdj2lR3+YAdLQRgxzerOl/TRr5R4rFJx8TUrvIk1v7GEmQ
         kW80/oYXICrRj09V7xe49KhmG2HZE1rJdek1rUmiqrM2TA1ik6ZtsJgqvXoDfbFUOR+S
         r4jYBxwP6P+szzZp1EYHRu4AAGuOv48jtQZkBrJIuIK+HpL2oLgfyUT6VPMjGkKDonHS
         muByxxO7QtKKoPg2xVphTkV4PvV79xkf5ySxjt/21cxk5LPq3n5eJ1Ke3iNPGFjjCCDn
         eVLHYSC/VtVDEYZMxvnvbWN0zOjJl29ex2JcIHoqtd4k3gYMyhNO+XXv3bD3rnJ2e43X
         LLtA==
Content-Disposition: inline
In-Reply-To: <20190129205852.GA7310@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Tue, Jan 29, 2019 at 03:58:52PM -0500, Chris Down wrote:
> Currently THP allocation events data is fairly opaque, since you can
> only get it system-wide. This patch makes it easier to reason about
> transparent hugepage behaviour on a per-memcg basis.
> 
> For anonymous THP-backed pages, we already have MEMCG_RSS_HUGE in v1,
> which is used for v1's rss_huge [sic]. This is reused here as it's
> fairly involved to untangle NR_ANON_THPS right now to make it
> per-memcg, since right now some of this is delegated to rmap before we
> have any memcg actually assigned to the page. It's a good idea to rework
> that, but let's leave untangling THP allocation for a future patch.
>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Looks good to me. It's useful to know if a cgroup is getting the THP
coverage and allocation policy it's asking for.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

The fallback numbers could be useful as well, but they're tricky to
obtain as there isn't an obvious memcg context. We can do them later.
