From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 4/6] cgroups: forbid pre_destroy callback to fail
Date: Mon, 29 Oct 2012 18:06:34 +0400
Message-ID: <508E8D6A.5040602@parallels.com>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-5-git-send-email-mhocko@suse.cz> <508E8CDE.1090702@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508E8CDE.1090702-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 10/29/2012 06:04 PM, Glauber Costa wrote:
> On 10/26/2012 03:37 PM, Michal Hocko wrote:
>> Now that mem_cgroup_pre_destroy callback doesn't fail (other than a race
>> with a task attach resp. child group appears) finally we can safely move
>> on and forbit all the callbacks to fail.
>> The last missing piece is moving cgroup_call_pre_destroy after
>> cgroup_clear_css_refs so that css_tryget fails so no new charges for the
>> memcg can happen.
>> We cannot, however, move cgroup_call_pre_destroy right after because we
>> cannot call mem_cgroup_pre_destroy with the cgroup_lock held (see
>> 3fa59dfb cgroup: fix potential deadlock in pre_destroy) so we have to
>> move it after the lock is released.
>>
> 
> If we don't have the cgroup lock held, how safe is the following
> statement in mem_cgroup_reparent_charges():
> 
> if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
> 	return -EBUSY;
> 
> ?
> 
> IIUC, although this is not generally safe, but it would be safe here
> because at this point we are expected to had already set the removed bit
> in the css. If this is the case, however, this condition is impossible
> and becomes useless - in which case you may want to remove it from Patch1.
> 
Which I just saw you doing in patch5... =)


