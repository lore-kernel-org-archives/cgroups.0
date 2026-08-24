Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368F393DF1
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787614985; cv=pass; b=hyzLbJiM+hvtIXF2+JDJTk2rvnwDARY9fmjD5x5V4XDrKatrxAwkV8bcpGvN3jfIqWePf1b+gZ4NgD+v+NXpCRHOU+szW+Qj/lMC0Id236gW1TJWJyUmCxRNnmjGiA1Qr9NbHqfe8HfjXOArQ6ukxaFkFCAKV1TF9K7PLMkhCFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787614985; c=relaxed/simple;
	bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLySR+CVMTAIARoFTTAdO/X3iF8l6k2GR7npBZVs9Ug1Gv4Bu+akxklvHVxBAkyprCbc0bnEAJF2lVkrdCSTpgK77e8PuQBIRLcMA9RV+GB++a6lsI/D+D42/6D2eeCy64hrnjtco+Buk/WHpZqEiqbUZgimFw3HPcsyZUuSXyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2uelV63; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2uelV63"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-499b6c02b02so19237255e9.1
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 16:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787614982; cv=none;
        d=google.com; s=arc-20260327;
        b=fgSarhrOmT8epYH3VJAoNgaYrDnjK3srsA12Y6nPQsgYLR0vw4sSKgV/hJ/nGVG7Vx
         tWfrc916e3S1uvVOosl1qq8NFTsxik/tvgE38PW05SsMCKenkxlWPA9btAZzuWITqEGJ
         FM2bgLuYyrO6zT1a874NHr7nRR2FmOmFIsvdiDU8LPb5DyyI7A0HF6dpqf2yu0lv2cgc
         TaWr9wJjLZX8t3EY1VYllWAkBZldoc5RmZPKqW5E46DS6WXa/Tzfbrx83i4kKhAh1do9
         AdgVr2CB/5oxsJZreTQzG6Ah5uLb7dVGGoYjokPaC0V9jy4oQcUL1RDHB3jzr7Zkaox0
         X1SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
        fh=m0gEy2WvU8WjTojkCrAHwb0O4mk5IZvQ8/rJHKfQRsg=;
        b=EBqz4zATyKau/kmHICPwnl9MUuko/08BEu0QSJW+GWTH41m9+qNQYCPA0UuiSGunZM
         BHPxbKPYWgNmHtWdSHCyhrdhBEfOZL/rNbAoSOGq/9HirG3ZAXLthYm5zYSkD0mhIGZd
         KrmGzwyQx8TtcfhkA5E02yoXRQ9u8lntt/Ma5flnOUJnx7FIyPb4u5XuGZOTSkgXcZi9
         +bjmCBS4Bw1evGAF5vjuCsxXf7Jjl9m+FgnNtGy/R7j4BsgspTvJVGoa+2xMCB5DadvI
         kX1IUpfmV466wa1+faD5/efFZD9NPO6/d+fxhAQwsoGSgyujoGtHQzBfk2MlaE9hzH/z
         rZvg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787614982; x=1788219782; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
        b=h2uelV63RA1KI/d610zMVtXkoVzjoNExOXZEOOETin1s6ccJnSsLuNwP63Qz5Mey44
         frM2+JDVCqfWZPAEeK+BRffhVIFOTEbVHVeWySFX2wDYZ+cQMevQv4rsBSUNTn7UaqRe
         zrueLROytLujeezVwR5d+mA25uxdHvCeTdIHZup1P9e7fLz7RZf2ySve3cyzLwDX9mvr
         r8I2zPOBAF+drq1WnFcbNsNyhNgYXum5MWjcnjXp9hxNIyiCEySL+xKd1mlW6RW9xwP+
         ij+K3BRd9zUslegs/+tCSIAIkDiaaxEwmFB72AXI6jJdxh5cjqdUZJEiRZwc3QQVGuqW
         ZIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787614982; x=1788219782;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sHnXZHT8WiiUeAdh+tKiJaengtnfesqTEZdJsUGA+8I=;
        b=ntjDBWqSPmVOO3xmUkiw2H9T1hFA29xCQN4FIzr//fHN0UfrpaMz/wTAZRy2A56nWc
         My+mQjy4FsjDOfM16Bo6DdTqXAbmnyXhvJiaffFYpwe4ZfMlqDwpQhkxYnHjIq780z8m
         NoYMEGWUYNu+EN+nEl6B54MLDsbtuNYideDlld9v066pPbkeAg8+cffVwrUrZmXXRvou
         dvVXUXPeKH2FnjBReKhLbN0iH/SnSJsCyBBj/vOJQGf0xYFs3n0SMTkeEcf6PQzR/utC
         YML6yVVQz1RNjdTxUiEHapHE/Bc58vnRVC0EM5BFGJagiQsZZRgQRO8h9KqQK7ZHms6y
         0MpQ==
X-Forwarded-Encrypted: i=1; AHgh+RqLPmG98RnhzSomlQImT0RXCpp8Zxx+tN4J9UxkC0QeluXlLqIwT3sReyFEczry2AW1skHcghmy@vger.kernel.org
X-Gm-Message-State: AFuF++mQFcSa7txn3V7Kc0Fz/Z7Bko402NphN1BtpHetvapzw3H2sQKI
	IMoDnB+YrhqVfI6cM0RY5bLGs2qU1y9CoZ5XFoijzcH4qtiLbc0wROvM8oxtzr9hpKkWLkiVFBQ
	4bfcRVP2Zq3zpmsiIgFbdLf8bEg7+JTc=
X-Gm-Gg: AR+sD11mkgCd1fiDViH+7hGMhxhIKT/tstS6chZ7A8rQMV99BlfJfMMj4s23PZGx8m7
	0DGcVvfHL41Vj8rijEI0w2DrvfMIGx9IucqBMlvo/9jkexw/mQm5lm//awdvPs/BczGHX3Vyp/r
	iwIL/D8KTMCCfhS2ATTESfl3MRFWsL6XacfeQDKrx6O5X2MXX13MMtybKsIuq7HeKsYFLAo7o6D
	zzkkEZEP25iypQUSfiClG3102kp1Wmfe2AQM+VsC4pa1bVNU4DiIs1z7LnTfEtimGifZVEBR5F/
	8498fevYKkW7ndQkThBYtzvuuhO3SZs03zo+lhkTtGSdTDs6k40gsZs0mtwgBpOGzHElbf437j1
	WqvPGrn0vi7xBo89CPD0Brq4mnXc=
X-Received: by 2002:a05:600c:5294:b0:499:7f38:d77 with SMTP id
 5b1f17b1804b1-499b830f690mr402396315e9.6.1787614981730; Mon, 24 Aug 2026
 16:43:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com> <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
In-Reply-To: <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 16:42:49 -0700
X-Gm-Features: AcwNN1Wa1AOcfS35Y1v_bgY_n2l1WDv-MkAP-PHL7EYAY7Mw9O0j_aJCxbHrZ54
Message-ID: <CAJnrk1ZU1UO35n46acq9My77G8=h3JUCLXchiamBCFbiDZXJzg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: James Houghton <jthoughton@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 6:39=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Aug 21, 2026 at 12:41=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > On Thu, Aug 20, 2026 at 4:39=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > > Would you be able to share the test you're using? I've been trying to
> > > repro it locally without much luck.
> >
> > The exact test uses some internal testing libraries, we're looking
> > into whether we can translate it to a standalone C repro.
> >
> > From a high-level, the test:
> > - Creates a VM with 260 MB (256 MB for testing + 4 MB margin) in a
> > cgroup, backed by shmem THPs. The VM is not a fully fledged VM, just a
> > KVM VM running bare metal code (so 4 MB is enough margin).
> > - Enables zswap in the cgroup.
> > - Tells the VM to write to 256 MB of its memory.
> > - Checks the cgroup shmem usage and that no swap occurred (no limit).
> > - Sets the cgroup limit to half the VM memory.
> > - Checks the cgroup shmem usage and swap again, usage should be ~half
> > and so is swap.
> > - Tells the VM to read the 256 MB of memory again. This should cause a
> > lot of thrashing and reclaim, but no OOM kills as all guest memory is
> > reclaimable.
> >
> > With the ratelimited flushing, the test started flaking 5-10% of the
> > time due to OOM kills.
>
> Hi Joanne, Yosry,
>
> I've attached a reproducer for you (as a patch that should apply to
> Linus's tree).
>
> In tools/testing/selftests/kvm, `make` should build it. Instructions
> for running it (like setting up swap/etc.) are in the comment at the
> top of the file.
>
> As part of the patch, I've also included a sysctl to dynamically tune
> whether or not the memcg stats flush is rate-limited. You should find
> that when it is rate-limited, OOMs occur, and when it is not, OOMs do
> not occur.
>
> This reproducer behaves slightly differently than our internal
> version. This version, when run with `-b 512M` anyway, seems to OOM
> simply by setting memory.max, whereas our internal version would OOM
> upon re-accessing the memory. Not really a meaningful difference, but
> just wanted to point it out.
>
> Please let me know if you have any trouble running this test or if the
> test is wrong in some way.
>

Thank you so much, James! This is very helpful - I will run some
experiments with your repro this week.

Thanks,
Joanne
