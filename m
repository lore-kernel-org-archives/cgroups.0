From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] mm: memcontrol: Use cgroup_rstat for event accounting
Date: Wed, 4 Apr 2018 09:58:29 -0700
Message-ID: <20180404165829.GA3126663@devbig577.frc2.facebook.com>
References: <20180324160901.512135-1-tj@kernel.org>
 <20180324160901.512135-2-tj@kernel.org>
 <20180404140855.GA28966@cmpxchg.org>
 <20180404141850.GC28966@cmpxchg.org>
 <20180404143447.GJ6312@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=epoN4Th0eB74UGZq+OeEAZ7LRzqpdsK53mDZcFiDtps=;
        b=R6HmM2HxnsaaCPmZNVyFJQ8L2UHi0MhIKs0lKtTBokxNtf9JF5fqZ9+sS3k9Xk73D1
         PjqV2KkGU+amu3FbO2lGDxIbpLwNJzJ7+AKSt87q6jgJZlINBiY6LG9MdiVgm8IdVIFb
         X30G0iTWie52eiGchia2h8aYnSPEoZ06tB31MLYbGLKidZV7CejsyJ0zFJ7wC1oo4OId
         iqB+TyUb4cIhbYVL36KNl89z5X6XFPxl40lUkFbi7wrIHoQ9vewgfkNZY1MF2pcJ84l7
         VFUFUAs8yXRIZ7j0lPokdqZrLH2+9aGAdSGdJjCf25AUs8VPbZiMJYZDLvdV0XzZ7NM/
         p3Eg==
Content-Disposition: inline
In-Reply-To: <20180404143447.GJ6312@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello,

On Wed, Apr 04, 2018 at 04:34:47PM +0200, Michal Hocko wrote:
> > > The lazy updates are neat, but I'm a little concerned at the memory
> > > footprint. On a 64-cpu machine for example, this adds close to 9000
> > > words to struct mem_cgroup. And we really only need the accuracy for
> > > the 4 cgroup items in memory.events, not all VM events and stats.
> > > 
> > > Why not restrict the patch to those? It would also get rid of the
> > > weird sharing between VM and cgroup enums.
> > 
> > In fact, I wonder if we need per-cpuness for MEMCG_LOW, MEMCG_HIGH
> > etc. in the first place. They describe super high-level reclaim and
> > OOM events, so they're not nearly as hot as other VM events and
> > stats. We could probably just have a per-memcg array of atomics.
> 
> Agreed!

Ah, yeah, if we aren't worried about the update frequency of
MEMCG_HIGH, which likely is the highest freq, we can just switch to
atomic_t.  I'm gonna apply the cgroup stat refactoring patches to
cgroup, so if we ever wanna switch the counter to rstat, we can easily
do that later.

Thasnks.

-- 
tejun
