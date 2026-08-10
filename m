Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32A2D2487
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786371130; cv=pass; b=n6W5VNYIWVb52ZjtvjsjX1OlSuWNQRwGa1yKIQfOFdIiJgXaiBZ4+U4a8tPTAobLtrCmu3H5tZDDfuC01VD2Ua2hjPAEuVgF6l3SeNVgKazZa7PfXqyYt/V3RzL+ym9oU+/rniOctVlc6ysSH3508ShsmPfXub6P4hhmbqhSHv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786371130; c=relaxed/simple;
	bh=buETODvHchsbz9QCOGYwQZtIf1tlc9xFyXSpm4aNJos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zm7x3fI/Eb97l1FwIMN4GYOcCbQxrIICzEYwIiCl2Gal4D3rNeonRpX9exz9tTz47OGw9L5RahEJ1Zku0GvDGxf9fUJz+ERTd9FTmKp8H3vGwGMYwO9JX2/EyQVq4IpCHTgpu0K8/iNZd2EGhmtp5Yz0vH26PRas+cho4imQuHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h478xdt+; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h478xdt+"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49967f24eedso2658565e9.0
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 07:12:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786371127; cv=none;
        d=google.com; s=arc-20260327;
        b=n0NlB3r6a67W0AR/oYtE1Mxwo77x0iOkg5EdhkLu/vEWrGfJFOfP4QPINMwsxO5Gtx
         ksQsmViMKisD34osEOtiOvF6Jkf3PeX8bY+KTgtQoAPyeji0SFNaSC08IYgw9FRJCIFF
         mL3Cd1lyrvpxdyts4Sb/bQGH370EcLfduKXyWpKaCueuCDMb2lWH+Vc70tSRB94FU/0V
         rnzOZF8elwNMnYvzFO7yQoCabUj+nkjHaLiuLDs5cFmQGsVxEugCtTmBtYGUmuCmASBQ
         I/xrsS3lyhbe1G+ahgUF+sVXgcNRUtGI64gqlMv0VT3FiThS3a5l1hwm5dz8ESqCt00k
         IzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
        fh=xz2jBJjZHW8v2MObxXiBuVoTHQ6XN8zA2bqITCAMR80=;
        b=G8jvY+Dvy+Pq89ZM9VfwukxzRhjaZgdbFNZnOdZP046ij3nMyO7SQCjGBl7mI6QeY4
         K2sbkX3qUW1GEmoHrXpT8r840RNOFnkgOHxwW6HG9UsM22HSwlMVjqRq6SFUw543kVj2
         z9ueMUuQ2zUNrCgrkyvMtZMHoEqKiPIJlxQloSsn7H+xyjMsLr4N7mQRBMoudH0j80QC
         T/ifxBp/OZqjt3ZYY3kj16DFgbTAMDwI2hs2gQGYv8vEDq0gXMQSnOBMrxbfzLReUZ2g
         7dzH+D5gWvLYCtv7NLqN8lxK+bc6RxXLKZc7ijjAM30+4M+t69UELaqSTRaL8gO+/3Jj
         rZMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786371127; x=1786975927; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
        b=h478xdt+8rU0chKMfY34awgG0U26366ytHeFUpYkjSqGeequZOLVirJhLOIq8c+oIS
         TFenLlOn+qo792CMLyTAg0CNiLHZgmKaiKzvCx41ahMmsS+SnXhUzFn7sN4B8eL4GAq/
         GuHCjEMLYnhILd7xaT5RwSXI5ODl/I7PnaCt28tnMEV6A+450bTsu+AF2KRjx88pC3AD
         9scgT3HL3DKc5bT2RBT4HofnO49iLsMa1Vnw56IoDycFzshUcFZFi1sJSRJHUxsuLLCJ
         TZPKeXvX/lQkR0rDet+haTvqArgw6zcoLN9be/C+s0LU2P+aJ/mVcvTDqhy++pH4arXH
         mOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371127; x=1786975927;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4T+gwRZDRIShJR4gZnLC0NVnW6k5s6US28LrwcXeY4=;
        b=A/1zsOk19M7LvD59ScMcJKmg6ITTGjhBr86Je5Sm7qy78zZ36HXgfSyaHwJoiwkO95
         MydZLNCYkepxlEOeLqfWcn/AtGfMs7kXP4radVV/BWoV6YzSTMRE7SsxMX7ZcZ30FCL2
         HFMX5vGMffQFaD9i8uGTta9KKXBTSTKBPEiZ0V6PyeUCKiDRubnhD7K6eetPlmx6gSoV
         G0K53jXZ40rPoBQ9XMpVEXnJYSbChJW2eU0n4caK6PRLDRkvPfOvxB411JnMoWgW6+eT
         FOPbgea+t0x0c5y8vrL5vZxaNUg5Oc+1Cwi4E3LcpJOpaq9PBfFEy3dCLrYZGWQGrYnP
         xPYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rox/z+lDXUqqOz5zeePAZZQztbt8lNsZFUJMY7BCMHe+68ECkI/CULqBYqZmlr1PQpLivc81pzG@vger.kernel.org
X-Gm-Message-State: AOJu0YwA2Fs9BY/O1JhBzA4e1vSfBecpOF6FGpOdlb+CPAArw5RDNoJQ
	ywfDVLQjEFZq9k5eldfcslbp3uPkz2p//r61DXAixhGu5s1Ka0gOzqZsdIASgrSa1gcmzPFhDHY
	YlrJQcugdL3HR7/WDMRsav0Dk5gNyHWM=
X-Gm-Gg: AR+sD10ioxeDKUhhPgM1In5eYCtIgep5xAg4LbocZ0SL7I2/lRP8oSD4vwwMYhElCzf
	J9xnYP2UoJBh2HGoB19deajIOsH5rQO91CWoNcqXBR2yK8g9X17s6oZpNqjX5bQYFR8/ZqnbQrQ
	9ceLFlEVd2Zd8dD+XlUreRiSJmB4XxwHDIAFltIIxxqt26uauLVqnNEGNNaQcFZWOue3uAg5p9+
	ngsVSjFU9zPPYGjWBT+BRgrzLK5SMAlfnGEOfevCEw0gau8g1eGIi9hs0VpULLTvO0RNOLYJcZH
	SlWaAVnocD7aswCGrfB44GfUdGljXqT0O85N+W9+FO/QOlTOLBlGMqRO9qBm2DktmaRBkEE/pmH
	7Obb193VTrDfdo/jA9EdqZZYdFpooaA==
X-Received: by 2002:a05:600c:1387:b0:495:3eb4:3c6d with SMTP id
 5b1f17b1804b1-4994e7b810bmr274599375e9.2.1786371126190; Mon, 10 Aug 2026
 07:12:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com> <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 10 Aug 2026 22:11:54 +0800
X-Gm-Features: AUfX_myzk3L8tu8iuyY3KCv2aKO9j3yll3zHn2I8kTwXhIPWsgZ1D2l0l_IZSoo
Message-ID: <CA+qSx6w_EY23GzgfaypXz5pd=h9JoBjiyX5+4Po487QYb4R=aQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 7:12=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Thu, Jul 30, 2026 at 8:23=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmai=
l.com> wrote:
> >
> > folio_alloc_swap() reports most allocation failures with a generic
> > negative error code. Reclaim cannot tell whether splitting a large foli=
o
> > could make progress or whether there is no backing space at all.
> >
> > Keep the global free swap count and the remaining hierarchical memcg sw=
ap
> > margin as separate inputs. The memcg charge path reports only its own
> > margin; folio_alloc_swap() combines the two layers when classifying an
> > allocation failure.
> >
> > Return -E2BIG for large folios when a smaller allocation might still fi=
t,
> > -ENOSPC when no global swap space is available, and -ENOMEM when the
> > failure is not helped by splitting.
> >
> > For early large-folio rejections, check global and memcg swap availabil=
ity
> > instead of returning -E2BIG unconditionally. On a memcg charge failure,
> > swap slot allocation has already succeeded, so use the remaining memcg
> > margin to decide whether a smaller charge might fit.
> >
> > This only refines folio_alloc_swap() return codes. The reclaim callers =
are
> > updated separately.
> >
> [...]
> > +
> > +failed:
> > +       if (get_nr_swap_pages() <=3D 0)
> > +               return -ENOSPC;
>
> I wonder if we can do this earlier when swap is full or disabled.
> We could exit immediately and avoid trying many redundant paths.
> Have you tried this?
>

Hi Barry,

Regarding moving the check earlier, I currently have two concerns:
1. It would add an extra get_nr_swap_pages() atomic read to every
    successful allocation path.
2. If the failure-time check is removed, the earlier snapshot could
    become stale while the allocation is attempted. The failure path
    could then return -E2BIG even if global swap has since been exhausted.

Thanks,
Xueyuan

> > +       if (swap_margin <=3D 0)
> > +               return -ENOMEM;
> > +
> > +       return order ? -E2BIG : -ENOMEM;
>
> Best Regards
> Barry
