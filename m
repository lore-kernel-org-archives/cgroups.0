From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Tue, 28 Apr 2020 17:16:51 -0400
Message-ID: <20200428211651.GA400178@cmpxchg.org>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WE6fRMNAlJdivHdtcAIHzYCELiaeahloDmul9mg0d04=;
        b=Tqpge43yY2XClplBd6Cuaaz88Fy6z2Qetea0T++CdEVcloY1WyqWjq9GfNzvdloNf+
         QCyDC7llMs9FBzVbURzA6D2Q7zKZX469Z0F+4Nio7TMivfGJKk8UlmDymTXKq+4dgRsO
         BKbEtWpnzOKtWZMiirCI3Ybp9zHdbKYkkOj3efyJeOoZQARwk13IewUWv53ivh3bZHLE
         2sI3P6Qod7o/TOvQCgAECFhN2fPYIXf0l1/OaiDqILqzJXcoiR4TfBzmdOZ880OwlFop
         grO3SdOEeWLC3XC9c3Td6B2frG8r/+tjxUjk9EGVq9WX7g1l58zDfeurHDEdNkYGStkr
         ciSg==
Content-Disposition: inline
In-Reply-To: <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Apr 28, 2020 at 07:26:47PM +0100, Chris Down wrote:
> From: Yafang Shao <laoar.shao@gmail.com>
> 
> A cgroup can have both memory protection and a memory limit to isolate
> it from its siblings in both directions - for example, to prevent it
> from being shrunk below 2G under high pressure from outside, but also
> from growing beyond 4G under low pressure.
> 
> Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> implemented proportional scan pressure so that multiple siblings in
> excess of their protection settings don't get reclaimed equally but
> instead in accordance to their unprotected portion.
> 
> During limit reclaim, this proportionality shouldn't apply of course:
> there is no competition, all pressure is from within the cgroup and
> should be applied as such. Reclaim should operate at full efficiency.
> 
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim cycle
> in which the cgroup did have siblings.
> 
> When this happens, reclaim is unnecessarily hesitant and potentially
> slow to meet the desired limit. In theory this could lead to premature
> OOM kills, although it's not obvious this has occurred in practice.
> 
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> 
> [hannes@cmpxchg.org: rework code comment]
> [hannes@cmpxchg.org: changelog]
> [chris@chrisdown.name: fix store tear]
> [chris@chrisdown.name: retitle]

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
