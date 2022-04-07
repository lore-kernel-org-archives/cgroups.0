From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Thu, 07 Apr 2022 16:11:06 -0700
Message-ID: <df6110a09cacc80ee1cbe905a71273a5f3953e16.camel@linux.intel.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
         <YkcEMdsi9G5y8mX4@dhcp22.suse.cz>
         <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
         <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com>
         <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
         <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com>
         <CAAPL-u_6XqQYtLAMNFvEo+0XU2VR=XYm0T9btL=g6rVVW2h93w@mail.gmail.com>
         <87bkxfudrk.fsf@yhuang6-desk2.ccr.corp.intel.com>
         <215bd7332aee0ed1092bad4d826a42854ebfd04a.camel@linux.intel.com>
         <CAAPL-u_aAbDOmATSA8ZvjnfBk_7EoXvLoh0etM0fB0aY1845VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649373068; x=1680909068;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dUrof2VxTLYM9v29u7hGUQzQzbvw3951Xsun8u5eDL4=;
  b=mJMpwghtkg8+RC4t+uTG7hFap8ZZ10816fv++IhnmoVAGLcnKqEWFCcI
   BHbk3g8rh2f4VnqHDjecymjkeKE5RZFozo6IBDSwp8FdQSUVXhVpPzvLf
   LpCXQ1OcOAOrGAL30xp29Fs5pOQbIhIRRZIRyoT1WY5cwOsyC6GuFGNRN
   U3At7u5n3YQKtumTArnRKTc6vtWtjHVmLiz4riAoxla05TMCkAfWSeUnX
   n4lEgNv/8hrXujKlVE8SQUXeigU0pyKWiMvqZXopb4FCqSEkRmTFVer1x
   FlnBBX4PohqSKJ1MaSCNnCV/PE0pIf3R0TM1tYzI92awE7azS2JN6sHa2
   A==;
In-Reply-To: <CAAPL-u_aAbDOmATSA8ZvjnfBk_7EoXvLoh0etM0fB0aY1845VQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wei Xu <weixugc@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

On Thu, 2022-04-07 at 15:12 -0700, Wei Xu wrote:

> 
> (resending in plain-text, sorry).
> 
> memory.demote can work with any level of memory tiers if a nodemask
> argument (or a tier argument if there is a more-explicitly defined,
> userspace visible tiering representation) is provided.  The semantics
> can be to demote X bytes from these nodes to their next tier.
> 

We do need some kind of userspace visible tiering representation.
Will be nice if I can tell the memory type, nodemask of nodes in tier Y with

cat memory.tier_Y


> memory_dram/memory_pmem assumes the hardware for a particular memory
> tier, which is undesirable.  For example, it is entirely possible that
> a slow memory tier is implemented by a lower-cost/lower-performance
> DDR device connected via CXL.mem, not by PMEM.  It is better for this
> interface to speak in either the NUMA node abstraction or a new tier
> abstraction.

Just from the perspective of memory.reclaim and memory.demote, I think
they could work with nodemask.  For ease of management,
some kind of abstraction of tier information like nodemask, memory type
and expected performance should be readily accessible by user space.  

Tim

> 
> It is also desirable to make this interface stateless, i.e. not to
> require the setting of memory_dram.reclaim_policy.  Any policy can be
> specified as arguments to the request itself and should only affect
> that particular request.
> 
> Wei

