From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 2/6] memcg: root_cgroup cannot reach
 mem_cgroup_move_parent
Date: Mon, 29 Oct 2012 14:52:03 +0100
Message-ID: <20121029135203.GA20757@dhcp22.suse.cz>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <1351251453-6140-3-git-send-email-mhocko@suse.cz>
 <508E8910.40203@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <508E8910.40203-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon 29-10-12 17:48:00, Glauber Costa wrote:
> On 10/26/2012 03:37 PM, Michal Hocko wrote:
> > The root cgroup cannot be destroyed so we never hit it down the
> > mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
> > even try to do anything if called for the root.
> > 
> > This means that mem_cgroup_move_parent doesn't have to bother with the
> > root cgroup and it can assume it can always move charges upwards.
> > 
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> I think it would be safer to have this folded in the last patch, to
> avoid a weird intermediate state (specially for force_empty).

force_empty excludes root cgroup explicitly so there is no way to fail
here. I have kept VM_BUG_ON for future reference but it also can go away
completely.

> Being a single statement, it doesn't confuse review so much.
> 
> However, this is also pretty much just a nitpick, do as you prefer.
> 
> Reviewed-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 

-- 
Michal Hocko
SUSE Labs
