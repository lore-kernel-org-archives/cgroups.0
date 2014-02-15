From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: fix top cgroup refcnt leak
Date: Sat, 15 Feb 2014 17:31:42 +0800
Message-ID: <52FF33FE.4070307@huawei.com>
References: <52FEE6F8.8030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52FEE6F8.8030404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/15 12:03, Li Zefan wrote:
> If we mount the same cgroupfs in serveral mount points, and then
> umount all of them, kill_sb() will be called only once.
> 
> Therefore it's wrong to increment top_cgroup's refcnt when we find
> an existing cgroup_root.
> 
> Try:
>         # mount -t cgroup -o cpuacct xxx /cgroup
>         # mount -t cgroup -o cpuacct xxx /cgroup2
>         # cat /proc/cgroups | grep cpuacct
>         cpuacct 2       1       1
>         # umount /cgroup
>         # umount /cgroup2
>         # cat /proc/cgroups | grep cpuacct
>         cpuacct 2       1       1
> 
> You'll see cgroupfs will never be freed.
> 
> v2: change to take the refcnt and drop it after kernfs_mount().
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Please hold off applying this patch. It's still buggy.
