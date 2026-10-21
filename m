Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792600807;
	b=cnAD7QanpxD7G3vRVwWMkVLFp/i2rvdEoM69Wu7lSa/dAyU7bhlsceOSzIV7U6WyWEWV
	 frAmkdK5rnp/aK9sbJfnymTVO0eAherz5kYKDT/1sm40lSJ1B9FurNN4rFgrdXKBV93a8
	 k1aqEEbvm3QzA2k+P+7epHQ+tXUzyzb5oAKIkHIUwgYdI+P1G9WXJMYc2F2+2K/xF25Qz
	 Ne1U0zIP8rNK8HnWiYwAqFH37fG082wFGD6g8unidqCDI/WaoOU3hOqOXYicdneOsDPki
	 91k9fEFVMHtJQ9sHXbt9PH5SQdpmBmNQwtt7kcEqikBAygjUP9OPcW+MXT5zvSCoMBw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600807;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9gOUhyLHHkMJbpilfrmh1aBh45/2ZIo3brA+Cp6zFLs=;
	b=AglR2sijHn/GRk83MKG/cL07Dt4LyBIDlnaq6tghvoOo9nxlxrUIOpkPGTYrHIwND3/+
	 f7SOBKJ8CAXgUfy+9/Jfy5mNtMZkLq/8uUlhIszMMrOkh3chnrk1X7+EhRcVtPFFw1zhB
	 8Kcc5JX5IdmPYy2W/YYINly6+7CF87aumJrteIAo5bHQ807dCtiKUlZ1HbVNbbLwCavzK
	 FvfUb9jmHPCgw594givve7BUYlG4Xb6UNK3j8nVgzKiG5hiHpM5nfG9f5cGuFMChQp4aR
	 fqtvbuiV5PkEgI+FZtzZMowFYP7Ruu2wz9p2KibGgAxW5UEeaiU31hjVqCvWnR+7+Rg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fjO05O2Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF86606A32F
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 16:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BF86606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fjO05O2Q
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1d2ec9aadso62575e9.1
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 09:40:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792600805; cv=none;
        d=google.com; s=arc-20260327;
        b=qcJ1J/ir50OW2wC6gsC9Z18EJDTgZs9KrL53fzFc4V5wgTbegO5MzRdKXgDgQpxjKF
         r5e6XBl9zt/6l6wISumRNqORGz72wwu6yBu+l7T4/HFmHOOI7jy3gFZ9v2myNxdFJbfP
         nhJfp0EMBcvx9P1txKa3znzJwkwFqdiCgJxZvSJ7v7ZFhSaR2vBWEIbp8p/Bk2HGm4NF
         Lz5UwxkUWaHxsZMJvnAKj3+kQaGSVUWrh9P3QsPr/UQUDTE/arSt/yZ4hhUwp4W6oTfP
         ryQEVJCeTLDT1cnkPDJG9Tn3yB66KhEUU5ThYdwGnfLaU7FQEXhkVnPyhRIWFIpXupwl
         Gqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9gOUhyLHHkMJbpilfrmh1aBh45/2ZIo3brA+Cp6zFLs=;
        fh=i7CnD/d2qOVEo1Hxbp2qf2dyxm6ZlYDfnoukqPSPk1g=;
        b=W/Q6v3dJiIHHpswt1Y7NTER/+Z2hb8N43+xJ2oFQUbKtun7Smjl29GsOFXwC1YPBEV
         B9hmR5ayAY5Fojkge5wmPhML9puURxrCvoNsADJwTontKg1pcK7NEQmBEY69QKG8kQDH
         H8sFuciIf6/7hp6j65aVafeXkW8AJenTa7wHu+9GIbA95vx2RzhnslMa7FAbXJQulGKo
         jkZJBhSkI47XfnyuRz3iUC2di4PsmgnFJb25e/a2cNX6ZvjysSusMtgZ9D1D5Je+E9Fg
         r1oLozN6nsjSoJoK9nY/62t+uqSPjuYAH0vy/6hZdjytP34mCiIDcZXHfAGy4/SZarzb
         w1Dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792600805; x=1793205605; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9gOUhyLHHkMJbpilfrmh1aBh45/2ZIo3brA+Cp6zFLs=;
        b=fjO05O2Q0qGAPz81SNh/wciIGLSVT1/aMsj6RZh1P7UKkYUE2JsJlY1gD7dCqE2jP8
         GbD0n5CmgUlv593JGStjdrJJ4k1DC3DRhq4qeK26T+op8QKD4DNA/IEP4BwGmjRnD/vj
         p0UwCNmLmKxr3bMk5UsiQn3yDNx5KXdGGgC0XySv5dgiLy+O70DnLUr2FIw4nEYRk04T
         9xWQEmITDxv6n+2mrPdyxWaWWOg8PKlCcn1C5t/KmpMCP6p2D/laetw9OkCC8vpHr713
         Fg0EBR85vvRdeW12s7uDq240KVnroB/GPTGurUk+skAjqwjOKY9SaumizECQEpuvDLPK
         RCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792600805; x=1793205605;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9gOUhyLHHkMJbpilfrmh1aBh45/2ZIo3brA+Cp6zFLs=;
        b=K2mpAhrHzVUTYZz4JRtqAg8ODHmHcfC9ULHpsNfKeXh8mn1OMa54qA+A9T3tXNwVuE
         C6fsGkJdjjAeuOwRyPuIHCr5Sorn8W2qHzISFZCWNhfWTm5OoGdmT3CXfg3uDvzRTq7O
         ykTU1Z9l6orI83x2mo/z1WzW2nhLJ500oG8zqKu1UgAU55yiRnJFixea5S6V0x6Zd/mV
         E6kvDt8ibxKUr3JEJa0BfA6bGd7tkrHmRgTVo8RilCVIZHRN/DXAF69TXzEjy6qqAlOt
         suagtRNOO3Y9TzM0nejimrgyENWPVw8dywlDkwCgorHD5KKiI2UWqwoWZRbXASaXDt/E
         Ze5A==
X-Forwarded-Encrypted: i=1; AKwUvBwVnCvAt6wj8TscODg2U6dAhU+d1IRPGslYVUI/OZAG0+rL1vPquY8rLEe1SyXvkCKs10qL14X2@vger.kernel.org
X-Gm-Message-State: AFq9FYICPDhtBudDuHWgcGbP+8ucwJ05neBiD95hl+ZCiImhbR//e3dz
	FvgYESBbVZcCnnQ3Bz8Bi+7wJV8K9p/WFZSMUuUyczPCH59j6i8iVPhZCFcf7qd11tSNuTHM+jM
	vj0He7GfThGMOgBKYpv0oD2+vV1nE0Gl+VpuSploL
X-Gm-Gg: AYBFou1ZNjvUEBMyp0FcnE0eIbXHsLUi/yr5sYKA7gMqhaFZaSdeyHP+3ZILd4euNgX
	01JP+B4XKDP7VKd1A4G2OqzqNQttgVkKXL1uqVqIkiqU8EcqQUua6t0Js5Bm0KiRZAgxiz+YU2l
	DMew1d14oIjhsCW8bJEJWgIi5ujN3VlzvxYtYfqU3Q+16E3mBvji/EDbrrIkxec6nQYYVxKuAcT
	hWNSMfjD6VfC187x+XLou7e8iqWBBOQ5DilPP9iAUJ1i2cS+g0O/6I+gAPTOsRE76gdoOHFf6LK
	jQbqds6W80hCXa2kNiYCXSgXqgVxdbuIX5DvPjXzaYqt/t2bQXmv95yj982CemzLYX819ZDtu2v
	v+180Bq6+vE5eTZMESfKW8gNx64bNENBq0a6bw4tNUjNlF8G9aUuGcuIjAtlwyF9sHPUonHDyWZ
	P7xAPH+XVy7JWQ
X-Received: by 2002:a05:600c:2d05:b0:4a1:eccc:7807 with SMTP id
 5b1f17b1804b1-4a1f5985a37mr1368455e9.8.1792600804895; Wed, 21 Oct 2026
 09:40:04 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules> <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
In-Reply-To: <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
From: Josh Don <joshdon@google.com>
Date: Wed, 21 Oct 2026 09:39:52 -0700
X-Gm-Features: AclHuK9kE_MPdzQX8tUVw7v8ryQgrlgBpnHtL6HIx0LDZ771blfjDouEHb53TJg
Message-ID: <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com>
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kayra Cizmeci <kayracizmeci@gmail.com>, Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com, 
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, jakub@okonski.org, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:50=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Oct 21, 2026 at 04:41:52PM +0300, Kayra Cizmeci wrote:
> > On Wed, Oct 21, 2026 at 03:32:59PM +0200, Vincent Guittot wrote:
> > > On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.org> w=
rote:
>
> > > > What is the actual semantics of cpu.idle nonsense? Why do we care a=
bout
> > > > this common ancestor?
> > >
> > > AFAICT, cpu.idle applied to one level and against entities at the sam=
e level
> > >
> >
> > Yeah. Like on here:
> >
> >     ROOT
> >      /\
> >     /  \
> >    /    \
> >   GA*   GB
> >    |    /\
> >    V   /  \
> >   TA  GC*  GD
> >       |    |
> >       V    V
> >       TB   TC
>
> (marked GA and GC with * to denote their 'idleness')
>
> > If GA is idle and GB is not, while GC is idle and were looking to TA an=
d
> > TB we gotta choose TB. But if we just look to GC and GA we would choose
> > neither. .idle just applies to one level as Vincent says.
>
> Yeah, that's what we used to do, but the more I think about this, the
> less sense it makes!
>
> Josh added this (added to Cc now), but we have a number of Google folks
> on Cc already. It would be good to hear how this is actually used.
>
>
> So in your example TA and TB are both inside an idle group, and
> therefore one can argue their behaviour should be like !idle. But their
> common ancestor is root, and so the fact that they're contained in idle
> groups gets lost (which seems crazeh).

TA and TB have a matching se of GA and GB, since those entities are
siblings under the common ancestor. Since GB is not idle but GA is, I
would argue that TB should preempt TA.

Consider GA and GB as groups representing different users, and user GB
has internally decided to create an idle cgroup GC to adjust
competition between its own tasks (TB and TC). This should not affect
GB's overall preemption ability against other users.

However in practice doing the exact computation to determine
preemption for relative idle properties (especially on wakeup) is
expensive and perhaps not strictly required. This is also why e.g. the
whole sched_idle_rq stuff is imprecise. We keep an overall tally of
the number of tasks that have a cpu.idle ancestor cgroup and use that
for wakeup placement, but if we were trying to be perfect we would
need to consider the matching_se stuff for that as well. What I'd say
there though is that imprecise placement is better than imprecise
preemption.

So overall, I would say the find_matching_se() stuff gives the more
ideal preemption decision; my first preference would be to keep it. It
avoids a regression with users who delegate cpu.idle internally within
their own cgroup hierarchy. FWIW wakeup preemption already does a
cgroup ancestor walk via update_curr; find_matching_se is similar in
spirit.

But to be clear I also don't think it would be terrible if we did
something like you suggest, cache whether a cgroup has _any_ cpu.idle
ancestor and then just make a single decision on wakeup comparing this
for the two tasks. The result of which is TC preempts T{AB}, but TA
and TB don't preempt each other. In which case I would suggest we
cache that as a part of updating cpu.idle so that we can avoid a
pointer chasing loop in se_is_idle().

Either of these two will at least also restore some semblance of
respecting cgroup cpu.idle in wakeup, as the flattening made it only
consider task level SCHED_IDLE.

>
> But worse I think is T{AB} vs TC. In that case none of the common
> ancestors (root,GB) resp. is idle. But T{AB} being inside idle should,
> IMO. definitely matter vs TC, which has no idle anywhere.
>
> So I think I would very much like to change the semantics here. The
> current stuff makes no sense.
>
> Anybody, please chime in with how this idle crap is used and expected to
> work.

Hopefully the above makes the use a bit more clear; cpu.idle is both a
weight thing and a preemption thing. The weight part is respected
naturally by the hierarchy, and it would be ideal to try to respect
the preemption part as much as feasible.

Best,
Josh
