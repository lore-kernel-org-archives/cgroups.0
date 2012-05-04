From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Fri, 04 May 2012 09:24:40 +0400
Message-ID: <4FA36818.9010409@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org> <4FA24E07.1010206@samsung.com>
 <1336075511.2320.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1336075511.2320.2.camel@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Hi Eric,

I had try to implement with FSNOTIFY_EVENT_PATH. But it's pretty hard to 
obtain struct path without full chain of the sys_open()
or may be I don't know some simple way. I'll spend some more time on 
this, but for now I have no idea how to do it. If you have some please 
share them.


On 05/04/2012 12:05 AM, Eric Paris wrote:
> On Thu, 2012-05-03 at 13:21 +0400, Alexander Nikiforov wrote:
>
> Can't comment inline because patch was attached rather than inline.  But
> if there is ANY way I'd really like to see you using FSNOTIFY_EVENT_PATH
> instead of inode.  inode works for dnotify and inotify, but not for
> things watched with fanotify.
>
> -Eric
>
>


-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
