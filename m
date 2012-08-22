From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Date: Wed, 22 Aug 2012 12:22:49 +0400
Message-ID: <503496D9.3020806@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <20120817090005.GC18600@dhcp22.suse.cz> <502E0BC3.8090204@parallels.com> <20120817093504.GE18600@dhcp22.suse.cz> <502E17C4.7060204@parallels.com> <20120817103550.GF18600@dhcp22.suse.cz> <502E1E90.1080805@parallels.com> <20120821075430.GA19797@dhcp22.suse.cz> <50335341.6010400@parallels.com> <20120821100007.GE19797@dhcp22.suse.cz> <xr93fw7fbumo.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <xr93fw7fbumo.fsf@gthelen.mtv.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>


>>>
>>> I am fine with either, I just need a clear sign from you guys so I don't
>>> keep deimplementing and reimplementing this forever.
>>
>> I would be for make it simple now and go with additional features later
>> when there is a demand for them. Maybe we will have runtimg switch for
>> user memory accounting as well one day.
>>
>> But let's see what others think?
> 
> In my use case memcg will either be disable or (enabled and kmem
> limiting enabled).
> 
> I'm not sure I follow the discussion about history.  Are we saying that
> once a kmem limit is set then kmem will be accounted/charged to memcg.
> Is this discussion about the static branches/etc that are autotuned the
> first time is enabled?  

No, the question is about when you unlimit a former kmem-limited memcg.

> The first time its set there parts of the system
> will be adjusted in such a way that may impose a performance overhead
> (static branches, etc).  Thereafter the performance cannot be regained
> without a reboot.  This makes sense to me.  Are we saying that
> kmem.limit_in_bytes will have three states?

It is not about performance, about interface.

Michal says that once a particular memcg was kmem-limited, it will keep
accounting pages, even if you make it unlimited. The limits won't be
enforced, for sure - there is no limit, but pages will still be accounted.

This simplifies the code galore, but I worry about the interface: A
person looking at the current status of the files only, without
knowledge of past history, can't tell if allocations will be tracked or not.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
