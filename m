From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 30 Mar 2017 09:48:55 -0700
Message-ID: <CALvZod7Dr+YaYcSpUYCMAjotnU4hH=TnZWaL6mbBzLq=O3GJTA@mail.gmail.com>
References: <20170317231636.142311-1-timmurray@google.com> <20170330155123.GA3929@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Ubk3OLU3Daq+O0EpdZaG8qRLSeik3YTkCbQaLsVgfLk=;
        b=dMEzW2vY9D+MfOP6jWHZIaRaPc46tuCq98YEaQtt8DoVQYs/0P3FLn3XRGR9nnV4Eh
         bZAEr0FkUHEu2eMjY/A3QFPgdMHB6aEVcghsR8RZkV5Ndln2HmYNFoJlC6uYe/Qgj3py
         wB12eTdCelJtSzYmCPLmWnkxMwrkIqNGTPfgDvi7p5juQmdwn/nh2j7tvkkfTQtqwM6M
         AkzRDe7X+pTJpKnVsDNKslx7bNwSk1XCQCuCToBCpTzy6NOqwy0qYMMPwmqVdpqjNn4f
         BCBOnvfw0LJ5knNKGs8QNuQ32X1stxHYJOFIBU01NGYzUw3gYeQcqIIqtwn9ZNoPECDi
         UScA==
In-Reply-To: <20170330155123.GA3929-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, totte-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

> A more useful metric for memory pressure at this point is quantifying
> that time you spend thrashing: time the job spends in direct reclaim
> and on the flipside time the job waits for recently evicted pages to
> come back. Combined, that gives you a good measure of overhead from
> memory pressure; putting that in relation to a useful baseline of
> meaningful work done gives you a portable scale of how effictively
> your job is running.
>
> I'm working on that right now, hopefully I'll have something useful
> soon.

Johannes, is the work you are doing only about file pages or will it
equally apply to anon pages as well?
