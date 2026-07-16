Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F45424673;
	Thu, 16 Jul 2026 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209358; cv=none; b=TJ9S3yIUBJEpAvqeyAFlUlcRwMi0jCgGQzRgTiU6IZxRDTAd1PX6eSPaDyWhmWPH631Qr4lhkDoKDr4qN+BDshRzRD1vIqdumwOBgaTnwxkf0Bd9goBf3LelXL2UT54EXKg2v0aIpkiUqhARYR6iMXKpQ33J24/XfvMkoI6o3h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209358; c=relaxed/simple;
	bh=2nY+Iq6/8VzBLEajE4I0ru/SZDDX3gzUmQW+p4wy440=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=aaIUopzRJlQ8gKp0+IOwwHU53CaDj5rB3MlmtNgb6dWkvlvH0pb/92EvLkjEy/oiVePpZCG2RLF41QPFvL/W/6hmqBfgKpubyTxo+R2x7ZONRkFmXwf74LlxZi2WXEYRABFdSWjDXes8J+Bt+TCdHBwpOr01VsxEqNrZ80NBXRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=PJtGmJv0; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="PJtGmJv0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=MtdjGmLT0xt5rMnJR8PCtisC7e2MD/SvK2a/9gGKrV4=; b=PJtGmJv0Ua40atV3ewnSERxsNR
	1dsgVmixvVTNJz1outxIMgkjfOP245nFazjkLZwnup7oyutYHdLymiFBtbMrwqmrSRv5vTUn2qPxp
	2MV9oeBGV/lI278BhyA+S+OHXsIePAGd4puaSGcdhwkAsuPgTCtIZYh7az9unRIJC8UCipZuayVdE
	0bh0kTGFF7glT5557VBsTeRD9uCHDfNMlJDZ46Cu1P+qXMjF7zR3SUEeGjjPt49gDo7FqZnwH7Qc5
	N2oH7EOvXZ4XCgxCtIpy5JnY98NgKIOxKFUzNmer9xA19Ev+jLnq6f1hqoPlVx6fSyvXYN2hMQnRi
	BKvdGe0w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkMMB-003rWL-1G;
	Thu, 16 Jul 2026 13:42:31 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 16 Jul 2026 06:42:18 -0700
Subject: [PATCH v2] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
X-B4-Tracking: v=1; b=H4sIALnfWGoC/4XNQQ6CMBBA0as0s2ZMW6SkrLyHYQHtABOlJS0SD
 eHuRi7g9i/e3yFTYsrQiB0SbZw5BmiELgS4qQsjIXtoBGipjTTa4EyzGzHGGV+BA6/4jO5BHit
 ytfXDcC2tgULAkmjg9ynf20LAxHmN6XOONvWr/81NocJOSlVXtjR9aW+eeu7CJaYR2uM4vlSZL
 2C/AAAA
X-Change-ID: 20260626-memcg-oom-uninit-locked-5ec79dff4396
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 SeongJae Park <sj@kernel.org>, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2364; i=leitao@debian.org;
 h=from:subject:message-id; bh=2nY+Iq6/8VzBLEajE4I0ru/SZDDX3gzUmQW+p4wy440=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqWN/Dp97T9AqgyJAixlK0EYy/uzxI1gYRwj0LV
 T+tPYLJUJ6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaljfwwAKCRA1o5Of/Hh3
 bdhuD/9RMDX/TQB0TIXan2SW1ILowW4i9xqF+dCqiN4JL4VHM4AEK47BfKlg6vXjmvHWsPVlsSI
 gTZsT8p6yiT2O6WDrMh0vVmWLPfj8SygfKSFYxFNKh/hlx8vGSmVBn/RVxvSg8oF7XvsnGNWS1N
 KQpyZH/jJaWwEHJGM9KYco1alSy3l3PJeJdbww6eKHCSbhB4pRK+UW0gduK6ECSRz9VWu85dXui
 GsvqFzfHwqK9aTKwHFGiASNxebqEtZtAQA9xNsAAQE+w7EvtJFq/0lqSOqIL0/txcXttZVrlJKk
 DBSykJyMMIWZ+X3ppCuILAlsx6M9Rh52ml9t79iOm00gRx9kPDsssU3Ny4Fu9/tdDzTtaGKwr/n
 OUUlCDfPV7b+U+OCprmVNH6g51Y1jF0Ow+HmbhtmTrJvgg48oJeysUxw0UT3cyTQLn9lnVI/500
 y/bRiHpdvEVP1s4C8N8ASPupuguJBxk5o4MHH8KUSgz5M+DQdoiZbBh120mxv0dBFmbtNcBbccm
 AzZ35B2x4iRzuxf2wNdXHJYfcjqlufl/7yb2LSrhrQuzSYu1tYxm8/LEFVhNcHTamS+L1ykL7bd
 WXyKRXGq1EapdIudlVAr9c4QQlMtpVRKhqIOiKBlrCQ0K5nWs46upe/0kAFyeMPDs0WC2CGPk4R
 pw0o2O9iMAZEtzw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out
there is no OOM lock to take.

Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Cc: stable@vger.kernel.org
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- added the reviews and acks.
- Link to v1: https://lore.kernel.org/r/20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org
---
 mm/memcontrol-v1.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index d3ed5b93290fb..0f703f239c80f 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -101,7 +101,11 @@ static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 

---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260626-memcg-oom-uninit-locked-5ec79dff4396

Best regards,
--  
Breno Leitao <leitao@debian.org>

