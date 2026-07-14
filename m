Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8213F3769EF
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 10:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025052; cv=none; b=j2TL9Ve9qErAgNXf73gNC0dtemSzREdxDrrrYmeV+NqSZ4CsDofJDX5V59A27e/J0jWHhwcbXWAuH48tN5RJR6dx7UQ5dm4Fo8CZ2EA+UiDT8PyDU06rmLrZF2tYJNwoa27vsNqmAIi4OB8aF4eZcuMnJHT7tYz6KFfkvdgmgZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025052; c=relaxed/simple;
	bh=HmNx+IwtsMyp7HDRxMTrfeyywG50CrxCgsAyvEE1Ru8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ahMlX9AO4oKvqzqxCxffj0xq8Y9FjN3MPn7mfyV0MR7gl1G9RuAkusV7SetNtiISV9Z4+a36npQvvdXPM/XwC+h3IVKNtnXIu36rr8PYgs0iZUoM22GctjeKoMMeOGOh6tfpIoRIg3lG+3p5gUOdQNLZvtB8bgD9FhDrIiSsfww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sf5DyfPM; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sf5DyfPM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784025039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cMrsQK0mZZzzTfisH0k4vPZ3JQTeKNbIs42nnTfRpiA=;
	b=sf5DyfPMGcyw+hHdHRiCZoIPv6Yi4SslE3UY4rE+ss1Jt6+Uj2C+31neXdskMnLCX61q01
	p28r5tdCKF0Wa6Kcva4DW5K7xX4Fpy/YdcdD4zWN153vtIGixrO48ePsGat5rVM0/WMqa4
	Jqak6OWk7sF7rj4h21a+vgoOk6q3f1Q=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 0/2] blk-throttle: minor cleanups
Date: Tue, 14 Jul 2026 18:30:26 +0800
Message-ID: <20260714103028.1334831-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

This short series collects two independent, behavior-preserving cleanups
to the blk-throttle policy.

  Patch 1 reworks calculate_bytes_allowed() to short-circuit a zero
  jiffy_elapsed explicitly, rather than relying on ilog2(0) == -1
  (fls64(0) - 1) to skip the overflow guard. __tg_update_carryover()
  reaches it with a zero elapsed time right after a slice starts.

  Patch 2 factors the four identical rbps/wbps/riops/wiops print blocks
  in tg_prfill_limit() into a small helper and drops two alias locals.

Neither changes behavior; the io.max seq_file output is unchanged. Built
and boot-tested in QEMU (cgroup v2 io.max read-back matches, throttled IO
completes without warning/oops).

Tao Cui (2):
  blk-throttle: avoid ilog2(0) in calculate_bytes_allowed()
  blk-throttle: factor out limit field printing in tg_prfill_limit()

 block/blk-throttle.c | 52 ++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

-- 
2.43.0

