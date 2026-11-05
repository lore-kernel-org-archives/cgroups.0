Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849643;
	b=Jy3TvEC9MA0fvaMJn8LeIgCvYnpFoUcRhO1NXs83hExPQjAoGGAxFWJLk5XV8/pzCvye
	 WuszmBj6YM+arKSsvhjmgUYBsu37MaHDQ79+PLmzH7+I7R/NiCmZJFb0/Tk7WHgodwjfZ
	 ji+VODfe7QbJ6tV9Xm1DIWuwyS5TdzneYfmllE06RNL7YBSvvfmXbqY/n0hFFOhCQe2DX
	 K0Fb3EurfvYpIwHmnPWQ2dYNPUyEg/Cvq8PUQTAsGHKhVLeMpsfcg72BdsshrMK9LxrK7
	 yRlTInsiL6QIEyMPlEMcTsxmbcw6NaUDRKiABCVt8/r1zYuQqItA/WmYxTMv6RuHQlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849643;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=l+Yp56smGIs8eBVmZ42TlX/QjRgKCo02jmsCVaG2LHM=;
	b=Vn0karF2baJKh2zJvAgkVzbcfVsud5wC/Ok0yXtVmj5rhbutyS4RFUid9OsHcg7+lV91
	 A68I6xyY1DuJvfcwyhIoiZSbi91/F3ziXM4rhrmMo6W638VOiuMFHZGOxgh0EkiAyfpuE
	 t77Fd+f5WPf/MZ8o18lZntEqtn7s35hGo4GuQcZsc/KELTPe42gm41lYI7nvGjLCCvsVN
	 /HQlCQoekD1TIL3ICtAPfA8nf9UcYfDsDdc8Yh1XEBEPB0J3XtmlGo6pp8K7oYfoEbO0C
	 5t38xw6yRJeclJ1/o5QfqhrhvU3ob2tIZkKkNLjAVCgw53/cs8AZTApbLid1kZe3Mjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGjYA7GK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD050606A31B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 03:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGjYA7GK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3B51F00A1D
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 03:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793849642;
	bh=l+Yp56smGIs8eBVmZ42TlX/QjRgKCo02jmsCVaG2LHM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YGjYA7GK343Pjnrfl3nofa0xcvg8KD1pXJekSNdyyCiTvYVtawW3B5HsQyMsage1F
	 j4Drah6q6VlOF5mqA0cMvykdPH7q2jFJADU1qs4r/jM2c2wVcGsEaOhL6I1NT4r25v
	 yBzXn9kmVUfdGUZMMwIIIWh/2jJPZ7YlCRQ5touqvXt8CASPKZOkADXbUvuBi1p0Xm
	 kVwX0CvQCqnjUwipJd3dRGy/W2npv7BntvX/KM95lwaL0ZMg9D+7JUJbPrtfVAMLsg
	 sBfpQyW4hrdzahpG74ElKjd4UP4l9N09jpRCho70txcS/HaXse5J0hJg4G4jmDAnHS
	 rMVggHotSGVrg==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91c6ce60697so18650356d6.3
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 19:34:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxrZXbwkAbjAuE/BCUH9uQBmG/Ok3Vk8iW5oJMIEKoqsnUf4MRKwgNR/j82//iiRUmN9VvWcU7V@vger.kernel.org
X-Gm-Message-State: APuU4Z+r2eOgYTJ8mTho4+AVKlyKxultpss5wMJjHmJbFo/WBMsWv38Y
	XFfW5v4Q9xfiXILwcmId+pAtvCPkJNPI+JEtrTjmc/ThOEpTBxFd7Y0HoefY60nBgcxIP0MLl7P
	ivI/CbgZB6dxtdE/ohfpwH6xSPUl+Jrk=
X-Received: by 2002:a05:620a:3720:b0:93e:fc02:e8d4 with SMTP id
 af79cd13be357-94421630bedmr3380444185a.27.1793849641568; Wed, 04 Nov 2026
 19:34:01 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104130817.849089-1-ridong.chen@linux.dev>
 <20261104130817.849089-8-ridong.chen@linux.dev> <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
 <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev> <auvisj8NeTJ8FunG@MiWiFi-R3L-srv>
In-Reply-To: <auvisj8NeTJ8FunG@MiWiFi-R3L-srv>
From: Barry Song <baohua@kernel.org>
Date: Thu, 5 Nov 2026 11:33:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zVwLMRKOOGycVfnGEjxwy3wO8azyWD4YX6+d7DpAypzQ@mail.gmail.com>
X-Gm-Features: AclHuK95QOPSEjcqkBAiK0QpfFcwI57KNwsmNgJhbn3lT1vePCwCD9VdxFwjbS0
Message-ID: <CAGsJ_4zVwLMRKOOGycVfnGEjxwy3wO8azyWD4YX6+d7DpAypzQ@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
To: Baoquan He <baoquan.he@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 9:58=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
[...]
> > >
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> >
> > Hi, Barry,
> >
> > Thanks a lot for testing and the Reviewed-by.
> >
> > Updating it would be fine with me, but I'd slightly prefer the current
> > output, to keep it consistent with the debugfs lru_gen_full file. It
> > also prints a fixed window of MAX_NR_GENS generations from the oldest
> > to the newest, marking the ones below min_seq with 'x'. The event
> > reports anon_min_seq and file_min_seq in place of the 'x', so the
> > generations that don't exist can still be told apart, and they always
> > read 0. Keeping the same window and order makes it easy to compare the
> > event with debugfs, e.g. when looking at both while debugging.
> >
> > That said, if others such as Baolin, Baoquan or Kairui also prefer
> > printing only the existing generations from the youngest to the
> > oldest, I'm happy to send another version with that change.
>
> I like oldest -> youngest a little better because when I am thinking
> about MGLRU logic in my mind, I would put min_seq in the left, max_seq
> in the right, then wrap around from right to left.
>

OK. We have both left-handed and right-handed people
in the world. Somehow, I feel like a right-handed person
trying to write with my left hand when reading from
oldest to youngest. But I'm perfectly fine with that!

Thanks for sharing your thoughts, Ridong and Baoquan!

Best,
Barry
