Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA31405F7
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 00:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787617445; cv=pass; b=JEbJc5RhlpQecVNoDicetao3djase/ymBjrna8OcMQmjgVH/aKJc0XwKr3+iU3T/9W5pRh2c+xEWnMvPqFu6BiPBX507iaimUZIyYG2Nnn1DpGBLxmc6nShu7+IXfNhO247ESmggsszIWa3PJSaovesAdmx6MRFn10xMz7xXvHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787617445; c=relaxed/simple;
	bh=sD4t/4meW865SSv9NS2Z9q2uhT3+EtFOR3Gtp+V9Umo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PoFjx6dbZ//5MiAEH62vi5VUSvfTVGt007FNnySgdsgZVLL1Shvs9IwLkDEF5LNQAS8tTFDndtBweW+WRgCL9Mrw+3+oag/JevY8sXxxy31+Z/bUaHelzidDvZxKUH4Vc2H7ztDsaqDnh2xBY6zWTE1kwh3HA+qC20hBXidynvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPfxkiJW; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPfxkiJW"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso32342515e9.1
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 17:24:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617441; cv=none;
        d=google.com; s=arc-20260327;
        b=Dcs3YoPdVPj9yojbVGNuzmO7HlpCCUZ3NdRWAbhn+quUE21K8UXCsr2bYalVDLEZ+w
         4vni/jpsmHrL/YdFFOHl3B4R1k+fGk/gtvJZTh4v8hAndc+a58cXOtgXi3mVzH8pskit
         4r+Sf7mlffs3AlGyV1pO7KKxtfliKmbtRRaLQO9y+Zse74Zs/kXG7aWLs1Oc/v5M18J5
         v8OJxbCugrs9wG/A/PCcClwZl2n5lF2LNr18ihc8u+jrNEPhcevBgVtgiaNlETCwETKQ
         uqj0nBqArbTT/BMAnV12cjZsh5domMM/1BwWjNUzlzmsaH97QcDN94FcFWZOFrdeJ8eI
         GqFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
        fh=zIprZzMdW0VsE8QSV80MQ4Ym4eZmv6+mRdP3YUmuejE=;
        b=VGY5BlBz5/9Vrtnc1SumHKM67gyWlLPMmZDDyw4/ZBuHRcWvpLXW45mN8augIrn7Xi
         5/DKF+aK79Cch8Cm6oyVeEy8+JGgiy+A8ixl5AfP00LPqerz+uhB+9HtLFnwIwIDo4U/
         +luS2HSa3ZAK4VhOUQRrRspLt+tyMjDSBwicNzdbC+xbBZZ/mv5WQw6+NkJ70GreX7wt
         go10tbrSHTV2ylbvBl+EY0Kaic8O94G/Lsn+30Dad3mlhqOvILunAirOvCvOTdoJD45c
         5529tNO464Sw1OHZEvSCYbLC+1wScXBrEdfcB8YXvy56+wBmNyB2UZASqcMTQL7fxCkq
         t5Sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787617441; x=1788222241; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
        b=JPfxkiJWSvf3+eBnm7GOWg4rkfNLnrP0M7Y9ODKTYV/eZ5hP+UFqkOJlhDuxutPpxL
         3UHEpo3PiWfog6Wg9IFA9FXH7lpnkGqn9n3lZ6/My2bKgCU0OZRk2/+lg8WBSQsrrSnC
         rHekgNCIVsCvb1TxDODI3Yt30A4zCjij9yK1rC1C8JfitG19d5CeEQ5ODX+aX2hanW5q
         FMIf+aS7XZafYSCV55QkRSBXTJP/kaIDVpZUFQA1+70QZnnu3mSpiAUICTwj4U99qrZL
         MvkMVUx8AbuLZslCIjvvb5epHfA4AQvc3xTDuMD9srq072iAPGeIYsgv7xLEiH6QC7q/
         Jpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617441; x=1788222241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
        b=SEyfEnEczxfpcWugIkSw8Pwi9IF69IBDqYHKJGgRB/HRjBepxhF+EGpgN/Us8KW08d
         i5Uf80VZLM4ryGjd6zG/EG4gp3y2qtyc5uYiO1zReMbAuOIj35uFzn3PRnT+5oFsOBsH
         GIMoe78qqaRI9L/p9tUt6TAeKb/0l5AwOCBoPDIsiJUpCiT5vVasBQ12ofuH5CVkyOWh
         6CbT9PPtccRVc1qyrAgL964Gzs4MXEFHaybQB1lSa9PMLCmwh394qQJAP5X53MH1sfr+
         C7YR0urW8PDbw6bgb7Zxb9V82StKOsArrOYm41NPk3+xjQqOJaEfqjfywn7icR3Q49TR
         Y9mg==
X-Forwarded-Encrypted: i=1; AHgh+RogkNUeP/yz8PZvt0At38yyYaK3mE6397M45LZ9n9YFfxI9jau6ERNxMn+AEr0rptOyTcrWrQxG@vger.kernel.org
X-Gm-Message-State: AFuF++mB1T26kuGlR03oJKv6ZOYfRFXGXNb3bFw3nZnHmlDh3aXzQNCw
	wQ7OfhMRpI6O7CvbafovXpSQGs4Rd4WvmQJUEpc5SEH+K1ULVLDftUnlaXwikwEVOtnVp7YVD1M
	XKK3B60M0T6XRLFkOFQeniOEP6P+aDJk=
X-Gm-Gg: AR+sD13cwjFpeqqvWHT1irUmirBMtYXKZgTb1eTb/GG+nTR8ttXxDdJFR4QFnwdcHol
	GocSVHgAiqhO2tsZmaxi4QBvti5rsyR7w3ufYKuj6iB4Tiga17eFc4HmTRxTOyjit+Ct4SVhSZ1
	cNVPSvOOXJi8Azvej0dAipmcP/IeZdOAQjxxJDLS38Pc9sJ3MEth8BIy1xPpCiBRofCIlrXjAEV
	XhKiGG+VHe+RM1/tw8/5FrGdXy4dEr2zINMBoUaQ0NbjZ6gg//JVBdikd9vgG2EHcY7fsaUT23k
	jSMdqojGSPTDn5kUMu1GWX0J6tMGOjSE/oy9bhJNYa0z3gfwpZoQT0cEYtLC6GkVnpvowVMeMdp
	ByJI7s/+S3Bs+seqzSQ+SlkxHPwiNZcYcTMq3rQ==
X-Received: by 2002:a05:600c:800f:b0:499:a5fc:207e with SMTP id
 5b1f17b1804b1-499d64e89a1mr29445385e9.8.1787617441435; Mon, 24 Aug 2026
 17:24:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <20260824213127.2783019-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260824213127.2783019-1-joshua.hahnjy@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 17:23:49 -0700
X-Gm-Features: AcwNN1VvhoQUdKysuMaaEXxvbCegYlGP-f6bdSnaoNT-mW2XzDOEHtfE4jJBGi4
Message-ID: <CAJnrk1Y-ZaT_3QGZBc_RRKM-rJdEsaaQp20e39Omwh5nv_Lqag@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 2:31=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Thu, 20 Aug 2026 15:18:39 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > On Tue, Aug 18, 2026 at 11:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> w=
rote:
> > > >
> > > >
> > > >
> > > > =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes t=
he
> > > > >> cgroup rstat hierarchy synchronously with force=3Dtrue, which sk=
ips
> > > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap stor=
m
> > > > >> with zswap.max configured, a container takes the global rstat lo=
ck
> > > > >> on every swapped-out folio.
> > > > >
> > > > > Any reason you are limiting zswap through zswap.max?
> > > > >
> > > >
> > > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > > can soak the pool and crowd out the others.  zswap.max is the only
> > > > per-cgroup control over that share; memory.max bounds the total
> > > > footprint, not the share of the pool.
> > > >
> > > > >>
> > > > >> zswap_shrinker_count() had the same pattern and switched to
> > > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count(=
)"),
> > > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > > >> kernel cycles under osq_lock on a 96-core machine.
> > > > >>
> > > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > > >> before the patch and 198,968 times after, while
> > > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > > >> attempt count almost exactly; the remainder comes from other sta=
ts
> > > > >> readers in the swap path.
> > > > >
> > > > > This is a known issue. Using ratelimited interface also comes wit=
h a drawback
> > > > > that the kernel may react on stale information and the consequenc=
es might be
> > > > > unneeded oom-kills.
> > > > >
> > > > > There was orthogonal discussion on moving zswap limit enforcement=
 away from
> > > > > rstat. Yosry, any updates on that?
> > >
> > > I am not actively looking into that, but Joanne was looking into
> > > AFAICT. I will respond to the thread there and CC Song as well.
> > >
> >
> > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > (switchable behind a runtime knob [1]):
> > a) rstat + forced flush       (baseline aka what the tree does today)
> > b) rstat + ratelimited         (Song's proposal)
> > c) hierarchical per-CPU   (Yosry's idea from [2])
> > d) page counters              (following what all the other memcg limit=
s do)
>
> Hi Joanne,

Hi Joshua!

>
> I hope you are doing well! Thank you for running all these experiments.
> I'm not biased in any direction but I was curious what you did for the
> page counter implementation. The reason I am asking is because I am

Thanks for bringing my attention to your page counter stock series.
The implementation of page counters I used for my benchmarking [1] was
unstocked, where it incurs an atomic cost per charge / uncharge
instead of doing any sort of batching/caching.

> working on making page counters more scalable / performant by pushing
> the memcg stock down to the page counter level [3]. I wonder if the
> caching that stock provides can give (d) an upper hand over (c).
>

I think caching the stock would definitely help the update cost of (d)
as you point out, but unfortunately for this zswap case, the nr_cpus *
# descendants * 64 max over-reporting the caching would introduce to
the zswap stat could lead to overly conservative rejections of stores
that should have been allowed and/or OOM killings for cgroups where
zswap writeback is disabled. Thanks for bringing this idea up though -
I had a similar idea to this with batching the per-cpu counter [2],
until Johannes graciously directed me to commit 2d146aa3aa842 (mm:
memcontrol: switch to rstat), which had switched from per-cpu batching
to rstat precisely because the nr_cpus * # descendants * # batch pages
error bound was getting problematic.

Thanks,
Joanne

[1] https://github.com/joannekoong/linux/commit/9092e0057f038ffca43ae3f35fa=
f58c33b1d7c9b
[2] https://lore.kernel.org/linux-fsdevel/anpsLy_pCanocgS1@google.com/T/#m5=
ed6ff8e64eeb909ff3c92bde5105406b1ddaf10
