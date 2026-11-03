Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700032;
	b=IWVFnCR25g+MAxGosGnKXFF1OPIwKz8tQl5M5P6ewq/PRHyVdBMGH+MX1MC6PZlYDwQZ
	 M6Cl1itP8EbnPXb7O0U5eVXg4buk0wMKFqXLeMgnHH00Dbdua7CiGFsnaR0aY9LernaMS
	 MiKV7Vjyeu2zcGzi8KHsC9k6XIarrgTy4kMCBXv30jW/WzZ9fUuNoBKRUYseDLJK6oOVe
	 XfAUGN37wQtcjTjfSGzQ8m9IV4lq+ZqH3PmuYnzWpRSKNGg34NcpMqnzru3y3NapEvKVg
	 0xGBZsFRViSst54HetG4yBSsrUr+6qYogZIS8HFC7DMgyfCWvadWyI7VurR5nksrNLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700032;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5eBsKnOAtib/53cPHq4YDPTfnBHbrb23tyc46Pd1NRs=;
	b=S9TjzaR2TAfBNFNpa+oUi9AbRhx3Hn3y862lqtf4+enTna8vleptZ6dOf6m0T4uRMWQA
	 YC807qc4jPQOHCGFkxp2w8324B0lzxWodP65H9xh1c2HiEkrAMJEXE2Jj7ouv88O0fwt5
	 wOhCiFRF1G9WLswAARbHUXJYLju8LsLwdFVpyINSusLgb72yy00eRrQnhwNdSaYPRB2i6
	 PgYmRrHameZmLtR3FZRFnMECf3G7fwyuNzxvYroqViRDpVQCKSP1s7m5TWg4d3HWGUpvs
	 oe+4Ca9Tod+7Qrv9HUg5j78Rn8TBGzQs9jdX1SB5rFkdPzybabOVNMxERVcrxeguyrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2B606A82F
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 10:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09A51F00A28
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 10:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700026;
	bh=5eBsKnOAtib/53cPHq4YDPTfnBHbrb23tyc46Pd1NRs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eiSil1mqSE0j2PYtwUbO9UfsvsIc5feXXEeOV0FGZxcqNNvxcFFzgkmJz2YYlj5KA
	 W4xh6ZLH6hqIBcKHCrN/zbE+Nyix2wwVQh2jGgY9APgvDVsvgLjOBTOyyClHwvO/au
	 xbLkvvIHhYgbqAR0qXbZwlp0ztXzvvK1lTFj6O5wjuZOXUwx8tkp4fSciwzsrUhAQ2
	 Bh5v+AZ5LNxws7W1zrbh6S7jUGTtlLIsIA3WPGQLMQtgFidT76LzNqYUg8xD1uKKcS
	 olKLS5u8FGkqrefsr146rJBCUIXSysi3dMug3YD64IteAWnOz21nM6rO9eDwY5o2oN
	 MDpFozkxNK7jg==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93cc1ab5f6cso477981385a.0
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 02:00:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxG8Pm3KHAmxDaW0bEeKCCEYYxvd21Tszy75LgiYYW305Q3g+/cr4H/VrKG4GOqqkNlGOEiM0V3@vger.kernel.org
X-Gm-Message-State: APuU4Z8YzUK8dCXe1CMilAPJOZNQ+ZAnerRVU8a7MQWwFW41S+VOYuZ/
	zFFWcr9MHCoM6fNR1MsX8fxn5K8KCcGk8pbWTQJfqfhJNDID/UBCqajGzDg10Ix2miesVSiplvQ
	qdEebXJZ19GkezNOkNVO48KjSlYE5gA4=
X-Received: by 2002:a05:620a:7303:10b0:945:b101:67c1 with SMTP id
 af79cd13be357-945b10169d1mr751687785a.24.1793700025088; Tue, 03 Nov 2026
 02:00:25 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev> <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
In-Reply-To: <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 18:00:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
X-Gm-Features: AclHuK-l8OdgfBebeJ7I2lXBHNEFb91IlwAm3Z2gmv4eIjSIYhVp7xL_4GoZss8
Message-ID: <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 4:39=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
>
>
> On 11/3/2026 2:48 PM, Barry Song wrote:
> > On Tue, Nov 3, 2026 at 10:58=E2=80=AFAM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> >> youngest generation. There is currently no tracepoint on this path, so
> >> the moment a new generation is created, and how the min_seq of each ty=
pe
> >> trails behind it, cannot be observed as it happens.
> >
> > We might be more interested in why aging is triggered rather
> > than the exact moment when max_seq is advanced.
> >
> > With your patch, we get:
> >
> > ~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
> >             a.out-93      [001] d..1.   278.276539:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D4 anon_min_seq=3D2
> > file_min_seq=3D1 nr_anon=3D{0x0,0xf016,0x12,0x0}
> > nr_file=3D{0x1886,0xb,0x4c,0x0}
> >           kswapd0-50      [000] d..1.   278.422400:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D5 anon_min_seq=3D2
> > file_min_seq=3D2 nr_anon=3D{0x5,0xccb6,0x3439,0x0}
> > nr_file=3D{0x4ae,0x4f,0x55,0x0}
> >           kswapd0-50      [000] d..1.   278.508003:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D6 anon_min_seq=3D3
> > file_min_seq=3D4 nr_anon=3D{0xccb6,0x3d29,0x1,0x0}
> > nr_file=3D{0x0,0x59,0x7,0x0}
> >           kswapd0-50      [000] d..1.   280.046056:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D7 anon_min_seq=3D4
> > file_min_seq=3D5 nr_anon=3D{0x3bf3,0xcbbd,0x23e,0x0}
> > nr_file=3D{0x0,0xb,0x1,0x0}
> >           kswapd0-50      [000] d..1.   280.124876:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D8 anon_min_seq=3D5
> > file_min_seq=3D6 nr_anon=3D{0xcafd,0x3e31,0x0,0x0}
> > nr_file=3D{0x0,0x5,0x7,0x0}
> >             a.out-96      [001] d..1.   290.629014:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D9 anon_min_seq=3D7
> > file_min_seq=3D6 nr_anon=3D{0x0,0x10615,0xb,0x0}
> > nr_file=3D{0x331,0xb,0x9a,0x0}
> >           kswapd0-50      [000] d..1.   290.653098:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D10 anon_min_seq=3D=
7
> > file_min_seq=3D7 nr_anon=3D{0x15,0xef23,0x18c4,0x0}
> > nr_file=3D{0xb,0xb8,0x55,0x0}
> >             a.out-96      [001] d..1.   290.684875:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D11 anon_min_seq=3D=
8
> > file_min_seq=3D9 nr_anon=3D{0xeee3,0x1afb,0x2,0x0}
> > nr_file=3D{0x0,0x76,0x4,0x0}
> >
> > You can see that the youngest generation is always zero,
> > because you're just getting the newly added youngest
> > generation :-)
> >
>
> Hi Barry,
>
> Thank you very much for testing and reviewing.
>
> > This somehow suggests that the information is redundant, as
> > there is always a zero there.
> >
> > I suspect we'll need an additional tracepoint to show why
> > aging is triggered and at what sc->priority it happens.
> >
> > But do you know why you trace the moment just after aging
> > is completed, rather than the reason why aging is needed?
> >
> My original goal was to pair it with mm_mglru_scan_folios, to see how
> the aging window of each memcg moves. The per-generation anon/file
> nr_pages were added following your suggestion on v1. I put it at the
> end of inc_max_seq() because of the restart there, as max_seq and
> min_seq are only final after that.

The per-generation anon/file nr_pages are perfectly good, as
they can also help explain why aging is needed, especially
now that we're introducing new code for imbalance-based
aging.

>
> You make a very good point that the reason for aging is also
> important. So I'd like to discuss which way is better:
>
> 1) Keep mm_mglru_inc_max_seq, and add another tracepoint at the aging
>   decision in try_to_shrink_lruvec(), reporting why aging is needed
>   and at what sc->priority.
>
> 2) Replace mm_mglru_inc_max_seq with a single tracepoint in
>   try_to_shrink_lruvec(), right before try_to_inc_max_seq(), reporting
>   the reason, sc->priority, swappiness, max_seq/min_seq and the
>   per-generation nr_pages before aging. The youngest generation is
>   not empty at that point, and the new window after aging can still
>   be seen from the following mm_mglru_scan_folios.
>
> Which one do you prefer?

Maybe we should keep option 2 for now. Understanding why
we are aging and at what priority is much more important,
especially since we're still introducing some
imbalance-based aging code.

It should be quite simple, just a matter of moving the code
around a little.

If we later find a good reason to have option 1, we can
always add it, right?

Best,
Barry
