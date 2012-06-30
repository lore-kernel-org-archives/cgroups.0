From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Sat, 30 Jun 2012 09:34:21 +0100
Message-ID: <20120630083421.GD14083@ZenIV.linux.org.uk>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sat, Jun 30, 2012 at 12:04:36AM -0700, Tejun Heo wrote:
> Hello, Al.
> 
> On Fri, Jun 29, 2012 at 11:47 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> > On Sat, Jun 30, 2012 at 02:13:02PM +0800, Li Zefan wrote:
> >> So it's bad to have dentry refcnts dangling after umount.
> >
> > No shit. ?Yes, it is bad. ?What on the Earth is cgroup code doing with
> > those? ?And what could it possibly want to do with dentry reference
> > after the filesystem has been shut down, assuming it could hold one
> > in the first place?
> 
> cgroup interface code was copied from sysfs back when it was
> piggybacking internal data structures to dentries, so, unfortunately,
> sysfs is still using dentries to manage internal data structures and
> propagates internal refs to dentry refs. There seem to be several
> places where dentry ref is held w/o active super ref triggering BUG on
> umount. Longer term, it should be updated to share sysfs code, I
> guess.

Now that I've looked at that code again...  What's the story with
                simple_unlink(d->d_inode, d);
in cgroup_rm_file()?  Wrong parent inode, at the very least...

While we are at it, what the hell is going on in
static void cgroup_clear_directory(struct dentry *dir)
{
        struct cgroup *cgrp = __d_cgrp(dir);

        while (!list_empty(&cgrp->files))
                cgroup_rm_file(cgrp, NULL);
}
Are you fighting some kind of race against somebody adding stuff
there?  Unless I'm seriously misreading cgroup_rm_file(), it'll
do all the work on the first call...
