From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: periodically flush the memcg stats
Date: Thu, 24 Jun 2021 08:00:31 -0700
Message-ID: <CALvZod4zaJZ1VjSQNvV7oUDZ58VYWvEUBa5WsGU4SYWnT70vbw@mail.gmail.com>
References: <20210615174435.4174364-1-shakeelb@google.com> <20210615174435.4174364-2-shakeelb@google.com>
 <YNSQNu4ZW7mEX6LW@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VEtW/m2G4JMnkRazKy7NH/xx9Lmp9+147gFKq1PM9Yg=;
        b=WAWI8So/qhhVeppsIvdijPvUzdKdS80W6KrQW/YiWqHSSLQfZqqWsi1EBJnzuaRtvQ
         uwilI74b1Rj2CMfhicSt0oPI4F1Xekqj4XfrQLsepNL76BJ8xBCOBMSkY3Y1x6Gqw2sj
         7lvnVcUcP93CrANK0OjxaCB9Zt34DH2PHf5vKOMNRYu5V5fvB00/TP3EnPOIhIxca6Zl
         P+N/bo1Uu48b6MI43s1/NQYwIej3Cl/5IKT4nCsxBXfmhsKkx3WsExXRF4YkWlBeBjCu
         K43gwfpaWSvIznaF14eSVUglFjETBkIwB6IrOSXTcfm8yUGeHyxDJ3fgOm99lLecLaBD
         MiWw==
In-Reply-To: <YNSQNu4ZW7mEX6LW@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 24, 2021 at 7:01 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> Hello Shakeel.
>
> On Tue, Jun 15, 2021 at 10:44:35AM -0700, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > At the moment memcg stats are read in four contexts:
> >
> > 1. memcg stat user interfaces
> > 2. dirty throttling
> > 3. page fault
> > 4. memory reclaim
>
> Sorry for being dense or ignorant -- what do you refer to with the point
> no. 3 (memcg stats reader during page fault)?
>

Yes, specifically workingset_refault() which reads lruvec stats
directly through lruvec_page_state and indirectly through
lru_note_cost_page.
