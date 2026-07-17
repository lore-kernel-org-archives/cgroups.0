Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1321337C930
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 04:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784262554; cv=none; b=Gs79fHK3iT0jj8TNYvehNGkqUODq1AzzeOE69beZNleR7lhsh3jPVwXAaMz5hxsH1kBoSLRDcFFud0CWXJJWbYuxx2JKmx4sOowtO5M7shZmr4pchbLUDUZIStX31FP/A0AeCRVeRY/XULTLiH9QR4USbo0pSkREzvUCI8on9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784262554; c=relaxed/simple;
	bh=cqVgEQjGi8SC8nIGs3Bo9AwpjXz1B44w2UNfMMxe+ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o8xMKHjOwydGzbL+iavYdVEEbSoPfQ2Lt0UwgRbei5t5TiSiHUnWKcNEjog2CqfntGpHvmn2foUFweBi8jVJQzh6gefVvyxDAOiQYSO42lMgUpU+lk3hYn8FPg2HlR2oy6/RSjDzR++eDeTHcn6fhvQnjo3X+KrIqj8D/86Gs84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e1r4t96W; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e1r4t96W"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784262541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rYkAJ6k25UpukOkE6eF37TfWeES/EpuM0W49M8Ed5io=;
	b=e1r4t96Wcno2ya2yjCaWkx5Op9S4qoxSr7fLp8P03JMRpkm3NAM1CtQAwATn7csNf9WnmZ
	Fx/vjHpQClf5JUOqjwdH4K9M0k473XAKW3+dLFsRgFzBEyXwDiuZehgcbqOkFxRagfj5mu
	LkuhUjuwxbDBFtxsJM/jaFawt6+UvCE=
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 0/2] blk-iolatency: fix io.latency documentation accuracy
Date: Fri, 17 Jul 2026 12:28:15 +0800
Message-ID: <20260717042817.2001826-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

Hi,

This series fixes three inaccuracies in the io.latency documentation
(Documentation/admin-guide/cgroup-v2.rst), all caused by the doc
describing only rotational-device behavior:

  Patch 1 documents the rotational vs non-rotational difference:
  throttling is based on average latency on rotational devices but on the
  fraction of IOs that miss the target on non-rotational devices; the
  tuning guidance and io.stat field list are updated accordingly
  (avg_lat/win are rotational-only; missed/total are documented for
  non-rotational devices).

  Patch 2 corrects the delay unit: io.stat reports delay_nsec in
  nanoseconds, not microseconds as the doc stated.

Both patches are documentation-only and checkpatch-clean.

Tao Cui (2):
  Docs/admin-guide/cgroup-v2: document io.latency rotational vs
    non-rotational behavior
  Docs/admin-guide/cgroup-v2: fix delay_nsec unit in io.latency doc

 Documentation/admin-guide/cgroup-v2.rst | 53 +++++++++++++++++--------
 1 file changed, 36 insertions(+), 17 deletions(-)

--
2.43.0
