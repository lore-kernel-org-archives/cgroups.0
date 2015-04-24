From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Fri, 24 Apr 2015 11:36:57 -0400
Message-ID: <20150424153657.GC24029@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-5-git-send-email-cyphar@cyphar.com>
 <20150422162954.GF10738@htj.duckdns.org>
 <CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=txLrCUmh+nAVDKo2sMBHHlvhBdWWmD+gG9qFrk9igPU=;
        b=wVcT4ljZ5mS4mirH8VSruM4Od9g3bR/OMP6Efyu7hG+7kEuKlaMl7wO1Pqm1DU48TE
         B9y2VginzC7xwpn28Q5MD+2FzjyPQjv9sp+BGqkqYN0zLwCLSwBIoDQcrXogz6a5AjFe
         hU7oX2s9efGd8SOG5qW1VnqDT0WE2mVZJmLzYsERmWh+ZzGl7N5Jk++RbkCeDk3K2AEg
         vVcXdr/K8N/87zUISPg6edEQAUyvbAr0+o1Ffa9kT2EB0H0ZQkc/u9IF7QjNZa0jAmBm
         iyYc1TLZtC9Uwc0Dn7J6xe2dU/9UvNuP5/zuEhYiGVZzMEbiLYSzRlvqTbbnJ0IAWrbX
         VtQA==
Content-Disposition: inline
In-Reply-To: <CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Apr 23, 2015 at 10:43:12AM +1000, Aleksa Sarai wrote:
> > Why is this safe?  What guarantees that css's ref isn't already zero
> > at this point?
> 
> Because it's already been exposed by pids_fork, so the current css_set

But what prevents against the task being migrated to a different
cgroup?

> (which contains the current css)'s ref has been bumped. There isn't a
> guarantee that there is a ref to css, but there is a guarantee the
> css_set it is in has a ref. The problem with using tryget is that we
> can't fail here.

The guarantee you have there is the css_set wouldn't go away until rcu
lock is dropped and you can deref csses from it.  The way it's
currently implemented, you're guaranteed to have references to the
csses but that's sort of implementation detail.  It can be implemented
in different ways.

A task, as long as it's alive, is guaranteed to have a css associated
with it all the time.  What the tryget protects is races against the
task being migrated to a different cgroup, so retrying until success
is guaranteed to finish in a short amount of time.

> >> +     /* We use INT_MAX as the maximum value of pid_t. */
> >> +     if (limit < 0 || limit > INT_MAX)
> >
> > This is kinda weird if we're using PIDS_MAX for max as it may end up
> > showing "max" after some larger number is written to the file.
> 
> The reason for this is because I believe you said "PIDS_MAX isn't
> meant to be exposed to userspace" (one of the previous patchsets used
> PIDS_MAX as the maximum valid value).

Yeah, but wouldn't it be weird to allow the userland to input PIDS_MAX
(whatever value that may be) and reads back max?  It can be whatever
maximum input value + 1, no?

Thanks.

-- 
tejun
