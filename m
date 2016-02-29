From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: reset memory.low on css offline
Date: Mon, 29 Feb 2016 15:02:55 -0500
Message-ID: <20160229200255.GA32539@cmpxchg.org>
References: <1456766193-16255-1-git-send-email-vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456766193-16255-1-git-send-email-vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 29, 2016 at 08:16:33PM +0300, Vladimir Davydov wrote:
> When a cgroup directory is removed, the memory cgroup subsys state does
> not disappear immediately. Instead, it's left hanging around until the
> last reference to it is gone, which implies reclaiming all pages from
> its lruvec.
> 
> In the unified hierarchy, there's the memory.low knob, which can be used
> to set a best-effort protection for a memory cgroup - the reclaimer
> first scans those cgroups whose consumption is above memory.low, and
> only if it fails to reclaim enough pages, it gets to the rest.
> 
> Currently this protection is not reset when the cgroup directory is
> removed. As a result, if a dead memory cgroup has a lot of page cache
> charged to it and a high value of memory.low, it will result in higher
> pressure exerted on live cgroups, and userspace will have no ways to
> detect such consumers and reconfigure memory.low properly.
> 
> To fix this, let's reset memory.low on css offline.

We already have mem_cgroup_css_reset() for soft-offlining a css - when
the css is asked to be disabled but another subsystem still uses it.
Can we just call that function during offline as well? The css can be
around for quite a bit after the user deleted it. Eliminating *any*
user-supplied configurations and zapping it back to defaults makes
sense in general, so that we never have to worry about any remnants.
