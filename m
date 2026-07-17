Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96C39FCC4;
	Fri, 17 Jul 2026 06:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784268183; cv=none; b=mvho1COHHx7dhSXDc2fBCAs/QFDlQLfMGqLxzB0i+iKr/1+TkXuv5xFihIPGtAyhk+FdhOoostpWN0+Kf+YOzXxhYcgnNMJjzGS/e6pQXRvLR+IQlhmYUPd13msxi3/KXHRrV84y2Nnw6rvZA7zuwd5Dgv3iRXKGv44uh2kq9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784268183; c=relaxed/simple;
	bh=FJkACmF9ctC/kC3im3SVj1O3ysPVeLhC0+2JRpi7B/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C24oYrecxNerSEOE8mqkluadisXxx4ERJU5BtsOkXoxGd0qkSeLy56j2awNCYQHFqEZhn7+d4mBcgMRYVDc0JgUdHg54FBLmLc4wNXV36RVkhqSKMPURYBEbmla/jYQW0cHvgmKYvYcCnZIVCcrMOiOJMFrysQlaz1iq9n1F/IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n7jOqPhb; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n7jOqPhb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784268179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UoDPzUhIkglFscp2IezsZ4tuLclQXM4zODv4qy31gM0=;
	b=n7jOqPhbxxS+b4rnzRX98TuTdDiahcfGm15UA5g1Bs/alSLXmMUAuqRdZ+hMilfYJHaGnJ
	jWOeiqLMxSlwf/0T7m6SU1b6ET9phvlVj9LjZi1xC3zdm2RHCT7LlH6iLDv/XtHiOKep2t
	FNQ8+82rbmVE8yUYIwKZrPleddkvyZg=
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH v2 2/2] Docs/admin-guide/cgroup-v2: fix delay_nsec unit in io.latency doc
Date: Fri, 17 Jul 2026 14:02:25 +0800
Message-ID: <20260717060225.2019764-3-cui.tao@linux.dev>
In-Reply-To: <20260717060225.2019764-1-cui.tao@linux.dev>
References: <20260717060225.2019764-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The io.latency doc says the io.stat delay field counts microseconds.  The
field is delay_nsec and is reported in nanoseconds.  Refer to it by its
real name and correct the unit.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 4386365ef180..755c2a1942ef 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2305,9 +2305,9 @@ This throttling takes 2 forms:
   throttled without possibly adversely affecting higher priority groups.  This
   includes swapping and metadata IO.  These types of IO are allowed to occur
   normally, however they are "charged" to the originating group.  If the
-  originating group is being throttled you will see the use_delay and delay
-  fields in io.stat increase.  The delay value is how many microseconds that are
-  being added to any process that runs in this group.  Because this number can
+  originating group is being throttled you will see the use_delay and delay_nsec
+  fields in io.stat increase.  The delay_nsec value is how many nanoseconds that
+  are being added to any process that runs in this group.  Because this number can
   grow quite large if there is a lot of swapping or metadata IO occurring we
   limit the individual delay events to 1 second at a time.
 
-- 
2.43.0

