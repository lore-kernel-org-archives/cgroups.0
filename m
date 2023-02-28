From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 6/8] sched/fair: Add sched group latency support
Date: Tue, 28 Feb 2023 10:09:47 +0100
Message-ID: <CAKfTPtAq-fRhgXw21RxLhT_ZZQUoMSZgGc90R_qoqkUhu+ADDw@mail.gmail.com>
References: <20230224093454.956298-1-vincent.guittot@linaro.org>
 <20230224093454.956298-7-vincent.guittot@linaro.org> <20230224192919.d4fcde3dwh7betvm@blackpad>
 <CAKfTPtBorwnjU2=nprBo7aAEjoz+7x5nRYUdajZc53cuVgHSBw@mail.gmail.com> <20230227144236.z6zbgsaohlz6sl7o@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JD6LFUjaCV0Y3rxiGh/Ykg8y93935IDS5wJRL1FIbVk=;
        b=V8ikxzfit8o1ERBDuVpWZBjCJo3dBKGAYbIiDxp9M9uCoraXVlmQhSEskvLmuayfg7
         /A8wcV7Xoc0qpfJZtw6hgOyJsrSsEWnaY6cSn+3lyXcaR4wB89slxOmi+OPCGsjOAbrN
         QxvsRE8/q4humpPg/XxOfc5HxA9dOoJSpNo/FKyyoHQPu6t3Yz3jXs7uSmB0txyiTz0e
         PUi+8DPIYfsOf5AYgU8+ggxQauIYTdqvYTy8pEMolMHzGgRZoYlFxf5Gzjp17l6mhKxY
         a/KI6B9hkhoCTAhTmYKOpgcqM7aPi8tZ5WYPp2xh0paNZczkU7SJWbRcVLCujWEUckUj
         wDKQ==
In-Reply-To: <20230227144236.z6zbgsaohlz6sl7o@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Mon, 27 Feb 2023 at 15:42, Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon, Feb 27, 2023 at 02:44:22PM +0100, Vincent Guittot <vincent.guitto=
t@linaro.org> wrote:
> > Regarding the current use of latency nice to set a latency offset, the
> > problem doesn't appear because latency offset applies between entities
> > at the same level as you mentioned above
>
> Splendid, it turned out that way (latency nice analogous to bandwidth
> nice).
>
> > Does  my explanation above make sense to you ?
>
> Yes, thank you.
>
> Thus, I'd like to propose avoiding the use of "limit" in this context and
> stress the horizontal scope. For example:
>
> > +     This interface file allows reading and setting latency using the
> > +     same values used by sched_setattr(2). The latency_nice of a group=
 is
> > +     used to limit the impact of the latency_nice of a task outside th=
e
> > +     group.
>
> +     This interface file allows reading and setting latency using the
> +     same values used by sched_setattr(2). The latency_nice of a group i=
s
> +     used to modify group members' latency with respect to sibling group=
s.

That sounds reasonable to me.

>
> Regards,
> Michal
