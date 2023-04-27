From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Thu, 27 Apr 2023 15:12:46 -0700
Message-ID: <CAJD7tkac7VKV6Ob8qQWzhm8Ayyk3xB0YCY6edL-TxpXV3aCzXA@mail.gmail.com>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-3-yosryahmed@google.com> <ZElC127xlU2NtlqF@dhcp22.suse.cz>
 <CAJD7tkZ1cODXRuVQ3fWL0s=VsyKZqDPPNqFZec_COAXm0XfXWA@mail.gmail.com> <ZEqBesAJFfLZI65/@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682633603; x=1685225603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgWZRPwaHBehs1AT1+EN1sm+gG/yK/cc9a/rK9nqc80=;
        b=TImfCv3uzAlaFIlONsUxs6zUYHviKGih0Ap26skG6pLvncBEDe1jEd+HM2+EYAuzzx
         ck6w3374QXKX1EOzf80afrzhU7Lg0y7s1+gPIGWI5YYLuVPHjnVTsDgKdTMXDtCoUwbn
         j5rB1ExQCHG3JTfgRXwq4XU+3J5LGv985H4gdDzQ5Ykk29usV26mnKtjFpQ3hmpN+jFo
         mdWnhRGw5r0FmXmRCPy484L017Uqf6QMqxBuuyYEEeUlrMeoePnV9CQBBaIh7j/cB3iP
         SmieYUpfNc1oxcCg97YzwuZrXWaTpe1Pma3RHiMaOq7xo2Le6jRZbFpC1EQybkCONi+Z
         kuLw==
In-Reply-To: <ZEqBesAJFfLZI65/@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 27, 2023 at 7:06=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Thu 27-04-23 02:21:30, Yosry Ahmed wrote:
> > On Wed, Apr 26, 2023 at 8:27=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =
wrote:
> > >
> > > On Wed 26-04-23 13:39:19, Yosry Ahmed wrote:
> > > > Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgrou=
p
> > > > OOM") made sure we dump all the stats in memory.stat during a cgrou=
p
> > > > OOM, but it also introduced a slight behavioral change. The code us=
ed to
> > > > print the non-hierarchical v1 cgroup stats for the entire cgroup
> > > > subtree, not it only prints the v2 cgroup stats for the cgroup unde=
r
> > > > OOM.
> > > >
> > > > Although v2 stats are a superset of v1 stats, some of them have
> > > > different naming. We also lost the non-hierarchical stats for the c=
group
> > > > under OOM in v1.
> > >
> > > Why is that a problem worth solving? It would be also nice to add an
> > > example of the oom report before and after the patch.
> > > --
> > > Michal Hocko
> > > SUSE Labs
> >
> > Thanks for taking a look!
> >
> > The problem is that when upgrading to a kernel that contains
> > c8713d0b2312 on cgroup v1, the OOM logs suddenly change. The stats
> > names become different, a couple of stats are gone, and the
> > non-hierarchical stats disappear.
> >
> > The non-hierarchical stats are important to identify if a memcg OOM'd
> > because of the memory consumption of its own processes or its
> > descendants. In the example below, I created a parent memcg "a", and a
> > child memcg "b". A process in "a" itself ("tail" in this case) is
> > hogging memory and causing an OOM, not the processes in the child "b"
> > (the "sleep" processes). With non-hierarchical stats, it's clear that
> > this is the case.
>
> Is this difference really important from the OOM POV. There is no group
> oom semantic in v1 and so it always boils down to a specific process
> that gets selected. Which memcg it is sitting in shouldn't matter all
> that much. Or does it really matter?

It is useful information that we already have and used to dump. It's
not really about which memcg the victim lived in, but which memcg is
not behaving as expected causing an OOM. If you have processes running
in the OOMing memcg itself as well as its descendants, then it's nice
to get an idea of which memcg's usage is not as expected.

>
> > Also, it is generally nice to keep things consistent as much as
> > possible. The sudden change of the OOM log with the kernel upgrade is
> > confusing, especially that the memcg stats in the OOM logs in cgroup
> > v1 now look different from the stats in memory.stat.
>
> Generally speaking oom report is not carved into stone. While we
> shouldn't make changes just nilly willy it might change for
> implementation specific reasons.

Agreed, but for this case there is really no reason to change the
behavior, and imo making restoring the behavior makes the code cleaner
/ more consistent.

>
> In this particular case I would agree that the new output is more
> confusing than helpful. Just look at
> > [   88.339505] pgscan 0
> > [   88.339505] pgsteal 0
> > [   88.339506] pgscan_kswapd 0
> > [   88.339506] pgscan_direct 0
> > [   88.339507] pgscan_khugepaged 0
> > [   88.339507] pgsteal_kswapd 0
> > [   88.339508] pgsteal_direct 0
> > [   88.339508] pgsteal_khugepaged 0
>
> These stats are actively misleading because it would suggest there was
> no memory reclaim done before oom was hit and that would imply a
> potentially premature OOM killer invocation (thus a bug). There are
> likely other stats which are not tracked in v1 yet they are reported
> that might add to the confusion. I believe this would be a sound
> justification to get back to the original reporting.

I don't think the collection of these stats is v2-specific, I was just
testing in a VM without swap, and the process had 100% anonymous
memory. Testing with swap gives sane stats:
[   68.851724] pgscan 248801
[   68.851725] pgsteal 123081
[   68.851725] pgscan_kswapd 0
[   68.851726] pgscan_direct 248801
[   68.851727] pgscan_khugepaged 0
[   68.851727] pgsteal_kswapd 0
[   68.851728] pgsteal_direct 123081
[   68.851728] pgsteal_khugepaged 0

However, I still think this change is valuable. Like you mentioned,
the OOM log is not set in stone, but we shouldn't just change it for
no reason. In this case, for cgroup v1 users, the OOM log changed for
no reason beyond a side effect of another patch. Upon upgrading our
kernel we noticed the behavior change. This patch restores the old
behavior without any cost really, and it makes the code a tiny bit
more consistent.

> --
> Michal Hocko
> SUSE Labs
