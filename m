Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008155;
	b=e1kuxA86ghoP78sb10chrVjtw86DOeESutQfHGZOZ6LQ8NjFsUsQKKoT6CU+1SpPABwj
	 LZjVaJEbeTTHRBeHMlTgL7l9rmErlVfnk+MIXf0WrW1xqgs+BFGROPOOs06L+qxtQPcjG
	 739XI5rSn84R80BuGxfbUCmk4ilfu20jqWLRNOfDAtp0FF1FtGuz4kbozS+oArAH2IjG9
	 u+Rw2KUN1TzPpOXaWcbUREaBK6soaymlW1O+LrZDdHHpFLDU9kyu3S4igi47Nytc8OBk0
	 mdApOhd440z9ovLrKmI9iW5tdXslnDTs2Q+Qr954VZdivkUMuIvagrMQXa71Ok0LknQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=8TF6UKCst8lzq0LV30okvmZ/jdB3sqBqVgF0ME6NPUU=;
	b=lQQ5ml1wE101xGbBAufHLkm6A+apH4Z2RwQcJ3SpTSfnkAqjZaN8CAkSQAbQUJ++jUbq
	 Nu31fUKHdnJfr0U2Hd24Vglh+RBBgLWzIyuOkcw8Jls1WgwboV1z9EIDvaVHPL8B/krFd
	 tGOR2thwA1jNfGiHfvEsTP7pTtjwBWb0my1kWEDabXs94hPs7wQIoWJHraXM2RHqAoN1T
	 btP31Ep/IQ4cVUzzGnQu4dKNySF/Iv6OsxSQz3k5jn7DGPKGZ5sToxWurqxYc2MZOcmp/
	 N2d2zMfPGG/LomquTV++e1WPbYzJkgr0fq4f4DJKALgy/ybFfFLpjz5o6wp8Rjv9ZlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PnAvX89B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0C606A320;
	Wed, 18 Nov 2026 13:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PnAvX89B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142691F000C4;
	Wed, 18 Nov 2026 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795008155;
	bh=8TF6UKCst8lzq0LV30okvmZ/jdB3sqBqVgF0ME6NPUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnAvX89BLlompbeCCkZjl3vr9MCqKZciuydSOpL0eogzTLskwf3xZTohivEs0roUy
	 SGHE3ptZwvcw56AzvAQmWHU2AKWfZBJ1Q+aHQiUujgs16dQbeouPrsRjUXjxqwCmzL
	 Ic0BLwqP6KqS0jGWCMS2T/Ixdqkpxh4ygAhpATxyMBjSiigYgk4GNjPL5CPg7RuAHm
	 2wFGRm0miTBwzMDFzEuxnDS2tc8VOXV/OZSGQmr95YsoKwOuCDUI0e75scvGjYgnhZ
	 3DWuuj7B7Ts5+S7mf+y4R+8vNESPWSyJ/M9EWivAgicYCJ5uI0mObnGGnufPMbHttt
	 d5ZeN50+Ga+jQ==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Julian Sun <sunjunchao@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: (subset) [PATCH v2 0/4] writeback: make slow writeback report more actionable
Date: Wed, 18 Nov 2026 14:21:46 +0100
Message-ID: <20261118-abhaken-flocken-popmusik-322cfc4cfb7b@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1641; i=brauner@kernel.org; h=from:subject:message-id; bh=17BmXY+svo1KKAU3k/ez0FW6KIlSlOJjiwLKTuSYAHE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9XdZ/5kOhJceeRM/vHyZofy/xnxT4zdrUsSbiyamTA sbRT85N6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI74UM/z3e+ShL79f9uLr3 jg/fksyjM6fc89T1ub/9mXZq3aXuc4GMDA1OrMk/izVsRdd9amKoZV95hK0/V3jVt8rFS0XKtr+ 6yQ8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 10 Nov 2026 03:39:26 -0800, Breno Leitao wrote:
> Since v6.19, writeback waiters are woken while their writeback makes
> progress, so a slow sync no longer trips the hung task detector.
> Instead, a waiter past hung_task_timeout_secs logs:
> 
>   INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
> 
> Across the Meta fleet, this line is logged about 19,000 times a day
> (the median over 40 days), and up to 82,000 times on a busy day.
> 
> [...]

I took 1-3 as they're fairly separate fixes. Please rework 4 as agreed on the
thread and send it.

---

Applied to the vfs-7.5.writeback branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.writeback branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.writeback

[1/4] writeback: add the missing newline to the slow writeback report
      https://git.kernel.org/vfs/vfs/c/82da6ca38c26
[2/4] writeback: name the bdi in the slow writeback report
      https://git.kernel.org/vfs/vfs/c/8dd5775aab52
[3/4] writeback: log the end of a slow writeback wait
      https://git.kernel.org/vfs/vfs/c/26286f60c266
