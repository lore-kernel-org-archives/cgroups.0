From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup: use restart_syscall() for retries after offline
 waits in cgroup_subtree_control_write()
Date: Tue, 13 May 2014 13:00:11 +0800
Message-ID: <5371A6DB.2050908@huawei.com>
References: <1399663975-315-1-git-send-email-tj@kernel.org> <1399663975-315-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399663975-315-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On 2014/5/10 3:32, Tejun Heo wrote:
> After waiting for a child to finish offline,
> cgroup_subtree_control_write() jumps up to retry from after the input
> parsing and active protection breaking.  This retry makes the
> scheduled locking update more difficult.

Could you explain this sentence more specific? I don't understand what
"scheduled locking update" means.

>  Let's simplify it by
> returning with restart_syscall() for retries.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  kernel/cgroup.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
