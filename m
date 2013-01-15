From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] cgroup: don't show pid list on tasks/procs in ascending
 order
Date: Tue, 15 Jan 2013 08:08:11 -0600
Message-ID: <20130115140811.GA4082@sergelap>
References: <50F4E902.20202@oracle.com>
 <20130115062507.GA21358@sergelap>
 <50F4F76D.2050409@oracle.com>
 <20130115063412.GA25338@sergelap>
 <50F4FD99.7070406@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50F4FD99.7070406-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Quoting Jeff Liu (jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org):
> On 01/15/2013 02:34 PM, Serge Hallyn wrote:
> > Quoting Jeff Liu (jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org):
> >> On 01/15/2013 02:25 PM, Serge Hallyn wrote:
> >>> Quoting Jeff Liu (jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org):
> >>>> Hello,
> >>>>
> >>>> Currently, the pid list shown on cgroup->procs & tasks is in ascending order.  However, this list is not
> >>>> guaranteed to be sorted according to the following records mentioned at Documentation/cgroups/cgroups.txt.
> >>>>
> >>>>  - tasks: list of tasks (by PID) attached to that cgroup.  This list
> >>>>    is not guaranteed to be sorted. 
> >>>>  - cgroup.procs: list of thread group IDs in the cgroup.  This list is
> >>>>    not guaranteed to be sorted or free of duplicate TGIDs, and userspace
> >>>>    should sort/uniquify the list if this property is required.
> >>>>
> >>>> This patch remove the sorting function to make the default behavior of pid list be consistent with
> >>>> the document.
> > 
> > ...
> > 
> > I've gotta say, as someone who tends to play with those files by hand, I
> > don't mind not having to type | sort | uniq every time.
> 
> I did this for two reasons, one is for the documents, another is per
> Cgroup TODO list from Tejun -- https://lkml.org/lkml/2012/9/13/542
> 
> . Misc issues
> 
>   * Sort & unique when listing tasks.  Even the documentation says it
>     doesn't happen but we have a good hunk of code doing it in
>     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
>     don't like it, scream.

Yeah, I figured, and since he also wants to move to a place where
cgroups are always manipulated using a library, not by hand, it
would make sense to get rid of the overhead there.  I just don't
really like either one of those :)  And in the list of things to
clean up in cgroups, this seems like one that can wait.

-serge
