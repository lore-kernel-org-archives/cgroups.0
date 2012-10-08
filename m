From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Mon, 8 Oct 2012 14:48:58 +0200
Message-ID: <CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
References: <20121008020000.GB2575@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=i0pN0UMoWqPLO5qR9hTBicLgC/reTWNDrmwcFXMaIFM=;
        b=Aiu3EF+CjxCS4chA4ktywr3UUvyQJMCzO4vlgzUOPyK9Y8YAD7pyDwHBy5kXdhQ8lM
         Y2T4vX04NR3DViV+it+R2j9jbIgcMRQkMHTqyQdTU3zIBTsNRvQlYwb5gTtmBKVMgbVh
         4GhXAWXd1cL+1H4XbiBfY63N7KBAnljOrev5rJQU/B7Goaavof6pryayZEAPg4zCTDnM
         cz2FaE3ZUdnFK32UY5X2WSIWo6CvVBsF363j+Z6S/r9RJQrgZowv5xf2FNVHAdId00bB
         Lwkx//8W+38shXVMhl4GNrXn7VdgS5Q2GLNFskjrE9T+qG9seDml65BRypPLl0vnf4gR
         /ABA==
In-Reply-To: <20121008020000.GB2575@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2012/10/8 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> Hello, Frederic.
>
> 7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()") removed
> task_lock from cgroup_fork citing that current->cgroups can't change
> due to threadgroup_change locking; however, threadgroup_change locking
> is used only during CLONE_THREAD forking.  If @current is forking a
> new process, there's nothing preventing someone else to migrate the
> parent while forking is in progress and delete the css_set it
> currently is using.  Am I confused somewhere?

Yeah I missed this one.
Now the whole cgroup_attach_task() is clusteracy without the
threadgroup lock anyway:

* The PF_EXITING check is racy (we are neither holding tsk->flags nor
threagroup lock).
* The cgrp == oldcgrp is racy (exit() can change the oldcgrp anytime.
* can_attach / attach / cancel_attach can race against fork/exit (and
post_fork if you consider those interested in cgroup task link like
the freezer. But that is racy in any case already even with
threadgroup lock)

It has been designed to be called under that lock. So I suspect the
best, at least for now, is to threadgroup lock from
cgroup_attach_task_all(). And also make cgroup_attach_task() static to
avoid future unsafe callers.
There is no harm yet because the only user of it calls that with
current as the "task" parameter, in a place that is
not in the middle of a fork. So no need to worry about some stable backport.

Also, looking at cgroup_attach_task_all(), what guarantee do we have
that "from" is not concurrently exiting and removing its cgrp. Which
is a separate problem. But we probably need to do some css_set_get()
before playing with it.
