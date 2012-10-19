From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Fri, 19 Oct 2012 15:32:45 +0200
Message-ID: <20121019133244.GE799@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121018224148.GR13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu 18-10-12 15:41:48, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Oct 17, 2012 at 03:30:46PM +0200, Michal Hocko wrote:
> > Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> > safely move on and forbit all the callbacks to fail. The last missing
> > piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> > that css_tryget fails so no new charges for the memcg can happen.
> > The callbacks are also called from within cgroup_lock to guarantee that
> > no new tasks show up. We could theoretically call them outside of the
> > lock but then we have to move after CGRP_REMOVED flag is set.
> > 
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> So, the plan is to do something like the following once memcg is
> ready.
> 
>   http://thread.gmane.org/gmane.linux.kernel.containers/22559/focus=75251
> 
> Note that the patch is broken in a couple places but it does show the
> general direction.  I'd prefer if patch #3 simply makes pre_destroy()
> return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.

We can still fail inn #3 without this patch becasuse there are is no
guarantee that a new task is attached to the group. And I wanted to keep
memcg and generic cgroup parts separated.
-- 
Michal Hocko
SUSE Labs
