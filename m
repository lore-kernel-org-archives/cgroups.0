From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v5 20/31] shrinker: Kill old ->shrink API.
Date: Thu, 9 May 2013 14:53:29 +0100
Message-ID: <20130509135329.GA11497@suse.de>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org>
 <1368079608-5611-21-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1368079608-5611-21-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, hughd@google.com, Greg Thelen <gthelen@google.com>, linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Thu, May 09, 2013 at 10:06:37AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are no more users of this API, so kill it dead, dead, dead and
> quietly bury the corpse in a shallow, unmarked grave in a dark
> forest deep in the hills...
> 
> [ glommer: added flowers to the grave ]
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Glauber Costa <glommer@openvz.org>
> Reviewed-by: Greg Thelen <gthelen@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
