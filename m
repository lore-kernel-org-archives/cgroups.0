From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Fri, 4 May 2012 18:43:30 +0100
Message-ID: <20120504174330.GS6871@ZenIV.linux.org.uk>
References: <4F98E4E5.6020602@samsung.com>
 <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com>
 <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org>
 <4FA24E07.1010206@samsung.com>
 <1336075511.2320.2.camel@localhost>
 <4FA36818.9010409@samsung.com>
 <20120504170412.GD24639@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120504170412.GD24639-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Fri, May 04, 2012 at 10:04:12AM -0700, Tejun Heo wrote:
> On Fri, May 04, 2012 at 09:24:40AM +0400, Alexander Nikiforov wrote:
> > Hi Eric,
> > 
> > I had try to implement with FSNOTIFY_EVENT_PATH. But it's pretty
> > hard to obtain struct path without full chain of the sys_open()
> > or may be I don't know some simple way. I'll spend some more time on
> > this, but for now I have no idea how to do it. If you have some
> > please share them.
> 
> Hmm... we have dentry from cfe->dentry and we can either use the first
> vfsmount from sb->s_mounts or all of them (ie. generate event on each
> vfsmount).

	No, you can not.  There are damn good reasons why that list does not
go through a field of struct vfsmount and preventing that kind of idiocy
is pretty high on the list.

	Consider that preemptively NAKed.  Eric, would you mind explaining
WTF would fsnotify *do* with vfsmount(s) here, seeing that they might very
well be not mounted in anyone's namespace?  And as for generating an event
for each, they might appear and disappear at zero notice.

	*notify: Racy By Design...
