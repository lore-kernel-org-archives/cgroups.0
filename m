From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Bug report - OOM killer kills task outside of cgroup
Date: Fri, 12 Sep 2014 17:32:22 +0200
Message-ID: <20140912153222.GG12156@dhcp22.suse.cz>
References: <CALehsD6wjTSn2P6vaurL65XLGCymgbMEiddw5=PGBE5+YQq-Gg@mail.gmail.com>
 <20140912015833.GA7415@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8X8iK5TCBMOaXFsPq6dGkHp9mvhlke86OXSVPCUiFro=;
        b=BPXAx2/4F++VfFv+wM/T3hhlyGgEHh7sarK3nMqCwEdkBLXkYdhc1+99TKQTnbspYf
         LMiG2h1wm9eEDtMti1ZkF2N6l/V8WM4Yq6O5nXKO3BLvebEocCRoU01gwmcd3jJp4Gtc
         CJNYv0JSmignVRltPIz3+/Z75wo5VInGrOd7QLShP1V0hvIkoewyxKYOYANPUv2ulkQ7
         K2svBk4yM8GIrXnKqOZm5tFKm5WQttOVzItycm+n2PbDAlv82u6hHR227K676MiMltiX
         ACBO62rS04KClDgoipjw+SwNMiFe8kiqq+KvjvEOaIlePGTRw11pkx918KRHwgXextVs
         ISkQ==
Content-Disposition: inline
In-Reply-To: <20140912015833.GA7415-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tyler Power <tylerp-0OmgUqZ5G+O9C01uVemLPA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri 12-09-14 10:58:33, Tejun Heo wrote:
> (cc'ing memcg maintainers and quoting whole body)
> 
> On Thu, Sep 11, 2014 at 02:05:19PM +1200, Tyler Power wrote:
> > Hi there,
> > 
> > Hopefully I'm sending this to the right place, this is the first time
> > I've reported a kernel bug. I'm roughly following this format here
> > https://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html.
> > 
> > 1. The OOM killer kicks in to kill processes inside a cgroup that has
> > hit its memory limit but sometimes kills a process outside of the
> > cgroup
> > 
> > 2. We've encountered an error on Ubuntu 12.04 running on vsphere with
> > kernel linux-image-3.13.0-32-generic as well as
> > linux-image-3.13.0-35-generic which causes the machine to hard lock
> > up. It is completely unresponsive until hard reset.

I am not familiar with Ubuntu kernels much but are those kernels
applying any patches on top of 3.13? If yes can you reproduce with the
issue with the Vanilla kernel?
It would be also good to know whether the same issue is reproducible
with the current Linus' tree.

[ 2634.867954] Task in /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4 killed as a result of limit of /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
[ 2634.988982] Task in /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4 killed as a result of limit of /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
[ 2635.101917] Task in /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4 killed as a result of limit of /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
[ 2635.212105] Task in / killed as a result of limit of /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4

So this is about the same memcg all the time (except for the last one
which is obviously invalid).
The oom reports are suspicious though:
[ 2634.922570] Memory cgroup out of memory: Kill process 15919 (java) score 904 or sacrifice child
[ 2634.924952] Killed process 15758 (bash) total-vm:11040kB, anon-rss:216kB, file-rss:416kB
[ 2635.041469] Memory cgroup out of memory: Kill process 15919 (java) score 904 or sacrifice child
[ 2635.043872] Killed process 15757 (bash) total-vm:11040kB, anon-rss:216kB, file-rss:392kB
[ 2635.150580] Memory cgroup out of memory: Kill process 15919 (java) score 906 or sacrifice child
[ 2635.153010] Killed process 15919 (java) total-vm:2205588kB, anon-rss:58444kB, file-rss:564kB
[ 2635.249819] Memory cgroup out of memory: Kill process 15861 (java) score 918 or sacrifice child

So we are always selecting 15919 but actually killing bash instead. At
least two times. The third time it is java that is killed and then
things go south.
15919 is not listed as a memcg member:
[ 2634.888650] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[ 2634.891018] [15552]     0 15552    12511      732      29        0 0 sshd
[ 2634.893373] [15596]     0 15596     5180      276      15        0 0 cron
[ 2634.895686] [15731]     0 15731    19971      926      43        0 0 sshd
[ 2634.898004] [15735]  1014 15735    19971      395      40        0 0 sshd
[ 2634.900305] [15736]  1014 15736     2760      376      10        0 0 bash
[ 2634.902588] [15756]  1014 15756   551397    14730      92        0 0 java
[ 2634.904853] [15757]  1014 15757     2760      152      10        0 0 bash
[ 2634.907080] [15758]  1014 15758     2760      158      10        0 0 bash
[ 2634.909316] [15759]  1014 15759     1472      171       7        0 0 tee
[ 2634.911495] [15760]  1014 15760     1472      172       8        0 0 tee
[ 2634.913689] [15936]     0 15936    11535      338      28        0 0 cron
[ 2634.915905] [15937]     0 15937     1102      153       8        0 0 sh
[ 2634.918055] [15938]     0 15938     1102      153       8        0 0 maxlifetime
[ 2634.920385] [15940]     0 15940    53661     2029     105        0 0 php5

mem_cgroup_out_of_memory relies on css_task_iter to iterate through all
tasks (threads) belonging to a memcg. Memcg just makes sure that memcgs
under the target one are considered. So it might be possible that a
!thread_group_leader has been chosen. dump_tasks would then ignore it.
This alone wouldn't be a big deal.

How we could end up killing bash as a child doesn't make any sense to
me. First children are killed only if they have a bigger score and
second bash as a child of Java?

3.13 kernel didn't have 1da4db0cd5c8a which is mentioning endless loops.
As the lockup was detected and we do not see "Killed process XYZ" it
might be possible that we are still in do {} while_each_thread() loop.
This is called with preemption disabled so lockup detector would be
quite natural if the loop cannot finish.
-- 
Michal Hocko
SUSE Labs
