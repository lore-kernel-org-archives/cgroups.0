Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126D519E16
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750617; cv=none; b=T/7l3tLcEmHJOLQiV4xy9TSkLlKBqImUEtRou+BhpZryANb8s9OnxAzXgHjoHqmSTkWeTrwlsnkePqxrCks08FUIx3w2/xyosj0bSFv7b4Njo3Cmf4sVNeea8g6x7TFziM2BOtX75oZO/FNPZTyVcJqz0F5b0z0WAkCez8WAtQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750617; c=relaxed/simple;
	bh=TSyTJvkqaPMNE9NUr5ytx8YmL6TBT8EihcFtZo4cjmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtaCLF24qSBZ+GDLJPsu2xN9lH/PuBQNe1MdfqHXfPash77VELPYVSIbi14LqtjylDw3xbJCo9/8srbdPwb27A56cLqia+Oh8KOAg65KL/oZglTOqw3HIBcXh7hMuR7tXPhCDYQHCtLHiSDVzAUU78/gT7odJb+HY5Y5JitLRz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lQgwG7nH; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xKVlXRjw; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lQgwG7nH";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xKVlXRjw"
Date: Fri, 18 Sep 2026 18:56:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789750613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=emdDJKcEKTGGLQ7h14SrN3QAr0euBcRN0XPBQmBSILE=;
	b=lQgwG7nHAtdfoal/qo2RXooU4cd8/pzoZTMqk1eVnqUDArCnPyqab8r1lm5tw4I5c4JEr/
	KyKaor2UI6rcTYg+bTqmEYr+QuxIL8r0nnQncJ58LMBi4AGqbxudicjEro2B8QKW1wePL0
	2vTRO+M1KFi4EhfCn9j16Y2WKoAYP4iS78dq1a1lEIzeihUGJMDCD9ppDFdBNQ9PrTrhOS
	U5QjpP7sgbT/gk6k0wQmtyn/hGlk8Z+BvMrCEoU3tQB49AWqHldlKH0NAULnwLWCsrTL76
	hHfawkk+6HQcxnOHFYqYvEsb1dyQP8khExIP4DcvQRypbOVLTIZrqemgSHaO/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789750613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=emdDJKcEKTGGLQ7h14SrN3QAr0euBcRN0XPBQmBSILE=;
	b=xKVlXRjwL3gT2XT1PhgNJK5O1FRS9n4HRS4EjK5nxEfXkzHS4s2cFJc557MNxN/5+hNzhJ
	FYkrc9RifU3YX6Dg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: Use %p for pointer formatting
Message-ID: <20260918165651.-T6A2FGq@linutronix.de>
References: <20260918104852.1p2fz_-_@linutronix.de>
 <aq0z3hEYggA_TuUD@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aq0z3hEYggA_TuUD@localhost.localdomain>

On 2026-09-18 14:59:00 [+0200], Michal Koutn=C3=BD wrote:
> On Fri, Sep 18, 2026 at 12:48:52PM +0200, Sebastian Andrzej Siewior <bige=
asy@linutronix.de> wrote:
> > Since commit ad67b74d2469d ("printk: hash addresses printed with
> > %p") pointers are hashed by default and the behaviour can be controller
> > by `hash_pointers' boot argument.
> > The policy on %p is to not introduce new ones.
>                 %pK  should be here?

No, %p was intended. By making it %p it is "introducing" it. The "not
introducing new ones" is based on
  https://docs.kernel.org/process/deprecated.html#p-format-specifier

> I assume it based on:
>=20
> | This is because %pK checks are done at read() time rather than open()
> | ...
> | The correct long-term solution is to do the permission checks at
> | open() time.
>=20
> of Documentation/admin-guide/sysctl/kernel.rst-time

These checks never came. I need to update that file as well=E2=80=A6

> <snip>
> > Removing %pK makes it possible to remove its handling from the library.
>=20
> This is also a good sell.
> But I see there are a few of them still here and there.

I am working on it ;) I just sent all code patches and networking
has it applied in -next. So it is moving.

> >=20
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  kernel/cgroup/debug.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
>=20
> Nevertheless,
> Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>

Thank you.

Sebastian
