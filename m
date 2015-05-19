From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCHSET cgroup/for-4.2] cgroup: make multi-process migration
 atomic
Date: Tue, 19 May 2015 14:57:37 +0800
Message-ID: <555ADEE1.30807@huawei.com>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1431978595-12176-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, linux-mm@kvack.org

On 2015/5/19 3:49, Tejun Heo wrote:
> Hello,
> 
> When a controller is enabled or disabled on the unified hierarchy, the
> effective css changes for all processes in the sub-hierarchy which
> virtually is multi-process migration.  This is implemented in
> cgroup_update_dfl_csses() as process-by-process migration - all the
> target source css_sets are first chained to the target list and
> processes are drained from them one-by-one.
> 
> If a process gets rejected by a controller after some are successfully
> migrated, the recovery action is tricky.  The changes which have
> happened upto this point have to be rolled back but there's nothing
> guaranteeing such rollback would be successful either.
> 
> The unified hierarchy didn't need to deal with this issue because
> organizational operations were expected to always succeed;
> unfortunately, it turned out that such policy doesn't work too well
> for certain type of resources and unified hierarchy would need to
> allow migration failures for some restrictied cases.
> 
> This patch updates multi-process migration in
> cgroup_update_dfl_csses() atomic so that ->can_attach() can fail the
> whole transaction.  It's consisted of the following seven patches.
> 
>  0001-cpuset-migrate-memory-only-for-threadgroup-leaders.patch
>  0002-memcg-restructure-mem_cgroup_can_attach.patch
>  0003-memcg-immigrate-charges-only-when-a-threadgroup-lead.patch
>  0004-cgroup-memcg-cpuset-implement-cgroup_taskset_for_eac.patch
>  0005-reorder-cgroup_migrate-s-parameters.patch
>  0006-cgroup-separate-out-taskset-operations-from-cgroup_m.patch
>  0007-cgroup-make-cgroup_update_dfl_csses-migrate-all-targ.patch
> 

Thanks for working on this. The patchset looks good to me.

Acked-by: Zefan Li <lizefan@huawei.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
