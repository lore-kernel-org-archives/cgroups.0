From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Date: Mon, 5 Aug 2013 18:01:07 +0200
Message-ID: <20130805160107.GM10146@dhcp22.suse.cz>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375632446-2581-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun 04-08-13 12:07:21, Tejun Heo wrote:
> Hello,

Hi Tejun,

> Like many other things in cgroup, cgroup_event is way too flexible and
> complex - it strives to provide completely flexible event monitoring
> facility in cgroup proper which allows any number of users to monitor
> custom events.  This is overboard, to say the least,

Could you be more specific about what is so "overboard" about this
interface? I am not familiar with internals much, so I cannot judge the
complexity part, but I thought that eventfd was intended for this kind
of kernel->userspace notifications.

> and I strongly think that cgroup should not any new usages of this
> facility and preferably deprecate the existing usages if at all
> possible.

So you think that vmpressure, oom notification or thresholds are
an abuse of this interface? What would you consider a reasonable
replacement for those notifications?  Or do you think that controller
shouldn't be signaling any conditions to the userspace at all?

[...]
-- 
Michal Hocko
SUSE Labs
