From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: drains percpu charge caches in
 memory.reclaim
Date: Fri, 11 Nov 2022 15:31:00 -0500
Message-ID: <Y26xBGvyhehWfqML@cmpxchg.org>
References: <20221110065316.67204-1-lujialin4@huawei.com>
 <20221110144243.GA10562@blackbody.suse.cz>
 <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g@mail.gmail.com>
 <20221111100843.GG20455@blackbody.suse.cz>
 <CAJD7tkYWvR+2o==-R38hDBEM=k=2bta9kKRND3wxDLF1pWbp6A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kn0Y+63FiU6va/fYBfDM/PWGy/IsvE7/E02gtmFvSYk=;
        b=LauIKZokprmiYiUpRTowA0fVwRhG1sb1N7oihtbcgMA7TwP9eoVi2520gPrIFZep7S
         pJnuHLwnDF2VDM9eUh55VHUYnGdkEFidW9/9bsNhC/qNPgf5eX6F0ZxcVaMrWioEO11Z
         fa5qR7RTnoLcaQeazMfqpw8iB6MHozM45QG6JrYFvfBOdc0XVnsHZcd16DoWgcdHSSln
         8az5drUooRNM39glR86z3JAW8CGKXl1Kw2nESRhfwUmp1h9lUnClNjf9EHo2ndngSttk
         n3MNlcC6AFIU5GIrmmoz6H9ekRsAIuImchViSew+lYdowbE8L1q+rheJT/HmOLIAP8o7
         NyUQ==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYWvR+2o==-R38hDBEM=k=2bta9kKRND3wxDLF1pWbp6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Nov 11, 2022 at 10:24:02AM -0800, Yosry Ahmed wrote:
> On Fri, Nov 11, 2022 at 2:08 AM Michal Koutn=FD <mkoutny-IBi9RG/b67k@publ=
ic.gmane.org> wrote:
> >
> > On Thu, Nov 10, 2022 at 11:35:34AM -0800, Yosry Ahmed <yosryahmed-hpIqs=
D4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > OTOH, it will reduce the page counters, so if userspace is relying on
> > > memory.current to gauge how much reclaim they want to do, it will make
> > > it "appear" like the usage dropped.
> >
> > Assuming memory.current is used to drive the proactive reclaim, then
> > this patch makes some sense (and is slightly better than draining upon
> > every memory.current read(2)).
>=20
> I am not sure honestly. This assumes memory.reclaim is used in
> response to just memory.current, which is not true in the cases I know
> about at least.
>=20
> If you are using memory.reclaim merely based on memory.current, to
> keep the usage below a specified number, then memory.high might be a
> better fit? Unless this goal usage is a moving target maybe and you
> don't want to keep changing the limits but I don't know if there are
> practical use cases for this.
>=20
> For us at Google, we don't really look at the current usage, but
> rather on how much of the current usage we consider "cold" based on
> page access bit harvesting. I suspect Meta is doing something similar
> using different mechanics (PSI). I am not sure if memory.current is a
> factor in either of those use cases, but maybe I am missing something
> obvious.

Yeah, Meta drives proactive reclaim through psi feedback.

We do consult memory.current to enforce minimums, just for safety
reasons. But that's are very conservative parameter, the percpu fuzz
doesn't make much of a difference there; certainly, we haven't had any
problems with memory.reclaim not draining stocks.

So I would agree that it's not entirely obvious why stocks should be
drained as part of memory.reclaim. I'm curious what led to the patch.
