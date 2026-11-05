Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793900344;
	b=jQaFQSWeAtjRYi2kBp2oId5yDoJPvqPSkA23Js2uxBPV5XyFMQOlpIAuLbcix1aFRcvU
	 25rKQDmoSK98jGbLbh++nfHPct+3FTrIcr56zPfacM7fa7TrV7nmVQvj7c240Y3PLmLEn
	 mcfVZ+tHemQq3L8co+/1K1U+11Dg7kvVbpWRXiouhicf31ce8yifk7cT+c15QxXRWnat5
	 vDxjv/gVEp8MTGP3pCP9qpKIlCizvbVQ+8W4c8xBlF5Ppy7hWBkBT8eBk7SmubrQEEbax
	 ToDOEn3RoTM2d5zJf1TlzmbbxEpPuNxBHFyb/1uz/EbHYKRHdw4o1+hP++9pLnneAjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900344;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
	b=5iD6KMvkRwjvuCXwOPeGep6fH/7bH47oRaLZM4preU0F0KnNyQBegOaUOth/BvlDZB7L
	 78Ll66DXsSjKgVHZIpe1oR7/2JNKYtIEFFkX3tveNGFWIQYg3AmiCPJm5ivMYX1wlSKwz
	 BEx7iLC//LW84ULd+/hxUN2FToWPpzqOj22V8nNMNN1k+6WchXSNosi7Qxt3VXALGtQ0Z
	 lHdzbXM1FWx2ECcO9Mh6nmOO4PDvQ0rMoAAZKmrIrNUed3p6Yp+HSLPJcwgLZLcjPQwrQ
	 LWq+yWhvBLj4mwxOt3xWBc0MfeeubU2p3mCBsXQJ14MrahB5T4SJ3kzAi6C9/6lJMOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tU7NlAOs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38863606A329
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 17:39:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38863606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tU7NlAOs
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-490585eddfcso1276268f8f.0
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 09:39:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793900342; cv=none;
        d=google.com; s=arc-20260327;
        b=FuyaEu1umTfDDmf7VKz/CjROOj1nthipZS3Uk5lz/9GEmhl87unH03jnyO5d06sfHw
         I0/mPQ9UDzpx5uTT30oBykEl/UAcNDHwex3D+bXVDsn6MR6Dky7Y+KzH42noNfHzNv79
         IMIgIEIjyNvPg+mQB17K+i+8dLhG/3OCY2owS3+eAjVWJm8IftPRlXqgVw3KE0FMP+MF
         QRBcMUtUhiKEp44cBvw8rBzaykcqm3xzKcTiR3BCIBH9AVxmlu3PiOZla90937MVRBTA
         WYs8w4cTOSX34HSrTvSlFPte0elUxgoIi5rqSrrYmJYSfbje6I7N+YpMLXnh/EK54fm7
         frCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
        fh=72OZW7faXMovzIg+Z3JW30itz/e0hfZyG8wb6sunQ4I=;
        b=Nn8oO/iY8sUQOGZvaahKKBjHVGygCb1RrKtbC0XO5eW2eYgJ+g7iXD5Sag2l++t0jC
         O9hoBN4tR3AqcjKVfvvaoDUD/XoOKHGEV22Qx5ZHVZrwg/pMd4bOnZ2UuVV2YevOsHoV
         JMAClFr/0f3k6O/GQE3cwHPtX/ofhspvsZpsQZ0PDlNzaqQsb+m2giTdnD0DHNfHKa63
         Dae+ht8eWZjtoITvX10hiq9lx/eiOqG1XzFDp9cEO6dKzGReNbg7kyRQbNakdY2Lxw7b
         9WbYfWMyJyZiNXC3/a31abJR+QrLudfql4eK40ukVECXdvXPf48+Pze+gYi0PVHHAP9M
         Gdbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793900342; x=1794505142; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
        b=tU7NlAOsG3wc5zCXPivrK2hTsvsg7FJNikZ2YCpIYkyel9zIAqvxqqUBWU3EO+KqP9
         2T4GniflhEuOaBCI75uFKMH5I3+bQlg/RF/q1R4rt1TmMJrBFPzcK+3e0nlgJLFF9yJQ
         5+xbKQx7TcJZdlPbz6IBem1BH5bh5a44jPxMwuw7a+16rsVUVj8LUXHJ5VTT97VycvLk
         D8NCtm1bcs+uKEAQgAWaXgIA6iGXfmSiX+XB4speDiuf/zhAwI5QYZ4jgFkRmzLZViL0
         Eki329tM/MyENYElqoRV74jbpbueg/o4Sycu8egcmQKSFmqwf/ramLEZBY3sknI9P4jP
         ud6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900342; x=1794505142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
        b=zhtkZrofHwQpq/zqYDQXuiWnyuAVJdHjIebVmiaPPUUW3JVi18BDKazBR8ZWzaSF9Y
         kNJG/4q63bhwiQmE8Gp1C/8YMe2qvxU31P1XGSPziLKqSAZs+mQt/LGCAvSn0o/IJtr9
         39uITGM8wD9G11YD3kAEhQAqT3xE/yx5wXMCfo9eBYsU07CP3mvsNzYhMBPdOvcQzTLt
         wTXJb/ixRCsX7wRN+Lf+7IE+jkPOPs0jJvKP4eYqUX56oCV4ESglXGiZCalbWJHCqsth
         E2XLxfGVxdNuJtGXpXDJDr38h5pVE/3FMwQs7tIuvRoWjNrInqmudsKeV402pis1BQHF
         DnlQ==
X-Forwarded-Encrypted: i=1; AKwUvByQGeStOIXwUVRlwWH4irklmrDL8n6YrSQEM7sFVKobgXynerZqWC+yXvRtAG5kYlMHHreGMWbI@vger.kernel.org
X-Gm-Message-State: APuU4Z+jIm7XGQb1NZOPHJZQEUA94YUVwCM4kslJqz1dqbQ/m11Ys1kG
	RWgSZsByCsfVocYQN0NjJPzV8lzADqi9ZcVvRrL3J+JwQS6OeBkcFZzHvj8p2PVMIEp09YkCq4Y
	VF12Pw5WB173HZ9MbCWhovz/ksVHa2EM=
X-Gm-Gg: AYBFou0rutVhADhCuSdADM6FkdX/NhoFGGwNMWcreY2Wrdn00U9rD6tTDjk5z/q1Nyy
	7N9TtdKae39DdAF35xG+E8d653igtOwPwV09I4LButAvyutCG4fkB3xup5tQrlmgrjxCVJjkmK0
	/Ds8J/lwccv24ibXbZ4rKE/lAI5fuN6MWXQnis1MiCdxzHgaRWVe0vZzJXF+bbcbd59XIz2ewty
	j4s7ZgZ4df5xM8rPdgN3daSNla9PDWGw+hHS2dpKoVq7FOfUBzHjxJkeZ5ZndYTN+tQTm6lTpYe
	IbIt9ETgntEZ5PErufpZFkWH3U+dJ3RDI5iTgMsLEFIfcuZz93fTB8JQ9vrd7Mo2Si2qqlmmn7T
	6G7bwmzWdwi675IJCy8UQ+O0SQARrsBrXjctcX6h4b1KIZL9Ibz6JQ9OemspD+u7F0jVbzXaivj
	nGgADu0lNRsveMXFq00qq6HWme4aDi77upw1MEv5oOR/F04Vfm8z6E
X-Received: by 2002:a05:6000:5c9:b0:48e:75f:477d with SMTP id
 ffacd0b85a97d-49273e5b2eemr704427f8f.7.1793900342253; Thu, 05 Nov 2026
 09:39:02 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com> <20261102225030.2743129-2-joannelkoong@gmail.com>
In-Reply-To: <20261102225030.2743129-2-joannelkoong@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 10:38:51 -0700
X-Gm-Features: AclHuK-snOd3ku1r5RN2yfgSJS1XUyMqGhPauQIZ7tv5ax41vh5WTgomz0EDQZ0
Message-ID: <CAKEwX=MBdWEuKZhi_g3Rq42ytwmn7h3DbVhHHmPjOtVfAKceTA@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, shakeel.butt@linux.dev, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, chengming.zhou@linux.dev, sj@kernel.org, 
	david@kernel.org, ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:51=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
>
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
>
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
>
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.
>
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.
>
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>
