From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, memcg: Handle cgroup_disable=memory when getting
 memcg protection
Date: Fri, 1 Feb 2019 08:48:09 +0100
Message-ID: <20190201074809.GF11599@dhcp22.suse.cz>
References: <20190201045711.GA18302@chrisdown.name>
 <20190201071203.GD11599@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201071203.GD11599@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri 01-02-19 08:12:03, Michal Hocko wrote:
> On Thu 31-01-19 23:57:11, Chris Down wrote:
> > memcg is NULL if we have CONFIG_MEMCG set, but cgroup_disable=memory on
> > the kernel command line.
> > 
> > Fixes: 8a907cdf0177ab40 ("mm, memcg: proportional memory.{low,min} reclaim")
> 
> JFYI this is not a valid sha1. It is from linux next and it will change
> with the next linux-next release.
> 
> Btw. I still didn't get to look at your patch and I am unlikely to do so
> today. I will be offline next week but I will try to get to it after I
> get back.

Btw. I would appreciate if you could post the patch with all fixups
folded for the final review once things settle down.
-- 
Michal Hocko
SUSE Labs
