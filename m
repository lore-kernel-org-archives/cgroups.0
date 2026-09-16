Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54562477991
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547955; cv=pass; b=bCLIr6bJfmPHRm/Pm1rHM2ZA6BgykaqOLrJAtE/rvreRgjlFhBC+oGQDVP3Wh56LBWBz+ue/Hssd87lCiQDQlnmUYuGlJ+vAhQaqBB09LXfbnVnPHW+kh7t6DaIUins+rZ7QbqzAcsA/OREkTp0B1k/Ld/eN2qZyrRc65YXMlrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547955; c=relaxed/simple;
	bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=StxfQkFLnfHeicqz3Wyw3N92QhzoikNnn8AlJrM6Mq/U6VDH/kZBW4yLQr+pS9KPbToapNtJEvKysnMb61416QksRP+ksT5A+wS0hIhWz1nKGqZfdmudNXJyIDAc6KghR/qO/e8TPg2bbfJ3RMF01NyKzhVJbY8Wv4LGF6QV02k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kva0WNp9; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kva0WNp9"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6aa13a28848so1290289a12.1
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 01:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789547951; cv=none;
        d=google.com; s=arc-20260327;
        b=MGY+h/7tEDUc5LMa2Dj3uPH38Z5pflp+nUpjuWFR5vWsxPDootTb6e5fep7Mr0jrwC
         StyuEDz03qMQl0P4LgzRx8vxKcezHIn2TcgTQb70N2G8GlAc9n1fuAoUK8b/5xx2PJaV
         palzKxqAnZQJCc++fiGoWQtzVURruMddB6QE0jzqnvTi9kalyOvRzCkE9HQj+LvmGdio
         iC1fiXqKF4agPKRn51WNaX9Aip692M1B2+q/Ce68aql/j3/ZVr/G1QT9/x0EOUat2mqb
         sgDT1iMjGP9SNcf7o2M1PlsZGlc/RtB+2mcUx/6G+D6VHjPsDv1IipJMjmpfHIRMPI6A
         lVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
        fh=6Cbbd2FPr+y9S8uewPV4YqWCzXZhbT7Y/kraSKBBNSQ=;
        b=pm8hnUl4zCH0zrHSXWyuzceHBNKDwgSRmwtld9xDk4JwmrYTQO7Ejsuo3E9NSNkLfZ
         oStTjeGGo4XUmtLZxQ8AC7InUj61qfBSQV9FZr3onVBXUrHGjgnH5faNcp9GIxUQw2IY
         VTfX7x5BmLc0Ux7pYe+fZHcuWgeYcDxKZWZNJv/4ZO+Zxupmxi5IBPq9UyIuzReq2qH0
         hoLhpc+VHL4SEmGXis3TFFcO7BlM7ByrqPpNYpN4N8Os2YopP0WWjFKvjWb3xOCG82lq
         qf2CWiLQ5du8S5Wswm/cVm7tigPlv47lWX5FMflemgC7SG4Eu3fx93WfC2VQT1+zA6S1
         bRzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789547951; x=1790152751; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
        b=kva0WNp91hK922vW8uEn1XZOSxGLWIhCm/GrywED5wEr3agJiciLaAC7Sq39O6U5FP
         Zosr5JtFh9E5uaiv5kHI+RF0iu+SFC4BC8F3iT6xjXT8o3mbrMzIbnUV348GxIET4Ywd
         /ZLXzJLjLaLIAtiy3quoUEx/l+E7ahaS5usqEJokM3wJAcmyg73hmXxj560FckOWyqWa
         AbEWJno3hgvgyA/60W0L/wC9bR6UgoqfhAJBV5CqK5WAabKn8rT1FJvup8QRTN11emPT
         PCxsK6Brc+reCTp45yLX8CKvHAfZnNb0G8kDPRUyQdm6PEC84ChBZA8MtFIVHz4F5Liv
         vphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547951; x=1790152751;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9n3jjmSPydEac4OpzLVHay3P89pv9PBRtC/AixhDU3Y=;
        b=wiSAaBrw7H2muX2RwJjHiVESHNQQDwWf5RG8KsIrhWhCaBrZUFQM8kCHQv9wi9XR2i
         3UjARVc6ERSZsa7IkvsN2GLn5gejxd3ow4tH0F2qulZsL8rCoyYVewjopjGUIP9xpMTk
         R5nw8b25gst8lxWV9iTlFNSNyTSubk3EZitDzVjSzt6s3rxReMK4iQPkcI8tkalnReh9
         s+xqJwnfwOuTQR1T74hvK7GvMex1UAdtq2bbNf/CSbUcegsFojiWsUHBSGHz4UZb2m1u
         9SygnWC5G0iPv7dC1GJOET+F6AOBHpZAWYUN8bTesiVzZDdlZ1537ugmIPJY7anbcgu5
         b6fg==
X-Forwarded-Encrypted: i=1; AKwUvByGgqoj8HmlVheX6eQmTm/XtUCFMnsMdZfhR0/YfuPVFOELvfih9ZGgDR477VC3zCjkKijAMS4E@vger.kernel.org
X-Gm-Message-State: AFuF++nascMcATubnjPLizhja+kc2jDNMRVScBt4Sk6MaBx7SL/7cnOP
	9R8MYHlCtWYucAqbnXMp/WtbH6ie1QTzqE2s/c7E7FqDr8KEnqkxyAA1CNdwnVJtFYm9kisQ8za
	CsUHvTV2bcYUL05nnEeljtNeRlHLzySk=
X-Gm-Gg: AYBFou3DrEe/CRhPYof4iaBiPPr89xOD7TRMSt8p0UGosu6q2doNS+NOaHwDO99eedO
	cCHBn+kksqg1Rtr7HL3hPhA7GKwcJRNARo29h/nx+NMycy8+0ZmM+wPQNTdsqeWO/8uc2FA0kwd
	ADG+g1s2h7jtXx7PknhlX7fyPiy/cy5PPc6YhbCsRwepPu0wsRvGdply+GvI9ajAzY63BgGqVTP
	sGIQ08bXkEEuEywO72B2ir4g7pVlxypFLkkMcQ/BcZs857/TklPj2EXtgFS8whHNmntIwisXW1P
	2xg+v0+bY4ANiAeXvZfUUKuFMpgNtvGchZ4rthsnXzBzkwP6Domjwyr6tJ3KVuaf5vaOe0HVSWT
	SyWePUKdVI9waZCYN9B9gwBQ=
X-Received: by 2002:a05:6402:a246:10b0:6a9:8863:ada4 with SMTP id
 4fb4d7f45d1cf-6aa03f4c4ffmr3790992a12.3.1789547951018; Wed, 16 Sep 2026
 01:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com> <EF8E0336FFC4841B+20260916074241.3373002-1-zhaozhengzhuo@uniontech.com>
In-Reply-To: <EF8E0336FFC4841B+20260916074241.3373002-1-zhaozhengzhuo@uniontech.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 16 Sep 2026 16:38:33 +0800
X-Gm-Features: AcwNN1UpOaSQEBAOnxFM7gGPIqShqgdOpI3fmggqN1N_R_GBYHUnJOQm-8PiMzM
Message-ID: <CAMgjq7BMHPxkEYfTOaaP-dXX+EDhOdG1Yu9O8yqaEUHoeBa5XA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
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
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 16, 2026 at 3:43=E2=80=AFPM zhaozhengzhuo
<zhaozhengzhuo@uniontech.com> wrote:
>
> Hi Kairui,
>
> Following up on my earlier v1 test report [1], I tested the complete v2
> series on a small WSL2 box. Applied on the stated base-commit
> 9958290885035431e2494159f555e332c3c14906 (mm-new): all 15 patches
> applied with git am, zero conflicts, and the resulting diffstat matches
> the cover letter exactly (20 files, +812/-499).
>
> Environment
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WSL2 VM on a 32G Windows host, 12 CPUs, deepin 23 userspace, swap on an
> NVMe-backed virtual disk. VM memory was 15G/4G swap for the kernel
> build, fio and sqlite-grep runs, and 20G/8G for the DB and browser
> workloads. The distro WSL kernel ships without CONFIG_LRU_GEN, so both
> kernels were built from the distro config plus CONFIG_LRU_GEN=3Dy +
> CONFIG_LRU_GEN_ENABLED=3Dy; the two kernel configs differ only in
> LOCALVERSION. MGLRU was toggled at runtime via
> /sys/kernel/mm/lru_gen/enabled for the CLRU/MGLRU split, as in your own
> harness. Workloads were scaled proportionally to this smaller box as
> noted below.
>
> In summary: no After-vs-Before regression anywhere in my matrix, clear
> wins on fio miss rate, Chromium&Node and sqlite hot-path stability,
> both MGLRU modes consistently ahead of CLRU, and classical LRU
> untouched (MGLRU-off runs agree across the two kernels within <1% on
> every metric). Both kernels survived ~8h of heavy memory pressure with
> zero panics/BUGs/warnings. One caveat: your +13.4% MongoDB gain did not
> reproduce at my scaled 12-thread setup (+0.7%), but no regression
> either. Android was not tested (no real device here).

...

>
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

Thanks!

Glad to see this is working well for desktop and smaller devices, most
of the cases here are for large servers this time, with fast storage
and maybe WSL has double caching of files (not an expert on that) the
effect of LRU is limited. The result still looks good, which is good
news.

I tested Android and deployed it on my desktop look alright on my side too.

> Thanks,
> zhaozhengzhuo
>
> [1] https://lore.kernel.org/linux-mm/92DCEFFD13221261+20260828102344.1537=
874-1-zhaozhengzhuo@uniontech.com/
> [2] https://github.com/brianfrankcooper/YCSB/blob/master/workloads/worklo=
adb
> [3] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.co=
m/
> [4] https://dl.acm.org/doi/10.1145/3731569.3764820 (artifact: https://git=
hub.com/cache-ext/cache_ext)
> [5] https://github.com/ryncsn/emm-test-project/tree/master/sqlite-grep
