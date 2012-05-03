From: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Thu, 03 May 2012 16:05:11 -0400
Message-ID: <1336075511.2320.2.camel@localhost>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
	 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
	 <20120428214131.GB4586@mtj.dyndns.org> <4FA24E07.1010206@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FA24E07.1010206-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Thu, 2012-05-03 at 13:21 +0400, Alexander Nikiforov wrote:

Can't comment inline because patch was attached rather than inline.  But
if there is ANY way I'd really like to see you using FSNOTIFY_EVENT_PATH
instead of inode.  inode works for dnotify and inotify, but not for
things watched with fanotify.

-Eric
