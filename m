From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Add a allow_attach policy for Android
Date: Thu, 6 Oct 2016 15:43:51 -0700
Message-ID: <20161006224351.GA25887@dtor-ws>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <1475556090-6278-3-git-send-email-john.stultz@linaro.org>
 <20161005191056.GB31873@dtor-ws>
 <CALAqxLXxFcLWCbSHiFFy0OEDgbnJY+2OLbgLYvypDwoQMuapHg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HFmWwAKCpdcqfQezvEXUZ7HpKz2eju+bnTKs94Jf5as=;
        b=Z7w6ztGcJAOccWbv8vzHi3FrRqBX1T7KuODp2K8CPWXTiVk4zippckvxJABmNZveSl
         BfAJv2LeH/tc21GnQTq+gflGv8pmA9fArVeU/MCeJVBmEpYAMNmLTEeBQxGA29D/WRo0
         xWlvuYiTrRv0fJfNJvZR+dXcZdRAHwUUud0YyAfses7U89AFCWsoxeE5dwK/B8tMMSv/
         bF8hLCGXdHLwaQkBLvVixBNGMS+If3DeOtXZRrfmRa7MkC1awWMxYhD33PA2x8KkmGcr
         Wc6G4v7MVnP4qASGTX9TyRM2pa1hrrvwNe5wl5EBoBxOvoRNIRvE6eLokYWTrmtv8/d7
         V5Pg==
Content-Disposition: inline
In-Reply-To: <CALAqxLXxFcLWCbSHiFFy0OEDgbnJY+2OLbgLYvypDwoQMuapHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Wed, Oct 05, 2016 at 12:18:17PM -0700, John Stultz wrote:
> On Wed, Oct 5, 2016 at 12:10 PM, Dmitry Torokhov
> <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Mon, Oct 03, 2016 at 09:41:30PM -0700, John Stultz wrote:
> >> +#ifdef CONFIG_CGROUP_NICE_ATTACH
> >> +int cgroup_nice_allow_attach(struct cgroup_taskset *tset)
> >> +{
> >> +     const struct cred *cred = current_cred(), *tcred;
> >> +     struct task_struct *task;
> >> +     struct cgroup_subsys_state *css;
> >> +
> >> +     if (capable(CAP_SYS_NICE))
> >> +             return 0;
> >> +
> >> +     cgroup_taskset_for_each(task, css, tset) {
> >> +             tcred = __task_cred(task);
> >
> > __task_cred() requires RCU lock (courtesy Ricky Z).
> 
> Again, hopefully this isn't an issue with the new approach, but for
> the short term I'll see if we can get this fixed in the android tree.
> 

Actually, it should all be simply removed from there right away, as this
ends up being basically noop (but with all the locking violations and
races):

cgroup_taskset_for_each() needs tasks to be placed on cset->mg_tasks
list, but nobody does this in the ->allow_access() code path, so this
loops always executes exactly 0 times and the whole thing is exactly
equivalent of doing

	return capable(CAP_SYS_NICE) ? 0 : -EACESS;

which can be done right in cgroup_procs_write_permission().

Thanks.

-- 
Dmitry
