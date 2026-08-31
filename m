Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609F12E7F39
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 08:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165941; cv=pass; b=aZ9HWkBH+X8IuEjt695trS/RUejuM5+yIQlyYggSAdpUB5GzqG94PC8aNeEodcU8gJ//6hpmETCQJj8/1QNgOvxl/3JBMwzGdqhY4WLmp+YSENXOSXMAQXVaGGrLgv802+vi7Z0ngXcKCOjf+q9u5rARNnToJm16S/vJt52U4WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165941; c=relaxed/simple;
	bh=VjLyCE3ULm1W9z56D4wq6X0rbN/EyoCSd9TZqyvP8TE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PnS0/BhLCzRd5bWmRspWH/JeVTCO/LKyhts1tLbRDk0ULYXyw3ks8TiW9QTcgEtFBoSx2XyY4RIbrDOI1MQ05TA8FWkdJZDK/1ToB5kwJhVN7/SpDKHAevSfx80rSCU6Z6gTbIPva74z28Amd228MIjmX0O7VOD9ESlZ0sAEg4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qz7fQzIR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F2Pt5yZB; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qz7fQzIR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2Pt5yZB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788165939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vg1jasgozEJAkrVTwgSp5gxj0PTi1l2mqJv39TXaqQc=;
	b=Qz7fQzIRnc7W9sjW8/AAFlbLIwov4ogHVSW03Jx7BVhonqLDbWkKeP62hQCtJBjWB0pitB
	XI8+CfGUAzM0zGoXaljFRRSJWZQCxrLFF/0cPI96rKlQ3gudGZPqa5LGBCLxAEG/KvHPtF
	2JdyuEgcVmUWSqPA+QD5oB4ib05kvzQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-zhqT5Hw0MXihco_d5lI83A-1; Mon, 31 Aug 2026 04:45:34 -0400
X-MC-Unique: zhqT5Hw0MXihco_d5lI83A-1
X-Mimecast-MFC-AGG-ID: zhqT5Hw0MXihco_d5lI83A_1788165934
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-836c8fc09cfso50243667b3.1
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 01:45:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788165934; cv=none;
        d=google.com; s=arc-20260327;
        b=XqA20MWHYPmGqWGoYEF0eyKs0J1faDWX523fj71nA/ZoqK1iE0c/qkVJ/3frJQhPKz
         3M/vET6XV/zIjnbUvErceEYEsBdJhKK43nCjamUChGF9zD6H16J+CPebm4MzxYNMj3pU
         3QKwtqufXrbHN//2y4URG4dHyiovnyztmlj8efUiNvfjEMZeZx4+W1THsbUAgw3A8+NT
         XSEu4e9A/wK/AG2iNPtm529oWPYsflBnEeFNZzJn+VKeZtOdMCPYciFlB/0tbbTRrq+K
         hlaBuUuucXJv+YE4WVBZ0mc17oSDrMW6hPkEPLJKAwkC1+XUkqKYp2esyzvpSNdw0PJo
         sKmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vg1jasgozEJAkrVTwgSp5gxj0PTi1l2mqJv39TXaqQc=;
        fh=exT5RKZJ/Cxd1Wi23g68bEAZKp1RYsKPkXwxkXI0zPo=;
        b=XmmTmDEuMm1lJTVJugptNQQ4tlKV/Dblq2CyhApNK+EGmdlEI6WlXpTLpfytPG2gia
         c1lIu6xy+t7P8sXO3uIl2vxO1N5uv2FqIcJPzLtlIHPSf68gqQXL3Rn2Y8w8Ada3O0On
         iN9PGq3Z15Pu69xNZJfZ3Q5XIzfaKeHYYjEXiWp19TFzAloNEiso2L6U0lpACb2ihx3s
         qfaeNu7xJsPjI/Swg1VfM0gAOHcX5RblOCosgAtYNmWBJkSFLg5lyrRKrGMzHyfRz2k/
         TbreSSNOi4+gPwpf6sLETOHcUmLT79CaZyp85FEr+lsYybtHgnNoLcqeSix3XqIeJFn4
         WeBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788165934; x=1788770734; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vg1jasgozEJAkrVTwgSp5gxj0PTi1l2mqJv39TXaqQc=;
        b=F2Pt5yZBQ/IoUPjVPeuFlkIff/F1KhVvJo19zlPvTTV+FA4WNvcszJi4u3APb6alwf
         duqsRsIOwzgwwcLa3BcUfUQ7fjt3NbcH9yCnxW1WYyAPcCkrAaFH9H6K6OXaLnj6mwX7
         NyZYpYS8s1Na08gnpB33WeEFMYsO1JKlTYTbsh2FDZkXcgB/05xDzFkYe4bXPlzkcLQR
         OvJ8QE2xQGiByW4mrIraucsnu3GG08TDC+IYNtDrFm9BgvYvOrPc/d/HVi2TeA9zW+j9
         Batf3c3GDV86uL2IB4a45alOx9fcpUcE9h2J4IRiuzSCiBzIg6Eh2s6WKbCmuz8+smgA
         Yahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788165934; x=1788770734;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vg1jasgozEJAkrVTwgSp5gxj0PTi1l2mqJv39TXaqQc=;
        b=JLyr2rWg419F+r+nw+uBwIoFiLxfaYICT2uJ+X3VXZfIQpDkzXwJaHPJKHKtguHc+A
         qBR9AJBgeTKMfgzoRtAscqKxBk4mOUgy1WQYcE9Ycl6CHYGZGuMk7dsCkC8ZHB3haRLq
         xeLo/aHGWKgVKKSQwqfrXPRdtWcGI9NpNKrExjAO1K/tgQxw42aWpf5OmZ7zmI+twty0
         mSr59ti9abTe0T8zEjZ1/7pQfvs6dGEb3CEh69YfSGqRnTOzaRC7UnEx5Gm10xTdUg6Y
         5//Cj0UK11RrpZJdSbEkhEtwKKnPNRC+M4DlHTRMl0vCRuMb3HzUGl+gw6VL/0iqqsHs
         7QLg==
X-Forwarded-Encrypted: i=1; AKwUvBz5xtocwZIzfINHXiAZ050aGTHj2srzcFIezjHn/Y85K2zFEtjBNlLELFWE0kXnnW7XAySSYcgn@vger.kernel.org
X-Gm-Message-State: AFuF++llT+cfb/9faraGIV6vaBv4vMstrUSY+XIgZaDmWU/UOjxVdoBK
	p2LgowflYD7enzKM/LdEmYpfNGvhLqUx7AEcMvwV5vNVPBm5pZjaYH6Uue7Bo9gMq3AxFEZ17+L
	fAYJoyrwfNhy2PKdBz3LLUZTD+/AAcpx9LqVrm8ZSAfiC3p3oE3LO3Btp50qQnOvtMGtnOy/z+O
	aQVc5ltW+LnGmfcmtqkdABrbI68sxXwDFf+A==
X-Gm-Gg: AYBFou2nT4A88hR/7vYk2DlXakE89VtKM7PB9//LTu+Cq33yYAb0i3n4reTc/0DD1ic
	KqbqYQIaNmK0Yu7blI1KdWVwsRKQZ+nowkrnPyiFvtxBZFfyi9y//j10A041MjNLUEgOjjO9A2F
	1jIqaqQAHMI+IxTWLLQzxT9blrNU9Dzfxk7UFJGVvyRz8EQpsvqVx4QSc=
X-Received: by 2002:a05:690c:e3c1:b0:845:cc1a:af6e with SMTP id 00721157ae682-85d6c4f9797mr89839047b3.30.1788165934293;
        Mon, 31 Aug 2026 01:45:34 -0700 (PDT)
X-Received: by 2002:a05:690c:e3c1:b0:845:cc1a:af6e with SMTP id
 00721157ae682-85d6c4f9797mr89838877b3.30.1788165933810; Mon, 31 Aug 2026
 01:45:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706-kunit_cgroups-v5-0-6c42c8753468@redhat.com> <aoyLV5ovAaY15G-h@localhost.localdomain>
In-Reply-To: <aoyLV5ovAaY15G-h@localhost.localdomain>
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 31 Aug 2026 10:45:21 +0200
X-Gm-Features: AcwNN1URWgK4fv0lv7-8mBvsb3EpLpT39bC_2lvLWDVD0tpVvUbMExgZhTXTnyc
Message-ID: <CADSE00+5PWATGzHokJMEoY9fuYRYrf=H9NA1zfXXoaZA2NvPzA@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] cgroup: dmem: add selftest helper, coverage, and
 VM runner
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Eric Chanudet <echanude@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 8:27=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hello Albert.
>
> On Mon, Jul 06, 2026 at 02:06:39PM +0200, Albert Esteve <aesteve@redhat.c=
om> wrote:
> > Hi all,
> >
> > This small series adds practical test coverage for the dmem
> > cgroup controller.
> >
> > The motivation came from following the recent dmem API discussion in
> > thread [1]. That discussion considered changing the dmem API and
> > adding a new knob. Currently there are no dedicated tests covering
> > dmem behaviour, which makes such changes riskier.
> >
> > Adding selftests has an additional challenge: dmem charging paths
> > are driver-driven today, so regression testing is harder unless a
> > suitable driver is present in the test environment.
> >
> > This series addresses that by adding:
> > - a kernel-side selftest helper module to trigger charge/uncharge
> >   from userspace in a controlled way,
> > - cgroup selftests covering dmem accounting and protection semantics
> >   (including dmem.max enforcement and byte-granularity checks),
> > - a virtme-based VM runner for repeatable execution of the dmem tests.
> >
> > The goal is to make dmem behavior easier to validate when evolving the =
API
> > and implementation, while keeping tests deterministic and driver-indepe=
ndent.
>
> Thanks for the dmem selftesting. I'll respond to first two patches
> individually. I find the wrapper scripts in the last two a bit of an
> overkill for the selftest (as it adds dependency on particular VM
> environment, I'd keep the simplicity of selftests such that wherever
> they are executed (w/out wrappers), there they run (be it a physical
> machine or a VM). At most, I'd consider a simple wrapper that'd load
> ensure the test module is loaded.

Thanks for the review!

The last two patches were meant to follow the existing virtme-ng
vmtest.sh pattern used by other selftests, mainly as a convenient
developer loop. Anyway, I can see how it might be overkill, especially
in this initial version. I'll drop them for now and keep the first two
patches.

If a tiny wrapper that only ensures dmem_selftest is loaded turns out
to be useful, that can be added later.

BR,
Albert.

>
> Thanks,
> Michal

