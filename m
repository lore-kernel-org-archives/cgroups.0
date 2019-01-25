From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Fri, 25 Jan 2019 18:37:13 +0100
Message-ID: <20190125173713.GD20411@dhcp22.suse.cz>
References: <20190123223144.GA10798@chrisdown.name>
 <20190124082252.GD4087@dhcp22.suse.cz>
 <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190125165152.GK50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Fri 25-01-19 08:51:52, Tejun Heo wrote:
[...]
> > I do see your point about consistency. But it is also important to
> > consider the usability of this interface. As already mentioned, catching
> > an oom event at a level where the oom doesn't happen and having hard
> > time to identify that place without races is a not a straightforward API
> > to use. So it might be really the case that the api is actually usable
> > for its purpose.
> 
> What if a user wants to monitor any ooms in the subtree tho, which is
> a valid use case?

How is that information useful without know which memcg the oom applies
to?

> If local event monitoring is useful and it can be,
> let's add separate events which are clearly identifiable to be local.
> Right now, it's confusing like hell.

From a backward compatible POV it should be a new interface added.
Please note that I understand that this might be confusing with the rest
of the cgroup APIs but considering that this is the first time somebody
is actually complaining and the interface is "production ready" for more
than three years I am not really sure the situation is all that bad.
-- 
Michal Hocko
SUSE Labs
