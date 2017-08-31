From: Christian Brauner <christian.brauner@canonical.com>
Subject: Re: [lxc-devel] [RFC PATCH] cgroup, cpuset: add cpuset.remap_cpus
Date: Thu, 31 Aug 2017 11:41:47 +0200
Message-ID: <20170831094145.mrz6daucapq5kvn7@gmail.com>
References: <1482419271-15410-1-git-send-email-w.bumiller@proxmox.com>
 <20170830132755.tnqmuttodexc3oh6@mailbox.org>
 <20170831004131.GZ491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170831004131.GZ491396@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: christian.brauner@ubuntu.com, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, w.bumiller@proxmox.com, stgraber@ubuntu.com, serge@hallyn.com

On Wed, Aug 30, 2017 at 05:41:31PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 30, 2017 at 03:27:55PM +0200, Christian Brauner wrote:
> > The following patch was sent a while back by Wolfgang Bumiller to remap cpusets
> > for a whole subtree in a cgroup v1 cpuset hierarchy. The fact that currently
> > this is not possible in a non-racy why is a pretty big limitation. This is
> > especially true for nested containers. Where the nested containers often create
> > additional subcgroups in the cpuset controller at will. The fact that you can't
> > *easily* and in a non-racy way tighten the restriction on them after having
> > created the parent container's cpuset cgroup seems really troubling.
> 
> There was a recent patch to enable v2 behavior on v1, which feels like
> the better approach at this point.  I'm not sure about adding a whole
> new interface for this.

Cool. If it can be done easier and less invasive I'm all for it. Did the patch
already make it into your branch and - only if you happen to have the reference
flying around - could you point me to it.

Thanks!
Christian

> 
> Thanks.
> 
> -- 
> tejun
