From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Date: Wed, 29 May 2013 15:05:38 +0200
Message-ID: <20130529130538.GD10224@dhcp22.suse.cz>
References: <20130517160247.GA10023@cmpxchg.org>
 <1369674791-13861-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369674791-13861-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 27-05-13 19:13:08, Michal Hocko wrote:
[...]
> Nevertheless I have encountered an issue while testing the huge number
> of groups scenario. And the issue is not limitted to only to this
> scenario unfortunately. As memcg iterators use per node-zone-priority
> cache to prevent from over reclaim it might quite easily happen that
> the walk will not visit all groups and will terminate the loop either
> prematurely or skip some groups. An example could be the direct reclaim
> racing with kswapd. This might cause that the loop misses over limit
> groups so no pages are scanned and so we will fall back to all groups
> reclaim.

And after some more testing and head scratching it turned out that
fallbacks to pass#2 I was seeing are caused by something else. It is
not race between iterators but rather reclaiming from zone DMA which
has troubles to scan anything despite there are pages on LRU and so we
fall back. I have to look into that more but what-ever the issue is it
shouldn't be related to the patch series.
-- 
Michal Hocko
SUSE Labs
