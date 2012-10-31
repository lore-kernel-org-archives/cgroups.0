From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Wed, 31 Oct 2012 21:49:36 +0100
Message-ID: <20121031204936.GI1271@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-2-git-send-email-tj@kernel.org>
 <20121031200859.GE1271@dhcp22.suse.cz>
 <CAOS58YPbYoMJ1+3uRfK_ZERyZoaby=FPW7uTpp8dVOSgYC8Mrw@mail.gmail.com>
 <20121031201415.GG1271@dhcp22.suse.cz>
 <20121031202400.GT2945@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121031202400.GT2945-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 31-10-12 13:24:00, Tejun Heo wrote:
[...]
> local_irq_save/restore() from cgroup_clear_css_refs() are replaced
> with local_irq_disable/enable() for simplicity.  This is safe as
> cgroup_rmdir() is always called with IRQ enabled.  Note that this IRQ
> switching is necessary to ensure that css_tryget() isn't called from
> IRQ context on the same CPU while lower context is between CSS
> deactivation and setting CSS_REMOVED as css_tryget() would hang
> forever in such cases waiting for CSS to be re-activated or
> CSS_REMOVED set.  This will go away soon.

Much better. Thanks a lot!
-- 
Michal Hocko
SUSE Labs
