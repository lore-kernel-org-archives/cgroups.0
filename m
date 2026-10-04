Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FA59460
	for <cgroups@vger.kernel.org>; Sun,  4 Oct 2026 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791084645; cv=pass; b=rL2wz3ipsx1HBU2z7g2XlhzXEe2efWp5aL4y/2DEhcS7KFAmtpnH1BPUwsJPDrVuHCJuKfiSEKkmTOqI6sBeqqw8QdpWhFvuQWELA1X5BZPkKyLarawGEHPU+e2/7Gevdn5DAICd8aYNJgMNbbBEC4rqsaGpF8VAYMelgHzvRtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791084645; c=relaxed/simple;
	bh=C3qe6xrBttWpE47/cr80mPV4srst/5FkKQdl15lo4VM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtxeP6BBS4HQSywAQ2qtR1eCqAyIsnzmg0I3U/FoFtg3CH2vyJ3UlWpMZwpj27eJLmyZUIly9a/mIFlnL0WYpE3d20dpMp/3VxBNFF3VaR/l2uN16J2RQMfT52qi5OPD7tC3Vxun0y92n65mGf/5P8nRraHrpCMzndYRWU5jcvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b+Zs8GyX; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+Zs8GyX"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2a25dfbf5fso140462766b.1
        for <cgroups@vger.kernel.org>; Sat, 03 Oct 2026 20:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791084642; cv=none;
        d=google.com; s=arc-20260327;
        b=IajB972mNl4pBeoml65YBVSQLzTXqYGDHNkZRBX28JSRE+NCsJrm0Qpfc4QcXoyyDZ
         bNMWt3jwfND8M4cxVyQHPTv5KII4Lfi5aHmfRZn6u2UONOjZaCgDI68yYG+Xi7cmNLK6
         w8dZjercmL7x2H9aLVrBlw0cz0BjMXV+1VOLQwisMiyrfxlSCPqrEMJqhy5GocFu2H9W
         hGS8raRQPnB+Hl1ZxIyLcXrxczQL06aUw5a4PtCZcD27xL7UgTLd5sYUiuBjqWS6z3gf
         uEqtb8qGBhBJsYafNrzYCY3WnnxxBpd2OXwxA2vbmxWFQOAF6CgUuuoSTxKJMMLQiD/J
         F3dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
        fh=Xh2GR1vf3u6CnAhkJi7QgJHXw0Sq43dpUFnBAjjRQ/Q=;
        b=ldtiF3v8ESwdLM0sYEj+kHI7s9jgl0MVgSih/2Vt6URFUVqWUL6M8DsIjoXuWTYSTO
         cf/af75RHpOmjFl2nGkreU3U/B9/aWwa3wIeQem3cweQV47Bt1WwRAfvM1rhhTmcoO14
         Cegd6CUv1EfijhS7mXL06MLxd6sZufns6oUT3e/CPhZyA4Vd9Vcjx/gtBqOOS1ncPjfz
         jx1PvHbvso7LVvKWgXgfXeUQJaA1LOKpDgh25RjeuyhbBNbnFerHGtlaPBHxCU3+eCni
         S8HP1nCZUViOLr/zDh8mIPsxw7BOfUn/9a76qhGLkIdUnYvNlb20oxHWF+omWVDtqRE4
         Qedg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791084642; x=1791689442; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
        b=b+Zs8GyXKGtphecIfxq1xDM5EgrLYTw9lH/cKWK028H99nPv/8INSTssARC0sKSEoU
         mQI+6ci2dRUIQ4JOMQWZOav0mtghWCek1h4LoUHZeKryk/VjgD9hFD8LraoIhgnBUebR
         tx1ckS+d0Y1t1KgGiw54vupXVSj3f3nhYwdtNcrs6npVB384NDA+47DKy7FlRU68LgZr
         JHGx5kEjdG/1TE5Zj2pXXEU356vFhlHQhH9OpGug1pUU/OpTc2P5RHDgSs+MTqaqmx10
         W1Z7WBAXuC57dYTeTC4blwjEFdwuaLlvEKu3K3VdV+4fhqj2od1rCepR7sZNbNh+MqQr
         h/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791084642; x=1791689442;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ocMEG1JQitysYEbxaeOoYgeb6SO1YjUdEbtsSzCE3S8=;
        b=1GHjQC1wchthwj81EmkifxTWclKOne0vYstkIG+dF2cUxeAI7XG9qMGYj8moBm7d5D
         Mqi1xUoEcdu6HFQx0rhP6p4HaGR3HFJzQCNE8ybCOv0+hpi5LK1hDS4vXezHlXnRAYMI
         /VJYIxffulIGK0fsXNhM6nnUYTh0XpHZK7f0nSE+00gYGjHibhLfg6b4rdOxDTvO3uDH
         ZJxP8I3tMeSSgyLiqW7XMBlueqTD0j0h+Ix7JIQJjIcmjU89XQ+OTyxam8G0TejEp83k
         iwle+eg17Mxe9ZamKE80Ia8Z4mZWdOoBxjzt61KLANzN6YHtuTowLI1rFnGTuw3hDXk/
         867A==
X-Forwarded-Encrypted: i=1; AKwUvBwzTk676MLfL6gS0jlZfLxM1VPrt5PxwjYAV58wV+j1S88yHSsnpUg3qVLw9CgUe9STR/Fg3Qr7@vger.kernel.org
X-Gm-Message-State: AFuF++nzpb7zZ1VrDVcexQx//x8y2LGCvIZkUQvjhH90m2jgL+X3jWtl
	gKs/iOhWB5Vc5LPrM/ADy26B04l7k25FNLcdag9dY4W8ICYr9XvL+6XZ7bjli5yq2ctPNx3XwTb
	6mV/cU78jTqjINDX6zGlVs8yrgcbhuyk=
X-Gm-Gg: AYBFou3M4SbUmaOjOVpskGyoyqHhnewKZTzWfjSUOI3Bcoz/JwcItsQBd6KGHyyd5wu
	fBPFk6VYC8d0fV2is86sHagK5qgqePsuFf/sS01qAOQxzsnZkkqyHuqq+rJVKbv367oJ0gKuOWc
	rq7tAyoew/+6AfzjhI+0VVIujWYj0Hzz4l8m64KTZuJBOehuG2CoFNT0iO3p7w7Qi556ad2qiQv
	pfgLLeNKj7hpMxQXgTzzB51iE7QFQsFi5M3Zy4ufzWpcdsDHJ4DjmdkGY04BRBImnvnf+Q0dnUL
	ZaK3WBAbAsuaLcWFLqFbXaxq/HvW3fhEWINSml3dfKjVvTId2i6WQQ+3GngN2HdKk5FpMesSueY
	5CO20iod0tWEX2Szv/BQ=
X-Received: by 2002:a17:907:97d3:b0:c29:45f6:6a0b with SMTP id
 a640c23a62f3a-c2e6edba366mr293421166b.34.1791084641659; Sat, 03 Oct 2026
 20:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
 <20261003-mglru-fg-v3-15-cbd4546a5bd9@tencent.com> <DLVOTZLINBSQ.2FBQBO7G548GA@nvidia.com>
In-Reply-To: <DLVOTZLINBSQ.2FBQBO7G548GA@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 4 Oct 2026 11:30:05 +0800
X-Gm-Features: AclHuK_0vu692Azs09lD-vnP7S-2xAgVgXDUAR3MwsA-IVgdqMPkuZxdr53J7D4
Message-ID: <CAMgjq7CNpFbtU5X5bhjMFgb6qcgw0yuLbw73mKOCkE9tpMohkg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 15/17] mm/khugepaged: check folio referenced state
 via LRU refs under MGLRU
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 4, 2026 at 6:11=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Sat Oct 3, 2026 at 8:55 AM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> > count, so folios with a higher refs count no longer have the bit set.
> > folio_pte_referenced() testing the raw bit misses hot folios at
> > refs >=3D 2, under-counting the referenced folios of a candidate range
> > and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
> >
> > Test the refs count directly when MGLRU is enabled, mirroring the
> > smaps conversion.  The classical LRU keeps the plain bit test.
>
> Why not reuse the smaps helper function? You can rename the helper to
> check_folio_referenced() for general use.
>

That's a very nice idea, will use that.

> --
> Best Regards,
> Yan, Zi
>
