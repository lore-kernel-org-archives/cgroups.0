From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Try charging a page before setting page
 up to date
Date: Wed, 20 May 2015 16:18:55 +0200
Message-ID: <20150520141854.GE28678@dhcp22.suse.cz>
References: <1432126245-10908-1-git-send-email-mgorman@suse.de>
 <1432126245-10908-2-git-send-email-mgorman@suse.de>
 <20150520140353.GC28678@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520140353.GC28678-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 20-05-15 16:03:53, Michal Hocko wrote:
> I am wondering why do we still have both
> __SetPageUptodate and SetPageUptodate when they are same. Historically
> they were slightly different but this is no longer the case.

Bahh,  I am blind and failed spot a difference game. It is __set_bit vs
set_bit. Sorry about the noise.
-- 
Michal Hocko
SUSE Labs
