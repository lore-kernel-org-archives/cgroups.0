Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974D637C0EC
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 04:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784262558; cv=none; b=A2cNHH25suTMrBNceljmgUw9/nkiJ7wWtU9Zsc3fM08D6hWcINtSw4OGF7F7EtxktAkCX+Y47cRBfQshQHO6c+ikJA71g5ti4aQs3zdPL0RlrEOPIj3VDa1vJ2EWPbvm2VH4zMjj3jph6b4tIseNf25mf+3DYBzdsS8YLIgpOhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784262558; c=relaxed/simple;
	bh=ua3GEs8av4fKYGgEome92IxLpMf9Xz9GhNiVp1ilV6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK65u/FRu9wFgSsQqOuLx1RNNlf/68ibDg+oRx6QGZu0slx+WWUxB3BAlWQWf0rK/FVO2Nw3cOW1FBLnxh1VWC/EW27l+yJDp8DiCumhKLG4YACJjbuvhWpcnWWo3YcS3zPjUAJvleU0dWOTzs2I6hmgQY51ah0GXT8z78cO12U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W8z8SST+; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W8z8SST+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784262552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WA/PccghGHgwDI3QqI4VMqYsFAIGgfe0C5h0k9pSEA=;
	b=W8z8SST++zfFC9i3WtnOP0DxUpDZvwy4SWcjOBJ42YAhBVUfKpdgpoenK1a6GyrnpMkiHS
	s5pDbSLzRqVIX8aDdZ0mls7aRSjt9SgH+SJkmute2AZpirbCxOwiNbnk818sf/E1uuYr0T
	HJqCmS6Q9NrUMGJOSPHjkG1w3fm9WRk=
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
Subject: [PATCH 2/2] Docs/admin-guide/cgroup-v2: fix delay_nsec unit in io.latency doc
Date: Fri, 17 Jul 2026 12:28:17 +0800
Message-ID: <20260717042817.2001826-3-cui.tao@linux.dev>
In-Reply-To: <20260717042817.2001826-1-cui.tao@linux.dev>
References: <20260717042817.2001826-1-cui.tao@linux.dev>
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
index eec99813d82d..687839cf5c73 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2304,9 +2304,9 @@ This throttling takes 2 forms:
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

