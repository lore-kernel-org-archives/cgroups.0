From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Mon, 22 Oct 2012 12:30:21 +0200
Message-ID: <20121022103021.GA6367@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
 <20121019133244.GE799@dhcp22.suse.cz>
 <20121019202405.GR13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121019202405.GR13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 19-10-12 13:24:05, Tejun Heo wrote:
> Hello, Michal.
> 
> On Fri, Oct 19, 2012 at 03:32:45PM +0200, Michal Hocko wrote:
> > On Thu 18-10-12 15:41:48, Tejun Heo wrote:
> > > Hello, Michal.
> > > 
> > > On Wed, Oct 17, 2012 at 03:30:46PM +0200, Michal Hocko wrote:
> > > > Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> > > > safely move on and forbit all the callbacks to fail. The last missing
> > > > piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> > > > that css_tryget fails so no new charges for the memcg can happen.
> > > > The callbacks are also called from within cgroup_lock to guarantee that
> > > > no new tasks show up. We could theoretically call them outside of the
> > > > lock but then we have to move after CGRP_REMOVED flag is set.
> > > > 
> > > > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > > 
> > > So, the plan is to do something like the following once memcg is
> > > ready.
> > > 
> > >   http://thread.gmane.org/gmane.linux.kernel.containers/22559/focus=75251
> > > 
> > > Note that the patch is broken in a couple places but it does show the
> > > general direction.  I'd prefer if patch #3 simply makes pre_destroy()
> > > return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
> > 
> > We can still fail inn #3 without this patch becasuse there are is no
> > guarantee that a new task is attached to the group. And I wanted to keep
> > memcg and generic cgroup parts separated.
> 
> Yes, but all other controllers are broken that way too

It's just hugetlb and memcg that have pre_destroy.

> and the worst thing which will hapen is triggering WARN_ON_ONCE().

The patch does BUG_ON(ss->pre_destroy(cgrp)). I am not sure WARN_ON_ONCE is
appropriate here because we would like to have it at least per
controller warning. I do not see any reason why to make this more
complicated but I am open to suggestions.

> Let's note the failure in the commit and remove
> DEPREDATED_clear_css_refs in the previous patch.  Then, I can pull
> from you, clean up pre_destroy mess and then you can pull back for
> further cleanups.

Well this will get complicated as there are dependencies between memcg
parts (based on Andrew's tree) and your tree. My tree is not pullable as
all the patches go via Andrew. I am not sure how to get out of this.
There is only one cgroup patch so what about pushing all of this via
Andrew and do the follow up cleanups once they get merged? We are not in
hurry, are we?

Anyway does it really make sense to drop DEPREDATED_clear_css_refs
already in the previous patch when it is _not_ guaranteed that
pre_destroy succeeds?
-- 
Michal Hocko
SUSE Labs
