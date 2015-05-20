From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 2/2] mm, memcg: Optionally disable memcg by default using
 Kconfig
Date: Wed, 20 May 2015 17:44:19 +0100
Message-ID: <20150520164419.GT2462@suse.de>
References: <1432126245-10908-1-git-send-email-mgorman@suse.de>
 <1432126245-10908-3-git-send-email-mgorman@suse.de>
 <20150520162421.GB2874@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520162421.GB2874-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 20, 2015 at 12:24:21PM -0400, Johannes Weiner wrote:
> > 
> > Low thread counts get a small boost but it's within noise as memcg overhead
> > does not dominate. It's not obvious at all at higher thread counts as other
> > factors cause more problems. The overall breakdown of CPU usage looks like
> > 
> >                4.0.0       4.0.0
> >         chargefirst-v2r1disable-v2r1
> > User           41.81       41.45
> > System        407.64      405.50
> > Elapsed       128.17      127.06
> 
> This is a worst case microbenchmark doing nothing but anonymous page
> faults (with THP disabled), and yet the performance difference is in
> the noise.  I don't see why we should burden the user with making a
> decision that doesn't matter in theory, let alone in practice.
> 
> We have CONFIG_MEMCG and cgroup_disable=memory, that should be plenty
> for users that obsess about fluctuation in the noise.  There is no
> reason to complicate the world further for everybody else.

FWIW, I agree and only included this patch because I said I would
yesterday. After patch 1, there is almost no motivation to disable memcg
at all let alone by default.

-- 
Mel Gorman
SUSE Labs
