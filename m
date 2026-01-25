Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F2130DEA9;
	Sun, 25 Jan 2026 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769381216; cv=none; b=Z48FII7qhNXAPyHl1V5sYtwoR6ov8qY6KXm2DlRe9r39zGs9qU67t7TSBGQpsNqjVIRrWEzb1qwgS9htcZu6O1DpHek9zUtYnTeltRuRlbCtYOcMY/7J2jYcaaWqKpwY+Pv5Rc0NPX2zU+7u5pSODjhwlVAehhYxwpAdT4lHykI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769381216; c=relaxed/simple;
	bh=gHL1k3Ce/0Yqnu3RKEhMFCTtXjaAjQ9JVob0E5Uoa3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEb+dhcsFEJ55f3RefIz4pc21GdNhdt4CmxQx1JqLBPS+gXz8OJiK+CA8pHgcxqvAHEtTqjXVLDo/pgVRH0vq2O3LwxlajNYPmLfiEMrObobUM6lM0L/NcbMlqGA+06PBEYKEEYgzcl0TzVLvQcWZK3ZaiI8bXKUqdUYM7gwxY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NeWRcvHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NeWRcvHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F61C4CEF1;
	Sun, 25 Jan 2026 22:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381216;
	bh=gHL1k3Ce/0Yqnu3RKEhMFCTtXjaAjQ9JVob0E5Uoa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeWRcvHfyNkP41Y23+BOqfICl2kcKZg/8wKK47gGHMusAHbGA2Wo7fFtJRW7vJrCX
	 yzl5Q2dYHHh5Nj+MLKzPGz5ditBgiu1Kh6txj3s/1tsBYFB5jUDpfDzgKJQ78xA9i+
	 vzkzY62pMpw+HbiFUi5N7D8TXWBRLwsIO0Tqs7qfREjVLgSIKCbdetc5JvC/vbLtFM
	 sGym7Mn6+sf/Pr7KMZUdgSqsox+/Y5NuRSqcvqjRsqx4KegjDVKO/x50YepFOOMc8H
	 RLpX2Ta4FLD8OVTkqUJ7OsFBHGf137O0zSliVHv7zlt4cT0w7Y8qThUAZgqeYQBe+k
	 qk4tadz39hsKw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 08/33] net: Keep ignoring isolated cpuset change
Date: Sun, 25 Jan 2026 23:45:15 +0100
Message-ID: <20260125224541.50226-9-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RPS cpumask can be overriden through sysfs/syctl. The boot defined
isolated CPUs are then excluded from that cpumask.

However HK_TYPE_DOMAIN will soon integrate cpuset isolated
CPUs updates and the RPS infrastructure needs more thoughts to be able
to propagate such changes and synchronize against them.

Keep handling only what was passed through "isolcpus=" for now.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ca878525ad7c..07624b682b08 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1022,7 +1022,7 @@ static int netdev_rx_queue_set_rps_mask(struct netdev_rx_queue *queue,
 int rps_cpumask_housekeeping(struct cpumask *mask)
 {
 	if (!cpumask_empty(mask)) {
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
 		if (cpumask_empty(mask))
 			return -EINVAL;
-- 
2.51.1

