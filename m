From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 17:07:32 -0400
Message-ID: <YkdplNIhtz3iyLKv@cmpxchg.org>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <CAAPL-u8g2qkhdTQtFtBS3GNYz0WnyahWEXvR4g_OSaKv+7EozA@mail.gmail.com>
 <YkcYq8F6MYlMi+yS@cmpxchg.org>
 <CAAPL-u-za-TTyyC5uMVev9eQyhxZS7q3pVqaUxCFjqk+Sv9+ig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xpR1DVaP7IDSimYCmW7Cs0QbhOf/zsDSmwDGGMtRXiE=;
        b=zjuB4EbQMLgWLd1xXiDq0DRbbEAMjzYTkvWV9FTeHjjdzxMzsgLz9cOT8LX0HL865X
         LHW2BCUJqmYEEKsG5XwbnSGOutsGN/YQ8gmiu4xTRrIth38kOixfHQZQp2D+gQEy+wAp
         5eir0XmdbMQD1DcCDnZSs2bABE+JK2WFkzuk8nyxnHCs0K+BO+55i+IvC4lNtDkq/8Xc
         /JtKNdUi3TT3IKCk5/e+FXfRTo0pkQIePvF+lwPnyDerrmezPkOlDwgKHH0Jqd1QjqH+
         b0Ya2VO3D31C+Q+ZLRx1Nd2EdE4udUMCOl40Onplk0lAqsORuAt13L2dbxATWATht7fU
         ojpQ==
Content-Disposition: inline
In-Reply-To: <CAAPL-u-za-TTyyC5uMVev9eQyhxZS7q3pVqaUxCFjqk+Sv9+ig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 01, 2022 at 01:14:35PM -0700, Wei Xu wrote:
> On Fri, Apr 1, 2022 at 8:22 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > On Thu, Mar 31, 2022 at 09:05:15PM -0700, Wei Xu wrote:
> > > It is better to return an error code (e.g. -EBUSY) when
> > > memory_reclaim() fails to reclaim nr_to_reclaim bytes of memory,
> > > except if the cgroup memory usage is already 0.  We can also return
> > > -EINVAL if nr_to_reclaim is too large (e.g. > limit).
> >
> > For -EBUSY, are you thinking of a specific usecase where that would
> > come in handy? I'm not really opposed to it, but couldn't convince
> > myself of the practical benefits of it, either.
> >
> > Keep in mind that MAX_RECLAIM_RETRIES failed reclaim attempts usually
> > constitute an OOM situation: memory.max will issue kills and
> > memory.high will begin crippling throttling. In what scenario would
> > you want to keep reclaiming a workload that is considered OOM?
> >
> > Certainly, proactive reclaim that wants to purge only the cold tail of
> > the workload wouldn't retry. Meta's version of this patch actually
> > does return -EAGAIN on reclaim failure, but the userspace daemon
> > doesn't do anything with it, so I didn't bring it up.
> 
> -EAGAIN sounds good, too.  Given that the userspace requests to
> reclaim a specified number of bytes, I think it is generally better to
> tell the userspace whether the request has been successfully
> fulfilled. Ideally, it would be even better to return how many bytes
> that have been reclaimed, though that is not easy to do through the
> cgroup interface. The userspace can choose to ignore the return value
> or log a message/update some stats (which Google does) for the
> monitoring purpose.

Fair enough, thanks for your thoughts. No objection from me!
