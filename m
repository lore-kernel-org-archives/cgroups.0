From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCHSET for-4.11] cgroup: avoid spurious identity ->*attach()
 invocations
Date: Wed, 11 Jan 2017 18:46:33 +0800
Message-ID: <58760D09.9010508@huawei.com>
References: <20161229221115.31995-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161229221115.31995-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2016/12/30 6:11, Tejun Heo wrote:
> Hello,
> 
> On the v2 hierarchy, when controllers are enabled and disabled, other
> ->*attach() callbacks of other controllers are called spuriously with
> the same source and destination.  While this isn't critical, it's a
> bit nasty and can lead to temporary double charging on certain
> controllers.  This patchset fixes the issue.
> 
> This patchset contains the following three patches.
> 
>  0001-cgroup-cosmetic-update-to-cgroup_taskset_add.patch
>  0002-cgroup-track-migration-context-in-cgroup_mgctx.patch
>  0003-cgroup-call-subsys-attach-only-for-subsystems-which-.patch
> 
> 0001-0002 restructures migration context tracking so that extra state
> can be tracked easily.  0003 fixes the spurious ->*attach()
> invocations.
> 
> This patchset is also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-avoid-identity-attach
> 
> diffstat follows.
> 
>  kernel/cgroup/cgroup-internal.h |   69 +++++++++++++++--
>  kernel/cgroup/cgroup-v1.c       |   10 +-
>  kernel/cgroup/cgroup.c          |  161 ++++++++++++++++------------------------
>  3 files changed, 135 insertions(+), 105 deletions(-)
> 

Acked-by: Zefan Li <lizefan@huawei.com>

