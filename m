From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Wed, 19 Feb 2020 13:06:48 -0800
Message-ID: <20200219130648.83e6810848774c6fd649c445@linux-foundation.org>
References: <20200211213128.73302-1-almasrymina@google.com>
        <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
        <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582146409;
        bh=We7qiHyZF1+0bxnalw+B0B6unBvDDpo3FZ3UilP54wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ukHYLZC7569bA3jMgJUE4Me0eScdonEH4QsdinQzJLb/YmaJEH255Pbk2YXN3mr++
         8Wg+cUdQTDSNrybE0lLFSy2X/bFPK8Dj5fyqLpxDt9xuTdPnYxpJKwIX5E0LNZZBZp
         gfmu61lnSEqsTfX2wTnJ6qyaDxsrEdO8My8VKDao=
In-Reply-To: <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 19 Feb 2020 11:05:41 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Feb 11, 2020 at 3:19 PM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > > These counters will track hugetlb reservations rather than hugetlb
> > > memory faulted in. This patch only adds the counter, following patches
> > > add the charging and uncharging of the counter.
> >
> > We're still pretty thin on review here, but as it's v12 and Mike
> > appears to be signed up to look at this work, I'll add them to -next to
> > help move things forward.
> >
> 
> Hi Andrew,
> 
> Since the patches were merged into -next there have been build fixes
> and test fixes and some review comments. Would you like me to submit
> *new* patches to address these, or would you like me to squash the
> fixes into my existing patch series and submit another iteration of
> the patch series?

What you did worked OK ;)

Please check the end result next time I release a kernel.
