Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3641CB47
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788385436; cv=pass; b=EF8OOEMfRLs5FJ6ZE4MmdnWVGINZO8HzDObzj9AzDTXoIc25jVwhguz321wdeziH1Acx/bulrabtAs40VyYQOWtNgj6JrR4GdcIaJ+r/Mx/80aX4V15rgDQlcb2rhIDPkHsUTiMaMLMthlgYKV1irn/44EXF+SiYEZcGjnjLC5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788385436; c=relaxed/simple;
	bh=g2U+KsZKm6WSxd3AMLEb2U617KKBcJ6EN/Dna+Lnw6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gxq6e6ejyCZN3es/sGtvx/O5r7MNCLUIqdJnN/lVFwaRmKmPAPOhlAinstlxU/G8tZKJlT0jY3gNB10oYL5nCwDYfF6eEDOSl+zcLCkVQpvzwCB4Z7D9DmdI2PMYvdqX60EZ9e2Tskvy7M4pHhRywegOqGhtU35TPNVMEt7FwOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oe06B5mX; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oe06B5mX"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49b9320423cso16369395e9.0
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 14:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788385415; cv=none;
        d=google.com; s=arc-20260327;
        b=hlm2be0gER+TC4l7ZeOjtkG2r7OycTgX4QXAwwCFGfhbtAEagAvox67SPK68aqjmoL
         uTcldV74suDmAq/FXhQ1nFrxNz9bwI0HkOP4KAdhenkVSLWzOgwNOG4HOha/rzERN4DU
         CNgflPO0uq5l97xUWGJvcKRH5Mj6oWev0A9yr2FIP066O3YyBniMM0v7Mh+g5eUDPjxL
         Jwki00lGNnvAO0ntbhS3y08ldbOpuDiValqwN0CK865LeWUOmlRIOj6P4zAuokZagd8Q
         YjFwVhG+pFhtxJlav24ho3n0hRVAoZoq29iXpf3PoOr8KZNpD/INdV2/lPOG615iH1GX
         k3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
        fh=aTA8RpR6gkBA8QBepmm9Cy9EAEzC4yCvBc531NsgaD4=;
        b=aup5wSBHXV+5IrdUgzUF0TWrGmd3QZ3P0bxCU3ejN7Ui0NKTh4lPMETXzfZJKUpIRv
         GKjNuIOZ70x/lXkw2Uy4Vo0NzkU+OdyrtNoZoitXx1udB69wKM3gOy++rbWdteIQQg4f
         rtPaozcQTp3BRTZyecKoxTaQF5qi3otpkreVSB2bvv0oIZu6Obdxq+XL0vUrzB+PgYsk
         TmG4wIs5f/MGX2b3WMAtVTw6C8Y3r6zd/eaPlFpJxYSJRhXl7yXKmPiAyanEBlGWdiUt
         fSOIgceECcS/vmPepMsPvTVGL0ychFWm1t9hqpVK6UOpMfU3TuNy+31iSoYSRE01M4Dt
         eXOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788385415; x=1788990215; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
        b=oe06B5mX3HRoH1/op4HFW048csq307wj3w6ZqaUMtiv9knod0PDQp8MN53WMZePmfr
         KfdmLuFk2X6j9c/dKg2AMEc3X0tKBUw13y40plRWR91f9b0GPJb2HQg7KP8guDpAB7t/
         gRUyU7+soJLOkYAnKGzVUiIlil6qmXW+VL4vLewal9mN5/3z2rW0kDEgU3muNjaOrw/M
         WKzpfILRVCAexHgcEOFzYONeq0fN3oZi5A4s6pBBG39kSjliPt1bX8ZWmvRWZpPvL1vO
         L50GTKcOCdmAZuTBurg6MBLmGmshjaL+hI6m1TgYt/toSgKw49iht6DyFA1Q5bT+srvE
         9dvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788385415; x=1788990215;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
        b=eYcFFeRRGQ599+nJDRRZiKkDBytYsLo94gpgxjAqnzuNFe+ZSnFe/MAXVX6AguuUbZ
         u3qZXGfa2M7Kvn9pULU/VZ6TsMeIF0zMGid77iqYv77zlDEFdBCC3ZvwGxWqqRpXM4YM
         bg9zO06S2cf+lN7coLBWQ/tHLSCzdm5YL/aEhNUPwYdED0VjDc63UK8/rUUE0C4ixbu2
         GyFJXOBEjlOYnDSHH/NCgm+MmFsV5AJ8tuPZR0Oif/PxqhzzpkXJfX5HfPUpm4kcoage
         i2YpPtmnGGUD4fCiK9JuQAmxg6omPj+Y0L0WHiJQ+q62/5klKHCX6ji59l0U4+LtsOZh
         9QVQ==
X-Forwarded-Encrypted: i=1; AKwUvByuYcIKv3BqRoIDN7XN0bYaA0vQDRTMq+xBxYsfKBMSe0poUlf40TqG8Qdsrcauwftu/SEUFjvl@vger.kernel.org
X-Gm-Message-State: AFuF++ncun2gGVNvDen26+0zTlh7xSnMLsQhWz7MCz5hrrivC6aN9J0z
	qwSzGu8WCk8Kl/vrho34bkSDXCd6nden1pOODInqQSzirz+31b8ZGRZJg6dcIimqCA6jMu1RfAK
	Al8nXFxzzYZ1DrlVuWUIr0Fp51G6Vn4Q=
X-Gm-Gg: AYBFou2iJiB00csJfFJmkfVyfdRFbJpiO2OjjefhbbvREUcAa5y/vCDvtUkkCkiqvAH
	tZ1wrdDxHq2NqjXlWPhUINsWK1f9RRzrulBJcq09vaa9T6xQiz+8ajY+o4lfnfI4QBZUX6XDGDF
	li55zU94je9rXhdYu569ZeOpAOy0l5WXutyrC0K3X7OlZLGFafn6d2hLFax1rx7LJm6mYZde5Dh
	TOoxe8tVtEP+F0SkbqJNPlxSdq/LWpOGlM7hxpTcWKVuKk18fv8ijP1BEmfSKSZAaldepmOsuY9
	SCdNZXwMwYAHHJmmcz3NvMQUV34OmrhYdHhhJNv28pV3MhSexGfmaE1wgq09WjrekrNdxCBIhgk
	rPXXM8nr+FO2ofvlr9/zzkaf/WU4=
X-Received: by 2002:a05:600c:1909:b0:499:ae94:be05 with SMTP id
 5b1f17b1804b1-49ce55cb36amr117683635e9.0.1788385414830; Wed, 02 Sep 2026
 14:43:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902205406.624782-1-joannelkoong@gmail.com> <CAO9r8zPqXkWBPbObB1ngCjUWjXJJ8sD4a7ZtfGOLQe+-NfD=zw@mail.gmail.com>
In-Reply-To: <CAO9r8zPqXkWBPbObB1ngCjUWjXJJ8sD4a7ZtfGOLQe+-NfD=zw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 2 Sep 2026 14:43:22 -0700
X-Gm-Features: AcwNN1VBdMWGtAIe6_hbwXmJgOUWR-EKlScm0Z8jBWXtnllsqPiwms1lhhZnyv8
Message-ID: <CAJnrk1bMcr=+yigJAS1yf_GzYiPN_BMSOwbtLuU50jj+pinH0w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memcontrol: skip non-hierarchical memcg-wide stats
 on the default hierarchy
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 2:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Wed, Sep 2, 2026 at 1:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > +#ifdef CONFIG_MEMCG_V1
> > +/*
> > + * Called after the controller has moved between hierarchies, with the=
 on_dfl
> > + * key already in its new state.
> > + *
> > + * If the controller is moving from the default hierarchy to the legac=
y
> > + * hierarchy, vmstats's state_local and events_local arrays need to be=
 populated
> > + * since they get read by the legacy hierarchy. Those values can just =
be taken
> > + * from the vmstats's state and events arrays since rebind_subsystems(=
) only
> > + * allows the move when the root is the only memcg.
> > + */
> > +static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
> > +{
> > +       struct mem_cgroup *memcg =3D mem_cgroup_from_css(root_css);
> > +       int i;
> > +
> > +       if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +               return;
> > +
> > +       /*
> > +        * The flush is necessary because there might be descendants th=
at got
> > +        * destroyed right before the rebind that may have left counts =
in the
> > +        * pending arrays that haven't yet been folded into the state a=
nd events
> > +        * arrays
> > +        */
> > +       __mem_cgroup_flush_stats(memcg, true);
> > +
> > +       /*
> > +        * Not serialized against a concurrent flush. The periodic flus=
her runs
> > +        * on root_mem_cgroup without cgroup_mutex and a flush incremen=
ts state
> > +        * and state_local together. If the flush happens in between wh=
en we
> > +        * read state and write to state_local, its state_local increme=
nt is
> > +        * overwritten and the counter stays short, but the difference =
would be
> > +        * a single CPU's accumulated charges since the last flush and =
the
> > +        * counters are approximate values.
> > +        */
> > +       for (i =3D 0; i < MEMCG_VMSTAT_SIZE; i++)
> > +               memcg->vmstats->state_local[i] =3D memcg->vmstats->stat=
e[i];
> > +
> > +       for (i =3D 0; i < NR_MEMCG_EVENTS; i++)
> > +               memcg->vmstats->events_local[i] =3D memcg->vmstats->eve=
nts[i];
> > +}
>
> I wonder if the complexity is warranted for this optimization to work
> when switching from v2 -> v1, or if we should just query the boot
> parameter.
>

I think you're right that we should just query the boot parameter.
Sashiko pointed out a race [1] in the opposite direction between the
flush and the bind where the flush can overwrite the local[i] value
stored by the bind, which is much worse than the above case where the
bind overwrites the local[i] value stored by the flush.

I'll drop the default hierarchy stuff for v3.

Thanks,
Joanne

[1] https://sashiko.dev/#/patchset/20260902205406.624782-1-joannelkoong%40g=
mail.com
