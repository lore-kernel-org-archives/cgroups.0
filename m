Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9644FC8D8
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064451; cv=none; b=ULG3+ecwaVZlUoVbOgBXsXWZzluEm3fZqly5bO1/LKKaFO9iFLgKlwaQGfUyu6dKi+oe1TNNgqCUdUxtEprf5lpClSdQTwi79HYa8bzb2Ejxx+9KBCwOQ8+Qqd3xzkHbPmkHPZHe+2l9NLy8pFpQAz0ovUWOhiBO+Swh01cUQZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064451; c=relaxed/simple;
	bh=KBWkxkWj46zd0xpwSYEYCzKTU4VSqzbWDHFWbIpbEgE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VHH/gkXFycZRBQqlg74biOP5vtla2knLy7cw9kWrlPz+Dtc638JmzHUEW4Zu4CpOt4PzfCh/8wcCTTFkg76GOSNBjPfthLOPX/r2NhG5mR7h8HFx2mFzZoKopSSEjsUxG+6rg2w5GsNXL6Hkpt1ozOsJlVUgETxXhFlc4NExoCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=bwKMju6z; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="bwKMju6z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1792064446;
	bh=W1u+B47QVH+BqoNNDPxX4qPg/iyN+d0UIT6/3msYHfQ=;
	b=bwKMju6zvUCM87kUBYN1FpffWt7b6O+/rGJ7+Yn29K+I8ZFuMEwVrrYaiJQwQ8BXKpTG
	r3i6L6/iSdKA8UBpfXRnQlAnIGIitDpes3q+er8at3OQ0CygfQXn4fdlf/Ms93THwG3C+1
	h8DZVR0sUd9XB/0nD1VqOAnQOTQ4ME1VgCmOSrAFHPW6vRNUz3BudbGBJlpMWBYgJA5pwQ
	bTq8c1C0NioY3XfCz3kgDLcTr80TfoVBMIqj7HGGFG3Ek2spJYyXpivufAr63Jtb9X3ZKy
	UKSh/YV7+0P00VdJZRfU69iHL5rX1Pn93ZW/MeGXQRf1DZ56K0a2CQeNEHI7PjMg==
Received: by recvd-6bcc8657fd-7xfmc with SMTP id recvd-6bcc8657fd-7xfmc-1-6AD0BBBE-5A
	2026-10-15 11:40:46.841842789 +0000 UTC m=+1363199.854799708
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-34 (SG) with ESMTP
	id VqFvasx4SLG8b5RDUQfJFg
	Thu, 15 Oct 2026 11:40:46.754 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 15 Oct 2026 11:40:46 +0000 (UTC)
Subject: [PATCH v7 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-wb-dying-cgwb-flush-v7-1-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1745; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=KBWkxkWj46zd0xpwSYEYCzKTU4VSqzbWDHFWbIpbEgE=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBq0Lu8rKtwblHFjr9VRJbmtr+LLZ3cYYunp4xOW
 WrZUBkpr4KJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCatC7vAAKCRClztTjl62v
 wp1LCADqhkBoYfmjxiMI2Tf9lnvY+4nejQr0tz3w5LnXY8N8R11E73joo7VVogUf0R/ovhudv8v
 2V9KqUJirxbnh88lQsSqoEjaBPQsved22/sekx2x1ixn+ytyZaY5KSnsoPiv60hKHz8rld6vaZs
 KIAaBczYFhy/bPOtGhW4/DlYGww/wRHyUq28PYO8mkVIOON9rHPeV0Nz+vv4Ax95oYnMesw+RqH
 cut5rYVPbs3bS5pIK6M5eymh6WV3cOa3/SEWIVrXXfXntwyAbrtUfro7Xq0TkkZoesAH2qO/WCk
 sekOINs+cWvCKohc0kKQxlba3IjhAdbczK+672cGv5xp6S7X
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeew8=2FcRq885E?=
 =?us-ascii?Q?u3Ov4f8W5n5pP8=2Fa06ebyKdHexyEXibOUIzFFzp?=
 =?us-ascii?Q?FtJT92p6u4X8vyHcALfAGBnicOn8G3J8x1TRjdZ?=
 =?us-ascii?Q?j8jIE0lEYuYj5+FK+htbdYjPEyiREs=2FoG2QuXdV?=
 =?us-ascii?Q?YFnBycKoXDbahRhnb1PKjEv=2FugY6GW73Wg6gRZw?= =?us-ascii?Q?SWrq?=
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
Reviewed-by: Jan Kara <jack@suse.cz>
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

