From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Thu, 27 Apr 2023 16:06:50 +0200
Message-ID: <ZEqBesAJFfLZI65/@dhcp22.suse.cz>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-3-yosryahmed@google.com>
 <ZElC127xlU2NtlqF@dhcp22.suse.cz>
 <CAJD7tkZ1cODXRuVQ3fWL0s=VsyKZqDPPNqFZec_COAXm0XfXWA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1682604411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSSPWlR+fmRaVisUOZECUtbamoubJx2aUQz5oMIT4bY=;
        b=hKsbcFXhcnHul4v4HNQG3MzF3hq7i1IWsZlGNpji0BcJbTTrTel8B1It9NdUZ03HwIfZuy
        0abcxObKmsKVLCZiUHzjViteSgmqRQ50fjmCojQynd3A1ABQ4xVmJ+CiM4H2lEhizMKgfp
        IU2sZ/WkV5Q9E3dTGvzCyHzglVpEcck=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZ1cODXRuVQ3fWL0s=VsyKZqDPPNqFZec_COAXm0XfXWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 27-04-23 02:21:30, Yosry Ahmed wrote:
> On Wed, Apr 26, 2023 at 8:27=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@=
public.gmane.org> wrote:
> >
> > On Wed 26-04-23 13:39:19, Yosry Ahmed wrote:
> > > Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
> > > OOM") made sure we dump all the stats in memory.stat during a cgroup
> > > OOM, but it also introduced a slight behavioral change. The code used=
 to
> > > print the non-hierarchical v1 cgroup stats for the entire cgroup
> > > subtree, not it only prints the v2 cgroup stats for the cgroup under
> > > OOM.
> > >
> > > Although v2 stats are a superset of v1 stats, some of them have
> > > different naming. We also lost the non-hierarchical stats for the cgr=
oup
> > > under OOM in v1.
> >
> > Why is that a problem worth solving? It would be also nice to add an
> > example of the oom report before and after the patch.
> > --
> > Michal Hocko
> > SUSE Labs
>=20
> Thanks for taking a look!
>=20
> The problem is that when upgrading to a kernel that contains
> c8713d0b2312 on cgroup v1, the OOM logs suddenly change. The stats
> names become different, a couple of stats are gone, and the
> non-hierarchical stats disappear.
>=20
> The non-hierarchical stats are important to identify if a memcg OOM'd
> because of the memory consumption of its own processes or its
> descendants. In the example below, I created a parent memcg "a", and a
> child memcg "b". A process in "a" itself ("tail" in this case) is
> hogging memory and causing an OOM, not the processes in the child "b"
> (the "sleep" processes). With non-hierarchical stats, it's clear that
> this is the case.

Is this difference really important from the OOM POV. There is no group
oom semantic in v1 and so it always boils down to a specific process
that gets selected. Which memcg it is sitting in shouldn't matter all
that much. Or does it really matter?

> Also, it is generally nice to keep things consistent as much as
> possible. The sudden change of the OOM log with the kernel upgrade is
> confusing, especially that the memcg stats in the OOM logs in cgroup
> v1 now look different from the stats in memory.stat.

Generally speaking oom report is not carved into stone. While we
shouldn't make changes just nilly willy it might change for
implementation specific reasons.

In this particular case I would agree that the new output is more
confusing than helpful. Just look at=20
> [   88.339505] pgscan 0
> [   88.339505] pgsteal 0
> [   88.339506] pgscan_kswapd 0
> [   88.339506] pgscan_direct 0
> [   88.339507] pgscan_khugepaged 0
> [   88.339507] pgsteal_kswapd 0
> [   88.339508] pgsteal_direct 0
> [   88.339508] pgsteal_khugepaged 0

These stats are actively misleading because it would suggest there was
no memory reclaim done before oom was hit and that would imply a
potentially premature OOM killer invocation (thus a bug). There are
likely other stats which are not tracked in v1 yet they are reported
that might add to the confusion. I believe this would be a sound
justification to get back to the original reporting.
--=20
Michal Hocko
SUSE Labs
