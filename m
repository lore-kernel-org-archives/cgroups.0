Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB57254B03
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 23:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790465540; cv=none; b=ClWfJrZuw+2RnKkBEctyalcvLL8u8q6GdiCkWIh3a0ZZ7X1v+ov1PhSbi8QZG8GKTZNHYnvyoaHHE+H9bqq0mnBJfs0xJD+gLVW5SBSTY2Ph0ZoiQAg7O2lVLajFgDIEUXZq5YHp086O3KypYrMbKQAb4/rZ8mo7bqPpCbtybiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790465540; c=relaxed/simple;
	bh=/4VC4x9PpIfi2jsGgmcRErzz+roJvLD2iHnoUCXfJK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e3LeaqHWsQHK08Va4TCgwqQKlbaIsQbAAuIwVbZcR82nP9DDzkHyrRHeZkI/pzyU3zZb8tuY7h0YnjkKjVfgYVhG7FT9B9tm2Xio11EsqXnLoj0kP2rySHLz2tEOwOrAWwFBQJ6gdd7gzJr+jNNJ3Dcs0/3noYQ95WBQQNo/r+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOntKYBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOntKYBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFDA1F0089C
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 23:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790465538;
	bh=nw4tcFFem5fMw8F25atJ8BPsyQyyVvwGckLrZIYusgw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SOntKYBx3mVDqzQQqKmTLcy5SmH61dXRyWMz0CKfqKDGhmmX6DzBF3I+b5HvtGETW
	 PxGXDUWq6iL8F9Jd+QR4jj7Ei5t9F9818kuauVMuFHw/taZntebsNY+G4fYhG8IKr8
	 gzX5bwD26p1BOmhW86v+HIWAPt+lIsFjWRKPNalZEb6eul6QjDRNUuSVIS9vJZtM0G
	 gcroxCinZJzF9ShuIDqq1EosXzHliS/g5ECjIh48ei+DBMQXx3UCPyqKPngM+74oTS
	 AqJdxm8iJp5FWBKA25WxTTBCgvaIrqddbE99s5/kFPFaCn8NBID1BPVsoFwCIcO7+f
	 Zcx92O+aH+Fqw==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af3701927so245514866b.3
        for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 16:32:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw9bEfuYiHxlsNuOJS8vUhEcRbLpPh5KYgtfp0kv9ZMiEE5u97HHSSws3O0PoWm6V1l1PGxd+av@vger.kernel.org
X-Gm-Message-State: AFuF++laqKjysyyqowLWUJX9SVWkR97Bw5UI3sK30OOBpn2PC6Xfak71
	rUTzJOqpTXrgLNaJ77VYBx6TRRZ1CBJHuKxsh9BNEJENBbMB5LY8mqy1iBA4vLDXCm5qzjYPGxC
	JXTBvk66PHQQBAusffdGIIuElpoiknIi3QQySMC3vBg==
X-Received: by 2002:a17:907:962a:b0:c2d:ca32:2176 with SMTP id
 a640c23a62f3a-c2dca3235abmr54019966b.8.1790465537433; Sat, 26 Sep 2026
 16:32:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 13:32:06 -1000
X-Gmail-Original-Message-ID: <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
X-Gm-Features: AclHuK9AxoX5x-gecpb2ks2aU57CnhQ2g3FIIpOxpjBk-hgB0LOGfyaEJiKPKFM
Message-ID: <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-api@vger.kernel.org, 
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>, 
	util-linux@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, 
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

On Fri, Sep 25, 2026 at 6:55=E2=80=AFPM Matthias Goergens
<matthias.goergens@gmail.com> wrote:
> The series fixes zram selftest device tracking and error reporting, adds
> the swap policy with DRM eligibility checks, and tests routing, workingse=
t
> activation and retained-entry write refusal. It is based on mm-new at
> 995829088503.

Hi Matthias,

I can't find mm-new 995829088503 anymore.

Your patch does not apply cleanly to the current tip of mm-new
mm-unstable, or mm-stable branches.
Do you have a git repo with your patch applied?

mm-new is whatever Andrew can find on the mailing list, regardless of
whether it has been reviewed. That mm-new branch is very unstable,
even more so than mm-unstable, which should at least have some review
already. Maybe consider using mm-stable or mm-unstable as base next
time.

Chris

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
>  create mode 100644 tools/testing/selftests/zram/settings
>  create mode 100644 tools/testing/selftests/zram/swap_offload.c
>  create mode 100644 tools/testing/selftests/zram/workingset_offload.c
>  create mode 100755 tools/testing/selftests/zram/zram03.sh
>  create mode 100755 tools/testing/selftests/zram/zram04.sh
>  create mode 100755 tools/testing/selftests/zram/zram05.sh
>
> --
> 2.55.0
>
