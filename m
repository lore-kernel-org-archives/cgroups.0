Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CCB38B7B4;
	Wed, 24 Jun 2026 06:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283598; cv=none; b=HjMjwpIPhKTxPYxwKovxLTTbKCUsbbQF7dOd3bLlhU1RZR9VsFZ9yaszFDc+NxzqsJmHVH0zFuQDXYcwXlVuCwkQO2MC1kKZnwiiT8HQvZw2un7LOMVM/f095hTMF5kyg8afpJHYF4NdqP+38V1yTPl7EJKLTk+n2rjw8audNB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283598; c=relaxed/simple;
	bh=mqeOltsU41ecYb4Pv/kiN9MaPfvWNqWaZUrDPH9aFTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4ZUkLh1HwpzNu2tNzh8kSMZDK244U46T1YTC2sK6oIm8diwKSezltoMli0AZnmd0ZKRrZyRgwNF4bxapNd2plbAxuQUtORRVTZRnZM12kBsjnG9JJdGPbsv6NgNwUJ73jMPoGMakL+8Mzncc+yAKACzdXALjViegqqzOsAQVMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zxjvgiav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zxjvgiav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B364F1F00A3D;
	Wed, 24 Jun 2026 06:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283597;
	bh=tQ5U75gZxbS9I0gcWftk3zWcpca0EZZnduvUXjeJdPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zxjvgiavs+9YgX5lq0yGW5X/md5UU2qGxBQtMfNzEZp1srr73so28YnRtBfTowj+E
	 PrNdMPdU9rbHd8u+KWrTWc0ClFZDDy5w3Ldi6UD8ZuNa7zdKpJCT1SdNm0OQunbsbC
	 RMKek2MweP5nbRJiFmeLwypVRjgcitKmM8dCY7H9OfOwUQzho/0PyKKBDlClUEArJS
	 7Ebe6ltPcXJVIG3QL4KxyWCc0GLDYeE2S2xOwq4z7/iwi2tTYmk8qSyH7J38GuiTI0
	 KcD/+ZdJ60ScXF4HalG7l/YdlHpjcwAllZBhOjrIy0PFUPNY1/aqIU1makpwdgrl7Y
	 L+Et3c+GtJJQg==
From: Yu Kuai <yukuai@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] blk-cgroup: fix blkg list and policy data races
Date: Wed, 24 Jun 2026 14:46:21 +0800
Message-ID: <20260624064625.1743650-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260624064625.1743650-1-yukuai@kernel.org>
References: <20260624064625.1743650-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Hi,

This series fixes races around q->blkg_list and blkg policy data
lifetime.

Patch 1 protects blkg_destroy_all()'s q->blkg_list walk with
blkcg_mutex.

Patches 2-3 fix races between blkcg_activate_policy() and concurrent
blkg destruction.

Patch 4 factors the policy data teardown loop into a helper after the
race fixes.

Changes since v1:
- Drop the BFQ q->blkg_list patch because the current block tree already
  has a stronger fix in commit 17b2d950a3c0 ("block, bfq: protect async
  queue reset with blkcg locks").
- Add Reviewed-by tags from Tang Yizhou.

Yu Kuai (1):
  blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with
    blkcg_mutex

Zheng Qixing (3):
  blk-cgroup: fix race between policy activation and blkg destruction
  blk-cgroup: skip dying blkg in blkcg_activate_policy()
  blk-cgroup: factor policy pd teardown loop into helper

 block/blk-cgroup.c | 65 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

-- 
2.51.0
