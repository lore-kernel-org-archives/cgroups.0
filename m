Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA72F38BF7A
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790417805; cv=pass; b=Ejc0AjV8FmnztwPbzo5qv4t1k/ClvjqIuAIZVwf5haGrPyIMCwr5bVhjL9/Srkk2amAg7gdbzuxKo3ET5uPzWuI8gAAlwFXSBwzBRl5mG7U0kOWQxl4obH61FtFNaJ1W76MK9SPlICfDwy+myzsAK1mzS1XZo0byPHi59/YDqGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790417805; c=relaxed/simple;
	bh=DlFYvFJLECsxFthzw/eFkvSmzedTUmwOpzdBKfUM0K0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LeH34zCwcwtpTB2rdfbkNh6ptR8pVQXMIhZ6zUAmXVttrlZE6If5MJabk1bNeHtLohQDrlfzxf37vIVPXmITorfUO9aG4ci1x+YMDPaPop8+6f4JjEcFAjFhjDND4L/2BsWmsTzANnB3TRvYlRQPL2Z4ER+IaxtJs2skvSfuQPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LFrqVxqy; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFrqVxqy"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6aae37d33cbso2068944a12.1
        for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 03:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790417801; cv=none;
        d=google.com; s=arc-20260327;
        b=dkua4rb3oS7M68MV7K9qGF1JL+cnEFuoJAzZif1OnB03PIBD51RkE8+BmBG0k5d4d8
         N0xNIv5bZR0mkLClWUuJ00OCMbNRBlaRQkhnNUD5ycVlTiN4opZJLsgZQBTIeQaNL4Hk
         qqY/kdc60vanm4SqgHk42QTIvMZtVjt7BnEKegoBOLHnuSc69xBBv5V/NckeIQYM0+oi
         K86esppSbh18EXfPEVrLbz2jzkeMsNnQfQZ3Ld//7ofm4jm0ouLiTI+zjSkdQqPzHC6K
         NjH+ab2RTnwdzP9QCRf6LU4omCTGMHGmrfQA7S8gwkaSHDEfJ9JQhvniQbbbdq3GbvSE
         ofvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
        fh=aqgQ2cW60MsCxUynRkH294Bs/cUJWU/7D62mz77E/uI=;
        b=scayulRvagW0uykdxads+xEWAcPzd+khkdWy1uuKmeYdYT5chI9W6QHvHJBYDgvPj+
         FbrAp/IiFlpmL7Thz3VGX9dy7BJIFMEpCU5rWJQss+aUIg2odcYEmhsClC2/QqbqWgDi
         yMSl0oGrxPhx0rl4B6EZTIeHiR5jS96Gz/Qwa3Yha0ByZnIvWdqdW2Js2YmuMO/W1u2F
         G9PoEcuBA08jBL7jeWSjG35kl7yBy9OSWglTTcjUZIWWHWyTfe9cWMIuYW1JK7syqFZB
         HHJ2VfE0ugDCQeVMUuzkBKoJ0eNVxU58vFO0IiCE4gdcgllN+VvUcJAl3KH43BelnsjV
         n4fA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790417801; x=1791022601; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
        b=LFrqVxqyv19kzRnHMAXhI4vAik/aMNgEsVTx/84IesLwhxI7w5kcphx7vTNr58KQP0
         LglTxfx1s/rQs1AxvYmLUpRQYCm2Lp7Cv9igFQ3wNeNpzNemzkmJgb5lUXceKTbkEQVd
         ue6Dy28OjDCgXTKFM5d28OCJ4CmegTTe7AkpBS0HofQ2GN6ZXBBWEta+Hvf77O5qRFzD
         ce1oQxToFYp3oIinFdBqmrJeoNzqadISTAz4RAGHvggGMaepTGJTGQRZvoh/Luu6kQML
         1j/tz19Go6qEO5Ku5KMz7XjE3W5VfNjj2Vff7qdjtUbY41Uo3UXOsM5oWg9RJorWKQTh
         7Oqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417801; x=1791022601;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nuUo8zdKSoKE11B/ziniOjON7mdE/CfW6nfGNWVjAv0=;
        b=zOHcgnhV9uZzcAPmHI+OYrJiiJv/LNPcNH48HoiUJdc4PkGmglyCAMTOrMN+tz1YSF
         uPM5vT6EJ4ASDE0SaLWFh6J1Zt/RcfGfgTkCbwWb/w/xHPOuxPT+ZUVUikDKkS4RBZgo
         wdVDugWK+i0D0gzIAWSMac5ai3RYyIvrI6wWp59ttib3Y82VUtf4lG/LSDBJ5dKcEntR
         zYX0SrOFJna1O1Km399q4dtVxTR2Q7Ey83t0R3UXANZEZQNg5Z/T3Z7iwok2KBOzlZaV
         HJ14R4fyTcygnvtwD5in8GAZppY4LHiCMzjQUJQ1gl0wuR9O3PZL51pIMwY7HHU7SGqu
         /sLg==
X-Forwarded-Encrypted: i=1; AKwUvBzTip2jBIjaCf/Mgqn2rG3yC0qfJoGDseUu5u940pwpv1nFegafA1u3FCky68gsKcR9TV9/MYkG@vger.kernel.org
X-Gm-Message-State: AFuF++m0OKJ+5sv/zYcLQXb3SsZrtndUAIgfhpHt9EtIFln31y6Ol6hM
	9MwrbR/IwzWUGt8yRDd2XLfYfS91rSXWaBiRuNHobooIlwBoe1+WLj5pe7fKO5cdJ6jPiym4Ivo
	79A2Z/WpgXblM5EgqFMMmcUH28FY1Njo=
X-Gm-Gg: AYBFou3+lmUwI88YJR/cHxAyEmepiuFjfRlzD4MPAqbsRF006S8hFq6vDjMTfQ0hF3A
	SGv/csI5wf82ISx0ywjbrEWOjHs7+OkbQ6sfL6yNa67KVMB3OZrnUhPSP7DCSbYePYRHig5d9PE
	Vi2iuLk8K8UjR4B1c1/h/F0r2Q6Ee1FXbqxoaLoOJ8T9fVMwdZmTiiujdB6rVt3brXDJrerhqth
	2VXX8gytNx0Rm2PED6gHe5D57QAVqlcLDQgirAV79Ad/DcWYP7FSD25+zUSUKLesHYRSP/kBP4Y
	HNCiDYBHGcoHLZPhOj91w/WhFMutlgxuzevtatnFVJzh5T8NdEI7GDp/X9Yn/XNQOTwvBs0UPHJ
	MWu1MLhVY6jc=
X-Received: by 2002:a17:906:dc89:b0:c26:3341:b8f6 with SMTP id
 a640c23a62f3a-c2ac23a79a0mr705591166b.31.1790417800888; Sat, 26 Sep 2026
 03:16:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 26 Sep 2026 18:16:03 +0800
X-Gm-Features: AclHuK-9Dsy7rrAClr-629S5BXo_K2Hom1PYuYOl9rMJseRXC4FOvcoZCXsi7Gw
Message-ID: <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, Barry Song <baohua@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-api@vger.kernel.org, Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 12:55=E2=80=AFPM Matthias Goergens
<matthias.goergens@gmail.com> wrote:
>
> This RFC adds offload-only swap areas for deliberate cold-page offload to
> backends unsuitable for pressure reclaim. ZFS zvol swap has documented
> deadlocks under memory pressure [3]; compressed swap is another target
> because writes may need memory despite free logical slots.
>
> Explicit proactive reclaim can use these areas alongside conventional
> swap, ordered by priority. Ordinary reclaim cannot initiate non-zero
> writes to them, including through retained swap entries. Conventional
> capacity is not reserved for emergencies. Operators choose the policy;
> the kernel does not measure headroom or make an allocating backend safe.
>
> TMO/Senpai [4] and DAMON_RECLAIM [5] are related cold-page reclaim
> approaches. This RFC admits offload-only swap through memory.reclaim and
> per-node reclaim, but not DAMON. Other related work includes per-cgroup
> zswap writeback control [6], Virtual Swap Space v4 [1] and swap tiers v10
> [2].
>
> The util-linux companion [8] proposes swapon --offload-only and an fstab
> option. Older swapon silently ignores the fstab token, so persistent
> activation needs discussion. Apply the separate i915 fix [9] first to avo=
id
> a pre-existing folio-lock leak when shmem writeback is skipped.
>
> The series fixes zram selftest device tracking and error reporting, adds
> the swap policy with DRM eligibility checks, and tests routing, workingse=
t
> activation and retained-entry write refusal. It is based on mm-new at
> 995829088503.
>
> Feedback is particularly welcome on:
>
> - Activation-time eligibility versus backend placement or migration:
>   is retained-entry refusal, with possible reclaim churn or OOM,
>   acceptable without migration?
> - Eligible-capacity accounting, including overcommit limits and OOM
>   scoring; cache recovery, cluster invalidation and workingset activation=
.
> - Persistent activation and visibility: current swap listings do not
>   expose the policy.
>
> Validation includes x86 builds, affected arm64 MTE objects and builds
> without swap or memory cgroups. QEMU tests covered routing, retained-entr=
y
> recovery, data integrity and cleanup, with negative controls for write
> refusal and teardown failure.
>
> I have also been using this policy on my own machine with experimental
> bcachefs swap support, with no problems observed so far. Deliberate stres=
s
> testing is confined to VMs; I do not deliberately stress-test this machin=
e.
>
> Changes since v1, incorporating Sashiko's public review [7]:
>
> - Improve selftest isolation, retained-swap measurement and memlock skips=
.
> - Track allocated zram devices, wait for udev probes and report cleanup
>   errors without deleting data through a mount that could not be released=
.
> - Clarify activation, capacity reporting and conventional fallback limits=
.
>
> [1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
> [2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.c=
om/
> [3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.=
html#using-a-zvol-for-a-swap-device-on-linux
> [4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent=
-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
> [5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.h=
tml
> [6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html
> [7] https://sashiko.dev/#/patchset/20260914104501.3960616-1-matthias.goer=
gens@gmail.com
> [8] https://github.com/util-linux/util-linux/pull/4633
> [9] https://lore.kernel.org/all/20260914105606.3997649-1-matthias.goergen=
s@gmail.com/
>
> v1: https://lore.kernel.org/all/20260914104501.3960616-1-matthias.goergen=
s@gmail.com/
>
> Matthias Goergens (4):
>   selftests: zram: track owned devices and report cleanup failures
>   mm: restrict offload-only swap to proactive reclaim
>   selftests: zram: cover offload-only swap policy
>   selftests: zram: cover retained offload-only entries
>
>  Documentation/mm/swap.rst                     | 105 ++++
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
>  drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
>  drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
>  drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
>  include/linux/swap.h                          |  29 +-
>  include/linux/vm_event_item.h                 |   1 +
>  mm/memcontrol.c                               |  20 +-
>  mm/page_io.c                                  |  24 +-
>  mm/swapfile.c                                 | 123 ++++-
>  mm/vmscan.c                                   |  31 +-
>  mm/vmstat.c                                   |   1 +
>  tools/testing/selftests/zram/.gitignore       |   2 +
>  tools/testing/selftests/zram/Makefile         |   4 +-
>  tools/testing/selftests/zram/README           |  20 +-
>  tools/testing/selftests/zram/config           |  10 +-
>  tools/testing/selftests/zram/settings         |   1 +
>  tools/testing/selftests/zram/swap_offload.c   | 425 +++++++++++++++++
>  .../selftests/zram/workingset_offload.c       | 207 ++++++++
>  tools/testing/selftests/zram/zram.sh          |   9 +
>  tools/testing/selftests/zram/zram01.sh        |   9 +-
>  tools/testing/selftests/zram/zram02.sh        |   9 +-
>  tools/testing/selftests/zram/zram03.sh        | 174 +++++++
>  tools/testing/selftests/zram/zram04.sh        | 164 +++++++
>  tools/testing/selftests/zram/zram05.sh        | 447 ++++++++++++++++++
>  tools/testing/selftests/zram/zram_lib.sh      | 189 ++++++--
>  28 files changed, 1926 insertions(+), 94 deletions(-)

Hi Matthias

That's a lot of changes for a rather limited usage. IIUC what it want
to archive is, for different kind of reclaim, swap operations should
only go to certain devices?

This really sounds like another usage of the swap tiering design: A
default per-cgroup tier setup, and a one time tier limit during
proactive reclaim.

Just like we already have a "swappiness=3D" parameter in the reclaim
interface, perhaps adding a "swap.tier=3D" would be better and much
cleaner to achieve the same goal? Based on Youngjun's work here:
https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/
