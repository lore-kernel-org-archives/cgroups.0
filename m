From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Tue, 28 Feb 2023 17:46:27 +0000
Message-ID: <20230228174627.vja5aejq27dsta2u@airbuntu>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <20230223153859.37tqoqk33oc6tv7o@airbuntu>
 <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
 <20230227205725.dipvh3i7dvyrv4tv@airbuntu>
 <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qd/+u84uDJwmpmYQF6SxZJhUAGP+xDhIDUueY75BVF8=;
        b=8GeXLjmBzEKuAmCFyT/3Bmq4kvfZUwyLF3wQFoUaJpWg6H29SDgKIWeaPcrNdBDl/j
         VLtShRsfbXUd30ohfMaQ4kwqR+LCmomSkLl72gPzJhgmpyIVhFWOg0Nm//qVPRfImP8k
         AHHnxzPBvgPmE9yWVFmqL2M49k2pujDH8HBB7+JxIeONfAQ2B0pZLQSfeGWJiCBeLSbr
         7RUa/1ffAfw6anxPDK7FRlB6SdXMsklPGbQDRQWa4ZCkeq3XMJ/xa3Gs7oDTVmjGSNE1
         +dnvzpdSwD3VabNDpgHE98iuv4UAqEKG9sXxUlqeoEYy8NEAcYa1e7ovtkJZx7WVyhaj
         r9ig==
Content-Disposition: inline
In-Reply-To: <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 02/28/23 15:09, Dietmar Eggemann wrote:

> > IIUC you're suggesting to introduce some new mechanism to detect if hotplug has
> > lead to a cpu to disappear or not and use that instead? Are you saying I can
> > use arch_update_cpu_topology() for that? Something like this?
> > 
> > 	diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > 	index e5ddc8e11e5d..60c3dcf06f0d 100644
> > 	--- a/kernel/cgroup/cpuset.c
> > 	+++ b/kernel/cgroup/cpuset.c
> > 	@@ -1122,7 +1122,7 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> > 	 {
> > 		mutex_lock(&sched_domains_mutex);
> > 		partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
> > 	-       if (update_dl_accounting)
> > 	+       if (arch_update_cpu_topology())
> > 			update_dl_rd_accounting();
> > 		mutex_unlock(&sched_domains_mutex);
> > 	 }
> 
> No, this is not what I meant. I'm just saying the:
> 
>   partition_sched_domains_locked()
>     new_topology = arch_update_cpu_topology();
> 
> has to be considered here as well since we do a
> `dl_clear_root_domain(rd)` (1) in partition_sched_domains_locked() for
> !new_topology.

Ah you're referring to the dl_clear_root_domain() call there. I thought this
doesn't trigger.

> 
> And (1) requires the `update_tasks_root_domain()` to happen later.
> 
> So there are cases now, e.g. `rebuild_sched_domains_energy()` in which
> `new_topology=0` and `update_dl_accounting=false` which now clean the rd
> but don't do a new DL accounting anymore.
> rebuild_root_domains() itself cleans the `default root domain`, not the
> other root domains which could exists as well.
> 
> Example: Switching CPUfreq policy [0,3-5] performance to schedutil (slow
> switching, i.e. we have sugov:X DL task(s)):
> 
> [  862.479906] CPU4 partition_sched_domains_locked() new_topology=0
> [  862.499073] Workqueue: events rebuild_sd_workfn
> [  862.503646] Call trace:
> ...
> [  862.520789]  partition_sched_domains_locked+0x6c/0x670
> [  862.525962]  rebuild_sched_domains_locked+0x204/0x8a0
> [  862.531050]  rebuild_sched_domains+0x2c/0x50
> [  862.535351]  rebuild_sd_workfn+0x38/0x54                        <-- !
> ...
> [  862.554047] CPU4 dl_clear_root_domain() rd->span=0-5 total_bw=0
> def_root_domain=0                                                  <-- !
> [  862.561597] CPU4 dl_clear_root_domain() rd->span= total_bw=0
> def_root_domain=1
> [  862.568960] CPU4 dl_add_task_root_domain() [sugov:0 1801]
> total_bw=104857 def_root_domain=0 rd=0xffff0008015f0000            <-- !
> 
> The dl_clear_root_domain() of the def_root_domain and the
> dl_add_task_root_domain() to the rd in use won't happen.
> 
> [sugov:0 1801] is only a simple example here. I could have spawned a
> couple of DL tasks before this to illustrate the issue more obvious.
> 
> ---
> 
> The same seems to happen during suspend/resume (system with 2 frequency
> domains, both with slow switching schedutil CPUfreq gov):
> 
> [   27.735821] CPU5 partition_sched_domains_locked() new_topology=0
> ...
> [   27.735864] Workqueue: events cpuset_hotplug_workfn
> [   27.735894] Call trace:
> ...
> [   27.735984]  partition_sched_domains_locked+0x6c/0x670
> [   27.736004]  rebuild_sched_domains_locked+0x204/0x8a0
> [   27.736026]  cpuset_hotplug_workfn+0x254/0x52c                  <-- !
> ...
> [   27.736155] CPU5 dl_clear_root_domain() rd->span=0-5 total_bw=0
> def_root_domain=0                                                  <-- !
> [   27.736178] CPU5 dl_clear_root_domain() rd->span= total_bw=0
> def_root_domain=1
> [   27.736296] CPU5 dl_add_task_root_domain() [sugov:0 80]         <-- !
>  total_bw=104857 def_root_domain=0 rd=0xffff000801728000
> [   27.736318] CPU5 dl_add_task_root_domain() [sugov:1 81]
> total_bw=209714 def_root_domain=0 rd=0xffff000801728000            <-- !
> ...
> 
> > I am not keen on this. arm64 seems to just read a value without a side effect.
> 
> Arm64 (among others) sets `update_topology=1` before
> `rebuild_sched_domains()` and `update_topology=0` after it in
> update_topology_flags_workfn(). This then makes `new_topology=1` in
> partition_sched_domains_locked().
> 
> > But x86 does reset this value so we can't read it twice in the same call tree
> > and I'll have to extract it.
> > 
> > The better solution that was discussed before is to not iterate through every
> > task in the system and let cpuset track when dl tasks are added to it and do
> > smarter iteration. ATM even if there are no dl tasks in the system we'll
> > blindly go through every task in the hierarchy to update nothing.
> 
> Yes, I can see the problem. And IMHO this solution approach seems to be
> better than parsing update_dl_accounting` through the stack of involved
> functions.

The best I can do is protect this dl_clear_root_domain() too. I really don't
have my heart in this but trying my best to help, but it has taken a lot of my
time already and would prefer to hand over to Juri to address this regression
if what I am proposing is not good enough.

FWIW, there are 0 dl tasks in the system where this was noticed. And this delay
is unbounded because it'll depend on how many tasks there are in the hierarchy.


Thanks!
