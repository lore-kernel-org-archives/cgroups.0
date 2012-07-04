From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: cgroup_rm_files() was calling simple_unlink()
 with the wrong inode
Date: Wed, 4 Jul 2012 13:40:39 +0800
Message-ID: <4FF3D757.9060905@huawei.com>
References: <20120627182903.GP15811@google.com> <4FEBF4B7.2070105@huawei.com> <20120628180712.GC22641@google.com> <4FED10DB.7040500@huawei.com> <20120629165809.GB21048@google.com> <4FEE98EE.1050409@huawei.com> <20120630064724.GC14083@ZenIV.linux.org.uk> <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com> <20120630083421.GD14083@ZenIV.linux.org.uk> <20120703171033.GC555@google.com> <20120703173806.GD555@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120703173806.GD555-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Tejun Heo wrote:

>>From 6da2689412c78b97716ec524cc30baf7b46508cd Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 3 Jul 2012 10:32:26 -0700
> 
> While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
> introduce struct cfent" incorrectly changed the @dir argument of
> simple_unlink() to the inode of the file being deleted instead of that
> of the containing directory.
> 
> The effect of this bug is minor - ctime and mtime of the parent
> weren't properly updated on file deletion.
> 
> Fix it by using @cgrp->dentry->d_inode instead.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>


Acked-By: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
