Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BFF3C3F42;
	Mon, 12 Oct 2026 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831573; cv=none; b=awF2geqWj+knpY7xZsislQ88zMZAg/PmAKJ5ZDpuJefF3YZIEOArD/TCboRzuGCTidXrYFqs9gdabPipanB6If9BYzZmXltMdX31rzLULjyE+8mPyqsgJUwWt2VhHoYthBJlMBi4sdoTU1XDmzlZtmP7vBlghNdEJIN1io13lZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831573; c=relaxed/simple;
	bh=Z2VvVLAnbjtCkzf0kYPUOKm4DAlSPjDPhPZN1aphmow=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=l1ZugC9AFj3JAr3Z00GtizHZNLHEXr2R8WRjdm43GsYyWCRyWHB6wXTcAfOmoMZXgDenriFtHYipQucKLBV3JTLkAS/ceOc+OXU3cIPaIr9oA5rvQLhYo+HDkc6l5NziCKnc4byGsMqIo3/6W4hWLuSaG8rrBabgDnCiXNHmpB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=XvnGkL31; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="XvnGkL31"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=lQtzq/X/JU52P/nJ09kQUjdCeEAwcZHCvd7GG32U+YA=; b=XvnGkL317Yciiwnhlpt
	uxNU+NQYKOZJwBDHqL5/wnKbQkPeOl3Jm7fpIqqkerOUAY6yvEiJ+0ia8xhPo1sXggfXT5rZ08LhW
	eFCvSlVA7dDqhW5reGRtVhzo/7gD1nmcWFg5ZLkk+sdeaUWKFe6vm2DLkZLgDOBmVFsIMe7TYhu04
	3nOyXfpQKOEiVzb2FMwaHhAFjdKqpCS0DPracO0pOX7tRDOt1VHmgQnVHLmFdgcebNieAX7O3fcxf
	UCZRkOz5KVUcfVdfYMUAOjNJngaSwFZT0PYZuTIhhG6FGNUYVavDi+YbdhRtxzkR52FqWhSVtHFFl
	V2HTePDXmEbdkgg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLBa-007pPW-1Q;
	Mon, 12 Oct 2026 20:59:08 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] selftests: cgroup: fix the flaky and vacuous
 test_memcg_sock
Date: Mon, 12 Oct 2026 20:59:04 +0200
Message-Id: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPgtzWoC/yWOQQ6CMBBFr0Jm7SQUKxGvYghpywBVoKQzEBPC3
 a24fG/x39+BKXpieGQ7RNo8+zAnUJcM3GDmntC3iaHIi1LlqkCrcYm04MYSIipd3W8aRxIUYmk
 mmlzfcHBvdGFaTCTsxpUHavGULEYYtbtW2nZ5aUoLqZQGO/85XzzrP/NqX+Tkl4bj+AKC4f09p
 wAAAA==
X-Change-ID: 20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-4c394bf06a6b
To: Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2062;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=Z2VvVLAnbjtCkzf0kYPUOKm4DAlSPjDPhPZN1aphmow=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS4CKF4EbIAivMcZSWEvRAa98vfn3KI6iASoG
 7PNPCwpWJqJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uAgAKCRBRlgpH+WFc
 KhFlD/9pWcEXyix7CRTAaXzW8kmtJ/hGZysy4hFvGY2ZCzBLD8HJKSV28swbdEFjOBm43mSu4MM
 nEDz+wjGhPqRvaN5kdIn/5wnTfw5q0Uoow5SM/aj6jTVFs3YL9+aWzfroyM1drnkngXfAHU6Nm5
 5rNLaLRMl6+KTUDtj+B4l9yQFtJuuY+tCxFYVX8QZ2EE31kUTOmXy0beTRBEb7dZ3Em58yXvlIU
 2HOSTqXA2JMzIWaVoahMwdq1aNm3QAb1lU4B74s7rLgRopcpsLK7DCbCbTXiEJly22Tf3K/L1Nh
 VfN184A95DOvv9hgxA91nm1y+gqq67e0dbsmrTCrhpZQo/c60dg77ZmXxrRwMSCNFbGXeekoXS8
 6RleJR4BObU7CokbrOlba2eJr1YKnUzIIvNF6b1HjlRKdPkzIIpxCGp22jqn8r7jTFAKDT6xwJX
 bf+QZVbAH/kLT97IhG2/13JIi3qbvAgC8S+VE1/05NRnAgjkrjExXpFH1rVDSSdEsJyJfHrQ3ns
 ZK5foNFuTC2H0TlJEBaIrHSNE4ThLD4SH1P4JvpJORk13UCTkZZdMmobrZ42hjMIiIXL/yKHIVG
 MjXjVtPby3FvN+ZzBccE+Tk/vFS9CKmPdxx0Qr0JX/f0baiLUDCoGCnIE0VMQp+FakdxqisZAoL
 XBo3u8XhuwtNuzg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

test_memcg_sock fails now and then, and many of the other runs pass
without having compared anything: tcp_client() checks memory.current
against the "sock " entry of memory.stat before the stats get flushed,
and values_close() accepts 0 against 0, so the test passes without
having compared anything.

The patch series
 * skips the test where cgroup.memory=nosocket leaves sockets
   uncharged
 * makes the test cause the stats flushes it needs instead of waiting
   for them: the client keeps the data in the server's socket with a
   small receive buffer and reads until enough socket memory has moved
   through the cgroup that a memory.stat read must flush, and the final
   check allocates and frees anonymous memory in the cgroup before it
   reads "sock ". No sleep or poll is left in the test.

Measured on a 48-CPU x86_64 machine, mainline a5ebb76233b79 built with
the Fedora rawhide config
 * as is (release)
 * with KASAN, lockdep and DEBUG_VM (debug)

test_memcg_sock in 30 runs of test_memcontrol per kernel; "fake" counts
the passes that compared 0 with 0:

                     unpatched          patched
                     passed   fake      passed   fake
  debug kernel       23/30    19        30/30    0
  release kernel     30/30    12        30/30    0

With only CPUs 0 and 1 online, the patched test passed 30 of 30 runs on
each kernel.

---
Konstantin Khorenko (2):
      selftests: cgroup: skip test_memcg_sock under cgroup.memory=nosocket
      selftests: cgroup: make test_memcg_sock check flushed sock stats

 .../selftests/cgroup/lib/include/cgroup_util.h     |  3 +
 tools/testing/selftests/cgroup/test_kmem.c         |  2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 68 +++++++++++++++-------
 3 files changed, 52 insertions(+), 21 deletions(-)
---
base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
change-id: 20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-4c394bf06a6b

Best regards,
--  
Konstantin Khorenko <khorenko@virtuozzo.com>

