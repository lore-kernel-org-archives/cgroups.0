From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 7/8] mm: memcg: modify PageCgroupAcctLRU non-atomically
Date: Thu, 24 Nov 2011 09:55:33 +0100
Message-ID: <20111124085532.GB6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-8-git-send-email-hannes@cmpxchg.org>
 <20111124090915.2f6e2e2c.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111124090915.2f6e2e2c.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 24, 2011 at 09:09:15AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 23 Nov 2011 16:42:30 +0100
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > This bit is protected by zone->lru_lock, there is no need for locked
> > operations when setting and clearing it.
> > 
> > Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> This atomic ops are for avoiding race with other ops as lock_page_cgroup().
> Or other Set/ClearPageCgroup....
> 
> Do I misunderstand atomic ops v.s. non-atomic ops race ?

Nope, you are spot-on.  I'm the cretin. ;-) See my reply to Hugh's
email.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
