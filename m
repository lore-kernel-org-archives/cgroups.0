From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 10:02:51 -0800
Message-ID: <Y/UHS0QYWoBmVrR9@P9FQF9L96D.corp.robot.car>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CADfL_jBDNZiEWbnn+w9+FhSRPzVwP872XBbhYTZwny8Jzr4bDw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677002589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sMsd45Umu3YuXLOVUwNN2b4uIloC4nQS/PME1ZUx4QY=;
        b=SHxsvZwyD5BmnUlPUsuusjZp3+TIl7ZqP0jdYYQwCKbWrkJ5vCHsFzPZQfPOB9oXXIDMOY
        YDC9T3cOn/usAilO1GAUxTsMoEZsSW9jal21ISKN04+sEI1olhWLV+lwwVv3QF5kklCJF+
        Q210mi7PR6nlOH1EM4T9+fTSiLRE8gA=
Content-Disposition: inline
In-Reply-To: <CADfL_jBDNZiEWbnn+w9+FhSRPzVwP872XBbhYTZwny8Jzr4bDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Martin Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, Feb 22, 2023 at 01:00:00AM +0800, Martin Zhao wrote:
> On Tue, Feb 21, 2023 at 1:17 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > ﻿On Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wrote:
> > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > >>> will be read and written simultaneously by user space
> > >>> programs, thus we'd better change memcg->oom_group access
> > >>> with atomic operations to avoid concurrency problems.
> > >>>
> > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >>
> > >> Hi Yue!
> > >>
> > >> I'm curious, have any seen any real issues which your patch is solving?
> > >> Can you, please, provide a bit more details.
> > >>
> > >
> > > IMHO such details are not needed. oom_group is being accessed
> > > concurrently and one of them can be a write access. At least
> > > READ_ONCE/WRITE_ONCE is needed here.
> >
> > Needed for what?
> >
> > I mean it’s obviously not a big deal to put READ_ONCE()/WRITE_ONCE() here, but I struggle to imagine a scenario when it will make any difference. IMHO it’s easier to justify a proper atomic operation here, even if it’s most likely an overkill.
> >
> > My question is very simple: the commit log mentions “… to avoid concurrency problems”, so I wonder what problems are these.
> 
> Thanks for your watching!
> This topic is found in code review by coincidence, so no real issues
> recorded for now. I checked other read/write callbacks about other knobs,
> most of them use READ_ONCE/WRITE_ONCE on the user setting variable.

Sorry, which knobs are you talking about? I actually don't see any user knobs
in mm/memcontrol.c which are using WRITE_ONCE(). I see some of them using
xchg(), but it's a different thing.

> Actually I am curious as well why this interface doesn't use
> READ_ONCE/WRITE_ONCE, is there any other synchronization mechanism I
> didn't notice yet?

Because nobody saw any issues with the current code?

And again if it's something that makes any automated verifiers/tooling unhappy,
I'm totally fine for fixing it, just let make it clear (and also fix the commit
title, which is not true).

Thanks!
