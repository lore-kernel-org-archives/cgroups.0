Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC974E7808
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727057; cv=none; b=cB0iXqP3+2YJuWxWPrlm5xKN3Ld07QqA6dOSNNpqMwlfTE9XeuE6lYfJIzKbmDh7COyS1vx2Fp34T/BOcQh1WSrsJPdTsXNhN7PU7itcqeC+x8aN9eA/n4/yfRekuEfoJ7GuqIfyP1MCoa7JumkvEqGVzVNtLU4xuumJueH06jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727057; c=relaxed/simple;
	bh=h7+M7L3TH6YTmhANl+7C6FgrYgY5h2T0izd1OuGTMv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=csdoD37ZESbHAW1mgrTFnPZI1RLEKWHiubCJRjQIJXLspkJo2YKtdGykeAOzPV5x4gZ0RELJeZ2WeMWxj7dMhxDV9A3yNY89/JF1lH8HQzaoZ0+B9fZrRMVggNEhEr3phfmDRqvaqqwa9PWpHp/hmdV1WZUoYjp7uvaqpsW4El4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m4rGIFwF; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m4rGIFwF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=h7+M7L3TH6YTmhANl+7C6FgrYgY5h2T0izd1OuGTMv8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789727053; v=1; x=1790331853;
 b=m4rGIFwFjD6oa2hC/0ZDfKyZKWY0Baw0gphAcxds5Fen8BOVwH8+xh/Rr7qZR81oSxQtrYIr
 QGRyr/RfguChxGWzSJ5x8bj/hGgBMKCgpxpJM7W47bxwATML4rO4kF1IWvSohmiTnbmX0jFkvZP
 gpSjEQfFMwS5pcwK+az6BRto=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id db0af9f75fba137c;
	Fri, 18 Sep 2026 10:24:13 +0000
X-Mizu-Trace-ID: db0af9f75fba137c
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 0/2] docs: cgroup-v2: Correct cpuset CPU descriptions
Date: Fri, 18 Sep 2026 18:23:57 +0800
Message-ID: <20260918102359.71826-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The cpuset interface documentation says cpuset.cpus.isolated is empty
unless an isolated partition exists, omitting CPUs isolated at boot with
isolcpus=domain. Its cpuset.cpus.effective description also assumes CPUs
come from the immediate parent and are normally a subset of
cpuset.cpus, which is not always true for valid non-root partition roots.

Update both descriptions to match the existing behavior.

Guopeng Zhang (2):
  docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
  docs: cgroup-v2: Describe effective CPUs of partition roots

 Documentation/admin-guide/cgroup-v2.rst | 37 ++++++++++++++++---------
 1 file changed, 24 insertions(+), 13 deletions(-)

-- 
2.43.0
