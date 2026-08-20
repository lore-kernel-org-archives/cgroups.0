Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439B3380FF6
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 23:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787269173; cv=pass; b=YM2qWwKUcC4W4VIyNschf6UGcaGdf2qieDd61jLo9Oj8w1x2kkRnH/DzXt+V06ZKKk1QJnM3pBZOP4tWk3QGGq/P2wdhZrVE02CGG+XhAv+XhVwNezSy4lG1SXkYdv4fDeSKgrLXHFL/sMCT61HVhuR2DN1GW/Y2dmpIZTjpmhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787269173; c=relaxed/simple;
	bh=uakSqtDmfHirt56Ih9c2dlFS7k35p9i6DyOchGy5ecg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a76HnTPQfL2kVugmHiaWncQlKeu5dvjCBPGns3yI+yxTApiBUgSCj9+QsmkdTUqDkU1H3Xnc3FFoO+xlpLGS+xm54Hk2At18Po/EYHdZvkbOePdX+v4qg+XsRjTWzNTR1YN/dVc48UX6YfbAe8KzeolTt/FebKqRsKqZ3CXkdOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+eJHeHQ; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+eJHeHQ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4996f1ee4a4so2889295e9.2
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 16:39:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787269170; cv=none;
        d=google.com; s=arc-20260327;
        b=RGcQI0QOr5Hdd47tvuguqMu0yfzLOmVqf3/ALtk0nEmqwmN3od8OZfL5xFJ01Osm78
         6sijw+TpmwUnSWWtM96LQ89a8C+vU45Yts8Mvm2KJsUHGqfGDV7/rmzCjhKKmHX6q1/3
         WF3v9J8zLQ2vaYmgqWJ6UCH0fBjs/q4lK40dWCjeb4GWFmbPQ5dxy/+Dxwpb/XowgGTd
         MbnUh57Km76lXzvWYbgKJDh71qh97E2aB5i6bPFMEqEdgECuL2Z96uZPBlHDAFSB5/P7
         PEY/OUASW827RYJcHJ+EprqEeWSZ+NJSo6WfidR3QxDElD330b4Dnwakzyqa+4+9xI4p
         JKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
        fh=0L7WYGlsbrmWAi3Sf8E2VSkyxKQIktR63wN+bl/F3eA=;
        b=ImX2H6QoYDUNU6IsbWDmgUfHzaToh0or6lrho2Kxpt7mhq2uGoM8Kdc2d11lRWCSBu
         /poFKbAGWnx1zW/pmU/DGFR9o8jZ3eFY+Qwbvi2+ZjoGiChczhHLECrGFKQgnFTLNTgp
         02IFfDZFW4WpJ7XolRw+04scFN+OVuE8YOhXMLDiBw9kCGfxToE64/7EPQ03MjdqaDjv
         fIXtMGPLRF8xvx337KGQS+tpScvMlkY59zLMEIdC/ERW4j2kgXJ63NAXt5R2BI8cjdCB
         b9fQa2n7kf3H+Pj8BDu2VYPS03l1/dK3u/08N5FUvL6d8DBVVc3jqVx1CjC9QbA2fzfw
         QJCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787269170; x=1787873970; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
        b=K+eJHeHQU99iLKRGTN0zGvU89hQbR5fMukf7LfPYLI6MgeGXRqkgKovCXx83n1H4qp
         l9ZUshx9CZ0tniQKrYTGdaOfHuXdaqmcm8ryDpfEZl48P7qTMcE7mVGvMRVJNfwSz7gI
         TWjTzCQI5fZ1r9TULeSSP6gHG8JAz15iuTmlnXEtVEcyfIq1MDLsen1I0/RxpYg/t6uP
         BlcOSlhQDeYmBYJFSzoWunJPBSrYIgw8UmoRs7Y3zCILdD3NJfzxLADZhz4YaMjnu0wW
         H8coLAMpb0uI78x/jtl2oD5AI/uqAh9TS8mqz+3ImPeF/pIUSs7WebIKpFICjRZhtHJn
         3+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787269170; x=1787873970;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
        b=nqHQ9IQN+O6cFcS2GK79P5Jt9K+JHUUaNuU1hFC4Vn4AvsJy2G2N7YOdG/zCpTcVQl
         na7IT5RcjqPwYWFg4sfiWAD43GV5K2WA5mjNSXDYZVfdgMBzoUmrhRVvRoI/Dco0U3E3
         6UbpVo4N4/bHjPRrutSmB7E2bW0ZDInPxfdTqyxxmMDM3imC17l4/Yd50wJsGARlRME9
         tEyTh3OTbMKzAoabNP1WqESIfOsx5KfKfU0jiI3N1VTiBNk3nleZSCHAVeFYdDfAbmY8
         bbPVi3GtupHCl7av1nbxJP2yERblt2BYXegJ0I9NFqMzBseemTgKtezzQv0XKcYrfUk5
         Aj+w==
X-Forwarded-Encrypted: i=1; AHgh+RpCr4OWy7hU+gfYZQ8c+uB0tQ3eteabFdVQBojekQGXdqzi5vRoJoirBpnAPy7RltSbzk/waFyR@vger.kernel.org
X-Gm-Message-State: AOJu0YynGVbQSO/jDuEjMF4zSTbI+rGy+XhVW1cTwHAX/0fHCDanvU7G
	O/oxcPAyXsvY1eQxrd8pNo/2b9T1cc+6rkinWqx/HNX+Hm5h0wVp8Jtb2ORtbj9Cs19zl18KhxI
	wWj+bypMcr9Y2fcq3z266O6uM92ol9+4=
X-Gm-Gg: AR+sD13j8aV5t1bBR9Cm2S3KFU4cJIZ474qOX4b7f6nc1tP5JZNIjSMEu1uDFwyuiR7
	ODxhNj/7MobeOQygY6FOHUuvwUVOxnScDPaesHpEn8AKHH3Qd5tdXjLK+w6mCpL5YxzC+akzi9B
	j9JtSIhM3CQep9YXPCJXN8N+5amnQPD1Oj7DiKQefIkKy4/GpBFNf2uFh7+81jbDtse1ndBq4Oc
	ffaERz+DRQnyq5RXFbmIJZNz+W4/KsprxoBj+LlNrTNCXYpO6LDjk5yZZpYXxr0dgPEWe08E/hN
	g1C2y6EUfc6elu1xH2wg3EAvFJF04LTeaV2BiB74x41rLy94XaggF+mjyoP4s/VtrcliqVDNiU+
	bWft+C/KpICoiZIIiUtb85wut
X-Received: by 2002:a05:600c:3588:b0:496:c18c:f9a3 with SMTP id
 5b1f17b1804b1-499b83184eamr33065975e9.5.1787269170200; Thu, 20 Aug 2026
 16:39:30 -0700 (PDT)
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
In-Reply-To: <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 20 Aug 2026 16:39:17 -0700
X-Gm-Features: AcwNN1W2WwOZ6oRwPRAG9dZBaGHXMlGuhp9w5dO0dP8YLHD19Z4QrM5cxrAENkE
Message-ID: <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:40=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Wed, Aug 12, 2026 at 1:59=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > d) vmscan (prepare_scan_control()): for determining whether reclaim
> > can deactivate, there's this logic
> >
> >                 /*
> >                  * When refaults are being observed, it means a new
> >                  * workingset is being established. Deactivate to get
> >                  * rid of any stale active pages quickly.
> >                  */
> >                 refaults =3D lruvec_page_state(target_lruvec,
> >                                 WORKINGSET_ACTIVATE_ANON);
> >                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_AN=
ON] ||
> >                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANO=
N))
> >                         sc->may_deactivate |=3D DEACTIVATE_ANON;
> >                 else
> >                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
> >
> > (and same for DEACTIVATE_FILE for file-backed folios)
> >
> > target_lruvec->refaults[] gets set at the end of the reclaim pass. It
> > stores the same lruvec_page_state() value that prepare_scan_control()
> > will read at the start of the next reclaim pass, which means if
> > reclaim passes happen more frequently than the 2s flushes (eg under
> > sustained/heavy memory pressure), this logic will incorrectly assume
> > no refaults occurred and deactivation is disabled, which afaict means
> > folios won't be moved from the active -> inactive list, and reclaim
> > will start evicting pages from the inactive list that are hot (eg more
> > refaults).
> >
> > This is from reading the code rather than a reproducer though, so I
> > don't know how much this matters in practice. Unlike for the writeback
> > case, I don't think flushign more frequently solves the problem. It
> > would shrink the staleness window but not eliminate it. Maybe one
> > solution is to keep the deactivation state for a period of time if
> > refaults were observed.
>
> We do have an internal test that runs a VM under memory pressure and
> we started observing OOM kills after the ratelimited flush was added
> in vmscan, so I think it's more problematic than just reclaiming hot
> memory, but I didn't look too closely.
>

Would you be able to share the test you're using? I've been trying to
repro it locally without much luck.

Thanks,
Joanne
