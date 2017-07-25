From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm, memcg: reset low limit during memcg offlining
Date: Tue, 25 Jul 2017 13:06:42 +0100
Message-ID: <20170725120642.GA12635@castle.DHCP.thefacebook.com>
References: <20170725114047.4073-1-guro@fb.com>
 <20170725115808.GE26723@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=9JoxCtqbgG1KC0ocGfXW5RByGSICi1xalngtyPSz6xQ=;
 b=YpYKsPik87+xM5usFIRhppwHK9j+swv8pQNh3k1GCZETP+q/9AEFTCf4XxdLO+/9JMnO
 T35ElQJVT2UA3x0dc6t01MzEWYJ/3PMhF+O/ywcV0KDA7Y+dgIUnAmiuTg4OOKSfzbXD
 aYY5433uEuEKDTM4XLuyHjiFJU/7DfZcBdk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9JoxCtqbgG1KC0ocGfXW5RByGSICi1xalngtyPSz6xQ=;
 b=azRa9g+Iqj+HSTOazR6xKSAx7sp8A9+AOan2sOszxjCtYz1WNWQR8Y2n6xhK1HAu295s+bbnMO4MOtQBLphA0yLxIsx4Mp24Saphg+1Xzk2BBf/XKEBLNBShuzwq4Go+wZwRdvv9ZAMp4jufz7FJdwflzALPoEjf3ZyZgONsS6M=
Content-Disposition: inline
In-Reply-To: <20170725115808.GE26723@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 25, 2017 at 01:58:08PM +0200, Michal Hocko wrote:
> On Tue 25-07-17 12:40:47, Roman Gushchin wrote:
> > A removed memory cgroup with a defined low limit and some belonging
> > pagecache has very low chances to be freed.
> > 
> > If a cgroup has been removed, there is likely no memory pressure inside
> > the cgroup, and the pagecache is protected from the external pressure
> > by the defined low limit. The cgroup will be freed only after
> > the reclaim of all belonging pages. And it will not happen until
> > there are any reclaimable memory in the system. That means,
> > there is a good chance, that a cold pagecache will reside
> > in the memory for an undefined amount of time, wasting
> > system resources.
> > 
> > Fix this issue by zeroing memcg->low during memcg offlining.
> 
> Very well spotted! This goes all the way down to low limit inclusion
> AFAICS. I would be even tempted to mark it for stable because hiding
> some memory from reclaim basically indefinitely is not good. We might
> have been just lucky nobody has noticed that yet.

I believe it's because there are not so many actual low limit users,
and those who do, are using some offstream patches to mitigate this issue.

Thanks!

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
