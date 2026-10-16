Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB893AA1B0
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 06:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792131400; cv=pass; b=k9Lv+XdaSiaW4tWO9NEeEVuUXeDCigGyXZWfi3/du6lqeCokn7KNgcpk0Viyd1AWUQK/5QnxrI3392DdsfTkL2IalpAoi6eP8J538q6rIhu7YZTaQLwmTZkFXJ20BwW9aWarJoAshDBbXxhYK8x65ovs0MKeVItnuGc9knmqE2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792131400; c=relaxed/simple;
	bh=btnoV6CU2q0UBdK7jbLnMoo6ItmP18ZDQfYmAVaSBNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O0hK4gQpPfFdgzhn07yqrigGdheHeBIvkVdiA6ij42Kv/OgUsYGnRKnp3Itxgk/mP/HewiZxUNm41V7BS8DnQ1SZ0MQ3VX6MHvjdCKUIb9FZOXHWmG8DlM1EJCNhwfzUeP+0QkiUWNCeMv3NXMJ9wneqlgPFHA9BwA8wMOMzQ9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HLqSw+d1; arc=pass smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLqSw+d1"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-89f639ba307so160815b3a.3
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 23:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792131398; cv=none;
        d=google.com; s=arc-20260327;
        b=K6bXPHKiWfkDnvtfwb516VUL1FegeVdJ8lDESkYxNCx86+gW/1OMDF/3YOXUMaZAbU
         sbLxlkzWPn0/SIVM2lUc/LaqaUdZls26qt0J1BAJ1peGQiQNjr+fzwSzBgYJ0wAZYRV4
         FBnpIRbD6R1ozmC2mVZKdIlFX4DTgEAJGFcRqNTTGEwRBdVNX3v8nFQAH4u9JpUlcDSl
         ck4AJIRTUv1s//Z7+wVOVIswCBAm+SZfuDJDeld4Q52VN8C6DaGOUYupJKUfGoct1Eld
         CWYYk07r5HTYso05zA13HHcJXRxx7HKMAMAsi02Fq41g/lJPtUImbJTSKs+rxMMCmTza
         oNVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
        fh=QIdTbLI4V2OgkaMu0dlCyi9tRese0GWwdmwUTZbuXRI=;
        b=e/wAzm3g4xHxdVy/x6crTiuaIcPyl0g9oX5AYHF/YSRzEYCVfkyJe60NEBhbLOstEW
         pJvHh7T9UkbVk/Kv7tNXgOi7nmZe/h7RLMUfKkP7bj1/B5ekDTtwygCM456rfQifk6c5
         I7KX8ckDq3TK7P+lPjuLGy7yrnTrhlVDHV4I1mEG+H7bWnWVLv8Ayqqc/nsQi6vUY8nc
         pMqaWFUQbxEfIBrBWq2x+A+NdrAgqBSovi8Xu55v2rYfTC0kd4pS0Iit+opLw8iKZeyH
         6JjvW2CLJwANRZ76POBH9DYy9oI6I1dWeyjeIxFBthfhcxco8jidc9bCoQKhhDcmO2VL
         VWpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131398; x=1792736198; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
        b=HLqSw+d1c5BP3YfnQSbETX3F1bFbr1NwlertT1k0xGAN68/dGLHBFi4MjPBEmblQow
         rfYKoOr7uKTjk2RBD2MZZquiaZ1GJgwf7kXUMpwIr23BECbq0yIS2vna8GnAQbbxQHRs
         FyHUARSj5NdA+u/C5BjzFAZs46EQsd8tLaESvOX8SBs3BASBp6ZzRZJDXLjY7lbQrvq2
         TWAsJw8v0tpXlGJ9Z9xpAS2wBxxEvF+AdrRsu+hWM6tFjGMf1/bh3+HbxLoK4Dj48HfO
         +Ciyg9CPpL7wSOf6901qidksaVg2UDm73By/h1QZ6im4OW73WnmF3DUR1zBFXp4MumoB
         WYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131398; x=1792736198;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
        b=wh17ztuhBtwsTwz57VWvToU93+UGufROIV0WOlqnWCd8qeTnG8n7RgeULIZO1cYiMf
         UsetElTB9LHqmb58z11fWsjWtGkskhPndzJqzCdXZ0wxOsIsiJA1e0PZrPxlUuyh+rEQ
         EKkvCednSLh7YsMK8fFOxjjvAvZv3z6E+OOkXu5nL6d807snA1v0lRKBO+fy+5oxtqII
         eycwaPbenh5QgGdSp4Nb2Av+lcU9j6PkdcL9haeKMnySg2NiWcrVlcwdLEHW9qnZKDes
         BOnFEwNqZM/EYDEplJZMSjM47VpuXgWfmch9RZKcrTWIVmmNXN16J+BDxKrgVRfnqONL
         Nvtg==
X-Forwarded-Encrypted: i=1; AKwUvBxfrQMVj8+awUwZJ00Nx+URdQWdF27Tcp2bmFCRF6zFTXgQMb+XWAUNeoktHuneHbAhy8Qj9gY6@vger.kernel.org
X-Gm-Message-State: AFq9FYIiGM7iJhQAcif73hvhGbIMLSh7w4KY6f6FpxIdd7Sb7kkfSc5Z
	MJXfVyvcwFGc1+vrrjQvD3TYMAwpOgM3Tuepj9uIaK2m86iaTfn8jt6YF31kTZjtfp6KTW0r2Q3
	QhhZnVWaQbamctyiNXiv+6dgetJ7BEwo=
X-Gm-Gg: AYBFou2qe9ziEnJX5enE3VkEAbHkUJPzs9L4VXUpSavdiRiX7LKCPWf2LLi8rpW7CeW
	2bSWiN0oIje67/47q9UJB/rzAchxPhboWdl98m+XmXc8T88Y4WVf5UmSjL2yi+MkdIvB7yvBTCg
	dP7/OEj4JFR51XBNfXd1GnqLOJcH91nRbGJh/GohfLP2SnYBxastGvizlHJkZk1LsTo8u8hb5Y1
	D75bSvy4hYFGUMBniPc3A7eWiUAa+JJse0zHVlsxmoZFjLd0gCrx59j24lD968qP9ZyoJV25CJe
	YV9uQ5x7QpawyIy4BcZ8i5SXaPZ76vBZWvo6Y7CU+Qss0mWXIoWGC3dtbEteY3v8EcL5rHw0ZV6
	rPpk6NfAQnbkN3rEh/ilDDH+BpVF5FVXEkZIKNxeYZzcZNwlhRLpEoVxkfeADK7FzBRGxyA==
X-Received: by 2002:a05:6a00:3d11:b0:88f:9fd9:3779 with SMTP id
 d2e1a72fcca58-897c65410bemr19217680b3a.19.1792131398279; Thu, 15 Oct 2026
 23:16:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com> <atEkfmRFgXJCbJuK@thinkstation>
In-Reply-To: <atEkfmRFgXJCbJuK@thinkstation>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 14:15:59 +0800
X-Gm-Features: AclHuK9suf2MtgpJ8U-2R0dSol8SG-UyxjWNOAi7XM84G6vCwX9BAPJIIlEtxbI
Message-ID: <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
To: Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 3:11=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
> On Fri, Oct 16, 2026 at 02:15:52AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Add a helper that resolves a stable lruvec for a folio under RCU
> > without taking the lruvec lock.  It takes a folio directly so the
> > lruvec lookup happens inside the RCU read-side critical section,
> > which a lruvec-based interface cannot guarantee.
> >
> > No functional change.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> This new helper is doing the the same thing as what
> get_non_dying_memcg_start/end() do.
>

Hi Harry, thanks for letting me know, I wasn't aware this helper
exists, this series started before the re-planting work, so I missed
it.

But it's a bit different though, get_non_dying_memcg_start assumes the
caller holds a reference to memcg, while folio_lruvec_live_get only
assumes the caller holds an reference to the folio.

I'll check if I can deduplicate it though.
