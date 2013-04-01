From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unused parameter in cgroup_task_migrate().
Date: Mon, 1 Apr 2013 09:47:28 +0800
Message-ID: <5158E730.1000705@huawei.com>
References: <1364764090-26369-1-git-send-email-wkevils@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364764090-26369-1-git-send-email-wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 2013/4/1 5:08, Kevin Wilson wrote:
> This patch removes unused parameter from cgroup_task_migrate().
> 
> Signed-off-by: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

But you have to rebase this patch against Tejun's cgroup tree, as this
patch conflicts with "cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()"

http://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/commit/?h=for-next&id=081aa458c38ba576bdd4265fc807fa95b48b9e79
