From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Date: Wed, 14 Jan 2015 17:28:41 +0300
Message-ID: <20150114142841.GE11264@esperanza>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
 <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420776904-8559-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 08, 2015 at 11:15:04PM -0500, Johannes Weiner wrote:
>   - memory.low configures the lower end of the cgroup's expected
>     memory consumption range.  The kernel considers memory below that
>     boundary to be a reserve - the minimum that the workload needs in
>     order to make forward progress - and generally avoids reclaiming
>     it, unless there is an imminent risk of entering an OOM situation.

AFAICS, if a cgroup cannot be shrunk back to its low limit (e.g.
because it consumes anon memory, and there's no swap), it will get on
with it. Is it considered to be a problem? Are there any plans to fix
it, e.g. by invoking OOM-killer in a cgroup that is above its low limit
if we fail to reclaim from it?

Thanks,
Vladimir
