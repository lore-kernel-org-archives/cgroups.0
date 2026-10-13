Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92CA3D8127
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791882893; cv=pass; b=m9ZVHnjTeBbZdwfBN5f72u2iDomd7wvcm9aYU11xZcCLJz5FJZszF5lxsMLN8LDbNtZKMrL+Hx34rONzatigGaa55vR7X5esZfON4QEIAlN5T2uTtdY6ilS/2MoDgleMVPuotl2o/+O3zFVeuPYnsw7jPocx4BZgDNFWyNjQuAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791882893; c=relaxed/simple;
	bh=/ZDx0qigdFSyCGhZXlqU3OErEYAQKoc8EV1Ldj229UM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NdFoUFEXWi8N4Tk4cLD9Kz4DmlRHsUfXaeJeS8i1uo0XTkA0Jks+bVOICyOX5WxuhWxe/Zzz4TTIDt8BR4cYDizj+yz0kVr2MS/abpDCO9DUs0wHKSxX/TisbczEOnoOHIem2JRdMVhMSJRIeMP78ym7p3anUAA3lkvFaZXh2zU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZnJLfpJ; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZnJLfpJ"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b05bf699easo18559877b3.2
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 02:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791882891; cv=none;
        d=google.com; s=arc-20260327;
        b=J4WBPZ+lzfcKs1boORSLegYqw9h3NNjWXDR1kAm0XZtgrJ3Yr5M7UOoIyBxBedOQlZ
         XF/AzoxI6JZMWebnP6HRKSKSd2+tLZdZ2LE2LGSW1BcVSfKfZ802T4/1ePgs5vcW7M3u
         cQFkhXGr8etG/DJWsPeNei0Zy7nHAm36gnuSdWY2vCkly1Gy1o6HRfu0QWkR47YcuK3S
         1GQ3nrcK6mh4zNlpDtXU425bo0HQtuOklXDwB5b0wFycO5/ggdoyY6P96x0gXcgO5BLM
         sIcjxjrFNA859opDaC4OZyU8U1TuvjO5Bb5CYZeGdrpIwIo3WpFMnJr3zhjEElISEJsG
         ftHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
        fh=+H/PAt5LlvP8g3+3C3lzFBNj5Xl5rHm+neSrHEcjHIs=;
        b=P5PQlSU3YzG+v1XpU9dgGldo8dK+NnaUyYH9mivTzZDyVTG1Ah88DQ7YV8OCYPPx6W
         m65IB504Mjd/rCHVVqQ+CLgvveRnnCTXT0nUjvTumBj1viq8EF0pbyUnN2pMhwqKJevC
         f/jvjU1rwhzKVtYwUqMuuhOWVdq2Sh5BpwoLnIO3ACpxSGcG/QgU0cZDHJHW1AUUx7Zi
         w5UQPdRtIkBD5eOSNuOpMK0t7iWSwDW1jCmvc8VvFPvMNRLidzuGcFmpRv2tBFBvIETJ
         6c2P3nX67j66xjJOWnAEz4bwcmKkNz6MydYpcrGH9lFdrdqCoyAoPJAcKVTmQRhtZBzv
         FsiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791882891; x=1792487691; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
        b=FZnJLfpJ8e3L/C7a9A3Pw6TbT0U3CixM1NRdnXYpbOrg/qJxUzQoq8EBkruxqmk6kg
         nN2ilGcyPiK91JQJAYktOTGw75qk7Fb/0jsEf8zZtCtmLfd2F2R3kaGq2RE6rRruPiIk
         aqEVueK46bXUhu0mFn71yHTDpnrAsE017Z+lN5OOjDSYEPciC8lRWGlxbG0Oa9/8H71O
         4ukjDJmnC4QJLGuQzlPOWYF00rDMOqPDs4hi7RCzqRlo5BG+2XFYgsKcFDJ/DOSfkcBz
         /sANET4r060IxjbT9BlvH/f1Jl91CUgFh2vB3gGI4VHZmjqvBAe7Lnf+RcPEg1L/np5Y
         JATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791882891; x=1792487691;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
        b=VNoM8b37FHv4IhJQ2qesP2qED1OA9+6ujUkw4w4IUg0b+lbsrkKgZrWQlxp9wIfci7
         SLdiVaw/G5aA8XFlEgH70p7Q2M1Z1lDnhcIAmlhHLJ2ZPdz6aosQpgjM2+c+VTn+B9ev
         hHn96kNTtXP0/2CrSjj8Ie+kOPHGCTJ7A+lTcMd0sAVXHCPV26R6qUYjee/4uiz3QtAc
         0XgCYdXtsrHrdJ7mgRgzZ6Cu+OT9w8osbiFVjajDJomNJb3tCTfm3l57QAKNx3Ns+P7d
         oEhPdjcBP02I81Ii930qWrFvsfeSAaxDsB2j5d46JfFvbcfzOpUTdAtgThS6m57yBTNz
         k4GQ==
X-Forwarded-Encrypted: i=1; AKwUvBy3yHR8wxKm65VqE8cU5CKMqDDLHmZjFxw0+8eKyz7arnfxS/FcrE5biP6ezKPfODcMtgIigSLk@vger.kernel.org
X-Gm-Message-State: AFq9FYLzhej6uEmZJiVcD3bO2fGIbPXybiRG6luN8qlLsszasUOKi6Bn
	IfNhsZTuKNejE/E0tqviAYkBSX6jL1uqq2FYhotu2aW027kqDXMHUXwqKgD+aq4P88i1kdzmsM4
	ci0NHVSm7PFfY7p4ExT5LwxAfjRVTiC4=
X-Gm-Gg: AYBFou33cQ92eRWmzPk09d8EirAvmg6Fh1D33dshthoPvq1Jif6w5X9fC8kE+bPwUkh
	IxmU8mosAFwUQJgkBnYfMn/cMqnkt64JWOxyoz7RpHeAuZ+eGnD1779eXwsqYw3VX2uy/2Ky8e5
	wbAlsDgL8Sp9aO+nF8pGDFxGc7Xm78516ae5isgnPJUpZBxQCQ9d/kNyaIoZ13B7FFk2ZITmifS
	3qX5N3viVy3g4lSpPYCLzr92/YnIp3x1sirrRVwj4t5YR1bw3kulnGUBlNYR+cTURGgusCrn/pw
	MAI/HL8zCXWjwVAk/l3/HL18Z/J65Lc2kYdo+P5kkVWYkfL8NrIj4aFGOHp2XDvodgI1+1F+F/R
	bIbR9m9jjRw==
X-Received: by 2002:a05:690e:43c6:b0:675:3d40:3c2c with SMTP id
 956f58d0204a3-679362ba7e0mr2295954d50.81.1791882890519; Tue, 13 Oct 2026
 02:14:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <20261012120438.52849-2-laoar.shao@gmail.com>
 <96324eec-d307-4bbf-975e-3c9b3dd5e190@kernel.org>
In-Reply-To: <96324eec-d307-4bbf-975e-3c9b3dd5e190@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 13 Oct 2026 17:14:12 +0800
X-Gm-Features: AclHuK93g_25NJAT6wXES6RLREaNoHaav4Z0uWW89g_0G4Uh0XP2UqZ1IpTsXuI
Message-ID: <CALOAHbCOZdYe6E-_atuyT3UvOQt+j01Ru0ErknVutF8kR=L1Fg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] sched: add helpers for numa balancing
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 3:38=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/12/26 14:04, Yafang Shao wrote:
> > Two new helpers task_numab_enabled() and numab_mode_tiering() are
> > introduced to replace the scattered direct accesses to the
> > sched_numa_balancing static key and the sysctl_numa_balancing_mode
> > bitmask.
> >
>
> I'll only comment on the new exposed helpers. Some of these might make se=
nse
> even without the bigger series.
>
> (obviously, minus the task change)
>
> > No functional change.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/sched/numa_balancing.h | 31 ++++++++++++++++++++++++++++
> >  kernel/sched/fair.c                  | 16 +++++++-------
> >  kernel/sched/sched.h                 |  1 -
> >  mm/memory-tiers.c                    |  3 ++-
> >  mm/migrate.c                         |  7 ++++---
> >  mm/vmscan.c                          |  6 +++---
> >  6 files changed, 48 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched=
/numa_balancing.h
> > index 52b22c5c396d..353772b49c5f 100644
> > --- a/include/linux/sched/numa_balancing.h
> > +++ b/include/linux/sched/numa_balancing.h
> > @@ -8,6 +8,7 @@
> >   */
> >
> >  #include <linux/sched.h>
> > +#include <linux/sched/sysctl.h>
> >
> >  #define TNF_MIGRATED 0x01
> >  #define TNF_NO_GROUP 0x02
> > @@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
> >  extern void task_numa_free(struct task_struct *p, bool final);
> >  bool should_numa_migrate_memory(struct task_struct *p, struct folio *f=
olio,
> >                               int src_nid, int dst_cpu);
> > +
> > +extern struct static_key_false sched_numa_balancing;
> > +
> > +/*
> > + * Whether NUMA balancing applies to @p.  The @p argument is unused fo=
r
> > + * now: a later patch will consult a per-cgroup BPF policy with it.
>
> Talking about later patches in a function doc is ... wrong.

Thanks for your guidance.
I will update it.

>
> > + */
> > +static inline bool task_numab_enabled(struct task_struct *p)
> > +{
> > +     return static_branch_unlikely(&sched_numa_balancing);
> > +}
> > +
> > +/*
> > + * The global sysctl state, for the system-wide tiering machinery: thi=
s
> > + * reflects kernel.numa_balancing_mode only and takes no task.
>
> The latter part doesn't make a lot of sense in this documentation.

I will update it.

>
> > + */
> > +static inline bool numab_mode_tiering(void)
>
> The function name isn't really intuitive. Should this be
>
>         numab_in_tiering_mode
>
>
>         numab_tiering_enabled
>
> or something like this.

Agreed, thanks.  I will rename it to numab_in_tiering_mode().

>
> > +{
> > +     if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > +             return true;
> > +     return false;
>
>
> return sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING;
>
> ?

Agreed, will simplify as suggested.

>
> Both functions could directly have proper kerneldoc if we are already
> documenting these.

Sure. I will update it.

--=20
Regards
Yafang
