Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD354457D3
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 21:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977248; cv=none; b=Uh6I+GLcqd5/WHDna7f3wR/awLi57cvrcytw4vG35tjjdNNpwa7DlHHXrwuLYFZbjpJ+1flkaAQIaPnHqkrEdd+bn9hARtt4bcxt5KlA0aAo7YRwhAjgY4weTSMYJS9iSbb2Rf4z4Ty4BKOX1b+nSFkRNXS/BYvB2y1+gGr0lHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977248; c=relaxed/simple;
	bh=zbX4cnEABElDWqQNtrSVaBW0Ked0tvk4MWPkaGIt+6w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FMAg2YqI8zaA3sK/Toe8cFCUiQy9wlo9xTpnlFStx10cFsutcl/kNZKO5W1x+XCdWQqyftgwMuCNSl1QmKcLouheHpY0m8NNggTpCnQ9ESAok4iIxIej3/PJ3/sMtOQrBB6AW0/ae0A0J4imxJFC48bnqAcvRY9lBalU5WBv0zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=mLqABnr1; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="mLqABnr1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790977246;
	bh=AtjuBaVBtKpkdhX//57sGHQwbbwgWOKhzo+1Wz1Aci4=;
	b=mLqABnr13OiWgyHlPw+Q6L1xwFRMf59LA4KL/GPNFu6E0UcmPMWvI/OD9Ld85nWikp59
	rTrAC22X2fDyipD8zSJo6HPpaBZqFSvXwBqMG6938x+svJhaDOShuJcKWNH2OqerkLNYUg
	87lZyXLvi8O/bd2LS2R0MRytxa9ci5zDHoRJ2TXIvG2Zdllt3gw8t+DF5nGg3MEEj7cCfA
	hWzQNHLkHGSX7YyoEvfwwAYP2+olMoDwBMZgJaMLdlztccLbhgzBhD8QoRg954Xl3+spZ/
	ersBJ8a1XT9nXlsCipX5xJmKj4Z1NP+oiEg2OtLJ6xb50U9o0ghG6nWSnTkTZoyw==
Received: by recvd-75d778fcc7-5kxrw with SMTP id recvd-75d778fcc7-5kxrw-1-6AC024DD-89
	2026-10-02 21:40:45.735661736 +0000 UTC m=+276011.229270050
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-64 (SG) with ESMTP
	id Dm-Ltn01QA6RCONnft8w1g
	Fri, 02 Oct 2026 21:40:45.667 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Fri, 02 Oct 2026 21:40:46 +0000 (UTC)
Subject: [PATCH v6 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wb-dying-cgwb-flush-v6-1-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1707; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=zbX4cnEABElDWqQNtrSVaBW0Ked0tvk4MWPkaGIt+6w=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqwCTbHKmybgMSFWqYOqVuQ0Q7s0V2yCJ8XziZ8
 O9DxyOHsXeJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCasAk2wAKCRClztTjl62v
 wgx8B/4u0V1aMjqcyxUZ2wpnLOD6jkCcwOUPNMiqsi2tdsqyI4sUvELleVgSO7stj7CtUBhmfyP
 y5BccMCdn3YXbVUth3FLOdlBADfDF9xMyedYUi7eGyHdx654JCb39LRXXgq00ZgMPGDcFXOFp8t
 JfqU4pvOMfIoA3GLvyPYeUf5MHSU4Im8ceRA9MrjSRBdxID/FnNy1Z5m/deP81YvfJL5F/Z8IWs
 TQ6DGTnqHpiU3JZUz4qsFg+AerhKP7Jl44yeh3vZ6XpbnT1YpGL9a32vT+a4F/F9cmmWfkEGr7T
 4Fk7vF5HVdFQ3JgduiBf+nT4+TCyTOWREbf2yCkJVo4HIokb
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeRuMe7SjpKgd?=
 =?us-ascii?Q?7aS6gNAUxeCWSVoTlVEi+vyXOAV69PW5X0TyP=2Fa?=
 =?us-ascii?Q?GVc9EGvWcV06Em37=2Fa2Gjb+6BNEPhCoIj7cfrXw?=
 =?us-ascii?Q?DMd=2FFpsZy4oM+eMQPjlezh49orWWYwvUrQ0xao6?=
 =?us-ascii?Q?m7Z79qZJgZn8t37+4Nt6TCh8Pvlt0YKwC6a=2FuPY?= =?us-ascii?Q?n55I?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==

Switching a dirty inode to another wb can leave WB_has_dirty_io set on
the old one. inode_do_switch_wbs() moves the inode onto new_wb->b_dirty
through inode_io_list_move_locked(), which only updates new_wb, and
nothing calls wb_io_lists_depopulated() on old_wb. A live wb clears the
bit on its next dirty to clean transition, but a wb that gets no more
inodes, such as a dying one, is freed with its avg_write_bandwidth still
in bdi->tot_write_bandwidth, which wb_split_bdi_pages() and
wb_min_max_ratio() divide by.

Call wb_io_lists_depopulated(old_wb) after the switch loop in
process_inode_switch_wbs(), while old_wb->list_lock is still held.

Test: after the last patch in this series switched a replaced wb's dirty
inodes away, BdiWriteBandwidth stayed at 411700 and 407820 kBps with no
writers and b_dirty, b_io and b_more_io all empty; with this patch it
read 0, in 3 of 3 runs.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..050d507aa554 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -566,6 +566,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	/*
+	 * inode_do_switch_wbs() only updates @new_wb's dirty IO state.  Clear
+	 * @old_wb's if its IO lists are now empty.
+	 */
+	wb_io_lists_depopulated(old_wb);
+
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 

-- 
2.53.0

