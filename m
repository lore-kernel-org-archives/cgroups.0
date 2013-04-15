From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCHSET] cgroup, memcg: introduce sane_behavior mount option
Date: Mon, 15 Apr 2013 07:46:33 -0700
Message-ID: <20130415144633.GD13662@dhcp22.suse.cz>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <20130415031754.GG3050@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130415031754.GG3050-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Sun 14-04-13 20:17:54, Tejun Heo wrote:
> On Fri, Apr 12, 2013 at 04:10:55PM -0700, Tejun Heo wrote:
> > To make progress, those behaviors need to go but we can't simply drop
> > or change the crazies as those are directly visible to userland.  This
> > patchset implements a mount option - sane_behavior - which turns on
> > new saner behaviors, so that we can keep providing the old behaviors
> > while and after transitioning to saner ones.
> 
> Applied 1-3 to cgroup/for-3.10.  Michal, I left the last memcg one
> out.  Please let me know how you wanna route it.

You can route it via your tree as it seems like the simplest way.

Thanks!
-- 
Michal Hocko
SUSE Labs
