From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 35/35] memcg: reap dead memcgs upon global memory
 pressure.
Date: Wed, 5 Jun 2013 16:09:02 -0700
Message-ID: <20130605160902.2e656a43aa7c5a51a574ea48@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-36-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1370287804-3481-36-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@redhat.com>

On Mon,  3 Jun 2013 23:30:04 +0400 Glauber Costa <glommer@openvz.org> wrote:

> When we delete kmem-enabled memcgs, they can still be zombieing
> around for a while. The reason is that the objects may still be alive,
> and we won't be able to delete them at destruction time.
> 
> The only entry point for that, though, are the shrinkers. The
> shrinker interface, however, is not exactly tailored to our needs. It
> could be a little bit better by using the API Dave Chinner proposed, but
> it is still not ideal since we aren't really a count-and-scan event, but
> more a one-off flush-all-you-can event that would have to abuse that
> somehow.

This patch is significantly dependent on
http://ozlabs.org/~akpm/mmots/broken-out/memcg-debugging-facility-to-access-dangling-memcgs.patch,
which was designated "mm only debug patch" when I merged it six months
ago.

We can go ahead and merge
memcg-debugging-facility-to-access-dangling-memcgs.patch upstream I
guess, but we shouldn't do that just because it makes the
patch-wrangling a bit easier!

Is memcg-debugging-facility-to-access-dangling-memcgs.patch worth merging in
its own right?  If so, what changed since our earlier decision?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
