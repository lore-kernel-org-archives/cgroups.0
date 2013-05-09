From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v5 06/31] mm: new shrinker API
Date: Thu, 9 May 2013 14:30:54 +0100
Message-ID: <20130509133054.GU11497@suse.de>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org>
 <1368079608-5611-7-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1368079608-5611-7-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, hughd@google.com, Greg Thelen <gthelen@google.com>, linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@parallels.com>

On Thu, May 09, 2013 at 10:06:23AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current shrinker callout API uses an a single shrinker call for
> multiple functions. To determine the function, a special magical
> value is passed in a parameter to change the behaviour. This
> complicates the implementation and return value specification for
> the different behaviours.
> 
> Separate the two different behaviours into separate operations, one
> to return a count of freeable objects in the cache, and another to
> scan a certain number of objects in the cache for freeing. In
> defining these new operations, ensure the return values and
> resultant behaviours are clearly defined and documented.
> 
> Modify shrink_slab() to use the new API and implement the callouts
> for all the existing shrinkers.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Glauber Costa <glommer@parallels.com>

I'm ok with your explaination of long vs unsigned long for the object
count so

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
