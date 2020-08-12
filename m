From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Wed, 12 Aug 2020 13:47:39 -0700
Message-ID: <CALvZod4+urCc-fFcjkoNOoLLyzcAW=hr14XgmBMAP+RnEyRyfw@mail.gmail.com>
References: <20200702152222.2630760-1-shakeelb@google.com> <20200703063548.GM18446@dhcp22.suse.cz>
 <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com>
 <20200707121422.GP5913@dhcp22.suse.cz> <CALvZod5ty=piw6czyVyMhxQMBWGghC3ujxbrkVPr0fzwqogwrw@mail.gmail.com>
 <20200811173626.GA58879@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YMlwqJSUWt1i6F6iEK9tCz9nN1m89EegznfYz1dxWM0=;
        b=Is7wIv1rlekdHNR2ib1o3cMo7WVrmIWWC+LnWxvZAwG92uGCGXtX+YtRbd5ROD2lgh
         Mpge5B1FXl6BaNj26hyaOzPPnA/QNeUNdczVSHNUJaIOR0yCrpT0DSqce2Ygglc5BYhQ
         ro0sx555IRcMIxwNlNfuI02xPmAvGNvYsb++W590hadWc97jyGgtLkvZHj2gF8ZOzG++
         n115EKAR5i7tUZQBbP7f9U2RCDZrj6qoW32soFk4Ha4K37OBfgrq3+Bw86zdjTYqLCu4
         ZPqFwWhZ0aQtyUiu/o3CIhSt6o8RAzjriZE/ElCU67i76Ue+4gB1Brnbzon9m2IGI/Lx
         /H7Q==
In-Reply-To: <20200811173626.GA58879@blackbook>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Yang Shi <yang.shi@linux.alibaba.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hi Michal,

On Tue, Aug 11, 2020 at 10:36 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrot=
e:
>
> Hi Shakeel.
>
> On Tue, Jul 07, 2020 at 10:02:50AM -0700, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > > Well, I was talkingg about memory.low. It is not meant only to protec=
t
> > > from the global reclaim. It can be used for balancing memory reclaim
> > > from _any_ external memory pressure source. So it is somehow related =
to
> > > the usecase you have mentioned.
> > >
> >
> > For the uswapd use-case, I am not concerned about the external memory
> > pressure source but the application hitting its own memory.high limit
> > and getting throttled.
> FTR, you can transform own memory.high into "external" pressure with a
> hierarchy such as
>
>   limit-group                   memory.high=3DN+margin memory.low=3D0
>   `- latency-sensitive-group    memory.low=3DN
>   `- regular-group              memory.low=3D0
>
> Would that ensure the latency targets?
>

My concern was not "whom to reclaim from" but it was "If I use
memory.high for reclaim, processes running in that memcg can hit
memory.high and get throttled". However Roman has reduced the window
where that can happen. Anyways I will send the next version after this
merge window closes.

Shakeel
