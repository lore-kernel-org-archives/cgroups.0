From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Thu, 30 Apr 2020 13:20:10 -0700
Message-ID: <CALvZod6Gatw+sX7_hsVPB-O2yMt-ygXUSweQbHwxZHgwdEth4Q@mail.gmail.com>
References: <20200430182712.237526-1-shakeelb@google.com> <20200430192907.GA2436@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=guKhKwrXEiDwgQzNFnO6v/2/mR5PiCzsUtQ3eT/ji4A=;
        b=gcaVyYdy32+4klv0m7W2u51o7lyTPuxVavEx8YwwdS2ENTcJOhovS0+Av7iXHFQVaW
         0DkmLQyPVheQfV0yVq4/ZjJ45Sm4cgzctg6kflk4xvDPRrCz9H4ctmEhZ7rU/ru60hBr
         5GNSJ3glyv1H/QAIx+KBjmCRwKhXWNzFHz1I5byQDnFd7QYuRsaizyq0/JvpuuF3vJBs
         sznI+dhDToDpZ8UYWzDkrEUWudNUnX2Au2DdObfHIzf0dkRHz9gnaCDhJiK/f0xcrvQq
         j69cVNJu7Ta/ldmUGyk+fln1PTh2sTsRPZdyYGbDCCdEisLWPib9t2fJl2bYdT22T2p4
         6sDg==
In-Reply-To: <20200430192907.GA2436-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 30, 2020 at 12:29 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Thu, Apr 30, 2020 at 11:27:12AM -0700, Shakeel Butt wrote:
> > Lowering memory.max can trigger an oom-kill if the reclaim does not
> > succeed. However if oom-killer does not find a process for killing, it
> > dumps a lot of warnings.
> >
> > Deleting a memcg does not reclaim memory from it and the memory can
> > linger till there is a memory pressure. One normal way to proactively
> > reclaim such memory is to set memory.max to 0 just before deleting the
> > memcg. However if some of the memcg's memory is pinned by others, this
> > operation can trigger an oom-kill without any process and thus can log a
> > lot un-needed warnings. So, ignore all such warnings from memory.max.
>
> Can't you set memory.high=0 instead? It does the reclaim portion of
> memory.max, without the actual OOM killing that causes you problems.

Yes that would work but remote charging concerns me. Remote charging
can still happen after the memcg is offlined and at the moment, high
reclaim does not work for remote memcg and the usage can go till max
or global pressure. This is most probably a misconfiguration and we
might not receive the warnings in the log ever. Setting memory.max to
0 will definitely give such warnings.
