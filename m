From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
Date: Wed, 14 Nov 2012 15:05:46 +0400
Message-ID: <50A37B0A.7010608@parallels.com>
References: <1352775704-9023-1-git-send-email-tj@kernel.org> <1352775704-9023-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352775704-9023-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org

On 11/13/2012 07:01 AM, Tejun Heo wrote:
> cgroup->dentry is marked and used as a RCU pointer; however, it isn't
> one - the final dentry put doesn't go through call_rcu().  cgroup and
> dentry share the same RCU freeing rule via synchronize_rcu() in
> cgroup_diput() (kfree_rcu() used on cgrp is unnecessary).  If cgrp is
> accessible under RCU read lock, so is its dentry and dereferencing
> cgrp->dentry doesn't need any further RCU protection or annotation.
> 
> While not being accurate, before the previous patch, the RCU accessors
> served a purpose as memory barriers - cgroup->dentry used to be
> assigned after the cgroup was made visible to cgroup_path(), so the
> assignment and dereferencing in cgroup_path() needed the memory
> barrier pair.  Now that list_add_tail_rcu() happens after
> cgroup->dentry is assigned, this no longer is necessary.
> 
> Remove the now unnecessary and misleading RCU annotations from
> cgroup->dentry.  To make up for the removal of rcu_dereference_check()
> in cgroup_path(), add an explicit rcu_lockdep_assert(), which asserts
> the dereference rule of @cgrp, not cgrp->dentry.
> 

Will memcontrol.c need similar amendments?

The code that lives in -mm and includes kmemcg includes the following
excerpt:

        rcu_read_lock();
        dentry = rcu_dereference(memcg->css.cgroup->dentry);
        rcu_read_unlock();

