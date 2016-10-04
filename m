From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 11:01:12 -0700
Message-ID: <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org> <20161004161630.GC4205@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=KmKhNriTPJy7J+r75rDRRypLQZMa53JHI+bjiHZtTpE=;
        b=fhADEjXGRpHgJ60XEqeAKNsX9Sq6e5BX5WUp7VYjUmuO7lMuCgUSA8/s6NKlfPq/3I
         7Ammb2oifv5epgI82saavsg7+k1ws3azP3DBHw4S8v8KtnwgQlGvSb0gPyIGJuxdfug1
         8ateJruK4y4sL56woAaGCdHr+yuiRQjyZkbVk=
In-Reply-To: <20161004161630.GC4205-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Tue, Oct 4, 2016 at 9:16 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Oct 03, 2016 at 09:41:28PM -0700, John Stultz wrote:
>> The migration of a task from the foreground to background, or to
>> elevate a task to audio priority, may be done by system service that
>> does not run as root. So this patch allows processes with CAP_SYS_NICE
>> to be able to migrate tasks between cgroups.  I suspect if there was a
>> specific cap (CAP_SYS_CHANGE_CGROUP) for this, it would be usable here,
>> but in its absence, they've overloaded CAP_SYS_NICE for this use.
>
> CAP_SYS_RESOURCE won't do?
>
>> At first glance, overloading CAP_SYS_NICE seems a bit hackish, but this
>> shows that there is a active and widely deployed use for different cgroup
>> attachment rules then what is currently available.
>
> I'm curious who issues these migrations.

The system_server process via the sched_policy logic:
http://androidxref.com/7.0.0_r1/xref/system/core/libcutils/sched_policy.c#274

See set_cpuset_policy() and set_sched_policy().

> Is that restricted to
> certain uids?  If so, would it work for android if cgroupfs supports
> ACL so that those uids can be approved via setfacl?  That'd be an a
> lot more generic approach.

So tasks might move themselves in some cases to specific groups, but
mostly its controlled by the system_server.

So to make sure I understand your suggestion, you're suggesting the
cgroupfs files like:
cpuctrl/tasks,
cpuctrl/bg_non_interactive/tasks,
cpuset/foreground/tasks,
cpuset/background/tasks,
etc
use ACL permissions to specify the specific uids that can write to
them? I guess this would be conceptually similar to just setting the
owner to the system task, no?  Though I'm not sure that would be
sufficient since it would still fail the
cgroup_procs_write_permission() checks. Or are you suggesting we add
extra logic to make the file owner uid as sufficient to change other
tasks?

thanks
-john
