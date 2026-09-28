Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38803783AD
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 03:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790565840; cv=pass; b=gOBCVq1HnOAT4K10VvoQGLnsaecq5doQYdKoWtPFC0Qtb98n4xiUadfa/7AtpajfkFy8QWSiXfj0IntlIWJghq5vES0o55F4e+ATPBHlNkQAYbx/LK/3lcmQjkJ5Y5rjcDCcHDt0lIqVmwCBHlkd65HiYumox0Ylo9SzPh5iiug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790565840; c=relaxed/simple;
	bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=op6oaQSYQDCg8XjLxpk0Rsoag8FIzqZuyw3tVJOKXqN9jHeBbcOtxqxuf0PkfOKoEkHlLRTBjJUQzNiLie9504EDkdNHRz99g3j7vfJ+hkQwgGyD2FuX0p0hmmBQnegpid8BGjivscGVYgJbVMuiLbpoabWkU+AFkPq7+fSlqKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qrxXDM8D; arc=pass smtp.client-ip=74.125.224.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qrxXDM8D"
Received: by mail-yx2-f40.google.com with SMTP id 00721157ae682-8a87fe69060so15798007b3.3
        for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 20:23:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790565837; cv=none;
        d=google.com; s=arc-20260327;
        b=JXAn4YaEdDpDoVgMKDvj8I9XS2qs0Hk4nUj27Rz/DdOX/xsMOcLtxML5kc8kMm7vYH
         hDDZJt+1kIX9vPtymqknGX40V0Wp35IuBhR/ionMTORHWJp2K1ZBpSdCpKvLwTGK1AdO
         2LYF9exXaYRorL84vjeVx5OjAn3F+HY/yRrE2ZY4zuUhDTOPCjn/822w9n/8sGWtfo1z
         5Jg4knMPNYKQftjfxNdjNcJVZtFvyyLDRIHqzt4AQgbI5j4sW1Nk0WIJjLNibHDJ8uN7
         2tFTPUc39HCz41yoC1KrK+nP01X2ofE7J1fFWjuzDP812xsnK1GBIGsDICRTCxUj6CRQ
         EQNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
        fh=KCgvoenqajpmjW8Bs/qHfrYd/S1fSAY4ZMkY/MA24lE=;
        b=SgsuMAyfJCpTdQ2Iu4HJMu3msQZo6yhLL6WaahCyeyWFckGfMfGkuDsgyS/W1Pl3hj
         sXvGbm3zIJM5xwACxXl+vB5LWmjhMbCuBSe8r1F31DJEN7wWg+cgBsURBZYryV1N+pwO
         tWfHdGf51PLMJgfuBj9tDPWtLA5dTprBM1973vWFbaIJZp9JeM/X/5WOzExeJxS7QWys
         dxDnks9g2kBBFeuCWNzOQbiCbL0goiwWcbkhjfX6cH4L0BYqDUtlaPv8XtGkq2YzRT7s
         kCCcwA52xI8z3T7OoB0eF0mmqV31PAFeLT15UePTiulymTEP0tYEqtiUQDEvP6ApLv3B
         qM+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790565837; x=1791170637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
        b=qrxXDM8DVJbLM3aRXZ8qIGu8mwDVY6d45qU+d7J9x/Jn6S3Fli4QxLAc0VW0C6Olp7
         SM3oayTFpxisbV/PjdPpbifLlsQqNGb39LF9YfsZXGicPAlx4sZvzJ/4hvqfn+6USluK
         kkDtV706sLpAXCG8WMV460KaVjPSmL1sdl8qxRCZRigbxD0fiEvJ93q/WtdleAdi3rUy
         5qrl0nO3RW6nnof6qK/507/25yPbLtwO4tftv1L429vieHH+sg0SR47Po1nkdOoLxa+k
         RnCovbwgcnCa4/JO2fpdPh8BrIvXGl0L9QF2Ovx3Q+Ve7xwKwhWWNiWhME9aSafhlVcN
         An9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790565837; x=1791170637;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
        b=sBtz9nkDrOKMWP5HEGUKIg3KOmURyY02m8ecm7wGr7GoSD4IssPqxYSZ9O2WmChJqy
         2X/AcQTg3m9s0Optfh1/vDB+CJwtBeb/sktKM5OnyyMsKQvtoc0YJh38Raw5Nt7arlNv
         u4YMjI3nFtIZUrBq6WQOq0MRreG3quYRLQYD5kifv/KknONlXQqeH2adu3h0tUvyLcsh
         EI4d/UIZy5SOFMw3DmksGJPe2jRP//BLK8KvhIJ7q9DrInMUXuORdkVk8+CDqMTKW+We
         hvnDO3/YHkql8jQp9lC8U1BzjmQwA/jSlMhOSktTkO/KTpfdBRDWP9PJIp+rZ5rv2jxE
         mS+Q==
X-Forwarded-Encrypted: i=1; AKwUvBy+3yirxNnxsQu620fdBzgvhFCGOdR7T7CBRrTFvagaHcohoSG2lwLqmFt3pnvAktFyDZr3KKmL@vger.kernel.org
X-Gm-Message-State: AFq9FYLS049PXXAOzR5ZUOQt9pO5foRyxfhEY5ybdSqM0qcWEVhB0Gry
	OFqG4sbTFuskJ1Ha97Mx/ndjgb0dzV5c625kZII3ISpj7yfktKyJmfkMY7F+XO0+Z52XMndw3Hj
	YnJgTbi3nNJJB69bDYDNMUf9w9dmDpJY=
X-Gm-Gg: AYBFou0LRlgUkcoAkWr7YsPg+rkOLvczU7bvp/AaKdqxfTLcX/Zui7l2TVcb5gIXA70
	dFw+EOYt1SdL/e+DEqKYfx63DT3niZpXAaeyA2ETR8paf9LY4qzAEz4z7CzWFf+g+Gojvv2Pu6x
	mzkAhdFINxYPaJR2KNSQNNPfNBBCoWSzwIWaT17T/oGJWpVPnHika8lWvDHdRNqiHKE8EOtD9Wd
	vqRXT3QkZ1YlphrDSmh9t8xkrQyW0zrY4ubIisjAKRq9wayRoS5Zo2IJAlp35SYzK7Dlsj8Fx1h
	C/q08zQ+1ykHr7CNaTCe5n/ASPBUZgrboi4x2eXvr9XnIPmtnbPGxyu0yjtxytggEIzB9S0E26J
	yMe2fDD3nxsPiunYpWm+J/g==
X-Received: by 2002:a05:690c:c4e6:b0:8a8:4931:61b5 with SMTP id
 00721157ae682-8a84940aad1mr42888027b3.30.1790565837502; Sun, 27 Sep 2026
 20:23:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
 <arPyspcEFNkqfNyr@linux.dev> <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
 <arWJBBOdvLsOSdCt@linux.dev>
In-Reply-To: <arWJBBOdvLsOSdCt@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 28 Sep 2026 11:23:19 +0800
X-Gm-Features: AclHuK_1E2YfKgYgZbd4tDw3yFNtrrBUY1yd8dRRWaf2ogOVKnaFSdEC5R5Nlks
Message-ID: <CALOAHbCAtEixXTvRaF0qtGMjNwMHtYBL1eQU6GMgduRaWPGOmg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 4:42=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Sep 24, 2026 at 06:01:27PM +0800, Yafang Shao wrote:
> > On Wed, Sep 23, 2026 at 11:47=E2=80=AFPM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > Hi Yafang,
> > >
> > > On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> > > > On Tue, Sep 22, 2026 at 3:30=E2=80=AFAM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > Hello Shakeel,
> > > >
> > > > On the open question of how deferred debt eventually gets paid: wou=
ld
> > > > it make sense for the policy to also notify userspace (e.g. via
> > > > ringbuf) when it defers,
> > >
> > > I think the notification through bpf programs is already possible and=
 a bpf
> > > program deciding to bypass memory.high can already do notification vi=
a ringbuf.
> > >
> > > > and have a userspace reclaimer do the reclaim
> > > > through memory.reclaim?
> > > >
> > > > I understand one of the concerns for the async worker is CPU
> > > > accounting. If the concern is that the kworker's CPU usage is not
> > > > charged to the target cgroup, the userspace reclaimer could instead=
 be
> > > > spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> > > > cgroup, and both its CPU and memory usage get charged there.
> > > >
> > > > One caveat: intermediate cgroups with the no-internal-process
> > > > constraint cannot take processes, so this would only work for leaf
> > > > cgroups.
> > > >
> > > > What do you think?
> > >
> > > I think all of this is possible without additional code and with this=
 series.
> > > With AI, should be very easy to prototype it. Please take a stab and =
I will look
> > > into it as well (time permitting).
> >
> > An LLM helped me quickly implement a userspace async memcg reclaimer
> > based on your series, and it seems to work quite well.
>
> That's awesome. Please do take a look at the code and provide feedback an=
d if
> you don't mind, a tested-by tag would be awesome.

For this series, feel free to add:

Tested-by: Yafang Shao <laoar.shao@gmail.com>

One nit:

Since we might extend the cgroup-ops to other subsystems, or even to
the cgroup itself, could we define a more generic CGROUP_OPS instead
of CGROUP_MEMCG_OPS, and also rename `struct bpf_memcg_ops` to `struct
bpf_cgroup_ops`? This way, we attach to the `struct cgroup` itself
rather than to a specific subsystem.

--=20
Regards
Yafang
