Received: from mta1.migadu.com (out-63.mta1.migadu.com [95.215.58.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A812DE702
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791619208; cv=none; b=Hs8qMA7v7WY5P52C0FcbLeBrOzc0Z2i29kDvxA/9s7ToQG7jtXLsLK4gSrWd4lSOEK3es1BJDTqwBwudADmw+ZEeGSvfQdZIO0lCJ7kyj2+rkRAn/WEzBp+r/xpAAg7cWeJEC3On2Lunjqo22IZ9O0/FgDEwWY2SCbtQAsV6b0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791619208; c=relaxed/simple;
	bh=L42Md5zBpeX6QzOTd8GFr7kWoBzsNWsK8EhP2e8qmpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q7NPYvpIkfT/33pBlJ8MUhRTdRk2gPKQqRcl76On4PKpx28RfJwrjWIDSMOSQ/S62PuLnsESOcxYAjdIKoaKEXIJ1Al9XLa+EODPx66MbMe3IX4C6r44lC+bZ+8701ff8SrL+BxoCDxN753DCVnrWmZJspBV+LNOjFl2F0T/5WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S+sjXfHV; arc=none smtp.client-ip=95.215.58.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S+sjXfHV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=L42Md5zBpeX6QzOTd8GFr7kWoBzsNWsK8EhP2e8qmpw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791619201; v=1; x=1792224001;
 b=S+sjXfHVswUp2A6GD/PVhJQSvaout4a8sJnu1mxgLqNbmZz54IehJjGNwCxl4FtJCr3mVSi2
 ZUYxE7w5oTgMoIEtLiCs7mcCQfO9SrMDJPEipDCdV7GSjw+w48W5SUXeHn+9FnBgf3vgtJsfULl
 +ewsx+fQq6bz5CiaJ4iAvye4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a53fe0ac8107ad79;
	Sat, 10 Oct 2026 08:00:01 +0000
X-Mizu-Trace-ID: a53fe0ac8107ad79
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 0/2] cgroup/cpuset: Fix partition updates using stale CPU masks
Date: Sat, 10 Oct 2026 15:59:45 +0800
Message-ID: <20261010075947.333549-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

These patches fix two cases where partition updates read stale configured
CPU masks:

1. Shrinking cpuset.cpus of a remote partition can leave a removed CPU
   unavailable to the top cpuset.
2. Updating cpuset.cpus.exclusive can leave an invalid local partition
   unable to recover after the mask becomes valid.

Move each configured mask update before partition_cpus_change().

Guopeng Zhang (2):
  cgroup/cpuset: Fix cpuset.cpus update in a remote partition
  cgroup/cpuset: Fix invalid local partition recovery

 kernel/cgroup/cpuset.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
2.43.0
