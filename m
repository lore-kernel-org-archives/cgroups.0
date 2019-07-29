From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] mm: memcontrol: fix use after free in
 mem_cgroup_iter()
Date: Mon, 29 Jul 2019 08:25:00 +0200
Message-ID: <20190729062500.GB9330@dhcp22.suse.cz>
References: <20190726021247.16162-1-miles.chen@mediatek.com>
 <20190726124933.GN6142@dhcp22.suse.cz>
 <20190726125533.GO6142@dhcp22.suse.cz>
 <1564184878.19817.5.camel@mtkswgap22>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1564184878.19817.5.camel@mtkswgap22>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miles Chen <miles.chen@mediatek.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com

On Sat 27-07-19 07:47:58, Miles Chen wrote:
> On Fri, 2019-07-26 at 14:55 +0200, Michal Hocko wrote:
[...]
> > > I am sorry, I didn't get to comment an earlier version but I am
> > > wondering whether it makes more sense to do and explicit invalidation.
> > > 
> 
> I think we should keep the original v2 version, the reason is the 
> !use_hierarchy does not imply we can reach root_mem_cgroup:
> 
> cd /sys/fs/cgroup/memory/0
> mkdir 1
> cd /sys/fs/cgroup/memory/0/1
> echo 1 > memory.use_hierarchy // only 1 and its children has
> use_hierarchy set
> mkdir 2
> 
> rmdir 2 // parent_mem_cgroup(2) goes up to 1

You are right I have missed this case. I am not sure anybody is using
layout like that but your fix is more robust and catches that case as
well.

Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs
