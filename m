Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD4379C3E
	for <cgroups@vger.kernel.org>; Wed,  8 Jul 2026 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783537694; cv=none; b=pZxRpZDCSSac9HsLYUO6zoblPeaBgAWqi6nyEfW5tdDwWtK0dVZdlHNDy+evitGySPz5Uu9iLo4CkO+Rn4Q0+XK73XnjjB8IxC3MnSh5Ksw681vP+YGPfdPVOrBVkzTe0rnY7qvircu0Y0Q3iklNeO4vu+xozjG0llk4hJ31o9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783537694; c=relaxed/simple;
	bh=yiBkA9xQHooEcgjjRAQRu3aK1yHlnq/UeMyE5vEXoEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vpad8HI0fTDzfelMYaaTNgVcYdauw+XB8f36SQIHiUhncePNYJf3Q6Bcqb3mxgYe+hbn954kQd/3dxOdLKsW2HPwNKTT17tlZUavce8E7ZecpaJkdR+UHmixA6CpSDp9Gv7GWGCEBtyPKdGLQjfDLM387rKAxZ9rWY28xVZzpwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JX1w5xxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JX1w5xxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C391F00ACA
	for <cgroups@vger.kernel.org>; Wed,  8 Jul 2026 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783537693;
	bh=yiBkA9xQHooEcgjjRAQRu3aK1yHlnq/UeMyE5vEXoEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JX1w5xxlZ7d0rlN3bIaPU9Yb1jxSFKZfedoZtGcsE+sngcvCXrnoGwvc6MLooVNXE
	 4lA6rIFmchXAe7hNCyBX8Q5pkx1k4Nfaf1+47IOHiUfIvJl+FlMRueQE3BgIddpBXR
	 LiJn90bD6okxSyv2Sss453Tad72ouC/YgBsBIMGAYNhI9ZFC2jmFEZkjY8nZMoH1VY
	 OekxpQz7JVsB95w2OJHIuUxinRS8BEEGD2hr2FQ8StOUHpJGvJRg1zt/F0dkPpkHge
	 K1yY/II+hKH8H8S905VbpHaHmTCtKTFlhoIr+CIzH/VFfsRfzDldCEexOA4S485F9v
	 9b1fy5gC18gbQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69532288224so221810a12.0
        for <cgroups@vger.kernel.org>; Wed, 08 Jul 2026 12:08:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqrpcWUioYjscn83shLGDBgBL67MNJsVIfkOyyMNWJugBOD+B2Nt41gFalOLU+fmpiy9d+EEhUd@vger.kernel.org
X-Gm-Message-State: AOJu0YwwNbU1vrOzVcNpsYgOMeM4iOlEK5awrtc74JvyL7xtT0PF0rKp
	2e+SGu69fVGQ2Bh+BfWm1IEpV4baFmzMNqp2Rf/gm11UQjIZvtfP8ckY6/yOWz66YxZWWzlAeOG
	eoiQn2XJJOfh87WiHXuTblmFejcPAJTo=
X-Received: by 2002:a17:906:c14a:b0:c05:b9db:68cc with SMTP id
 a640c23a62f3a-c15cdc8ac7amr170635966b.0.1783537692118; Wed, 08 Jul 2026
 12:08:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
 <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
 <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com> <ak6c2TaOlcGxZ2Ih@localhost.localdomain>
In-Reply-To: <ak6c2TaOlcGxZ2Ih@localhost.localdomain>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 8 Jul 2026 12:08:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
X-Gm-Features: AVVi8Ce2aMsGuquiDYnmvYMN9gnK32qIskLfiFxzN_JVMoIyoVCs7MHxGrMZ-QE
Message-ID: <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	tj@kernel.org, Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 12:00=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Tue, Jul 07, 2026 at 02:49:56PM -0700, Yosry Ahmed <yosry@kernel.org> =
wrote:
> > I would honestly rather use more memory. I think there might be cases
> > where the flusher is delayed. The flush being slightly delayed is not
> > technically a bug that we want to see a failure for, but if a large
> > stats change is not visible that's a user-noticeable behavior that we
> > want a failure for.
> >
> > WDYT?
>
> There's already the (recent) page size-based scaling, so the idea with
> nr_cpus scaling could make the selftest useful on wider range of setups
> (even page size can be considered as a slight implementation detail
> leak, thus the justification of nr_cpus dependency).
>
> Also, I still think that internally the threshold should be changed to
> the "harmonic" formula [1] but the selftest can go with the linear
> dependency for more pronounced effects.

Yeah I agree the threshold formula can be improved, but we need to
make sure performance doesn't regress.
