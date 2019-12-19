From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/3] mm: memcontrol: recursive memory protection
Date: Thu, 19 Dec 2019 12:22:11 -0800
Message-ID: <20191219202211.GD2914998@devbig004.ftw2.facebook.com>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r3E/D07/ZPDWwCmYCAV3wbix4nrV2NEeuAgSXWyKjuk=;
        b=u6Wv8j6rmYawNkXdt1PMu7j72pvZx7svOC3E6pznjHc7+FKrdLbnpmSkSLwC619uwG
         SIgEtVQR3RNyDP+MnUu66RibgcVwqQX/7rUtScjLHr6Pal8yn5U7QlcAesErCFSx45hg
         onib1uCCGQGQadOVJ+9ENHyQPk7xutFYx7b1zOF5X0rBodDabJl+LlsmlqIuIykD/DzO
         MOmBK1o41B4picUTKElrG4ixXSjCjS7NnbUTWFBfd3+qZfRpJHnl1AFp7qvXMZxle2rU
         17vEUZKBjvL3LIfCGY1R9UbjtXkIr9KX9urMGHHKJB+HfnE4pxaih6aOzIYdxGCeXAuG
         GRzw==
Content-Disposition: inline
In-Reply-To: <20191219200718.15696-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Dec 19, 2019 at 03:07:15PM -0500, Johannes Weiner wrote:
> Changes since v1:
> - improved Changelogs based on the discussion with Roman. Thanks!
> - fix div0 when recursive & fixed protection is combined
> - fix an unused compiler warning
> 
> The current memory.low (and memory.min) semantics require protection
> to be assigned to a cgroup in an untinterrupted chain from the
> top-level cgroup all the way to the leaf.
> 
> In practice, we want to protect entire cgroup subtrees from each other
> (system management software vs. workload), but we would like the VM to
> balance memory optimally *within* each subtree, without having to make
> explicit weight allocations among individual components. The current
> semantics make that impossible.

Acked-by: Tejun Heo <tj@kernel.org>

The original behavior turned out to be a significant source of
mistakes and use cases which would require older behavior just weren't
there.

Thanks.

-- 
tejun
