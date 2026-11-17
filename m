Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794956091;
	b=mMG30wjeZYRHkTX/02Xf0xHyEGs/gzuNHFO2bRg9sve327/OfaIzOMJ81k4RyFvTlarc
	 JUi9kLKMKJ6Zpw/EYeL5i5FqafN7O+QbMRDm3d5EVbTKYQaxcc5pRwc+3fnS/mLDcsNlZ
	 oe16ic1lhJMgjf2lyfDRIrM7jtKbWl7N13vKZ1f/Aqy6stHrn+iGNKDycJWmG7n7NB4g3
	 YcB6yJ1twD/v2in534fhoiopIzDwk0enpNlMMQqxFF/6UtiZjB80yNQV5V9hclO4RDciC
	 N9rcVJnriab8MJK+UgLDkzfC0kB3+BWZn5CYU8G3MQ3ErsdNYb1ek8RHjDzPBrXQ/Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794956091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:From:To:Cc:Subject:References:In-Reply-To;
	bh=k7/QLUvYDzH8xZxy3OOm+8SYpFBmpzd+eC/ISXSLxiA=;
	b=xrbYqEtGU98WN4thN3Sltt6GG99h0a58KdiBfJMyrB5aBCZhZdDa081Pz6p2n3el1NG2
	 daD/SRQXIJNjW1Fd5K+cLL5j8cqMyGr8ekNBhuVbgonnqlgSOOrb9cawWDcnQ/xJSnJ0d
	 mVxxlOkcvAUKdOdBGK8gHdVQu7aiUkhUBdvcpJRgsjwfOYYKaM47qAPU/Tgigr2mO+ZGm
	 Ga7yci6zyUjOfcoUafmIt+/2I6sPvFI6yh0yR9Dahc1rcCtmtDrfGC+LEIYZVRFz84ERi
	 z/zb/PtlKa1cthD4zGjoRL+GDgQBaAe4rNGjWq1Bb7uQS3JJckE1EP6dB+MeIXuJG8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=paul-moore.com;
	spf=pass smtp.mailfrom=paul-moore.com;
	dkim=pass header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=DIOqvTtw;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF8E606A333
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 22:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AF8E606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=DIOqvTtw
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91e7af9a67fso1361386d6.2
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 14:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1794956089; x=1795560889; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k7/QLUvYDzH8xZxy3OOm+8SYpFBmpzd+eC/ISXSLxiA=;
        b=DIOqvTtwgZ5ItvYEoe2KZqcsY3ZGLQ+HaihmoLRuvlSTEm54jSBGFp7446G3/I8rQV
         jdaaePJOPptbJB/iycrO1+C9CK7f1Lzi0/ZtjLgb3g74xLYezSMe33/lJcnXDXHCH2QR
         nPspoy5WRs3Kr/RdCST5lRUxeJijzn91kv7ip8tpuZvGiqXVwaGEyqsdCZ4UzGopcOig
         odhAaVLPfkteT28BObGagg1mfMyZi1OKOhsJXcZRCsolfwMYJPBhlTEF26Wy/fGeH2g/
         6GB9fJ+t+azZKqhhqQ/sH3UiAz8tKQMSv7Y+PqcaopnbJ1qBu03DBRydnqkMiL70S4pM
         2u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956089; x=1795560889;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7/QLUvYDzH8xZxy3OOm+8SYpFBmpzd+eC/ISXSLxiA=;
        b=qnrFR2FereUWwsf1183xTaeOjWC9zup6h4rgmPlJPTstWQH+peBr33ame2Tpb41BNz
         MRbMIgUDibM52tPIqq3G1PFP4v7N5plw/l2viEE+s/4Oyo+rKbTo2JR+GhHW+wgiJ8ZY
         DiSLS7xsdBIFvDXA6yg3B8y7C2sQtF97QTJNkSfGSrm3jrzjelQlAz4+wwOZiL9bVs6Z
         X2auv0t9Vw0wxu4CHQ8aWMkcwc2/WEPXPPe2dwNCOpppN464kcEXf3wuue46P9XkSAzG
         w/mJCjL3wrtK08KBSw9av+1Z64vDQgyXXdrymXIaIldg9YSkJmNvFc3Ef4MKuPPYuy+o
         /nsA==
X-Forwarded-Encrypted: i=1; AL+hErEpFdZ3yYdho8I/MP5grD/erIrf8oJQ+vpxdjEkSibuy5fDF94XS6mXX2hAUizXUIVwhZY8V8eC@vger.kernel.org
X-Gm-Message-State: APuU4Z81Sl9/WqR+p1ArsdOCnyjtD+/MFal3VQpg63G7S1V18ZZqBrPO
	FB92qyLjQ+D4BJLgO8Z2Y9NpbnYsukOR/O3t1BQjMzmN8pdlqFaYkqfc5tVo0D1fnA==
X-Gm-Gg: AZFdTZfr5V2g89c9HhCigCHOPaM0UIFCRPFL/dXXGsWQIPGQA7OAilkLfEEYyacuqi5
	l27nMHNdU5xziAcYXq4WxgEEThlNK8I4NaJQjcl3wMk1A2xPGEP2WI0Qd5M655asUZA4H4OhG6u
	qSISMgW08NKcSm/oHeMb/IhXddpmgva6Ex9cRNROdCFvXnpkKad3pJSXn2EPT8d4AM922FeRGxh
	V2LFbnQrz7HL2O6UbihV9oOIvvYqHwZJ2dnONSlPduFwWW4nnbfcUFflb1MQ8ZHDgPwElXBbOfY
	r+ng3GgvfxhVsdknT/sXahPYdADetBKu5EndWdiFkoa73TKXj61bPCRKCU6sV21MiKWeoPnt9Qg
	ELFaotEo5dCdbtJLVJ2rnxhzecoiVg+Z74l1Fjpv6nmO21PECgjvJX/m5VpheVSHjEEAGgnmLL2
	NVeDZuEzDsg4+NeEJb5ifLtt0qECBqt6apYDOzu7zgjuqlgFstUJSs4kw0qzY5usp66yTNDLTCC
	nANU2l23ZZI+Ly9LDZIfG4INUC8RsWNMY6S2FiUM27NC9eZeYHwCCuId2TeVhROid4miTxN3Lbx
	YxEDSn6Al5q8YjIuPi6ZaDJldyW3Kn4gIpEaI7WIQ8SEBl15OkUT3CSNvV5WE+AeuYI+qJgZtb6
	wzr/CAhaZUvAjBBaXZopQbS9anA5YOg==
X-Received: by 2002:a05:6214:4981:b0:921:9ed:ee6 with SMTP id 6a1803df08f44-92114dd0d06mr10225486d6.20.1794956088668;
        Tue, 17 Nov 2026 14:54:48 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d53b7fsm5495766d6.26.2026.11.17.14.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 14:54:48 -0800 (PST)
Date: Tue, 17 Nov 2026 17:54:47 -0500
Message-ID: <4356992ac4fb7876fb5759189ba4b492@paul-moore.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20261117_1552/pstg-lib:20261117_1552/pstg-pwork:20261117_1552
From: Paul Moore <paul@paul-moore.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, echanude@redhat.com, mripard@kernel.org
Subject: Re: [PATCH v5 0/8] memcg: dma-buf cgroup accounting and charge
 transfer
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>

On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> 
> Shared-memory allocator services (e.g., Android's gralloc)
> allocate dma-bufs on behalf of client processes in different
> cgroups. Today those allocations are charged to the allocator's
> own cgroup, leaving client cgroups with no visibility into their
> actual memory consumption and defeating resource limits.
> 
> This series adds memory cgroup accounting for dma-buf allocations,
> building on T.J. Mercier's earlier series [1] and incorporating
> feedback from previous versions and LPC discussions [2].
> 
> Patch 1 introduces the MEMCG_DMABUF stat and the
> obj_cgroup_reserve_dmabuf()/obj_cgroup_cancel_dmabuf() and
> mem_cgroup_commit_dmabuf()/mem_cgroup_uncharge_dmabuf() helpers
> in mm/memcontrol.c
> 
> Patch 2 wires up the charging policy: dma_buf_export() stores
> exp_info.objcg and updates the stat, a new charge_fd field in
> DMA_HEAP_IOCTL_ALLOC accepts a pidfd or cgroupfd to identify
> the target cgroup, and __GFP_ACCOUNT is removed from system-heap
> allocations to avoid double counting.
> 
> Patch 3 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
> dma-buf fd to transfer charges post-allocation. This covers the
> double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
> and works for buffers from any exporter that opts in. Charging
> is gated by dmabuf->objcg being set at export time, ensuring that
> transfer is only applied for buffers backed by system memory where
> size reflects actual bytes. If the receiving cgroup lacks capacity
> for the charge, the ioctl returns -ENOMEM and the original charge
> is preserved.
> 
> Patches 4-7 add access control for cross-cgroup charging. Letting
> userspace decide who to charge needs to be a privileged operation
> because it has material impact on OOM decision and resource limits.
> Charging outside the caller's own memcg subtree requires
> CAP_SYS_RESOURCE. On top of that, LSM hooks gate the two charge_fd
> flavours: security_memcg_charge_task() gates the pidfd path (target
> identified by task credentials) and security_memcg_charge_cgroup()
> gates the cgroupfd path (target identified by cgroup directory label),
> with SELinux implementations using process2:charge_to and
> cgroup:charge_to permissions.

I'm probably misunderstanding the description here, but in both cases
(the pidfd or cgroupfd case), ultimately the cgroup is charged, yes?  In
the cgroupfd case it is more direct, but in the pidfd case it is still
the cgroup associated with the process identified by pidfd, yes?

If that's the case - and it very well may not be (!) - it probably makes
more sense to combine the two SELinux access controls into one.  Yes, the
LSM hooks and callbacks would likely need to be different due to the
mechanics of it, but the permission check "cgroup/charge" could be the
same.

> Patch 8 adds selftests. The tests and vmtest script were mostly
> written by an LLM, closely following the style of the surrounding
> tests and the virtme-ng setup. All code has been reviewed and tested.

I think we need to have selinux-testsuite tests to go along with
this, especially as this would be the first patchset to add cgroup
controls.  Historically I've pushed back on piecemeal cgroup additions,
pushing for some basic design of how to manage access controls for
resource management first, but since evidently no one wants to do that,
we really do need tests.

https://github.com/SELinuxProject/selinux-testsuite

> Known limitations:
> 
> - Single-owner model: a dma-buf carries one memcg charge regardless
>   of how many processes share it.

Once again, I'm sure I'm misunderstanding things, but are you saying
that multiple cgroups can end up sharing the same dma-buf despite
only one of the cgroups taking the accounting hit?

Hopefully the charged cgroup is deterministic?

> - Only memcg accounting. CMA heaps would additionally need dmem
>   controller integration.

Do you have a rough idea of how that would work?  I ask only because I'm
interested in seeing if that would require an additional LSM hook or if
there is some way we could leverage the same hook(s) used here.

> - If a transfer of an uncharged buffer fails, the buffer remains
>   charged to the original cgroup. The allocator (userspace) is
>   expected to handle this (retry, free, ...).
> - The LSM hooks are intentionally narrow. Broader cgroup access controls
>   (e.g. for the memfd/kexec handover case [2]) could be a separate effort
>   reusing the same pattern.
> - Only system heap sets exp_info.objcg today. Other exporters
>   (DRM, V4L2, etc.) can opt in by setting it, but are not
>   covered by this series.
> - Related to the above: lazy backing-store allocation is not supported.
>   This can be extended later, e.g., by adding a flag on the dma-buf
>   struct for explicitly marking when memory is committed.

Similar to the CMA case, any rough ideas on what this would look like?

> Note on TTM/GPU accounting [3]: that effort charges system memory
> allocated for GPU buffers per page, with its own stats (gpu_active
> and gpu_reclaim). This series charges at the dma-buf level, for
> memory with no memory.stat category of its own; exporters whose
> memory is already charged by their allocator must not opt in, so
> the two do not overlap.
> 
> [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
> [2] https://lpc.events/event/20/contributions/2416/
> [3] https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.com/
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>

--
paul-moore.com
