From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 16/18] slab: propagate tunables values
Date: Mon, 22 Oct 2012 11:48:01 +0400
Message-ID: <5084FA31.4060709@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-17-git-send-email-glommer@parallels.com> <0000013a7a94c439-825659cc-8e6a-4905-909c-db1b230a4086-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <0000013a7a94c439-825659cc-8e6a-4905-909c-db1b230a4086-000000@email.amazonses.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On 10/19/2012 11:51 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> SLAB allows us to tune a particular cache behavior with tunables.
>> When creating a new memcg cache copy, we'd like to preserve any tunables
>> the parent cache already had.
> 
> SLAB and SLUB allow tuning. Could you come up with some way to put these
> things into slab common and make it flexible so that the tuning could be
> used for future allocators (like SLAM etc)?
> 
They do, but they also do it very differently. Like slub uses sysfs,
while slab don't.

I of course fully support the integration, I just don't think this
should be a blocker for all kinds of work in the allocators. Converting
slab to sysfs seems to be a major work, that you are already tackling.
Were it simple, I believe it would be done already. Without it, this is
pretty much a fake integration...

In summary, adding this doesn't make the integration work any harder in
the future, and blocking this particular thing on sysfs integration is
unreasonable.

This being by far not central to the patchset, if this is an absolute
requirement, maybe I should just drop it for the time being so it
doesn't stall the rest of the development.



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
