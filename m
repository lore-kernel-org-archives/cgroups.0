From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 8/9] hugetlb_cgroup: Add hugetlb_cgroup reservation tests
Date: Wed, 5 Feb 2020 10:03:40 -0800
Message-ID: <CAHS8izNZ+_UMEDjFXxMN9ig7QFEoJn_jLqxRTKOG7CFPvbDedg@mail.gmail.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-8-almasrymina@google.com> <0fa5d77c-d115-1e30-cb17-d6a48c916922@linux.ibm.com>
 <CAHS8izPobKi_w8R4pTt_UyfxzBJJYuNUw+Z6hgFfvZ1Xma__YA@mail.gmail.com>
 <CAHS8izNmSYumXpYXT1d8tAm36=-BRjXqdCDjLB6UNMwn5xhPZg@mail.gmail.com> <a980c9f7-2759-45a7-1add-89a390b79b39@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4JPeEjt7Um0jnncW2xGqU+AjtbYUDQIukn/RWGYtPE=;
        b=isUzJGTJ7f76WNj3ErRloIg+GCY6ppfYFibDbF7cYNcvcP7bRHDvBg3vVrVP41nXLs
         PD07PYxEOZQqCqG5IRE3GMbWwxGcKU2rsq68DZFR+ZvP1u/m722XWWDvErZR8seAUPJF
         lJmXNrqQKx1WThrxpU0zdZL9f3fX+c3NgvQ4MzjTE+A0k3mY8hGMgUZlOpIlYwIx9S5m
         axn1qNLQiFWRnKUgyVGwi1JRtg65lw+dXxeoT8i0E4wMdPHM/G6wLJZZno+wp2aYotgQ
         VdIXRU1IW2haNgXyxDNJLYTdTXdiBOsc/mHm/TjJWbphWVF8x+egXGz5JFiSyCeALgTl
         /q6w==
In-Reply-To: <a980c9f7-2759-45a7-1add-89a390b79b39-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 5, 2020 at 4:42 AM Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> wrote:
>
> Hi,
>
> On 05/02/20 4:03 am, Mina Almasry wrote:
> > On Tue, Feb 4, 2020 at 12:36 PM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> So the problem in this log seems to be that this log line is missing:
> >>     echo Waiting for hugetlb memory to reach size $size.
> >>
> >> The way the test works is that it starts a process that writes the
> >> hugetlb memory, then it *should* wait until the memory is written,
> >> then it should record the cgroup accounting and kill the process. It
> >> seems from your log that the wait doesn't happen, so the test
> >> continues before the background process has had time to write the
> >> memory properly. Essentially wait_for_hugetlb_memory_to_get_written()
> >> never gets called in your log.
> >>
> >> Can you try this additional attached diff on top of your changes? I
> >> attached the diff and pasted the same here, hopefully one works for
> >> you:
> >> ...
> >
> > I got my hands on a machine with 16MB default hugepage size and
> > charge_reserved_hugetlb.sh passes now after my changes. Please let me
> > know if you still run into issues.
> >
>
> With your updates, the tests are passing. Ran the tests on a ppc64 system
> that uses radix MMU (2MB hugepages) and everything passed there as well.
>

Thanks, please consider reviewing the next iteration of the patch then.

> - Sandipan
>
