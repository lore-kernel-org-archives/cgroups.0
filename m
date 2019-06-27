From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] memcg: Add kmem.slabinfo to v2 for debugging purpose
Date: Thu, 27 Jun 2019 07:20:24 -0700
Message-ID: <20190627142024.GW657710@devbig004.ftw2.facebook.com>
References: <20190626165614.18586-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ibMkJJWkf9wfeR0beVqPsWCh5Yhblc2HN5zfVuXpgPc=;
        b=WNnNyq3R8FEYB2OR4flGfDaN1gAY7zPvl1DH6UtOPQvFdLJb3HAALzv3EDVY/ywtdl
         TpKnrFAROO6vLbl+cRlP7sQ/1Lc580ODR9iQYsWRhQPGRdN8YIyadlaHheXQdXZofolU
         R8XFUCJOYrgrWI9K8MuvklrUsp0h60A6/ga0KIQ8nFq1NYb0GJIUnq8stt4LOn0nAA35
         AQ3BLdfljIXqXQUYnWdrvO0xLRuPg31xcILy/wmDpdItAuKlMBglKb0a/CspeBgyrgLq
         F0l4pO6YScXuy6RtPMh/BgdclgtR8UQWLIqcUDte8+04k4YUjlcbMMIw3z0ZZiZ986yh
         SsnA==
Content-Disposition: inline
In-Reply-To: <20190626165614.18586-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>

Hello, Waiman.

On Wed, Jun 26, 2019 at 12:56:14PM -0400, Waiman Long wrote:
> With memory cgroup v1, there is a kmem.slabinfo file that can be
> used to view what slabs are allocated to the memory cgroup. There
> is currently no such equivalent in memory cgroup v2. This file can
> be useful for debugging purpose.
> 
> This patch adds an equivalent kmem.slabinfo to v2 with the caveat that
> this file will only show up as ".__DEBUG__.memory.kmem.slabinfo" when the
> "cgroup_debug" parameter is specified in the kernel boot command line.
> This is to avoid cluttering the cgroup v2 interface with files that
> are seldom used by end users.

Can you please take a look at drgn?

  https://github.com/osandov/drgn

Baking in debug interface files always is limited and nasty and drgn
can get you way more flexible debugging / monitoring tool w/o having
to bake in anything into the kernel.  For an example, please take a
look at

  https://lore.kernel.org/bpf/20190614015620.1587672-10-tj@kernel.org/

Thanks.

-- 
tejun
