From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg: use rstat for non-hierarchical stats
Date: Wed, 26 Jul 2023 11:13:15 -0400
Message-ID: <20230726151315.GB1365610@cmpxchg.org>
References: <20230726002904.655377-1-yosryahmed@google.com>
 <20230726002904.655377-2-yosryahmed@google.com>
 <CAJD7tkZK2T2ebOPw6K0M+YWyKUtx9bE2uyFj4VOehhd+fYnk8w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1690384396; x=1690989196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cOppSR5vSHMc40APmcMzvAsvziT5KwEmkPNskmCaQgY=;
        b=razagjx5BCylQt5gjh9JrWZm0vXpRLG/piHYhTLKRLsw9zcpX1u5k0Vs+hrO22eo3e
         SfkcFjXF8k7a6zX2GsTDxVI2P7C+p9cdeVVWqBacemwDslPEmqfniR9mE8nddDPpabCq
         6dpDA4eXbXF/C7KRKLKH9oiVBg422CJtTD+CuvLV8xPXFpUPKo+R5iLBGqZvb3s/Lcgh
         hcK6qEOL48zST1lv9PuFKcWCke1qdlDDBpP5Om1APf4OhVh7DuHGAn6rqniiipNv2AJS
         PvL182LpjVrdjNiaGRVqcfKAt3ZgIZ/o2SV1UV7SVi8513mRcui/7i7sk96Jke6mFDC+
         XSfQ==
Content-Disposition: inline
In-Reply-To: <CAJD7tkZK2T2ebOPw6K0M+YWyKUtx9bE2uyFj4VOehhd+fYnk8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Jul 25, 2023 at 05:36:45PM -0700, Yosry Ahmed wrote:
> On Tue, Jul 25, 2023 at 5:29=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AK=
lfQT0dZR+AlfA@public.gmane.org> wrote:
> > - Fix a subtle bug where updating a local counter would be missed if it
> >   was cancelled out by a pending update from child memcgs.
>=20
>=20
> Johannes, I fixed a subtle bug here and I kept your Ack, I wasn't sure
> what the Ack retention policy should be here. A quick look at the fix
> would be great.

Ah, I found it:

> > @@ -5542,19 +5539,23 @@ static void mem_cgroup_css_rstat_flush(struct c=
group_subsys_state *css, int cpu)
> >                         memcg->vmstats->state_pending[i] =3D 0;
> >
> >                 /* Add CPU changes on this level since the last flush */
> > +               delta_cpu =3D 0;
> >                 v =3D READ_ONCE(statc->state[i]);
> >                 if (v !=3D statc->state_prev[i]) {
> > -                       delta +=3D v - statc->state_prev[i];
> > +                       delta_cpu =3D v - statc->state_prev[i];
> > +                       delta +=3D delta_cpu;
> >                         statc->state_prev[i] =3D v;
> >                 }
> >
> > -               if (!delta)
> > -                       continue;
> > -
> >                 /* Aggregate counts on this level and propagate upwards=
 */
> > -               memcg->vmstats->state[i] +=3D delta;
> > -               if (parent)
> > -                       parent->vmstats->state_pending[i] +=3D delta;
> > +               if (delta_cpu)
> > +                       memcg->vmstats->state_local[i] +=3D delta_cpu;

When delta nulls out, but delta_cpu is non-zero... subtle.

This fixed version looks good, please keep my ack :)
