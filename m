Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705753EBF07;
	Fri,  2 Oct 2026 19:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790968993; cv=none; b=k0lNQ9Fh3h48Ws8s4cd9S+blBK8pHfdU2Q/3egLPK0HQ0nhBLQnl1d220D/G/4Mj/R0/0HAoxV+sxHECIVE2SHORR97MYxKmdnCZSIcyfACOWCTB8BBpc2KxRrXcOO9EkqazphQVgHuQjdXrETZhHeMh3ApfcDnMcInkrfm9LBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790968993; c=relaxed/simple;
	bh=nmJFmwv1vZOSj64C4vxFCqZiEzsILZQ/fnirV7uR+/I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBI6TeAs6fKy0b+Ko+0FwVX4jhOSdVb1bWO9SYjHLNqWav8iSaHjqmyu74qbu8VVIw/iJW47TSZzZ76pYqHKf3AUULJueP+ZO1m7MUAYQ4Whut/EP44osrR2ObY4rw6c7uH1qKEA8J0pCj6UYDf9v1FBkU+wfZutr2d+kUh4+OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxFSYnvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxFSYnvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A0A1F000FF;
	Fri,  2 Oct 2026 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968989;
	bh=LDKFXAR0QzYZG82qZDFlEgdx5fL1gbJMd6mPxLwtfJ8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IxFSYnvjc06qv3d3xnR17CAgIP4Wz9E6F6qevNBi/fKJKUPzJJCa4Cw2Hlqj0A8S6
	 8vxK1piI/0QitQ8hDLk0ns43n+pUfVYziyoOgxZ70ETTr41LumfymTfb31h37kakRC
	 /eDFP7Gnvr6mYrRJXNGUP6t2keD9dgM5DtLiYWQLnGUkVevo1bA0z7fBrk3oQSWRdy
	 kSykIwEdeT43cHBqZ9scoC7+Q4ebajdk5V7LwZTw/9xQ3Shg6Iwm3Me0/Yu3YTo/AO
	 aPeJ/PihcT1HQTmKABKJpgYYbylJrjCE/4lm+PayNLrLheAJ9ynUpIxQms6hsivNU4
	 ThTXurHZBZ2Cw==
Date: Fri, 02 Oct 2026 09:23:09 -1000
Message-ID: <c5675dcba08c91acaddfc2869193cdb3@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v5 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-3-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
 <20261001-wb-dying-cgwb-flush-v5-3-8361eb8c65c6@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Liz.

On Thu, Oct 01, 2026 at 11:50:21PM +0000, Liz Fong-Jones wrote:
> it only queues the work, after dropping cgwb_lock. Inodes already being
> switched when the work runs are left to the existing per-inode
> switching, so this is best effort. If the successor is already gone,

That covers inodes being switched away from the old wb but not the ones
being switched to it. inode_switch_wbs() pins its target while the wb is
still live and the context lands later through the wb's switch_work, with
nothing ordering that against replaced_work. Those inodes end up on the
replaced wb after its scan, and for a removed memcg css_is_dying() keeps
them there until clean.

Every context lands through inode_switch_wbs_work_fn(), so can you kick
replaced_work from there when new_wb is dying and no longer owns its slot?
A dying wb that still owns its slot must not be kicked, or the work would
look up itself.

> +	/*
> +	 * The replaced wb is out of foreign flushes' reach but may still have
> +	 * inodes attached, dirty or not.  Switch them over to @wb.  We may be
> +	 * running with interrupts disabled, so use a work item.  A replaced wb
> +	 * never returns to the tree, so its work can't already be pending.
> +	 */
> +	if (replaced_wb &&
> +	    !queue_work(system_dfl_wq, &replaced_wb->replaced_work))
> +		wb_put(replaced_wb);

With the re-kick, already pending becomes a normal case. Maybe make this a
helper which trygets, queues and puts on failure, shared by both call
sites, and drop the last sentence.

Thanks.

--
tejun
