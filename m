From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Thu, 27 Jan 2022 14:36:45 +0100
Message-ID: <YfKf7YaUoaL998m6@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-2-bigeasy@linutronix.de>
 <YfFddqkAhd1YKqX9@dhcp22.suse.cz>
 <YfFegDwQSm9v2Qcu@linutronix.de>
 <20220126150455.GC2516@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643290607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjY0dW0yhGN0PJkMP5xju7/MogIUEUa6wSeDiVxCBYQ=;
        b=TQvEJLjphAdoWfSbcdBCOZX31ZONcIpQB2O0UTEwb1dRhZHwHS7E1WBElY23hM2520+D7W
        bQ6xksTWXPLUgUZiAr6hz2SNUTuJXERZtK0PMP4r+aMKRjxL+rGAjvYfOVVUycsNtJuYTJ
        Lpj/p4GT51eAKZgrtjaGga4oqsL/GoVtNn18ikMQn8wfGl+J4YKRa2Ph1De9jgC/Dx23HM
        xTRAcaNPDEJWp/fnSoDMMCJOd6hgNHvY0OLzQJbIyW8Cy4T+h5MHxhAaMHwZEmv5tKh29x
        Fr0YHcyesqAc06QqjBakve7Q4rGMIDPv5sz9fne1nxlnI4kgdh1lAGH3Y7Dw9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643290607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjY0dW0yhGN0PJkMP5xju7/MogIUEUa6wSeDiVxCBYQ=;
        b=Wob4kE+EqwyVSQfI16o+1cEpXLMB/VEr40ymUnoaYeIs8fdFlpi1/jtoFaQuIK2R39k//0
        MsGgjs/54gfF1JAg==
Content-Disposition: inline
In-Reply-To: <20220126150455.GC2516-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2022-01-26 16:04:55 [+0100], Michal Koutn=C3=BD wrote:
> On Wed, Jan 26, 2022 at 03:45:20PM +0100, Sebastian Andrzej Siewior <bige=
asy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> > If that is not good, let me think of something else=E2=80=A6
>=20
> I like ifdefing just the static branch enablement. *wink*

That would be one way but it is not obvious that the eventfd/ signal
part of the code is not invoked. And why keep dead code around?

> Michal

Sebastian
