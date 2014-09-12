From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] memcg: use percpu_counter for statistics
Date: Fri, 12 Sep 2014 11:41:04 +0400
Message-ID: <20140912074104.GG4151@esperanza>
References: <cover.1410447097.git.vdavydov@parallels.com>
 <395271ceb801fdb6b97160bbdd38fa2214b29983.1410447097.git.vdavydov@parallels.com>
 <5412481C.2020101@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5412481C.2020101-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Motohiro Kosaki <Motohiro.Kosaki-gkcJ3tX5bYHQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khorenko <khorenko-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 12, 2014 at 10:10:52AM +0900, Kamezawa Hiroyuki wrote:
> (2014/09/12 0:41), Vladimir Davydov wrote:
> > In the next patch I need a quick way to get a value of
> > MEM_CGROUP_STAT_RSS. The current procedure (mem_cgroup_read_stat) is
> > slow (iterates over all cpus) and may sleep (uses get/put_online_cpus),
> > so it's a no-go.
> > 
> > This patch converts memory cgroup statistics to use percpu_counter so
> > that percpu_counter_read will do the trick.
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> 
> I have no strong objections but you need performance comparison to go with this.
> 
> I thought percpu counter was messy to be used for "array".
> I can't understand why you started from fixing future performance problem before
> merging new feature.

Because the present implementation of mem_cgroup_read_stat may sleep
(get/put_online_cpus) while I need to call it from atomic context in the
next patch.

I didn't do any performance comparisons, because it's just an RFC. It
exists only to attract attention to the problem. Using percpu counters
was the quickest way to implement a draft version, that's why I chose
them. It may have performance impact though, so it shouldn't be merged
w/o performance analysis.

Thanks,
Vladimir
