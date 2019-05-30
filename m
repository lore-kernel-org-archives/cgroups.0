From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Thu, 30 May 2019 08:51:11 +0200
Message-ID: <20190530065111.GC6703@dhcp22.suse.cz>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190530061221.GA6703@dhcp22.suse.cz>
 <20190530064453.GA110128@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190530064453.GA110128@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed 29-05-19 23:44:53, Chris Down wrote:
> Michal Hocko writes:
> > Maybe I am missing something so correct me if I am wrong but the new
> > calculation actually means that we always allow to scan even min
> > protected memcgs right?
> 
> We check if the memcg is min protected as a precondition for coming into
> this function at all, so this generally isn't possible. See the
> mem_cgroup_protected MEMCG_PROT_MIN check in shrink_node.

OK, that is the part I was missing, I got confused by checking the min
limit as well here. Thanks for the clarification. A comment would be
handy or do we really need to consider min at all?

> (Of course, it's possible we race with going within protection thresholds
> again, but this patch doesn't make that any better or worse than the
> previous situation.)

Yeah.

With the above clarified. The code the resulting code is much easier to
follow and the overal logic makes sense to me.

Acked-by: Michal Hocko <mhocko@suse.com>

-- 
Michal Hocko
SUSE Labs
