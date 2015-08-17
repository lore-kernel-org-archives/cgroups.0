From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] memcg: generate file modified notifications on
 "memory.events"
Date: Mon, 17 Aug 2015 16:30:57 +0200
Message-ID: <20150817143056.GE10894@dhcp22.suse.cz>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
 <1439315889-3492-9-git-send-email-tj@kernel.org>
 <20150811180236.GE23408@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150811180236.GE23408-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[Ups this was hanging in to-be-posted since last week - sorry about that]

On Tue 11-08-15 14:02:36, Tejun Heo wrote:
> On Tue, Aug 11, 2015 at 01:58:09PM -0400, Tejun Heo wrote:
> > cgroup core only recently grew generic notification support.  Wire up
> > "memory.events" so that it triggers a file modified event whenever its
> > content changes.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I cannot say I would be fond of the offset logic but whatever suits the
cgroup core...

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> So, this won't apply to the current -mm.  Once the earlier part of the
> series gets applied to cgroup/for-4.3, I'll refresh this patch on top
> of -mm.

I think you can route it via the same tree.

-- 
Michal Hocko
SUSE Labs
