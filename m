From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v4 10/31] dcache: convert to use new lru list infrastructure
Date: Tue, 30 Apr 2013 20:13:18 +0400
Message-ID: <517FED9E.9020906@parallels.com>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org> <1367018367-11278-11-git-send-email-glommer@openvz.org> <20130430160411.GJ6415@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130430160411.GJ6415@suse.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman@suse.de>
Cc: Glauber Costa <glommer@openvz.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>


> 
> To save wasting space you could also put them each beside otherwise
> read-mostly data, before s_mounts (per-cpu data before it should be
> cache-aligned) and anywhere near the end of the structure without the
> cache alignment directives.
> 
> Otherwise nothing jumped at me.
> 
I will add:

Nothing-jumped-at: Mel Gorman <mgorman@suse.de>

=)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
