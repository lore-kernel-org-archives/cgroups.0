Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B4E304BA3
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784827424; cv=pass; b=tH6nk8i9LgflOqYos5JM9yb6nH+skK2W8gmoJcWGNTLuOtPyNc63ytrgYvdUT6DGZlKK4+UekSl1xgPr7Hnp5FionAwdRlukbmifqOs2GwUnQB4FJz5570TOT3tjHu3X1zAPNa30vlZnOpdwE4fOipe1ZNM2ilmZ/4LH04D3zGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784827424; c=relaxed/simple;
	bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jiq/9w0Low6t7yO2elSeaYrGmih4cTUpa/AqbhTHzWyG6IOoER3H7PqgL+uEHb9hof0JYlcyKw8ilt5L3hcZM4A/R+hO836EViKd7IEITqmfrXTFCjgLYwMBMsr252DHzIsldRM73JzUC/bKGR5OxZwVBpBZez5E9HzMaz07JwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XAE6UqpY; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XAE6UqpY"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c15a5b265so16221cf.0
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 10:23:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784827421; cv=none;
        d=google.com; s=arc-20260327;
        b=pxrzTy6wbgtmzhOhNfimm5546/OC9K5+jlbknGR+2+viptMnHAbbGqCfcdEgiXcrGq
         xF9j8OyslOsATRHiJ2rH8O2spv4EvFuX4o725tuqs1vDswbGTsOhgaSEKYV9LR0gXZ5J
         3/lt2c6UuQ8ASzRvbhKc1hHBI4M6H7OCsNdMTLNVMSakw8Q9DULv4/uLbmri/3Mm5Ok1
         /Gep/8S948vxTPgqEBf2fpmfiPX4jtGv1+y1jayj+48qCJHBCJ2rIs15KOzIJWybavrM
         ThVa54o5+3Z//+sMCPvJjlVVkVYhHsEd3+pHKB3MN6YPMN/YOe2Ady1GIvTRVsRg+SRE
         xyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
        fh=stUlkmKPOmoVrztewLGqmLBANRPVuO5rD7D+u7r659k=;
        b=f9NTL+l0Hi3B6mXe0+DmaodFLcVlAhun1srVliOvfZigBCwma8S8C0vBKVHbvCngBx
         NSDHusDQSLfHcwiK+pCogVQI/kNQLYiUMNx+p0VnnX5dcDvayUvaW4LFsfVFPnLrzKmr
         EvqqAFr/XhN/7ezRj3LS1ZzCNpW1LC2w5UH5elPO8krVMEHyaJecFg+oD4txxYv3dkOE
         jtvffmHBH9sOt7eZKflTCiddJ9PVIgiZfqe4kjafaKXG5IdIpU9LJY/hPIDVUQfEGNxX
         j2wXMguKS8q2ZjCUSw3vWcCCePZJgVAOSR3qF12aCSy2//FVih7Bxmi5QM38xsK6aGap
         rXOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784827421; x=1785432221; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
        b=XAE6UqpYNwMiECN7JqC5ZfDE5eTc94nNH+d/Ec+YeyYbGBmEqEgxD5glQy6odif5A/
         5Vk7msVXPyGYktz5p0ry7OS8UTSkjtEXszIPQlvq1gBpPHWODTLnQVy8vnLJUZ5Z0UHw
         RN5H67Vsx7Eza7I3JKy3tPi1WGnFszR1cjH9U7HTzUT6KzgEfetjessWfc9TVPWp2cdc
         Q6FwEdMdHEg4fBp3PQifz9T030Uw/T/tsR+bxx7O/Ty3Eb5LaCRNZ4k0rbpbttNqNb7i
         E40UJCL7DJUv7w+q98d5Wi3rxCYHwgMPGng9yGQeAwskyBuTgJA0sOkobn4yNSs3Fpfx
         3kzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784827421; x=1785432221;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
        b=Sb6PawPXgqZyCi5Qex4aoJ36QS0ZhrnSqHwuEkH047ja/JITbJd7GBdCF8veXTdvgM
         4x+3IUysLIAMVGTAurouPKMHjqG2QW8upU6niQSh6Z1hlNI2AtLg5/YW+HwTmvPS8bS9
         Y5xcit5LEcD+iYTOlAcj1MgvL7Ib7jwA1rvJEdZSFNqADUintZGNIlX2AL5GCSzSkdtY
         j4JMSwPiIGNdxEGAyDSL9HXq+Mi+VhqzxfFFBqGW/QVUPGUK3PuPJMWdz0N7fol8iBJo
         fwvyy9sv4TrwFodvb3N3RdVKtW4jClG1CD6+e4odQ5IS5DYAT7g05DWtwA0WC561zpJJ
         4bow==
X-Forwarded-Encrypted: i=1; AHgh+Rqgqp21mMy6Lli3rOTmTtbLVH6fKgKotSeN4kaj9pdGBXJuMB3URNGvc0RHou/laDcW2wakjHrE@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhuid4AFxlxzimQcnCyrzA1JY7wEPMPGzryf5cEWPUkXfIQnPW
	TzXEibSyTmyeX1yGD6tWXKrEdYw7Qzo8K/uBNRzjsnGJA+jMPhBTRSZB0HKR6jaiIpyESYb17gv
	4P0CHsR8PytR9e93hvJD9dY9dHmBGfPQ8CcqgLc+4
X-Gm-Gg: AR+sD13ylrXOhqHwf8ZQ4roJBX5SrvynNNqEmzmN93BJtFUijPh3dPwQdbaZVhfzfAy
	NFRB+HZqY4NaUh2K6Vzoq/OyTmvU2JAC+Z4pD+ziwoMXTf+vgz2Kew4wlxV+HGttk1CpfJvsiHb
	i1P57aAr0I+5ivoEThR94fUtKlJ79wAgYdY0TsFDQFNcJqthtoTwjzR9fF0rSWM/wb64QXj6qid
	SjoeffhxMFo2fOeu/oL0BbWn4fdxkRJRvAJGwSd5CrPm0K5EUnDHGpHQei3m+xX+led4s1UZfZk
	nrKL4Aq+9DYAYuK2HAIbxV6T
X-Received: by 2002:a05:622a:124b:b0:51c:289:6979 with SMTP id
 d75a77b69052e-5284ac9d4e4mr112451cf.21.1784827420090; Thu, 23 Jul 2026
 10:23:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-6-2fa7c6f60dbe@kernel.org> <amH7ndu2TAd4ixKU@fedora>
In-Reply-To: <amH7ndu2TAd4ixKU@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 23 Jul 2026 17:23:28 +0000
X-Gm-Features: AUfX_mw1njn7tPFKe87j3lzybQQ47T04IbnV6qBbIg0pwmajyEd7e5gU_4Gj458
Message-ID: <CAJuCfpG+pzf5_D_zF1NPB0n_dukveA5YJy9sG9RExj76ZZSJkA@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] mm/slab: abstract slabobj_ext.objcg access
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 11:32=E2=80=AFAM Hao Li <hao.li@linux.dev> wrote:
>
> On Mon, Jul 20, 2026 at 04:16:20PM +0200, Vlastimil Babka (SUSE) wrote:
> > In preparation for changes to the structure, abstract getting and
> > setting the objcg field with slab_obj_ext_objcg() and
> > slab_obj_ext_set_objcg().
> > Rename the field to _objcg to make an unexpected direct access a compil=
e
> > error.
> >
> > No functional change intended.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao
