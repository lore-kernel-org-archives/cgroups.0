Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF1248C414
	for <cgroups@vger.kernel.org>; Tue,  9 Jun 2026 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781018148; cv=pass; b=G3ZG/WJGh3LOqiDI3+7NRLYLKflF/+4Ub0fG5Z4jyooWmXTQGBdxug8BiOEv9qSnF8Sc0xylyhNJyXQj6pcoyOTEdbggoVBd3Q0BDl2mcqXB+egFMbvG9NlkbfbURhsiGxcA++FXFoCd/Re3kMNSK5e56VpEAXjniy4riMgARng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781018148; c=relaxed/simple;
	bh=XAGyGGRCa0i5p0EaF3Q9px7FiGrZLFso6DX4zKKzZD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gUB8YvzHhYEGtbRPEecEu9Ae6he0r++4qxHxg9nB6KKsBRboFXwSwgx0lVoqpTKGGysBNiS/jfZn3N3aESNN8QhuF+r+sv1WANh7sxeiGODDjEuj0lZGwiN3VZy9ioau2ZrJNu7QnOJSm7wc+SaaulEAdSd7gzj4PBaK3vsIZ6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dPdXpHEJ; arc=pass smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dPdXpHEJ"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-4865b9e16d4so2009796b6e.1
        for <cgroups@vger.kernel.org>; Tue, 09 Jun 2026 08:15:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781018144; cv=none;
        d=google.com; s=arc-20240605;
        b=J1AcAIq+Ka5dASiBlva6yYWHyHIc9IkIFPQnHIVQxLE8ENgI+ooumx2r/HZoVcs/H2
         yMMlae3or7BFvUO/VkcdGrVIiV6CWyfLBBbyjShwUwK49+jF79GsUxzgVOo7uji6/RvU
         i9HrchtdO10+tkwUErQfnhBwzd9jwoUOXBHVFU7j2bV0Mj4sE9ML+3mM8KJkQ9FlGJVH
         ifoVTI405JQRqYsjkpW5JSoBcbmvqsm9ZwZInw5cDGWB6VHEpHpaeL1COFYtgW1vcRMn
         HEvbfI5Jkst0NHG0O78eb9qg/FomxRpNxfm6sEDzVNARyv52WFW4/d95jmkNVcwetST+
         nlZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wt+3EeS6ijMa9x3r8w9B3P8FOrVy6t9nE/xiUFYUoJQ=;
        fh=eLukLmn0YU4R5LKDKooPu0YtkSnEry2x148nX/oWNNA=;
        b=IKevNfz2sjHHL8Wr/jgtACxMPXdkzSTGVu6szImSUSpnLhfGLNkp/d2zI1ibRPiI4o
         T04IkElUfiJZs6IzEzYC4gPCPouEo9GXNeTeVwDTZKIJa6NpHSdBg9PkPyLr7nJY7hx7
         t99+rnMwa2mYVk02vnHpcBSsQdNVmFtYv1s+5APCpesb2pi3zw3+Nv+zzo5JaeP9cV75
         dgLK88DxTAC7rbiFsHfFDtmicYZSEAkFFZDcAe6oWcgwumE/eKZmy7Q5Y9qpIDgZmxQo
         k5hY515rfrAmDhZoy4Xp8WRzUaju0+G7XzPTpQ9s6Ex0A0aR3NZSHjyp215m/1KGyfq5
         PS0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781018144; x=1781622944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wt+3EeS6ijMa9x3r8w9B3P8FOrVy6t9nE/xiUFYUoJQ=;
        b=dPdXpHEJCeybVRl2oQEFsBA/t7D0ImSg/33zrvhEW15m7LZAIeKssgC8XjlEogdGd6
         sjnCfI+WFYC4HWihYTyrVqZ398oF0ibFRODjaV+qZLdLc+AzVGKPjKEYiUEKTFwPH0ZJ
         NttS/WMLkNpx572r6OWMse4ct45kzsIm6oN89zg533jSazoxAF81vC3q6MizVFEF/M2a
         uxZ8j2w0/ILZF1J8f6EBzu8QvV0VrXJ54d/Xxv5o3ppPvlzLGHc959iCnp9fqFUZWOeV
         Bh18B6XSKXZBMM9HbVcfFwTRGfMAmVjIT7FCO3vB4zXM9zB0vYOmi7rrhP7TdRSL40xF
         /WuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781018144; x=1781622944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wt+3EeS6ijMa9x3r8w9B3P8FOrVy6t9nE/xiUFYUoJQ=;
        b=IsNa25eDwYIOGB0ksL1W4IlO1iCik0a7Uj1xS3BL+/5towIP0eD2Wz76N+1q8tdl34
         M5MkVvywrULJ2m30mF9CdNoCosVuhL5nN5DMMzLSEVxeDVMns4ta+B3Xm4pmqP7ao185
         MELE9azuEdkNLcp9JyL5n9Gmp4gXBCxmRk2MJ8KeUDMayqx4xPfOTk0jsOeG55mcv85s
         9W5LYGMUTMex0UxDa2jFgZQ5sA1H7QPZFfljU+beq+aHKrpba55fGo1j76Qt7E/GDupm
         ApPBnwNQAIKTolTxVxvO4xr7WJesUKpfTM7cRT7IakluMZX3UTTcNOuI2bvl8nvV2+d/
         6Uhg==
X-Forwarded-Encrypted: i=1; AFNElJ8iJO7KI50azcevx+vp81EdwghwHGveJfbTONFqTYXo2dJ4h5pAro234vmSqhkw5AGSAQvU4CtX@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj15CbveNuv7Busg/m9B7BA2pMR4lK2FgpuYXFW4JnZd070oyn
	6E9X9CbYEYozVghyqNOZN+1ic+xOC0RDjqEzcaWLxexqsqeKV7njVqJrxpnc/IKdH6HgM5PmGzH
	bjpzEW+giLmiMqebh8PzZz79P7eVGfW0=
X-Gm-Gg: Acq92OFr3qOmWOUEfpvzuCeSAAdFMHA7kHxGbOSt8OHCZosItGD6nRF2sd7/DdUm3jc
	V41zaKW9UvS2g93C0tgmQfiqrTnk3SvfnxKCgLB9mm0gSwTUsfdQpJsHYZAqRzvoiW+lwnS58PZ
	wT6CknL6pIu+uGoaUeXLXibR2jqq5uuscVKK3Evw1UlH9pBiuS23eUzUW00wIbqDYZ/uttN0VDd
	6+6EnXNEItOxtGKtMCtxsgA+OR2Y6NbiLGwKq1/9vd5SopZnGGchPqAjWBytTaDBByeVSy/2Fq9
	hvwsiQD3VNG00I6Qiq3fHZ88SgZJXucpqwbUOl3WziOk78F0XOS7
X-Received: by 2002:a05:6808:1454:b0:45e:f0af:5148 with SMTP id
 5614622812f47-4868de84142mr11623304b6e.30.1781018144395; Tue, 09 Jun 2026
 08:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780492756.git.yukuai@fygo.io>
In-Reply-To: <cover.1780492756.git.yukuai@fygo.io>
From: Yizhou Tang <tangyeechou@gmail.com>
Date: Tue, 9 Jun 2026 23:15:33 +0800
X-Gm-Features: AVVi8CcSfWWILCDELm0SA7ZWJBSUn8yjiqxY_MLXcIuNwEr1ynVC6AyoN5wQ7zg
Message-ID: <CAOB9oOZ_PMGRmNOSJM=Nda0t2zfxZ4+h7N7tvv_scmJeFfUdiw@mail.gmail.com>
Subject: Re: [PATCH 0/5] blk-cgroup: fix blkg list and policy data races
To: Yu Kuai <yukuai@fygo.io>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Ming Lei <tom.leiming@gmail.com>, Nilay Shroff <nilay@linux.ibm.com>, 
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 9:35=E2=80=AFPM Yu Kuai <yukuai@fygo.io> wrote:
>
> This small series fixes races between blkg destruction, q->blkg_list
> iteration, and blkcg policy activation.
>
> The first two patches serialize q->blkg_list walks in blkg_destroy_all()
> and BFQ writeback weight-raising teardown with blkcg_mutex. The next two
> patches close policy activation races with concurrent blkg destruction,
> including skipping blkgs that are already dying. The final patch factors
> the common policy data teardown loop.
>
> This uses blkcg_mutex rather than extending queue_lock coverage because
> the races are about blkg list visibility and policy-data lifetime, not
> request-queue dispatch state. blkg_free_workfn() already uses
> blkcg_mutex to serialize policy-data freeing with policy deactivation
> and removes blkgs from q->blkg_list only after that teardown. Taking the
> same mutex around the remaining q->blkg_list walkers gives one sleepable
> serialization point for blkg lifetime, avoids adding more queue_lock
> nesting, and prepares the follow-up conversion that removes queue_lock
> from blkcg list protection entirely.

LGTM.

I had noticed some time ago that blkcg_activate_policy() did not take
q->blkcg_mutex, and this patchset nicely resolves my concern.

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>

Best regards,
Yi


>
> Yu Kuai (2):
>   blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with
>     blkcg_mutex
>   bfq: protect q->blkg_list iteration in bfq_end_wr_async() with
>     blkcg_mutex
>
> Zheng Qixing (3):
>   blk-cgroup: fix race between policy activation and blkg destruction
>   blk-cgroup: skip dying blkg in blkcg_activate_policy()
>   blk-cgroup: factor policy pd teardown loop into helper
>
>  block/bfq-cgroup.c  |  3 ++-
>  block/bfq-iosched.c |  6 +++++
>  block/blk-cgroup.c  | 65 ++++++++++++++++++++++++---------------------
>  3 files changed, 43 insertions(+), 31 deletions(-)
>
> --
> 2.51.0
>
