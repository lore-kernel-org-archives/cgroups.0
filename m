Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793481701;
	b=Ep3++5EFinPRRTzUboTEQRQ1jNHF4tquuDvAgD/am30KTQ1sWY5XygEIm4mtQAZsDZue
	 +1LL3NA6SegE4zNiBrr2xwdbryR5AaSIf/0ROYz9BqJvlLCtmcJwcKPV/2I9Qp5fa+pMz
	 sD/YjU3LeHmNmjKTFnFgMn24MssQOKCsHdnjkUjxS3cOA2ANnzAk77ih2cO2Ix4BSoz1G
	 4VX4i2qion2M9Uy5IemBY6yIYo2/YBpS9j0+SBsW1eGUhzAcsoIbzLbQWjrACoRSbOru4
	 XoXbNqD0g+YCqBX6yiv96mj/sJeSHaSWDSN9JaPWmRhSyRPYVc/vimwZGG7QKllg2gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793481701;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ty94gSbhmDD5BIMgrsH4AK83dBi7LvnXvW0bmqOEn6Q=;
	b=YEsLn3EHnWqdcoh7qHkLHRo4ue2hC/U84YJ/7L7ELSM/yf6a/IMUD6ZJX134ftAkKnN7
	 vnKj8DJyC900Nn2DzywgZWR1r04sfZO6vyomLB38YQlA5odpk8NROVXcnkiD4Av29wx8E
	 PVzlQ5bBaRTFGV48RU76Ie4O2opy1iO+7WaRWGVsCX6S+mRH/qMEk4PVgxw6zDFsahO/s
	 3ZAOP4rgUFLowUzRw/y14tEtvxmrjX6uYVuQ1vfXmq91ZcNUy67gLEqbIS74BvnYCwqln
	 ZSukufi+YIG7MsxTmHAxrVcz9GJihVCog5qULTE2nFppMOdt5ukyXhc26/OTB75EfzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgOEpBpX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C98A606A31D
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgOEpBpX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014811F00A20
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 21:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793481700;
	bh=ty94gSbhmDD5BIMgrsH4AK83dBi7LvnXvW0bmqOEn6Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kgOEpBpX1LsYBAVB6hT/TEvjRTxXkDHPdjkVsNZjGEc1DltRtW/mCjPpIVTO6pZCP
	 eVEzWE+mFjHaf4VLcrYnv/4L2gBn3zffsLPlnaXBV2w6Z57NJ4+NtY4C/rKib1edHH
	 flRKy+1HtQOHla7hFeJph4xAmXwtuLDYXTuFlw5Bh81HckwTbSVE5gz1OYRZmLAMHU
	 mHqf7cV/rHCchcNWnBvsZQx0zOg9kDMZE5enYtyFgHDOTtZMLYZ01jAUWBGaLdNafn
	 KpaQ0AJCs5VCh05mmrlgwy22ms8I+8LbgmOlTSX1NsUYCj4rt5HjEial2+f/mzC2Ta
	 wRtRI9G4Xa8Fg==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5364c951da4so17793021cf.1
        for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 14:21:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx3YMuoQlkrwt8ZUDsDXBcA3Deb+k0ULHL0fgTBuH1kbnQOF/D6KRv3b+1E+vTVv5NLFCsl8pP2@vger.kernel.org
X-Gm-Message-State: AFq9FYL2UdVDw7nwMvStEFncqILBGz52UBYnbuFVcooubKEQctectNZU
	bGelkI400DeTXgdSbZDO/ZUzcxCw1ZIQ1zOnIRh9dKicynQfqNFBX5J0fKRIG0/tUYyH6lRRNXy
	lIstZpn/M1bbvuKM/GvVo3YX+eSFTkhI=
X-Received: by 2002:a05:620a:1a04:b0:93e:7939:acd0 with SMTP id
 af79cd13be357-944216bd289mr1066244785a.37.1793481699158; Sat, 31 Oct 2026
 14:21:39 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031090041.58574-1-ridong.chen@linux.dev> <20261031090041.58574-7-ridong.chen@linux.dev>
In-Reply-To: <20261031090041.58574-7-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 1 Nov 2026 05:21:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
X-Gm-Features: AclHuK9WNH9aLICSgSeVZV5too_5MSDmgtyvPVk6Q01fvL_ZF8MPvPlJAdKgm4w
Message-ID: <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 5:02=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> youngest generation. There is currently no tracepoint on this path, so
> the moment a new generation is created, and how the min_seq of each type
> trails behind it, cannot be observed as it happens.
>
> Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
> the lruvec lock is still held, with the node id, memcg id, the new
> max_seq, the anon and file min_seq, and the number of pages in each
> generation for both types, summed over zones and clamped to >=3D 0 the
> same way the debugfs lru_gen file reports them. The nr_anon/nr_file
> arrays are indexed by generation slot, so the emitted max_seq/min_seq
> say which slot holds which seq. They are printed with __print_array(),
> so the output is hex and its length follows MAX_NR_GENS automatically.
>
> Only the lruvec is passed in; all of the above is collected in
> TP_fast_assign(), so inc_max_seq() does no extra work when the event is
> disabled. Paired with mm_mglru_scan_folios it makes the full
> aging-to-eviction window observable per memcg.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c       |  2 ++
>  2 files changed, 49 insertions(+)
>
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index 8148b8224422..cddf42b5849a 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
>                 __entry->min_seq)
>  );
>
> +TRACE_EVENT(mm_mglru_inc_max_seq,
> +
> +       TP_PROTO(struct lruvec *lruvec),
> +
> +       TP_ARGS(lruvec),
> +
> +       TP_STRUCT__entry(
> +               __field(u64, memcg_id)
> +               __field(unsigned long, max_seq)
> +               __field(unsigned long, anon_min_seq)
> +               __field(unsigned long, file_min_seq)
> +               __array(unsigned long, nr_anon, MAX_NR_GENS)
> +               __array(unsigned long, nr_file, MAX_NR_GENS)
> +               __field(int, nid)
> +       ),
> +
> +       TP_fast_assign(
> +               struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +               int gen, zone;
> +
> +               __entry->memcg_id =3D mem_cgroup_id(lruvec_memcg(lruvec))=
;
> +               __entry->max_seq =3D lrugen->max_seq;
> +               __entry->anon_min_seq =3D lrugen->min_seq[LRU_GEN_ANON];
> +               __entry->file_min_seq =3D lrugen->min_seq[LRU_GEN_FILE];
> +               /* summed over zones and clamped to >=3D 0, as debugfs lr=
u_gen does */
> +               for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
> +                       __entry->nr_anon[gen] =3D 0;
> +                       __entry->nr_file[gen] =3D 0;
> +                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> +                               __entry->nr_anon[gen] +=3D
> +                                       max(lrugen->nr_pages[gen][LRU_GEN=
_ANON][zone], 0L);
> +                               __entry->nr_file[gen] +=3D
> +                                       max(lrugen->nr_pages[gen][LRU_GEN=
_FILE][zone], 0L);
> +                       }
> +               }

I feel this is wrong. Can we calculate the newest and
oldest generations from seq, then print them in order
from newest to oldest?

The nr_pages[] array isn't ordered from newest to
oldest or vice versa, as we have:

static inline int lru_gen_from_seq(unsigned long seq)
{
        return seq % MAX_NR_GENS;
}

And I added a helper here:
https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/

+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+ int type, unsigned long seq)
+{
+     int gen =3D lru_gen_from_seq(seq);
+     unsigned long size =3D 0;
+
+     for (int zone =3D 0; zone < MAX_NR_ZONES; zone++)
+          size +=3D max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+     return size;
+}

Maybe you could port it here as a separate patch so it
can land earlier as part of your tracepoints series. We
could then use it in the next version of the swappiness
series.

Best,
Barry
