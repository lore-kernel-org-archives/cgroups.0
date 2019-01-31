From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/pids: turn cgroup_subsys->free() into
 cgroup_subsys->release() to fix the accounting
Date: Thu, 31 Jan 2019 06:56:20 -0800
Message-ID: <20190131145620.GC50184@devbig004.ftw2.facebook.com>
References: <20190128160013.GA21219@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wqkae5/SZUXV0XpHwrdhyDmdmZuXObNbFvC+52gNI10=;
        b=T+tfKU9bLG/Ze8iEPeVXdRWijWD8iEUGg5hxZ7uE66Rm49Duni5enxE3uJgCj0ClBE
         8OHx1m0Y2s0wwyJHaSsN76bNKEbEG0RWW2e/Ft212//gGXoVP+sO1/qflAXTBx+FwUiS
         icEdvmjlo+NbU2KspZtxwijuTJEK40AKekvdtptVupBJ5hN23RQdGH9bPORrBFsiB59S
         eA+FsM2mQKfMnbjlR3cIWbUHKOfV0+fGr8LQPdnG3qcRwTzAK8lcHMa37eXx9CWGuAn5
         MvTn09SulsASG7+Bii1yDxsMlik+rv0QvEZYmbMwOyPxR9gviKae5xbVAcFtBvh+Xo0c
         1HiA==
Content-Disposition: inline
In-Reply-To: <20190128160013.GA21219@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Herton Krzesinski <hkrzesin@redhat.com>, Jan Stancek <jstancek@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jan 28, 2019 at 05:00:13PM +0100, Oleg Nesterov wrote:
> The only user of cgroup_subsys->free() callback is pids_cgrp_subsys which
> needs pids_free() to uncharge the pid.
> 
> However, ->free() is called from __put_task_struct()->cgroup_free() and this
> is too late. Even the trivial program which does
> 
> 	for (;;) {
> 		int pid = fork();
> 		assert(pid >= 0);
> 		if (pid)
> 			wait(NULL);
> 		else
> 			exit(0);
> 	}
> 
> can run out of limits because release_task()->call_rcu(delayed_put_task_struct)
> implies an RCU gp after the task/pid goes away and before the final put().
> 
> Test-case:
> 
> 	mkdir -p /tmp/CG
> 	mount -t cgroup2 none /tmp/CG
> 	echo '+pids' > /tmp/CG/cgroup.subtree_control
> 
> 	mkdir /tmp/CG/PID
> 	echo 2 > /tmp/CG/PID/pids.max
> 
> 	perl -e 'while ($p = fork) { wait; } $p // die "fork failed: $!\n"' &
> 	echo $! > /tmp/CG/PID/cgroup.procs
> 
> Without this patch the forking process fails soon after migration.
> 
> Rename cgroup_subsys->free() to cgroup_subsys->release() and move the callsite
> into the new helper, cgroup_release(), called by release_task() which actually
> frees the pid(s).
> 
> Reported-by: Herton R. Krzesinski <hkrzesin@redhat.com>
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to cgroup/for-5.0.

Thanks, Oleg.

-- 
tejun
