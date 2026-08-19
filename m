Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E671148C3E9
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157993; cv=pass; b=Cjg/4jo+GJVIu6CXxAAiJUMPGvvofp9JTA87QHjm6o1HVREsU9hJ3WXwgBJobJGfE00f8tC4OYxd/9lX4ourWrAnvzMa1SO/O/qZYQmXl8OOi/7n2IIgbmm5mQAJEw4t8c8LAdQ7JW9qJRyZh+JeNJ0tV4qegTFDY6W5xAAzxDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157993; c=relaxed/simple;
	bh=bm4ASoBKtUmJHUk2zSNZG8bG7KON1caZaOXDl2aDwUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZUsrlT18o9gYVQdjHO81ofs/4yN2pKN1kvR433q/M+3UdzP73fAuXwyZjdSWwbfGLK8seWIW+QC6p6SCCT5LTv5jqnDKjLKjdg9tkXitRi4ee4pjfLaHFctykrl7bFtoe7BvAvxSbJWQq7IU74rhHYaFKgsWYForHOQZwQcc0/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sVPozzVe; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sVPozzVe"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-482938466a7so1039655f8f.1
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 09:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787157990; cv=none;
        d=google.com; s=arc-20260327;
        b=jhVi5wXrZFg8dBn6EFHe8QpJ8/UaE72jE/yqmEKuLtiV/tWzRCIKX3paYwI329xhBs
         YBMVj5bda93dPR+QKs82ZFofEYZTgLqSMhvZRppdpzbbF9+D4xPD3NiLIxqZrfvcKm/3
         9kka2+pOpk4+ZN95XpOW8IWdQHLUwmKji6mhkLkKmDZOwx2h0VTNoBrP9KeQJhs0cxP6
         TbNVQX+XZhUxIK9BG4PDbOZFlAja+DVxhfl/K4XXPSfMIVzj5B4Y6Tiu/Zpa9YL09io9
         bc3wrZQnkG447t1FxGckdMffrmnFEKpwFgp3Crgs17W2FtTPyqxrtL5PJc7x7J0KNNGs
         xHVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
        fh=ixqwTg9uBf8BUjK6l7y7ioFuBerIDeptDPySfw1MgpU=;
        b=KE4RLMR/ob+NOpLOs/ZRz7BC1WmoKA5MGzsgHkspVn48toJO0NKXiOkUKQxsM2mA+f
         GDRAyodq2LFzXJtGIbTca5OTOoel5uuhg+jaowzmlIBWrNcIUHZOy3dAfHFY4gtyyYOb
         QT8264aXPHvVUzcIsDkmaIcVKKSJtLk3kPVjp8FsuBc1XD22nqK/3N1gda23teGjrg1Q
         coDh94QV67Ww/GiHijCxzWdJ3R7QRDv3FjlbGv64zgmENyz5NG9M+e2ThKYNcZ4R2SvJ
         MEzWFjtFfCmqZ6/HnkBmHS6ggK8/da8IMk3BBBErDs32necT2caUdtN4nQP6UcU9Fa61
         rI2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787157990; x=1787762790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
        b=sVPozzVecTITBkKuvfayI7txQF8rWRsy+IU0J9m6uVV6YM4NSyAk3JFUGU9RhHrhyQ
         j0qfyDK/dvFmpvOpr0JlSNW8V0soQobuxS1JdQDhqONJKKWLm5NanByKEEzMlkML8Ar9
         fh57Gdi9Ykqu+X8w/+S4tGQ7dce/26nb3IU1ZiD7m3l5suZZGePlatkK1+e9R6XWpQ0F
         7nST1oNClGH+PHQ27wGfXeqzfbw6fEPY5LKo2srlLWjvz5QitF5yAF27shqF19VXRf/a
         +kRGfWjTodZml167noIrOrbP64RuX6Mkl9tl8MAZZGJqSoFsn71LOyesB8kKqAXjG9cz
         hKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787157990; x=1787762790;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
        b=WS63EdwmhfK/uCz8S1yCAlkd/4qI9VkkLanZkbkwlXLnl9OTCINmeatuwC5ZT7QaJN
         w9vbIg6J7UEIdyuculJYxtuvLXz6gzIMrd+UaMrUePZRzKNfGUAj9634uMJ54xGmiTPh
         2COE87MEvcNWroISLI/4cXfZq+NNQxlv7oC+vZGMnjvG15S/78X6KtIrqT7O0uZSvqs+
         uGSJt5Hyc2JjWSfVUUFa+Ab5IZf+cOIxvPkgJ4uspmJbaJ0/x1GS11mzJ6DoFAsRpKZP
         8U9rfhnn/Y8k4+OcvuGJneihKsKu2tjt6vhXx2saQekIIkm0bVyx1iPSL6QkNFgykDTh
         XfMg==
X-Forwarded-Encrypted: i=1; AHgh+RqN/VN4nYsWVQAKsKM7QEmibWZNgcgj0wa04A+K8oMS1eY8681+0F5EXxw00fgkUCE3aM6ZOL2s@vger.kernel.org
X-Gm-Message-State: AFuF++kfs+oRHRBgqBDXf56xsBBuNd6F/9uZI0F1veGoSNPqx+3zN7Uh
	JzGmIArudhNvvQy3l740m02QANVu0azeGdeG4t1zaP8D/ZoewP4utBLS8IvEZ4pE9woUGagJDeY
	3BFsUzn2A07zLMyNs+SzOGIZXhhDB6N8=
X-Gm-Gg: AR+sD13z6HhnhsRU7azivr5pBOFvdLPP7JQ9f0rDeiCmJLCiJtl5fnN58W6M8I2W9pp
	bTlRdP+2jR3unNb0FhwVImb6hkxf0Plkdwkk5JwO1doO1GinxvVt3ktoHW0jcvzKBtJPDRn3BRS
	pDXzp5+tVmHQcFaRhn6rXfIf+aI1jCqrcXASP8FTjxtVTgkDRCBdyARqxTxGQjGSX+qItHO6Xd9
	htIGpc9lXwlqKyD3iDU8+vMRMjeargsRqp24JPmEyhlU4H91YDXQefxN3pLB6weK6K1mVyXDeuD
	JxxaogDv2rIdyJ0RhcmKiIVB6Smsh7K6Dfin3R8nSsuSrD3dISrDe3wKPeu54ruWfQrGVIDF+eI
	w
X-Received: by 2002:a05:6000:25f3:b0:47f:8ac0:ccb4 with SMTP id
 ffacd0b85a97d-482b1e9df5fmr12803729f8f.10.1787157989811; Wed, 19 Aug 2026
 09:46:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-2-nphamcs@gmail.com>
 <anX-ga41DMNWF6-2@cmpxchg.org> <CAKEwX=MmqyWdqfrp8kxeuucNFhU2e6Hk2TdANUGhNFHhvtSPwg@mail.gmail.com>
In-Reply-To: <CAKEwX=MmqyWdqfrp8kxeuucNFhU2e6Hk2TdANUGhNFHhvtSPwg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 19 Aug 2026 09:46:17 -0700
X-Gm-Features: AcwNN1VW1IFOK11rd1UcYSUArFyDXGImTjTFPjh0sY0B1rB0YRzMpSnPt4Jbiig
Message-ID: <CAKEwX=PjvsAOv8rvp+mz_aPqDLm6iRy6URRW2EMFvFrgD2HEgA@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> >
> > Can you make this a pure allocation function - vswap_alloc_cluster()
> > or something - that links it to &si->free_clusters, then jump back and
> > use the existing alloc_swap_scan_list() sites?
>
> That name was vestigial from Kairui's RFC, but yeah I agree
> vswap_alloc_cluster sounds better.
>
> Regarding the linkage of the newly allocated cluster to the free list
> - I'm a bit hesitant to introduce new surface for these clusters,
> mostly because I'm afraid I might mess up the handling of these
> clusters (when I unlink them from the free list), but I can give it a
> shot.
>
> >
> > There is a new_cluster: label upstream you could use for the retry.

Actually, I stared at it a bit more. I don't think we should jump to
new_cluster here - it's not what physical swap allocator does in the
first place (we never do any backward jump to retry).

So basically, this is the old code:

new_cluster:
if (discard)
    alloc_swap_scan_list(free list);  /* not taken by vswap */

if (alloc_swap_scan_list(nonfull)) return;

/*
 * Added by me. vswap (almost) always succeeds here
 */
if (alloc_swap_scan_dynamic()) return;

/*
 * not taken by vswap, because we succeeds above
 * and free list is always empty.
 */
if (not discard)
    alloc_swap_scan_list(free list);

/* if free list scan fail, keep going */

etc. etc.

The new code becomes:

new_cluster:
if (discard)
    alloc_swap_scan_list(free list) /* still not taken by vswap */

if (alloc_swap_scan_list(nonfull)) return;

/* vswap puts new cluster into free list, then falls through */
if (si is vswap)
    vswap_cluster_alloc();

/* vswap now scans free list to get the cluster it just allocated */
if (not discard)
    alloc_swap_scan_list(free list)

/* if free list scan fail, keep going */

This works, but I'm not sure if putting the new cluster on free list
buy us much other than more lock contention points (we need si->lock
to scan free list) :/

I'll just rename alloc_swap_scan_dynamic to vswap_cluster_alloc(), for now?
