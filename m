Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7AF3A4523
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 19:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786131457; cv=none; b=lMAu8TrIm00DLYuMlZz4vhuNgILEWWj/LnGCHHs5wb0BKbb1va2vUnvLGmpNgxLTZbaAHtpoGwwmNaSmPCOsaUKxdjzWGx/8QZxW/mX2XW4iKyHEowuMWMBNC6nMETesQa7RC3KvHjxISd7hSs1/NKqy4k5jfuLkONDr+4wM/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786131457; c=relaxed/simple;
	bh=OfZlFzq+2BnMIm4nQBcIZ5X575uhJ2FAVGh4LaBJbkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fOE/ExFJjNlqWp1rZKn6kUuZ8331JDreteikFyDmfld3ilgWyBQdLCe7V6raeAN6iWSFfvz/eniFhF6C+c6HuFEyj5kw1c7Byj4GD9TX2VVtV+1A9bOwZAax+RyHE/6NZPceU9NcNoOVrLagQ9TkHuF4xgyg8rK09rcggWf0UK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyDj2jsA; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyDj2jsA"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8486672f03cso4594487b3a.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 12:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786131455; x=1786736255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DEQarv7srdTW6cIHXAN9RnUfhHlppoDw4ouFa8YYmro=;
        b=fyDj2jsA47obp6f8xZJ+6JOpVp4lz9c1395UylUhVe0jh1frOe7KJ5zMMeG9aly9jl
         B2NO1Vr70JVyYJf6kNkR7pB1o701clz67r5urTJ27Y4/xH/XvwVm2t/n8evI077XbcMw
         GUeapCx2IocA3sIOdO8BTC/oM+2ma91Hdp2ADVR5mKKTpXOrZvAcAzSbkSk+1rCpu7bS
         zQIiz8hj+REQ4ADd12zVEOiozjf5dllQBMErUsvhQYuUqqjaCEvt0AlK/SpkeCQDdf9M
         FqcgM0gYxZzIfBxyx/+5Pf9gmSb2ljcUBKgrAWNsrpoAPp6zwGsqEFW9vm6OOjw92lLR
         edFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786131455; x=1786736255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DEQarv7srdTW6cIHXAN9RnUfhHlppoDw4ouFa8YYmro=;
        b=s40a/onjduhAihnYsCv3X4bKQnF0aAZLOEcdeie6YoV5DPE5r7igIbh01O5Nbhf7ha
         aXP5abe2KptdQAMMfdvNezY6R/xGSLSDqWzxm+COv2iysOXgQuywK7NsECCI76zbrLaG
         r1zFzWmMPngBNxooce0DopvkqUcpqHT34gLRDSMx00vxEIcnzMxS/41tIO1pCOCMlVPV
         63CcTsYaU1IA4De022ubg5Poqwtv4vI6ktZCgCRzU35EBGD6nKfWVWwNElCxaivpP97O
         IeBjWqie+pBHmNKCDdM90+bXz3gUvNGLzQSKcaOyek4lzfo0cDlpxSE64Z0PsWKtfra0
         H4mw==
X-Forwarded-Encrypted: i=1; AHgh+RpP3Ng+FKlj0UlAPQ2SvMfDQU25ar5wMn/0/1873HHOdMAd7UmSBZF4RC1HCTmxATQiSK2BnhoK@vger.kernel.org
X-Gm-Message-State: AOJu0YwWo7LdikeFF/6tD24Ji8UUgwQ1RjDXzXRZc5iGZiqKlJ9F1Wqi
	sgEYUo5KFnreG35iRWocEthVZ59/A36Zd0B+UohIL85fB34aN6oV9b2a
X-Gm-Gg: AR+sD11JJTVqWRQYB/sNW/h+1pknHnH6SZWDcvZwI+nqy+kF6X/bIRtKVHRK1cUEmV3
	mTgBhhhcbtdpJY78oKKtDyhDkb/r0HMUBmj1MPKT551qcpUnHVkkmnS/a2zVpSNKRwW7X6vcuvC
	goQwsmre9Mu9fjyAMcdfkZwTGBvCcEPqG4Zx8OSHUGQyEACWEGtdUQgPmNFZmZx6R+VIX/w12Ng
	MKy1zhCL2LH/KMvavwGlZHf5uJBEaboHR8hf4oipPB0ev4wHTpBsZI547wNtbrUaT38J5SxG+kA
	hsLOauayJup/F0lGtpPsC5GZ2cPwx7QEh54v4aXf+hoEpKp9TM8Lq1P8cGbzBSXqnfgYnbMdfcl
	9MiaEP+pMbbXS/yRuJr4wu9W4Sq/7pvQf8Rocfau7ObKZyN6h/KJUoX/VLrLXy7W5BHgXrZK/r1
	VpxvQy3DN+Q4DhrpQ7CSqRo2hi31GC3cTwtg83rRqeumhCP3bqnnmG5dU=
X-Received: by 2002:a05:6a21:7a9c:b0:3bf:983d:e9b4 with SMTP id adf61e73a8af0-3cb8603af0dmr29747576637.33.1786131454911;
        Fri, 07 Aug 2026 12:37:34 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:44::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141019b4eabsm9312963c88.6.2026.08.07.12.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 12:37:34 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	kernel-team@meta.com,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH 0/2] block: expose blkcg io.stat to BPF
Date: Fri,  7 Aug 2026 12:37:30 -0700
Message-ID: <20260807193732.4073299-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series exposes the block I/O controller's per-device statistics
(io.stat) to BPF via read-only kfuncs, mirroring the kfuncs for the memory
controller in mm/bpf_memcontrol.c.

Motivation:
Collecting cgroup statistics is expensive: the existing method is to open
and parse a cgroup file for every cgroup of interest. memcg already has an
efficient alternative through BPF; this series extends that idea to block.

The main difference from the memory controller is that blkcg keeps one
blkg (one io.stat line) per block device, so the readers operate on a
blkg and the iterator yields them under RCU. Reads take the same
u64_stats seqlock as the io.stat file, so the kfuncs add no fast-path
cost.

The root cgroup needs its own path. It is not accounted through rstat at
all, so bpf_blkcg_flush_stats() branches the way blkcg_print_stat() does
and refills the root's per-device aggregates from the disks' own
statistics. That is the only reason the series touches blk-cgroup.c and
blk-cgroup.h: blkcg_fill_root_iostats() is no longer static. Nothing on
the I/O path changes.

Patch 1 adds the kfuncs (block/bpf_blkcg.c); patch 2 adds a test_progs
selftest that drives direct I/O to a loop device and checks 1) that the
measured values are non-zero (as cgroup_iter_memcg does), 2) that each
kfunc value exactly matches the cgroup's io.stat file for that device,
and 3) that the same device read through the root block cgroup is at or
above what the test cgroup was charged.

Tested on v7.2-rc5 with the series applied: all five cgroup_iter_io
subtests pass (write/read/dev/match/root).

Ziyang Men (2):
  block: add BPF kfuncs to read blkcg io.stat
  selftests/bpf: add test for blkcg io.stat BPF kfuncs

 MAINTAINERS                                   |   1 +
 block/Makefile                                |   3 +
 block/blk-cgroup.c                            |   2 +-
 block/blk-cgroup.h                            |   1 +
 block/bpf_blkcg.c                             | 315 ++++++++++++++++++
 tools/testing/selftests/bpf/cgroup_iter_io.h  |  17 +
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/cgroup_iter_io.c | 310 +++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_io.c      | 107 ++++++
 9 files changed, 756 insertions(+), 1 deletion(-)
 create mode 100644 block/bpf_blkcg.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_io.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_io.c

-- 
2.53.0-Meta

