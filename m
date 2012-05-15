From: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Tue, 15 May 2012 11:25:17 -0400
Message-ID: <1337095517.31199.2.camel@localhost>
References: <4F98E57E.1040201@samsung.com>
	 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
	 <20120428214131.GB4586@mtj.dyndns.org> <4FA24E07.1010206@samsung.com>
	 <1336075511.2320.2.camel@localhost> <4FA36818.9010409@samsung.com>
	 <20120504170412.GD24639@google.com>
	 <20120504174330.GS6871@ZenIV.linux.org.uk>
	 <20120507203848.GL19417@google.com> <20120515151637.GD6119@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120515151637.GD6119-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Tue, 2012-05-15 at 08:16 -0700, Tejun Heo wrote:
> On Mon, May 07, 2012 at 01:38:48PM -0700, Tejun Heo wrote:
> > On Fri, May 04, 2012 at 06:43:30PM +0100, Al Viro wrote:
> > > 	Consider that preemptively NAKed.  Eric, would you mind explaining
> > > WTF would fsnotify *do* with vfsmount(s) here, seeing that they might very
> > > well be not mounted in anyone's namespace?  And as for generating an event
> > > for each, they might appear and disappear at zero notice.
> > 
> > Eric, any ideas on how to proceed?
> 
> Ping?

Oh sorry, if Al's correct, and there is just absolutely no way to come
up with any kind of mnt for the path we have no choice.  Do it the way
you were.

-Eric
