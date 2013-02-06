From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
Date: Wed, 6 Feb 2013 16:53:55 +0200
Message-ID: <20130206145355.GA27191@shutemov.name>
References: <510CB733.2080904@huawei.com>
 <510CB744.7000300@huawei.com>
 <20130202155858.GA13022@shutemov.name>
 <20130204101521.GA18322@shutemov.name>
 <51107F42.1090401@huawei.com>
 <20130205082820.GA22220@shutemov.name>
 <5111B664.5050606@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5111B664.5050606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Feb 06, 2013 at 09:48:20AM +0800, Li Zefan wrote:
> On 2013/2/5 16:28, Kirill A. Shutemov wrote:
> > On Tue, Feb 05, 2013 at 11:40:50AM +0800, Li Zefan wrote:
> >> On 2013/2/4 18:15, Kirill A. Shutemov wrote:
> >>> On Sat, Feb 02, 2013 at 05:58:58PM +0200, Kirill A. Shutemov wrote:
> >>>> On Sat, Feb 02, 2013 at 02:50:44PM +0800, Li Zefan wrote:
> >>>>> When an eventfd is closed, a wakeup with POLLHUP will be issued,
> >>>>> but cgroup wants to issue wakeup explicitly, so when a cgroup is
> >>>>> removed userspace can be notified.
> >>>>>
> >>>>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>
> >>> Hm.. Looks like it will break eventfd semantics:
> >>>
> >>> 1. One eventfd can be used for deliver more then one notification from
> >>> one or more cgroups. POLLHUP on removing one of cgroups is not valid.
> >>>
> >>> 2. It's valid to have eventfd opened only by one userspace application. We
> >>> should not close it, just because cgroup is removed.
> >>>
> >>> I think problem with multiple threads waiting an event on eventfd should
> >>> be handled in userspace.
> >>>
> >>
> >> I didn't realize this.. and if a cgroup is removed, the woken thread may not
> >> be the thread that is waiting on this cgroup.
> > 
> > Why? The only threads who read() or poll() the eventfd will be wake up,
> > won't they? Do you have a code sample to demonstrate the issue?
> > 
> 
> All the threads will be woken up, but one of them will consume the event counter,
> and then all other threads will keep waiting.

The woken up thread can identify that cgroup had disappeared and notify
other threads (probably with the same eventfd).

For me it looks like userspace mess rather then kernel issue.

> >> How crappy.. I don't know how
> >> userspace is going to deal with all these.
> >>
> >> And another bug spotted. We can pass fd of memory.usage_in_bytes of cgroup A
> >> to cgroup.event_control of cgroup B, and then we won't get memory usage
> >> notification from A but B! What's worse, if A and B are in different mount
> >> hierarchy, boom!
> > 
> > I think we can ignore which cgroup event_control is belong to, and just
> > use cgroup of cfile as base. It also means you can use one event_control fd
> > for registering events to different cgroups. It can be handy.
> > 
> 
> The most reasonal usage is, cgroup.event_control exists in the root cgroup only,
> and it's used to register events to all cgroups. But I don't think we can
> change the current interface that each cgroup has a cgroup.event_control, so
> we'll restrict event registration as my patch does.

Looks good to me.

-- 
 Kirill A. Shutemov
