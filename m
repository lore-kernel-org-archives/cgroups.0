Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717B438AC99;
	Sat, 17 Oct 2026 18:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792262365; cv=none; b=s/ESZEZgN8ei7sQU0DJIWEt9GDQUGVzCknUTQ/+VPsoEE1L4ZaIHwBxFXV3/8nPBg/MdweNFw2AVk+HBaDyGuikC7dZrUJUW/TonB7B7rF0zGut2C/OwNAb92c6FagbKW4M1Ey3/GKSEGXFFAY1YOyvcb4Q0CYvR9xBJhruPm6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792262365; c=relaxed/simple;
	bh=j1Sq7gj02Y/fsM3Bj+ujep5VUm++/+h+05QAs23TGuc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=aZq0ouE3B2sYfvw5esqaAmgu6wTbC4Jkl6BE9qvkyMYr9UouasF1agEx0hKLlcX7M1NyFH/jIfzg2yaNLlp9Aymiv7DhP9ghUJjSKxP0VK3g78xaRc+XSTsJPqGtvIuNzh40XLnsUI+/L7tXTGPDjGv9tH3ruHRDChrEsrNr4Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TstxZChG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TstxZChG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD601F000C4;
	Sat, 17 Oct 2026 18:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792262364;
	bh=j1Sq7gj02Y/fsM3Bj+ujep5VUm++/+h+05QAs23TGuc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TstxZChGQhlAuN6Vej9C86VmeJrYsg6BGTkCv6R0i0K3kqID3y+bag3dhJce+nGQH
	 ODj7UFvSgACiwPEL1V2lXbM3HvQt116JhVq3iTZpDzgklsAI96nyqRIZwQaGKTD9BC
	 8iytmUz8y8rfqy0kLxRKpBhXoUOgwl4ewJuFnxylRQoqr0W/LrtB4QXX5C2cX608wl
	 hdyuNckobaYMHxvEeEROYyekawL451BiQrTfaOIWoBOdTXFT3vPmGGTt8IEZ5Ui1lT
	 y+g2jNZHceecB7wy9xllu1qZSRqPAPaF90JpJbzPRvArfa2BGQtN6J2JD2nIT5g7vf
	 DzeDRtAFsALNw==
Date: Sat, 17 Oct 2026 08:39:22 -1000
Message-ID: <39c61e6b4d8064bc10440e6fbb00ce05@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
	"Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
 <20261017040710.1174009-1-lizf@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Sat, Oct 17, 2026 at 04:07:11AM +0000, Liz Fong-Jones wrote:
> On a filesystem mounted with lazytime, sync() and syncfs() can return
> without persisting timestamp updates of inodes attached to a dying
> cgroup wb, so a crash after the sync loses them. File data and sizes are
> not affected.
>
> Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
> rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
> inodes it walks to the newest end of the list. When a pass fills its isw
> before reaching an inode that got its lazytime update after a sync's
> cutoff, the walked inodes land past it on b_dirty_time, and the sync's
> queue_io(), which stops at the first inode dirtied after the cutoff,
> misses them. The late inode has to be one without a pending lazytime
> update; one already on b_dirty_time keeps its position.
>
> The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
> anything on b_dirty, b_io or b_more_io, so the scan has to land between
> wb_writeback() fixing dirtied_before and taking list_lock for its first
> queue_io(), unless a multi-pass drain started before the wb got dirty
> IO.
>
> Take wb_switch_rwsem for read across the scan, as
> process_inode_switch_wbs() does for the switches.
>
> Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
> Cc: stable@vger.kernel.org
> Suggested-by: Tejun Heo <tj@kernel.org>
> Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
> Assisted-by: Claude:claude-opus-5-5 checkpatch
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
