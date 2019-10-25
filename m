From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH cgroup/for-5.5] cgroup: remove
 cgroup_enable_task_cg_lists() optimization
Date: Fri, 25 Oct 2019 15:33:59 +0200
Message-ID: <20191025133358.pxpzxkhqc3mboi5x@wittgenstein>
References: <0000000000003b1e8005956939f1@google.com>
 <20191021142111.GB1339@redhat.com>
 <20191024190351.GD3622521@devbig004.ftw2.facebook.com>
 <20191025125606.GI3622521@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191025125606.GI3622521@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, dvyukov@google.com
Cc: Oleg Nesterov <oleg@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, arnd@arndb.de, deepa.kernel@gmail.com, ebiederm@xmission.com, elver@google.com, guro@fb.com, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, cgroups@vger.kernel.org, kernel-team@fb.com

[+Dmitry]

On Fri, Oct 25, 2019 at 05:56:06AM -0700, Tejun Heo wrote:
> On Thu, Oct 24, 2019 at 12:03:51PM -0700, Tejun Heo wrote:
> > cgroup_enable_task_cg_lists() is used to lazyily initialize task
> > cgroup associations on the first use to reduce fork / exit overheads
> > on systems which don't use cgroup.  Unfortunately, locking around it
> > has never been actually correct and its value is dubious given how the
> > vast majority of systems use cgroup right away from boot.
> > 
> > This patch removes the optimization.  For now, replace the cg_list
> > based branches with WARN_ON_ONCE()'s to be on the safe side.  We can
> > simplify the logic further in the future.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Oleg Nesterov <oleg@redhat.com>
> 
> Applying to cgroup/for-5.5.

The code you removed was the only place where task->flags was set from
!current. So I think this fixes the syzbot data-race report in:
https://lore.kernel.org/r/0000000000003b1e8005956939f1@google.com

Link: syzbot+492a4acccd8fc75ddfd0@syzkaller.appspotmail.com

Thanks!
Christian
