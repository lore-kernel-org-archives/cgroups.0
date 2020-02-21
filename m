From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation counter
Date: Fri, 21 Feb 2020 12:19:22 -0800
Message-ID: <CAHS8izPB1vwuZVFha+5_ca9gKC7UceDdJFJZe9eb-T43a6GF8A@mail.gmail.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
 <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q@mail.gmail.com> <20200219130648.83e6810848774c6fd649c445@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfpZw+eQB6iSYwMvRBzJaMRaqdbsGid5gEGpxbg9sSM=;
        b=uEcpgNIxyzARyyktOQSbbTIs3P/w6TgKfs9rTrYnQfUyOtw+Y/jWrbLk7GkpTw92F7
         YHwCKs5T5uF+WI5VOd8W3VJSXefpdWblnH2gBQoZnI+NHI3YMXR7Z3urY25D/8f0kt+5
         ettm551MbN+59D/LxW/SLaMiPedHQ9kOlXA3X8v3r5noGfJwngzmXCWszw3mqnCjIzvo
         r7Z6FaMc9KsSbykj/UPyzOLNB2wYbJqvXWsCv08JWsILT0TMm+92HS6wbrXIHvqew/Kd
         4mh4l1iYel1wAbHtHlNBjxSVzH58UCi+aOlqSAai7VkXTKw6DzwAqSLjD83fek6LJzR4
         Swfw==
In-Reply-To: <20200219130648.83e6810848774c6fd649c445-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 19, 2020 at 1:06 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Wed, 19 Feb 2020 11:05:41 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > On Tue, Feb 11, 2020 at 3:19 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >
> > > On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > > These counters will track hugetlb reservations rather than hugetlb
> > > > memory faulted in. This patch only adds the counter, following patches
> > > > add the charging and uncharging of the counter.
> > >
> > > We're still pretty thin on review here, but as it's v12 and Mike
> > > appears to be signed up to look at this work, I'll add them to -next to
> > > help move things forward.
> > >
> >
> > Hi Andrew,
> >
> > Since the patches were merged into -next there have been build fixes
> > and test fixes and some review comments. Would you like me to submit
> > *new* patches to address these, or would you like me to squash the
> > fixes into my existing patch series and submit another iteration of
> > the patch series?
>
> What you did worked OK ;)
>
> Please check the end result next time I release a kernel.

Hey Andrew,

Thanks for taking in the patset and fixes. Only pending change in the
latest -next tree is this one:
https://lore.kernel.org/linux-mm/20200219233610.13808-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

It's reviewed by Mike here:
https://lore.kernel.org/linux-mm/a0d7b8e1-cb43-3b43-68c3-55631f2ce199-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org/
