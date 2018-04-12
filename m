From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCHSET] mm, memcontrol: Implement memory.swap.events
Date: Thu, 12 Apr 2018 16:13:45 +0200
Message-ID: <20180412141345.GH23400@dhcp22.suse.cz>
References: <20180324165127.701194-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180324165127.701194-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi Tejun,
sorry for the late response. Are you plannig to repost?

On Sat 24-03-18 09:51:25, Tejun Heo wrote:
> Hello,
> 
> This patchset implements memory.swap.events which contains max and
> fail events so that userland can monitor and respond to swap running
> out.  It contains the following two patches.
> 
>  0001-mm-memcontrol-Move-swap-charge-handling-into-get_swa.patch
>  0002-mm-memcontrol-Implement-memory.swap.events.patch
> 
> This patchset is on top of the "cgroup/for-4.17: Make cgroup_rstat
> available to controllers" patchset[1] and "mm, memcontrol: Make
> cgroup_rstat available to controllers" patchset[2] and also available
> in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-memcg-swap.events
> 
> diffstat follows.
> 
>  Documentation/cgroup-v2.txt |   16 ++++++++++++++++
>  include/linux/memcontrol.h  |    5 +++++
>  mm/memcontrol.c             |   25 +++++++++++++++++++++++++
>  mm/shmem.c                  |    4 ----
>  mm/swap_slots.c             |   10 +++++++---
>  mm/swap_state.c             |    3 ---
>  6 files changed, 53 insertions(+), 10 deletions(-)
> 
> Thanks.
> 
> --
> tejun
> 
> [1] http://lkml.kernel.org/r/20180323231313.1254142-1-tj@kernel.org
> [2] http://lkml.kernel.org/r/20180324160901.512135-1-tj@kernel.org

-- 
Michal Hocko
SUSE Labs
