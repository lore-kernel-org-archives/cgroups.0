From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mm, memcontrol: Implement memory.swap.events
Date: Mon, 26 Mar 2018 14:39:31 -0700
Message-ID: <20180326143931.41a15320fd4d4af26c86d42e@linux-foundation.org>
References: <20180324165127.701194-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180324165127.701194-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Sat, 24 Mar 2018 09:51:25 -0700 Tejun Heo <tj@kernel.org> wrote:

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

This doesn't appear to be in linux-next yet.  It should be by now if it's
targeted at 4.17?

