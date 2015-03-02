From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: disable hierarchy support if bound to the
 legacy cgroup hierarchy
Date: Mon, 2 Mar 2015 12:33:15 -0500
Message-ID: <20150302173315.GA24664@phnom.home.cmpxchg.org>
References: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
 <421fb6bbff04eb70b8ad82b51efd373f0b4d170f.1424356325.git.vdavydov@parallels.com>
 <20150302171323.GM17694@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150302171323.GM17694-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 02, 2015 at 12:13:23PM -0500, Tejun Heo wrote:
> On Thu, Feb 19, 2015 at 05:34:47PM +0300, Vladimir Davydov wrote:
> > If the memory cgroup controller is initially mounted in the scope of the
> > default cgroup hierarchy and then remounted to a legacy hierarchy, it
> > will still have hierarchy support enabled, which is incorrect. We should
> > disable hierarchy support if bound to the legacy cgroup hierarchy.
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> Johannes, Michal, can you guys pick this up?

Yup, will do.
