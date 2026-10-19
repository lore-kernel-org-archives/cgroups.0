Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792433890;
	b=KMGwrWWBXdMxOskI6DiyqKEbTGTOgTNSOYmvENvu+rMSJ+dlpx7UY7biQ8H0cUwoA7fA
	 O58gcxmI9vBnBIq57Z2eGvBeOZLjB1c6C1Sl0ZZBRXUAR/wxXN780Z0a0a2gbWXgoeABY
	 GwsrkB/i1mhQIGDwgXso20YBg+kP/ZUhS1dqYTc4zo4IBgF78Ynp4vgqhU6XBhqDX31C7
	 ustME4mHjzr15zvZ+yJ7jPe3GmfOFPdYhjMuC6Df0FUjJzJeq0HY+/wxwDRkl1hd7V1a7
	 tTjSNc7ZUEeRSu8w6LCfpjdY8rgURws3L/QDharNHu9/5sxapyj8yiPuJW6AMtp68Pw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AMpq8scepCZJFIF7vkB29sciSmmD4/TgW9qbpDyJo60=;
	b=woRaP7hP/cA+HyvSLy1AB6YZwu4vj6QgO5ODeySOgP4SKTFpHHC1BQz7SrgwJk81nk6i
	 nns/GKKxyFmcGY5y4GzLWEoXfXRDOxtP09DrhCA3/THaTrCsM7qczjKUBAbQXFXv9Jbnv
	 fDaRASK6GM+O/tnbrWzgFrpJHB0jKkCLmoV+rjo/G0qqdA7qyzZZbpRN7avdYB99f574u
	 FMdRP4VBhfbgF12yhM6f7fo14+dt4iZdc0ck61iADI9uSNjVufdL4BpCDru2HM8GMeHIA
	 nPXBlT+yGBEdKenMjheS1DefqJqEDQvse9aODSTf3eofsHCFE8ONr7ftw4q9FvE1Hrw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=O66TplZs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE81F606A31C
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE81F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=O66TplZs
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1cc392d8bso2921329a12.1
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 11:18:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792433888; cv=none;
        d=google.com; s=arc-20260327;
        b=abLwz5ngdgcpSmbwZKGFFCxsIpk+JpPLiKCL8xmmvAm6jYGk52S29KfzBNdfq3MsPI
         WW+4oBBvBpq9B8uuslv3zfML2t2rhcPcRGXOB/yor9DoDiMIjcYHB/f3Ges58jobhs6J
         v2ybB6USyXxehHtplJPnd8LnKbailjfXFS2hZnTsPja09GZn3AcScMiMGTgO7bNtwm+i
         NK0OqZuUBu1W3wLMJnwVM7roqUsXkc2wUxyt2W+kce7V9fmjl9U5HtfVZ3Fetr9SvnsE
         EjNpzfVWSGd4Z0iNJLF+f0GWao5BvGu8nWMFi22ZlipooxRqBvH2lTETACndl8xaonVJ
         aSYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AMpq8scepCZJFIF7vkB29sciSmmD4/TgW9qbpDyJo60=;
        fh=YdRM0jsrEt6OeiNAy+M/Kj5tzSkz2tmzJbrt+uJYVpc=;
        b=PXm3nW491Pka1lw3MBzewmY6iLqDjMimFOWAvLZk2w3h189B975gjOwUVnhvPR+wrX
         MkhvGu6BpvpScTkp/W6DXR0rMOrbegNp332UVcEICTNBNX0RpaSWpoeMsk6csZSNDXuR
         cLkSMmkK+GnNLiu89MVv6CnMdVEApcVRq8W63+5YWfILL6/4RRDOWhTYzy1OiVk8/sAl
         yhWBvZ5hWyr4SL8N4rZVvl2L14c2wV2zuurOV/yxukIsbppau9YKx1Fot2sbZFF9zoOT
         oscXFcroSuG/YFJuY9gTGDTUHLTuInn89Awu/VHX2RYNd5AT7AF39A1vbeODFOYEtQqN
         SuPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792433888; x=1793038688; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AMpq8scepCZJFIF7vkB29sciSmmD4/TgW9qbpDyJo60=;
        b=O66TplZsYtUPecwtKiyMIErhS4EgMFQZiYjmEPuZc7rWIdfnaadprimP7Wj0JvKYHd
         7LT7JSMek8dUpZhqpoS3eLcLVyICzbxGA33S6p83RQDRSWCWyAJB2uwyDe0aaJrkQPrJ
         21cpp/YbLJdRdlMVYyfM84IgnlfLvbyuQ088GuqteVqR8a5YVjxs2vIEAcNcRIPnh0+Q
         Fu8AaLUpraNPpjroNxfeC85Iao5TMoI31gLArNG3YAnpmcEPJn5XKVKjSiCtvfBtvU5B
         lQ7yz6bgQn+h+U/LImJhWjca9fDh4tUX7UYCDfTlw+xChgLJxrFDVi3fdV2ukypiqAht
         rSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792433888; x=1793038688;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMpq8scepCZJFIF7vkB29sciSmmD4/TgW9qbpDyJo60=;
        b=Wv1OQwDae1yxO2Wf8hZ95ZWXjoZEGz5TcEZ4NrpwbBTou+dP//6p+NNqVJpFzdEr0V
         1Dl9n2RHnMop2upfXCGu5w8MCcWEOvXZ8znAeLpbrkIeh4UXQGUPyIbbt3+ig6jUmBSG
         SuPzw1KgTPAtjgLnsjjK0zjSsjNjzw9EBmf4ry/3DhSKidbd7pyL3DUxI5JgiSnZ/cmS
         +ESBhIT+8yu6X0xQ2INPT5bgB6pnGvSZaM00qPOCMiuPjD4xfWVUdOK/vK/4p1I52DxY
         Gp3DX+AiakRGHCjB87sbS0UnO2CZ1Hc7u+aFtbT/Ll/8/GIRiYy/GrbvWobR2GagJOHR
         3D6g==
X-Forwarded-Encrypted: i=1; AKwUvByD8el4sIUQZXRaNIQBJSjN+uYrv94db2ZBgw4Z7g22KOwnUtlj+TIHxWQCfogtavPaXqXdwkkL@vger.kernel.org
X-Gm-Message-State: AFq9FYISOwKx4IRD/+1cPZRaZXr9INZVwvyAcEd1e7pNhTIQ//b5yb2x
	325yWA4PY+4mPDnZo8EPm0WWSlC4U6l85rs3WsKUqWUAVDem2TWdZzaScTxGMAV3Hinjo98gKNR
	F6OBxLKXvEypgtTzYahV67ROp8cJcoxE2ARu80fstgw==
X-Gm-Gg: AYBFou3SMJqVN3QFMLXYGNtfmRVbqinsisyUgp+zEhbA1oVjAFwcfQCAwlENPOd1axC
	KQMBrYlM8HFHtYveKoNGutmS8W1o3IUurF+A+wxwV/DyYbmh3sOZatYoFHJJONWDEozgeTqIhoZ
	th9F24iN8FKUPgU5MqtrwkRFdfruYb8xZzpmdfi+ggN7Bscz6nneiPgZwaDjy+ifYdFo7Lq4F1n
	p0gkYcbk+/XyDGkaUi5pKEDn4FOSQFE8txIH134/P6mpf78wCRJD9SBzhJrB4is2bvrOb0CQVwT
	hYKU8r8rMA9HTXyFwTtmv+R091WfO531DlEaGPyjp4bIdOnyX50wvyXj1u1YyhDGDMk+WlQPzzI
	Fou3FkOQWlfs=
X-Received: by 2002:a05:6402:1d4a:b0:6b1:ef6b:f3e4 with SMTP id
 4fb4d7f45d1cf-6b3a8176404mr5105193a12.14.1792433887978; Mon, 19 Oct 2026
 11:18:07 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019181611.1461433-1-vincent.guittot@linaro.org>
In-Reply-To: <20261019181611.1461433-1-vincent.guittot@linaro.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 19 Oct 2026 20:17:55 +0200
X-Gm-Features: AclHuK8pcb1z55IYBFb9qBSmAibg0ZQJjuqDdIoxrmx7AMiXVR6pWAereysgFdg
Message-ID: <CAKfTPtCL-eV2WGv+KeK1xAwgmNFiqK2dd8BqVxd=JOaMFvw7Gw@mail.gmail.com>
Subject: Re: [PATCH] sched/eevdf: Fix sched idle task group preemption
To: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-kernel@vger.kernel.org, jakub@okonski.org
Cc: longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Oct 2026 at 20:16, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
>
> Even with flat hierarchy which puts all runnable tasks in the same cfs rq=
,
> we need to parse the hierarchy to check for sched_idle task group.
>
> Reported-by: Jakub Oko=C5=84ski <jakub@okonski.org>
> Link: https://lore.kernel.org/all/58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@ok=
onski.org/
> Fixes: 85570f10a4c6 ("sched/eevdf: Move to a single runqueue")
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

This was sent too quickly. v2 coming soon

> ---
>  kernel/sched/fair.c | 81 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 69 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0f2364479f9d..20c33d13a5e7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -433,6 +433,38 @@ static inline struct sched_entity *parent_entity(con=
st struct sched_entity *se)
>         return se->parent;
>  }
>
> +static void
> +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> +{
> +       int se_depth, pse_depth;
> +
> +       /*
> +        * preemption test can be made between sibling entities who are i=
n the
> +        * same cfs_rq i.e who have a common parent. Walk up the hierarch=
y of
> +        * both tasks until we find their ancestors who are siblings of c=
ommon
> +        * parent.
> +        */
> +
> +       /* First walk up until both entities are at same depth */
> +       se_depth =3D (*se)->depth;
> +       pse_depth =3D (*pse)->depth;
> +
> +       while (se_depth > pse_depth) {
> +               se_depth--;
> +               *se =3D parent_entity(*se);
> +       }
> +
> +       while (pse_depth > se_depth) {
> +               pse_depth--;
> +               *pse =3D parent_entity(*pse);
> +       }
> +
> +       while (!is_same_group(*se, *pse)) {
> +               *se =3D parent_entity(*se);
> +               *pse =3D parent_entity(*pse);
> +       }
> +}
> +
>  static int tg_is_idle(struct task_group *tg)
>  {
>         return tg->idle > 0;
> @@ -476,6 +508,11 @@ static inline struct sched_entity *parent_entity(str=
uct sched_entity *se)
>         return NULL;
>  }
>
> +static inline void
> +find_matching_se(struct sched_entity **se, struct sched_entity **pse)
> +{
> +}
> +
>  static inline int tg_is_idle(struct task_group *tg)
>  {
>         return 0;
> @@ -10129,7 +10166,35 @@ preempt_sync(struct rq *rq, int wake_flags,
>  }
>
>  /*
> - * Preempt the current task with a newly woken task if needed:
> + * Preempt an idle entity in favor of a non-idle entity (and don't preem=
pt
> + * in the inverse case).
> + */
> +static inline preempt_wakeup_action
> +wakeup_preempt_sched_idle(struct sched_entity *cse, struct sched_entity =
*pse)
> +{
> +       int cse_is_idle, pse_is_idle;
> +
> +       find_matching_se(&cse, &pse);
> +       WARN_ON_ONCE(!pse);
> +
> +       cse_is_idle =3D se_is_idle(cse);
> +       pse_is_idle =3D se_is_idle(pse);
> +
> +       /*
> +        * Preempt an idle entity in favor of a non-idle entity (and don'=
t preempt
> +        * in the inverse case).
> +        */
> +       if (cse_is_idle && !pse_is_idle)
> +               return PREEMPT_WAKEUP_RESCHED;
> +
> +       if (cse_is_idle !=3D pse_is_idle)
> +               return PREEMPT_WAKEUP_NONE;
> +
> +       return PREEMPT_WAKEUP_PICK;
> +}
> +
> +/*
> + * Preempt the current task with a newly woken task if needed.
>   */
>  static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, in=
t wake_flags)
>  {
> @@ -10174,22 +10239,14 @@ static void wakeup_preempt_fair(struct rq *rq, =
struct task_struct *p, int wake_f
>         if (!sched_feat(WAKEUP_PREEMPTION))
>                 return;
>
> -       WARN_ON_ONCE(!pse);
> -
> -       cse_is_idle =3D se_is_idle(se);
> -       pse_is_idle =3D se_is_idle(pse);
> +       preempt_action =3D wakeup_preempt_sched_idle(se, pse);
>
> -       nse =3D se;
> -       /*
> -        * Preempt an idle entity in favor of a non-idle entity (and don'=
t preempt
> -        * in the inverse case).
> -        */
> -       if (cse_is_idle && !pse_is_idle)
> +       if (preempt_action =3D=3D PREEMPT_WAKEUP_RESCHED)
>                 goto preempt;
>
>         update_curr_fair(rq);
>
> -       if (cse_is_idle !=3D pse_is_idle)
> +       if (preempt_action =3D=3D PREEMPT_WAKEUP_NONE)
>                 goto update;
>
>         /*
> --
> 2.53.0
>
