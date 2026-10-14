Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09329414400
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 19:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792005078; cv=pass; b=LuJcxVjPgQcSpf9D0P5mZGAfKV86BCrvFqWVrfdkAXDd8sFSshySXdX1YE6vD0a//s82/BvXw4yWD9m9xuTy3QZeP1qxaT6m/y811Z8HQpEfHKO3fDKcAGTqCr2RmXOJVoZz9GmspOQd2OsEWnLv+L5cxoJ0/7lioC3XiuMg/tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792005078; c=relaxed/simple;
	bh=4oB4aizrzm6vZ0ZydW4zr5YPF9osdEK++VeJ4BErisI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c2taQOXAoNjXo4YV8T69WoT6fAGXVduoVqLHYydqAGuvhtAKd0z140g3BxJ+GWXCrFl0s680Ec5K3klQwvmKPxAlXwtKmVR1aqKUj+kPlNWwE5H/uA1warO0xtKzWFjS9Hh5jKfBUiO5YWwSQ3Mzd4kPg4QOVeP7vnIlU5mANBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SY5O0Shx; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SY5O0Shx"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so352388f8f.0
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 12:11:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792005075; cv=none;
        d=google.com; s=arc-20260327;
        b=TL0Z/+UGp+1FJWz+pu6SPRXUHWBL2OVn4Ou/w3dNWbIYEOiin218KLoO2WK+ZlRzLP
         gZwS//dPbD92Re6IQiTFjjtqsclOf505zF6YNTLQap0IHoJIP9mdG2zHG44sgXAKE4hb
         uSYT0t9a9o7lTtlow9Ghdd2hS8LOBwH+C/7BB7z0Sj4li8SaxtmwkjvSpqBpzGrHpHSx
         NnDuNLBGRNxs2d0a84gLOjL07q6yTrMb7n7HVnnXJ9S9YDB9bnT+5AiHFyUDI+v4pgey
         pr5pOh9nOBZZymImxq2ZwcMd4eIPd2KSb52xyJm8Vxi7+BBjE2U3bXg/UVwc3uHuW/zp
         gjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
        fh=FkHqxO3/p9uPMpsIVHnQU2q4+U8ckSmLfn2stnu79ik=;
        b=mCcZe7m1ldtbTR12R8WqYq39VEAs9yyR3Ay4RBpevV+RaGIfxtqcxqjbSLdwvPQT+C
         s9s0Ugi//Z5puWPZetT07ThW/ydXbFRp2eyWAUykbqKJDfgZ2xz/SquOHxAWtuaTVRAl
         nEM/F7zlwbsxGuVuchlaoLkLSXJ6Tb0/pPaXJxCZNp3p/hj/ZvKnFhis7J/sifEcdV1V
         CpANqAzzR9LFBCVUky3ywgICltAcZnD0qPfgz+v85OvXv/A7VWZkMWexuGM0hIM5dUIj
         8mzPceqMkhAOOHn5ihDcniLeooCy5e7n+alMsKnkLsKytZL5d0phe2irI4AClfcY8jcT
         fnXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792005075; x=1792609875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
        b=SY5O0Shx6HTpqPc3ZhmZ+kpBevYpt08pmtEPAMb6HwrmD9U2OHA9Bn9aEyCG1WGZsH
         OGDqp09cMfL6xiIqlmOoe6GOG21ZBdfO5LQcoyUfuAdHghAAN0be/SiNPPgkXLkCqfFO
         LC8OndAQKL22Y2iUlJTnq/8e5fho0WbgBNj1pQBdPIhq9A3Xk5FFUIyWkSCJ3hA9XlRC
         koLfTf9rDh8uxmXPkGssTIftZaGGIRn7v1gzmClJViT0BEblaOWm/bsefO26L+CFQGWQ
         hj2xc8KmnqU+ojblMApBoz4DdVfLymAf/84RzOaaJFk9FLSzl0q8tKwO8tLaIUnGs1mV
         pZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792005075; x=1792609875;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
        b=pxyR3GyqpyPQmNLqrN1xZqSlnkN9v/cJhlCGkPhuc+bsVcF07M4SgCQVe9ojdBaePR
         Rxy7IcrMVZkVc6FK5cd27Q0WSTprVvBhmoC90/nUJpPDMquO5NoFHNbkdxUe4adZHbOH
         PsqQnBU5Lh9YQWJ/KafD0hF+ZIEkIEtvzaRvt5PSK92LEI8RzH/az37xCXHd7jdmhwOl
         QBc8bgfd5csDMe89/VW0EQSFgz4hy/0m3z9p5l6fPz9heBEnkTZbtzbZSRf8cD7CeP5N
         iXRgt6HzX+TYqQzQB71+5DxZfQQbck5bXjc0TqS9vGGY5UWRRtpgkRe8huC1ryipj1AS
         QZ2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwSTe2wD3jEqOVFELUkjwuqUxRCCUEca+j4R8AjzVKORbsHsd3GISxKziHU1Mn1QOfkbZNdEZtE@vger.kernel.org
X-Gm-Message-State: AFq9FYLAjte24CCthW/COq7RUSb1Ic/Ud9Vul/sQ/mL3BPKmlVDlFUDx
	YyC7NHDiQzyzrB84I0bbCY5jev7BG1huT5rP7d6bxVdcjF6na8J1FfSP+L/w2kWAvlGUhIcNbvk
	Dtj2/5QVroT88a3Upv5skcg3D5Vh/akA=
X-Gm-Gg: AYBFou1CBd2QL4EjSebjY/Fmc7kHG3ihM9cZ4eWO+PG1E3b3na+gpLAocJWXuYMto5g
	6ygDbaB9vda4xsBy+L1lJj+ENtrIR72wDDAQKa5MshvUUA5TBKNRvZbqT/0OqaxLDkxNBmOPzx5
	5SXLHAUZk1xjov1BlpphZEAMVbuaG/Aw8gbBzln/E7Yp9BGw0iMSkDzXD5jp/NYo+Yln6qACZxd
	0sqAsZtF1gzJUgLDcA3kcL2iZzvobyL99eM9Tob6AyPAaRdLJgNZcCVVHnI+uOq9WD02eIH+eWl
	DxWBKZZPSQ5Q/P+AvuD2K5rROalIS6iDF1bTKVmSeUPKFF6zzDvD3ZaxdGM+fV8nnb4LMc7fZUF
	9hnuxpx1wl1NCAuFgKdU4OD/zZF3h0awjoJivYFuk1PFFAWrxOdoqid6sjYarh/Xh3t8ZjUMMdI
	zhko0Mag==
X-Received: by 2002:a5d:5e88:0:b0:48d:bafc:a3f6 with SMTP id
 ffacd0b85a97d-48dbafca4a1mr35041657f8f.0.1792005074870; Wed, 14 Oct 2026
 12:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
 <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
In-Reply-To: <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 14 Oct 2026 12:11:03 -0700
X-Gm-Features: AclHuK-O9xN2h7Y61BKOyhDB3rUul2Ti7sGXJ2Q2LlVEmPwqRXTcsAZ_F7aCTNI
Message-ID: <CAKEwX=MTapFb8ZjjoFNSyG-_ZKAsxqPY+x9st2s0b2iPL-d1Kw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 10:17=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
>
> 6. The one part that I think we can and should agree on it shat the
> implement approach: at this point I think VM_SPARSE is the right
> direction, Nhat is concerned about the testing on it, and I think we
> can have more data for that, and collabration is highly encouraged. I
> previously conducted many tests on everything posted from both sides,
> will try to post more on this too.

Let's see if I can help by doing the rebase :) We can use vswap as the base=
line.

And yeah, from a pure conceptual PoV, I'm ambivalent about VM_SPARSE.
I just think it needs more data, as it imposes design implications on
the rest of the implementation, whereas I already test vswap on a
couple of workloads, including real swap-heavy production workloads
with a mixed of swap and zswap users. Performance was good.

My question - and we can wait until the meeting to discuss - is why
are we insistence on dropping all of existing code to just switch to
VM_SPARSE? I would understand if it is indeed very difficult to switch
down the line, but I don't think it is, based on my past hacky
attempts to do it?

>
> That's a lot of problems already. I think we can discuss these points
> further in the meeting.

Thanks for the summary, Karui. From my end, these are my concerns:

1. Interface: I don't like interface without justification. It has
real userspace impact. Things like priority should not be exposed at
all.

And we should also avoid overloading swap interfaces with things other
interfaces are better suited to handle. For instance, while I
sympathize with your logical memory use cases, but I chatted with
Johannes, and he pointed out that the overcommitting interface is
better than swap for this purpose.

Idk - maybe expanding /proc/sys/vm/overcommit_memory?

2. Charging: personally I don't want virtual slots to charge to
physical swap space, but I won't speak for memcg maintainers. One
thing we can discuss is what kind of use case relies on the existing
charging behavior, and come up with alternative setups to handle these
use cases.

3. Make sure any solution supports setups with mixed backends (per-cpu
caching should also distinguish vswap v.s other swap solutions).

Once we have a better idea of the rough design, then we can talk about
implementations.

Things I think we can skip:

1. Writeback - this is a given now, I don't want to argue about it
anymore. Just include it please.

2. Swapoff - I don't think it should be a blocker in the first place.
Vswap does not expose that functionality to userspace, but exposing it
is trivial, because the machinery is identical to physical swapfile
swapoff. If you want it could be a small-ish follow up patch.

3. Memsw:  I think it's mostly a separate conversation. Vswap does not
block memsw. FWIW, right now I keep vswap charged to memsw in cgroupv1
because my understanding is that it's a logical counter, so it should
count a page regardless of the physical reality.

So if you expose memsw to cgroupv2, it will work as-is. The question
is whether memsw will exposed to v2 in the first place, and that's
orthogonal. Maybe the memcg folks can have a separate meeting to
discuss it?
