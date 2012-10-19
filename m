From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Fri, 19 Oct 2012 15:34:15 +0200
Message-ID: <20121019133415.GF799@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
 <20121018224606.GS13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121018224606.GS13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu 18-10-12 15:46:06, Tejun Heo wrote:
> On Thu, Oct 18, 2012 at 03:41:48PM -0700, Tejun Heo wrote:
> > Note that the patch is broken in a couple places but it does show the
> > general direction.  I'd prefer if patch #3 simply makes pre_destroy()
> > return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
> > Then, I can pull the branch in and drop all the unnecessary cruft.
> 
> But you need the locking change for further memcg cleanup.  To avoid
> interlocked pulls from both sides, I think it's okay to push this one
> with the rest of memcg changes.  I can do the cleanup on top of this
> whole series, but please do drop .__DEPRECATED_clear_css_refs from
> memcg.

OK I will drop that one.

>  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Do you still agree with the v2 based on Li's feedback?

Thanks
-- 
Michal Hocko
SUSE Labs
