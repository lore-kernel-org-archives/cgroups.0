Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07A1244687
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 07:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790319657; cv=pass; b=moOcnz0RAvuiRttFcXgcPo0VQDEWol8qFnwZEZavEEqQSHbROMygf32WhcxJPNTea9b+V8C9+5xqFmiKwLywB+OnfteXUPJlyt6I9VulIoXoqn2rQ7awa/RsAXLhS94zEpe09L20E/E2ZXSOzbYTlmZz+9bJDCDjL3al8Xxhg30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790319657; c=relaxed/simple;
	bh=yW1j8DeY8ApZV6Ko2dzi4EzUT0F1I7IAr6qbeR25e4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HcWQ4viHNphXXMOJO1inpGJmdaEukc4nhexsH8B6g4By7YAvGfLmUCBW5AOqP1vA/jtuEkQcIPH7K5o2IDee5lyTKK/Bc36IMdtsG/FJmhmab9Y6ERjOcLCBYF8kaVGFEOsfL2GtTZC67h+SZUsAa5EtyaqFKYQI2shYh1d87Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjQGvKro; arc=pass smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjQGvKro"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4c6d6660191so370379b6e.2
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 00:00:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790319654; cv=none;
        d=google.com; s=arc-20260327;
        b=MUQnUJjjHf480uBcI9LBu7nldFkgadFrp/Kr3yQjhrGKp02Zq/xe8JY13KGPLtJdw7
         wp85i0Jq2cosrwX1pKNASe5ZtTQOhGyj2iTRfznrAamO9Xjf9H+cFDGE2plW4mQeJ99l
         wkvPcmoHIEnGizYucfdSZjLJCvF4uewlbnL3bXeaZTZkUkw8Uen72uLQIojoC1hgTN2q
         dky6M6Jojqh4e2V3KTvf7ZsgIxxQ08tZ33sxqCED9jCTlpNA1oQqLsskvLIz1Fujhfc5
         HxwY7u+VbgTtOfHggDJSLwygjSVS8Ch++fRBijTJllWPGXCGAGy2TMgBxZHsNZIeaBhn
         vj5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S1fXxaoehIopV1PeW/nrL+gXG87cQGpcsm5CRZuB4kM=;
        fh=CNsZhePPoaYiGyUXy9g8c0mKizMqBoJuw/AulEwD5HE=;
        b=BFlbyDsouvaesjrjrCLYYBAWzHNhfZsKIjaCv/kSfJk3jyRqUxWl2qJRA+dVplxJ0g
         ZRi/UsxNEmkECEKAX6noOLtN1ecPUODapTLqWlJ7h55wG+CifONLT3/Nmh5chbInQ8Vo
         fW5pBU/C7AlfQKVDSDOyQrz1Grj+m26fPhtiK6uJvUwbgK919tnV1oOWJhFWFydq99lD
         xG8DYPmmAc5+YVXZPhr0T5MPoCOpUF2taEguzkqo5J0oCpQFRe9TDdzys7mEsGChZf12
         wFvBjEkl0G+c1buvD2lyrarUwSt1ERHixZNkgIkqLCRWVhOsGafZMcrJCb2uNuJj6Zhg
         Qu2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790319654; x=1790924454; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S1fXxaoehIopV1PeW/nrL+gXG87cQGpcsm5CRZuB4kM=;
        b=DjQGvKroGER4zTPaCXicv/a04cOxxx0hHV/QVmta6kTNX//vJoWdZt1+TRO1bY4jMD
         63OoOlP9Clca1Nm8aTNMlEcB98LFBSLvlO+M54vMlbK0s1HOWMo9nDjI5q9KYbvIW9fF
         dB7J4VAGNI/pxuseLs2aCjZ8erPdsRq8Ehy3VahvZPSt8hIXKk+HnWrDPcE9Aq2+rOcb
         Es6ZftgeiQiO34B97IyT7x+re4YmCC/vmwWwRuOkXP/zuYYmranlsWFkqI9bwa+5crrv
         0z1ZsFkA6l9hg6dQbz11gt5gYCP3tHV7PvuyepdhzG35gH7z6KS1Y0l6oMbYIL7/rhAL
         PqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790319654; x=1790924454;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1fXxaoehIopV1PeW/nrL+gXG87cQGpcsm5CRZuB4kM=;
        b=HpN4aIog3uAbnyeZEi1i5z5jIGjTxyvjS34YQZQDzHst/ejK/Egh8fla+sgkLr8v0A
         PajCMn6fnxlKVGksTzy4KMKjbJhg6qPZrKZbkCdas3pYjzXMsXKzVxHi/JeaWgjCYyYY
         PlS2wPgBjGPr5LUbX+U35HYQJ+9Nd+79cNKlNqVP8xp7Frut8Xyf7iinzfN7x/on5yie
         HpxOaT8FuaVQYGHN5+676GjbjYSXFsy+D9tgExv4NnyFWGyNorOvde8eGONm8g7rBx5p
         L53XcPQGMziu9l2Hdjy0+G+N28BN/r03DLAnVVZ2ETYDt435BMua42l1wTcLB2zkxsV3
         f54A==
X-Forwarded-Encrypted: i=1; AKwUvBzwGvEi6bbtdVpZcySnh5azfzz0IJ+dIlD7bSSoK7AqUvHbbygSd2VnKSpS94g6teC3UkxjAclZ@vger.kernel.org
X-Gm-Message-State: AFuF++lJeS08bLNxZ//2YYNNuEOkx7xvxAsNSHBA1K8yDkE5JMV++WtF
	gjvwYPPJ6kIe1cq2Ks+egfqQSoQAqoxIg4s3qdGVBBJW4+6LExNdZiHfg59fFaoc4C3JAOQ1cQv
	ePf+dSPvMAQ1TntB9y+rVagwBl0VdNP4=
X-Gm-Gg: AYBFou0henemn/Mzpw8pYL5VVWxwB35EhJnJOna89PHc17RLLKN7HIZ0W0KhtVw/f3O
	xX8KEEri3rNUstvZC/GNnpd2VDnwp36N7BLyxoRRr8PofDuOciFPy/c0cZwfu9wtJhP/92/uRF/
	eeMkRlybRj6VsClszDcW1zAdqJ8mn9GEl0gjNbeYt7YqGK+z7NhonNqjNIAxlYWhE2S9vV/xErs
	MZHmoNyj0amoGHsz8xZSa8sEza4P89l4QTMEzyLnE5pYXjHOGAH5msFZrGd7iX+K2m6O2+ulseD
	s9s+ReaVCzXE4tWXDAK1p5IqoIp354EhhxGZjZSx4t/B86dYCGfNQy4RrVgTKxLKFTe2tmm2PZc
	g8sr2YEGLOes5jLP0w9yMTA==
X-Received: by 2002:a05:6808:159b:b0:4b9:a829:f01c with SMTP id
 5614622812f47-4d72e16431dmr5142881b6e.40.1790319654501; Fri, 25 Sep 2026
 00:00:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924053121.17703-1-yupeng0921@gmail.com> <arS-38fE5r638g4Z@slm.duckdns.org>
In-Reply-To: <arS-38fE5r638g4Z@slm.duckdns.org>
From: peng yu <yupeng0921@gmail.com>
Date: Fri, 25 Sep 2026 00:00:43 -0700
X-Gm-Features: AclHuK80rKmiL3-JKRQwzW_6XT8TAtbFUe0xI3YnKDyMTZWe3I0aCFGT4xVZq5g
Message-ID: <CAG3TDc0DZs5+E1tEBCn7uQyWJwZOY-brXBKTx8fBCy3HJqaqiQ@mail.gmail.com>
Subject: Re: [PATCH v4] nvmet: add cgroup_path to charge namespace I/O to a cgroup
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, 
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 11:10=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Sep 23, 2026 at 10:31:21PM -0700, Peng Yu wrote:
> ...
> > +#ifdef CONFIG_BLK_CGROUP
> > +static int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
> > +{
> ...
> > +     cgrp =3D cgroup_get_from_id(ns->cgroup_id);
> > +     if (IS_ERR(cgrp)) {
> > +             pr_err("failed to resolve cgroup id %llu: %ld\n",
> > +                    ns->cgroup_id, PTR_ERR(cgrp));
> > +             return PTR_ERR(cgrp);
> > +     }
> > +
> > +     css =3D cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> > +     if (!css || css->cgroup !=3D cgrp) {
> > +             pr_err("the io controller is not enabled in cgroup %llu\n=
",
> > +                    ns->cgroup_id);
> > +             if (css)
> > +                     css_put(css);
> > +             cgroup_put(cgrp);
> > +             return -EINVAL;
> > +     }
> > +     ns->blkcg_css =3D css;
>
> This is really odd from interface POV. The user specified "associate IOs =
to
> this cgroup" and that can fail if blkcg is not enabled on the cgroup. Eve=
n
> if it succeeds, if blkcg gets disabled and re-enabled on the cgroup, the
> device is still going to be issuing IOs as the old draining blkcg.
>
> What the user can express is the target cgroup and the IOs should follow
> whatever IO control that specified cgroup is under at the time of each IO
> issue. Currently, cgroup_e_css() has to walk up the tree to find the
> effective css for a given subsystem but updating cgroup code to add e_css=
[]
> array on each cgroup to avoid the overhead shouldn't be too difficult.
>
> Thanks.
>
> --
> tejun

How about this:
1. Add a one line change in the cgroup code: export the cgroup_e_css
2. The nvmet invokes the cgroup_e_css for each bio and under
    the rcu protection.

I think we don't need to add an e_css[] array on each cgroup. At least in
my case I don't expect to have a very deep cgroup hierarchy, so we won't
spend too much time on the cgroup_e_css.
