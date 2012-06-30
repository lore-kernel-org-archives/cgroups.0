From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Sat, 30 Jun 2012 07:47:24 +0100
Message-ID: <20120630064724.GC14083@ZenIV.linux.org.uk>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FEE98EE.1050409-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sat, Jun 30, 2012 at 02:13:02PM +0800, Li Zefan wrote:

> dput will drop both the subdir and the root's dentry refcnt, but kill_sb will be called
> inbetween.

????!!!!??!?!?

> So it's bad to have dentry refcnts dangling after umount.

No shit.  Yes, it is bad.  What on the Earth is cgroup code doing with
those?  And what could it possibly want to do with dentry reference
after the filesystem has been shut down, assuming it could hold one
in the first place?
