Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4368B48033E
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783461012; cv=none; b=qG7DcZNIfBBQzpcfC/GD78vXMPvwUoJpx8bxXBZJm2Nv0QGmkfqVRyP2ulBJLQ9yMKst80pVEOQ2zArdcQXz8r8Zc/rKDY3O4FRGN4BShwll9E1q55bFDQAdCpUWi6GwTVaJFNzVn2I/OvfeKxnKAAvtELPAP8HUS0WKLwAtERQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783461012; c=relaxed/simple;
	bh=/Hslq07Rv05EgItP7vGw5o1P7WVmqMuQLrNi01fX+zY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HYD28PQXsqLe4X/czDXH9Y9S4+vXUEe2fDa3vXTY6vyg5S5bnPRkWZq9S7VRYL72btyNIDt+7HLTGg2eA+88eQ8T07n6rKtioLTczif+fO/C2UigMp7KhwRm1McSqsq8tjKr33TGBFKVOxxx4GByr+aU7drTxv9NR5bmSMxOprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZ3GlEMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZ3GlEMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17041F0155C
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783461011;
	bh=/Hslq07Rv05EgItP7vGw5o1P7WVmqMuQLrNi01fX+zY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JZ3GlEMqtiUB9XFTunsCXTWYS7vIfXduoZLuI3cfc36W4qvGDr7v9cJjJDibTNWf3
	 SECAogVWu3465/3j2OO6fpSz7jAde2KXOiaISORJAIfYXdOhegp5m14w75lNUOhR14
	 yAsJDVuk2IZyjH7XikfEqHAwFZmHLSK8ns7xYDJcmobnt0g/VEkQwpitoNokADWaPF
	 QA5Dga33fCCSBYi52/2xcaY0AWhh56OvLSXstr/Xd/EVNE+fVXRJ37kbKabjxqfzlZ
	 +fmWb00nZaKphagU1xNnZj6ztt1CtQcRYfJ+86ONcI9mTZT0v1Pap/GhWzSky987gh
	 7Hz16xojJMLBg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6989c0ec3c5so46296a12.2
        for <cgroups@vger.kernel.org>; Tue, 07 Jul 2026 14:50:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrEfzqWvLEX2VqyQ4ePl8yC4pbhx+vy3tzc11Y9MWibFc7xBCasMXbZTjj6A815+5rI29mh7uKU@vger.kernel.org
X-Gm-Message-State: AOJu0YwqY/PElarN7wfCz89/bmoFwhD+lkOS0BtLLanqbQTe/OcA3aH6
	74WIyo01yTIhwAJKOqe2V+b6iIMBBldElsiizfAI3XrgQoT+7mzRsPDy2SJ9GBy5BGMHlawYxnr
	D4V8WP3LFs2trmZ3U5fTRRx5e/m6wr0s=
X-Received: by 2002:a17:907:9811:b0:c12:58ac:9869 with SMTP id
 a640c23a62f3a-c15a66b3229mr385276966b.9.1783461009836; Tue, 07 Jul 2026
 14:50:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com> <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
In-Reply-To: <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 14:49:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
X-Gm-Features: AVVi8CdZcEOfGuDZGNSV0M6zgE9Yv3CDLB_P91llgHInNN2rTx5aaFTXo4dLKK0
Message-ID: <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Nhat Pham <nphamcs@gmail.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 2:47=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Jul 7, 2026 at 2:36=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Tue, Jul 7, 2026 at 2:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > >
> > > > On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux=
.dev> wrote:
> > > >
> > > > We were discussing a way for userspace to explicitly trigger a flus=
h
> > > > before, which would come in handy for testing. However, we decided =
not
> > > > to expose flushing as a concept to userspace.
> > > >
> > > > Unfortunately I think the only way to "fix" the test is to allocate
> > > > more memory, enough to trigger a flush on most interesting setups.
> > > > Perhaps we should scale the amount of memory with the number of CPU=
s
> > > > so that we don't have to keep playing whack-a-mole.
> > >
> > > I don't have a good idea for writeback, but for zswap out, would
> > > MADV_PAGEOUT work here?
> >
> > I don't think the reclaim mechanism is the problem, but the fact that
> > we don't have enough pending updates to flush the stats. Am I missing
> > something?
>
> Ah yeah, you're right. Hmmm.
>
> Yeah it sucks, but maybe sleeping (more than the flush period) before
> read is the only way. Which
> is terribly implementation-dependent :(

I would honestly rather use more memory. I think there might be cases
where the flusher is delayed. The flush being slightly delayed is not
technically a bug that we want to see a failure for, but if a large
stats change is not visible that's a user-noticeable behavior that we
want a failure for.

WDYT?
