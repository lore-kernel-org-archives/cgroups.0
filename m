From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] cgroup: move number_of_cgroups test out of rebind_subsystems()
 into cgroup_remount()
Date: Thu, 11 Jul 2013 15:10:48 +0800
Message-ID: <51DE5A78.50002@huawei.com>
References: <1372463145-4245-1-git-send-email-tj@kernel.org> <1372463145-4245-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372463145-4245-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/6/29 7:45, Tejun Heo wrote:
> rebind_subsystems() currently fails if the hierarchy has any !root
> cgroups; however, on the planned unified hierarchy,
> rebind_subsystems() will be used while populated.  Move the test to
> cgroup_remount(), which is the only place the test is necessary
> anyway.
> 
> As it's impossible for the other two callers of rebind_subsystems() to
> have populated hierarchy, this doesn't make any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
