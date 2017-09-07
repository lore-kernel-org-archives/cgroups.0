From: David Rientjes <rientjes@google.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Thu, 7 Sep 2017 15:03:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709071502430.143767@chino.kir.corp.google.com>
References: <20170904142108.7165-1-guro@fb.com> <20170904142108.7165-6-guro@fb.com> <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz> <20170905215344.GA27427@cmpxchg.org> <20170906082859.qlqenftxuib64j35@dhcp22.suse.cz>
 <alpine.DEB.2.20.1709071122360.20082@nuc-kabylake>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Ij6BNckOY2KybM6f3eFiLPfx/LS+su2UcGS71n7vtv4=;
        b=lqo8ku5dCoBwTZO/lWw1pcx4pjggPsTbtnZNgExHR1Naa8YliA4NzPQmTV4rvvdVyL
         J0pAIr6e0Py3CEfrEJ4od5ERyNet/X68HcH6jKuNe/tIK/Ha/eioNFXIx3mF2m20+4dW
         mCnUqmjEbdzQjyVpegEOLl4+5nc2xhjnmRzyxTD+d3MpicFBfZh3spb5EAV+EyCP2QUX
         Zq/rxA8BdmYeBOG6Td9iSUKwjuddCsEUN13wpa7y6LmaWf4wuEF7ZtgwMlyEo0EVdhAv
         qTQOGrV2WNr49+Jhyg2J1csA0pPqWOWcqv3Vlcxm/9P2qRZN/1skPeQpLIiEIJoMCte0
         /KIA==
In-Reply-To: <alpine.DEB.2.20.1709071122360.20082@nuc-kabylake>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 7 Sep 2017, Christopher Lameter wrote:

> > I am not sure this is how things evolved actually. This is way before
> > my time so my git log interpretation might be imprecise. We do have
> > oom_badness heuristic since out_of_memory has been introduced and
> > oom_kill_allocating_task has been introduced much later because of large
> > boxes with zillions of tasks (SGI I suspect) which took too long to
> > select a victim so David has added this heuristic.
> 
> Nope. The logic was required for tasks that run out of memory when the
> restriction on the allocation did not allow the use of all of memory.
> cpuset restrictions and memory policy restrictions where the prime
> considerations at the time.
> 
> It has *nothing* to do with zillions of tasks. Its amusing that the SGI
> ghost is still haunting the discussion here. The company died a couple of
> years ago finally (ok somehow HP has an "SGI" brand now I believe). But
> there are multiple companies that have large NUMA configurations and they
> all have configurations where they want to restrict allocations of a
> process to subset of system memory. This is even more important now that
> we get new forms of memory (NVDIMM, PCI-E device memory etc). You need to
> figure out what to do with allocations that fail because the *allowed*
> memory pools are empty.
> 

We already had CONSTRAINT_CPUSET at the time, this was requested by Paul 
and acked by him in https://marc.info/?l=linux-mm&m=118306851418425.
