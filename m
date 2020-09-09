From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Wed, 9 Sep 2020 13:40:57 +0200
Message-ID: <20200909114057.GH7348@dhcp22.suse.cz>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
 <20200826011946.spknwjt44d2szrdo@ca-dmjordan1.us.oracle.com>
 <01ed6e45-3853-dcba-61cb-b429a49a7572@linux.alibaba.com>
 <20200828014022.y5xju6weysqpzxd2@ca-dmjordan1.us.oracle.com>
 <20200909024432.GA9736@desktop-ziqianlu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200909024432.GA9736@desktop-ziqianlu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, Alex Shi <alex.shi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Wed 09-09-20 10:44:32, Aaron Lu wrote:
> On Thu, Aug 27, 2020 at 09:40:22PM -0400, Daniel Jordan wrote:
> > I went back to your v1 post to see what motivated you originally, and you had
> > some results from aim9 but nothing about where this reared its head in the
> > first place.  How did you discover the bottleneck?  I'm just curious about how
> > lru_lock hurts in practice.
> 
> I think making lru_lock per-memcg helps in colocated environment: some
> workloads are of high priority while some workloads are of low priority.
> 
> For these low priority workloads, we may even want to use some swap for
> it to save memory and this can cause frequent alloc/reclaim, depending
> on its workingset etc. and these alloc/reclaim need to hold the global
> lru lock and zone lock. And then when the high priority workloads do
> page fault, their performance can be adversely affected and that is not
> acceptible since these high priority workloads normally have strict SLA
> requirement.

While this all sounds reasonably. We are lacking _any_ numbers to
actually make that a solid argumentation rather than hand waving.
Having something solid is absolutely necessary for a big change like
this.

-- 
Michal Hocko
SUSE Labs
