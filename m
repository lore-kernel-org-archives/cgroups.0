From: "Huang, Ying" <ying.huang@intel.com>
Subject: Proactive reclaim/demote discussion (was Re: [PATCH] Revert "mm:
 add nodes= arg to memory.reclaim")
Date: Wed, 04 Jan 2023 16:41:50 +0800
Message-ID: <87lemiitdd.fsf_-_@yhuang6-desk2.ccr.corp.intel.com>
References: <20221202223533.1785418-1-almasrymina@google.com>
        <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz> <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
        <20221216101820.3f4a370af2c93d3c2e78ed8a@linux-foundation.org>
        <Y52Scge3ynvn/mB4@dhcp22.suse.cz>
        <20221219144252.f3da256e75e176905346b4d1@linux-foundation.org>
        <Y7PpYsbv1xC6m/Hu@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672821774; x=1704357774;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=uaz6QB5HKom2SgAX7GeYtr38/rEA4ATvE3w66kjiUZo=;
  b=fTuGDMKWGr/vdD+8Eu/CtWrvxt5gCcz0EnQzcL/KiPFIrWZ3wLYhTqO1
   erQWwSUVRIPjqAsW1RyfInNpal8LUEsEW8uN9i4EvvXZ3aEjYzM1spCqT
   gIHSWbmAfDwFFsl2OKf0dNZwRW1EkkwqbUls5BN6y231zViwBNDh837M+
   We7qJiecwopCiE3FZ4ZqCJ/sCN2AmFJL2CmeBIn56PfR+plCH1berAMAW
   SbN9dJPOZA36azHDoJcFFzjVJe329ye2fUjGZ6kDjh8DnZaLUFYh62cIr
   zEY4SLu5a1U5T9yfWrgoVfPudv9T8bgIT/QoUlrmm4X5OMmnznvAiYHBn
   g==;
In-Reply-To: <Y7PpYsbv1xC6m/Hu@dhcp22.suse.cz> (Michal Hocko's message of
        "Tue, 3 Jan 2023 09:37:54 +0100")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>, Mina Almasry <almasrymina@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Michal Hocko <mhocko@suse.com> writes:

[snip]

> This really requires more discussion.

Let's start the discussion with some summary.

Requirements:

- Proactive reclaim.  The counting of current per-memcg proactive
  reclaim (memory.reclaim) isn't correct.  The demoted, but not
  reclaimed pages will be counted as reclaimed.  So "echo XXM >
  memory.reclaim" may exit prematurely before the specified number of
  memory is reclaimed.

- Proactive demote.  We need an interface to do per-memcg proactive
  demote.  We may reuse memory.reclaim via extending the concept of
  reclaiming to include demoting.  Or, we can add a new interface for
  that (for example, memory.demote).  In addition to demote from fast
  tier to slow tier, in theory, we may need to demote from a set of
  nodes to another set of nodes for something like general node
  balancing.

- Proactive promote.  In theory, this is possible, but there's no real
  life requirements yet.  And it should use a separate interface, so I
  don't think we need to discuss that here.

Open questions:

- Use memory.reclaim or memory.demote for proactive demote.  In current
  memcg context, reclaiming and demoting is quite different, because
  reclaiming will uncharge, while demoting will not.  But if we will add
  per-memory-tier charging finally, the difference disappears.  So the
  question becomes whether will we add per-memory-tier charging.

- Whether should we demote from faster tier nodes to lower tier nodes
  during the proactive reclaiming.  Choice A is to keep as much fast
  memory as possible.  That is, reclaim from the lowest tier nodes
  firstly, then the secondary lowest tier nodes, and so on.  Choice B is
  to demote at the same time of reclaiming.  In this way, if we
  proactively reclaim XX MB memory, we may free XX MB memory on the
  fastest memory nodes.

- When we proactively demote some memory from a fast memory tier, should
  we trigger memory competition in the slower memory tiers?  That is,
  whether to wake up kswapd of the slower memory tiers nodes?  If we
  want to make per-memcg proactive demoting to be per-memcg strictly, we
  should avoid to trigger the global behavior such as triggering memory
  competition in the slower memory tiers.  Instead, we can add a global
  proactive demote interface for that (such as per-memory-tier or
  per-node).

Best Regards,
Huang, Ying
