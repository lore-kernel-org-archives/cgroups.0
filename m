From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
Date: Tue, 5 Mar 2013 09:36:21 -0800
Message-ID: <20130305173621.GE12795@htj.dyndns.org>
References: <513568A0.6020804@huawei.com>
 <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
 <5135CAD8.2020409@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=LMu7rXs7K6TtWZCoCi9g9pJ1iJxWZWARGfb5OqyzaZc=;
        b=gPEkwmdQvEmOjd0mi/ATFTrDveI7oFoo0X+1rapfdsGAssZIWgOI12Fi/RGz88NvYB
         xKsXmosbCifSVib/aHdzCXnzWIwZjpkaTO+MH9NStaAfmEAu8zyQ6EIq8Qd9DqOcdT8R
         koP2uNy+oHDknZEx+DkNmE2YxedtlTk1CJWPpq6BkvgZs5NAVTe/JnQWVJHTA9LIQS8/
         2DhyAczzLqLgqJLqcmiTIyRnPItmSHVOq8NqzLeJYoGuD+vNLfn2TzSXVuobZoBxgvGh
         f1Hwkz4JkJBwKqlZfTWTdKYJJLc6rQmWliZari1Uoj/i81tNLnCF0pa6JFERxzOoMuoa
         lwCg==
Content-Disposition: inline
In-Reply-To: <5135CAD8.2020409-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Stephane Eranian <eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

(cc'ing Steven and Frederic and quoting whole body)

Hello, guys.

On Tue, Mar 05, 2013 at 06:37:12PM +0800, Li Zefan wrote:
> On 2013/3/5 16:33, Stephane Eranian wrote:
> > On Tue, Mar 5, 2013 at 4:38 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> >> Move struct perf_cgroup_info and perf_cgroup to kernel/perf/core.c,
> >> and then we can remove include of cgroup.h.
> >>
> >> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  include/linux/perf_event.h | 18 +-----------------
> >>  kernel/events/core.c       | 15 +++++++++++++++
> >>  2 files changed, 16 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> >> index e47ee46..8737e1c 100644
> >> --- a/include/linux/perf_event.h
> >> +++ b/include/linux/perf_event.h
> >> @@ -21,7 +21,6 @@
> >>   */
> >>
> >>  #ifdef CONFIG_PERF_EVENTS
> >> -# include <linux/cgroup.h>
> >>  # include <asm/perf_event.h>
> >>  # include <asm/local64.h>
> >>  #endif
> >> @@ -299,22 +298,7 @@ struct swevent_hlist {
> >>  #define PERF_ATTACH_GROUP      0x02
> >>  #define PERF_ATTACH_TASK       0x04
> >>
> >> -#ifdef CONFIG_CGROUP_PERF
> >> -/*
> >> - * perf_cgroup_info keeps track of time_enabled for a cgroup.
> >> - * This is a per-cpu dynamically allocated data structure.
> >> - */
> >> -struct perf_cgroup_info {
> >> -       u64                             time;
> >> -       u64                             timestamp;
> >> -};
> >> -
> >> -struct perf_cgroup {
> >> -       struct                          cgroup_subsys_state css;
> >> -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
> >> -};
> >> -#endif
> >> -
> >> +struct perf_cgroup;
> > 
> > The problem is that you have struct perf_cgroup in the struct perf_event
> > structure. Today, this field is not referenced outside of kernel/events/core.c
> > But it is available outside this file. If someday the field is reference, your
> > changes will have to do reverted. So I am wondering what is the point
> > of the change right now?
> > 
> 
> I touch cgroup.h quite frequently, so I'd like to reduce the compile time caused
> by cgroup.h changes, so I've made a few patches to remove cgroup.h from some
> header files.
> 
> It's better to expose as less interfaces as possible, and if someone wants to
> export someting he should think about if it's the right thing to do.
> 
> Like we often make static functions usable to external users, and also often do the
> reverse thing, this patch is nothing special.

I don't care either way.  Steven, Frederic, Ingo?

Thanks.

-- 
tejun
