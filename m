Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5269953ECF0
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 11:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788952405; cv=none; b=OZ/24VqRgA01MNahXCUiUdnAC5YBP0nck+lCLz3shOZHHNZ3UZOQTZC3kDAT1Ldfb7j4VTBKlEpxoy07S2ogsxulu1yx8HWHLKhXleAbqQv86YvpBvu1k4jF/ACiez9Lu72/Nk+svajYtj1oSbbK+UwSmp0IJuRo4oxhlHnxl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788952405; c=relaxed/simple;
	bh=SdDK9Jtea+gLoPmR5qgH21O2FL6w+8OF3kIkUfHK2pI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WemExtDOGWRAmo1u02fZBv8HtlM6H5v9wmollyBX4J53aB0GLP/XjMWlWCq+oa5AYa9812nk4bVyVRyjtWEXjvMGidA2nJ4MDT4gwHMbns0wtUv/pX84vkyTnTNKJOX5G+PbSMF6xJPEHHyuPe8VX0THlMfDM5FGmcJHx7Wl14Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UKSgAtEo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1H1aqm4Q; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zdgaJvOx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o9N+FL63; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UKSgAtEo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1H1aqm4Q";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zdgaJvOx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o9N+FL63"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3EF9A1FD7A;
	Wed,  9 Sep 2026 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788952392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeXsftOuNT3CbkQE1Mjo+rsYtRaEoFIut8eLiwn0gnw=;
	b=UKSgAtEoRd2Htkho2rLOzbDL+FbD4x0S4r74urdR0HNW50USjOzygSrun99W0WmLDI5kHL
	OsnrChYdhaHcHXZOKnoMmse7/8aHogubRISX/wSK7GRDIq5VWTOyzBQ+BT8Y8K/LmPDe8q
	1JWZA8Vko+c9IRG0vAPDs4ti0A+Zvow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788952392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeXsftOuNT3CbkQE1Mjo+rsYtRaEoFIut8eLiwn0gnw=;
	b=1H1aqm4Q4G8LuElJMu9tnqwjnzjXS4MHvXB/8VzFK5E74xZTkXE5sKFduEZslxYXhpjW2L
	EWXteG/oaSPaNyBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdgaJvOx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o9N+FL63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788952388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeXsftOuNT3CbkQE1Mjo+rsYtRaEoFIut8eLiwn0gnw=;
	b=zdgaJvOx0hG6nEDGLkB8Dbs4wkI30S8KHJa4pbGB/d7eOZyAhw2mXwvweHalw09A5QrHDd
	fWH9uG4fZhP3qPB+sHLuRoUY66hX9ioLyg2llyvaovZ0DrcDqJ+TsH1t/8otVEDobkTY1w
	3y7OYa/oOc7cqROP8g9Df70IMCB6A70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788952388;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeXsftOuNT3CbkQE1Mjo+rsYtRaEoFIut8eLiwn0gnw=;
	b=o9N+FL63CTDAvYFZ2FzI+7iVC/WpzlcL8KM3YHWg+5HryxpudPVjFBViNMpEfH2j/fgjN1
	qj8B1l3ucX2MLtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E88EE1352C;
	Wed,  9 Sep 2026 11:12:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iWY+AjA/oWqtXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 11:12:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 04EF5A1341; Wed, 09 Sep 2026 13:03:27 +0200 (CEST)
Date: Wed, 9 Sep 2026 13:03:27 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk, tj@kernel.org, 
	jack@suse.cz
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909034343.340703-1-sunjunchao@bytedance.com>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 3EF9A1FD7A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Wed 09-09-26 11:43:43, Julian Sun wrote:
> The expectation in wbc_detach_inode() that "concurrent write sharing of an
> inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> metadata from many memcgs shares the same bdev inode, so dirty throttling
> in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> These flushes can also write ordinary file data, reducing overwrite
> coalescing under continuous buffered overwrites. The resulting extra I/O
> leaves less device bandwidth for other workloads.

Hum. Are you aware of [1]? The guy is from the same company so I was
assuming you two are working together on the problem :). 

[1] https://lore.kernel.org/all/cover.1788836830.git.yinxin.x@bytedance.com

> Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
> foreign dirty tracking for non-bdev inodes are unchanged.

Frankly, I'm not yet convinced this is worth the risk of regressions. The
gains are nice but both the winning and the loosing loads are synthetic and
none of them is like "this is definitely what most people are going to
hit".

I think what [1] is proposing is more in the direction where we might go
(although the second patch in its current form isn't acceptable to me
either). But what I miss from both your approaches is the verification that
the change actually helps your *production* workloads. Unless it is an
obvious fix (like was the case of patch 1 in the series [1]) I'm very
reluctant to approve any additional heuristics unless it is proven they
actually help production loads. These heuristics are never going to be
perfect so you can always come up with a synthetic load breaking it in one
way or another. The art is in tuning them so they work for the practical
cases :)

								Honza

> 
> In a synthetic ext4 test with cgroup v2 (QEMU/KVM, 4 vCPUs, 8 GiB RAM),
> device writes are capped at 200 MiB/s. fio repeatedly overwrites a 256 MiB
> file in the root wb while four memory- and I/O-limited memcgs generate
> metadata and trigger foreign flushes through dirty throttling. A concurrent
> fio performs 16 GiB of sequential direct writes on the same filesystem.
> Across five pairs with 9 GiB of buffered overwrites per run, mean results
> are:
> 
>                                       Baseline    Skip bdev
>   Overwritten-file device writes       5.60 GiB     1.70 GiB (-69.6%)
>   Foreground completion time           104.2 s      89.1 s   (-14.4%)
>   Foreground bandwidth                 157.3 MiB/s 183.8 MiB/s
>   Foreground p99 completion latency     1434 ms      480 ms
> 
> The tradeoff is that memcgs with dirty bdev folios lose this way of
> requesting writeback to relieve dirty pressure. In a separate uncapped ext4
> test, a memcg with memory.high=256 MiB creates 60,000 files paced at 4,000
> files/s, each with a distinct 128-byte xattr, and makes occasional buffered
> data writes. The xattrs use external 4 KiB blocks. Across two pairs,
> completion is 31-33% slower including final sync, while device writes
> remain about 524 MiB.
> 
> With 64-byte xattrs stored within the inode, the same paced workload
> showed no substantial completion-time regression, including at
> memory.high=16 or 32 MiB where the baseline triggered dirty throttling
> and foreign flushes.
> 
> I believe this external-xattr-heavy workload under memory pressure is
> relatively uncommon in practice, and expect the benefits to outweigh the
> regression. I therefore consider this an acceptable workaround.
> 
> Core fio commands for the overwrite test:
> 
>     fio --name=hotspot --filename="$dir/hot.data" --rw=write \
>         --bs=64K --ioengine=psync --direct=0 --thread=1 \
>         --size=256M --io_size=9216M --rate=64M \
>         --refill_buffers=1 --invalidate=0 --eta=never \
>         --output-format=json --output="$out/target.json" &
>     hot_pid=$!
> 
>     sleep 8
>     fio --name=foreground --filename="$dir/foreground.data" \
>         --rw=write --bs=1M --ioengine=libaio --iodepth=32 \
>         --direct=1 --thread=1 --invalidate=0 --size=4096M \
>         --io_size=16384M --eta=never --output-format=json \
>         --output="$out/foreground.json"
>     wait "$hot_pid"
> 
> In the log below, base is the original kernel and skip includes this
> patch. hot_GiB is device writes for the repeatedly overwritten file,
> including final sync; the other performance columns describe foreground
> fio.
> 
> Full five-pair log:
> nohup: ignoring input
> [2026-09-05 17:52:10] RESULTS=/tmp/cgwb-20260905-175145; WARNING: reformats /dev/nvme5n1; 5 pair(s), limit=200 MiB/s
> [2026-09-05 17:52:10] round-001-base: booting
> [2026-09-05 17:52:20] round-001-base: running workload
> [2026-09-05 17:55:36] round-001-skip: booting
> [2026-09-05 17:55:45] round-001-skip: running workload
> [2026-09-05 17:58:57] ROUND 1: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
> [2026-09-05 17:58:57]          base    104.574   156.67    156.67    203.82   1434.45     5.862    0
> [2026-09-05 17:58:57]          skip     89.125   183.83    183.83    173.62    480.25     1.656    0
> [2026-09-05 17:58:57] skip vs base: bandwidth +17.33%, time -14.77%, hotspot IO -71.75%
> [2026-09-05 17:58:57] round-002-skip: booting
> [2026-09-05 17:59:06] round-002-skip: running workload
> [2026-09-05 18:02:18] round-002-base: booting
> [2026-09-05 18:02:27] round-002-base: running workload
> [2026-09-05 18:05:42] ROUND 2: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
> [2026-09-05 18:05:42]          base    103.533   158.25    158.25    201.75   1434.45     5.493    0
> [2026-09-05 18:05:42]          skip     89.124   183.83    183.83    173.65    480.25     1.730    0
> [2026-09-05 18:05:42] skip vs base: bandwidth +16.17%, time -13.92%, hotspot IO -68.50%
> [2026-09-05 18:05:42] round-003-base: booting
> [2026-09-05 18:05:52] round-003-base: running workload
> [2026-09-05 18:09:06] round-003-skip: booting
> [2026-09-05 18:09:15] round-003-skip: running workload
> [2026-09-05 18:12:28] ROUND 3: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
> [2026-09-05 18:12:28]          base    104.648   156.56    156.56    203.96   1434.45     5.334    1
> [2026-09-05 18:12:28]          skip     89.243   183.59    183.59    173.92    480.25     1.824    0
> [2026-09-05 18:12:28] skip vs base: bandwidth +17.26%, time -14.72%, hotspot IO -65.80%
> [2026-09-05 18:12:28] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
> [2026-09-05 18:12:28] round-004-skip: booting
> [2026-09-05 18:12:37] round-004-skip: running workload
> [2026-09-05 18:15:50] round-004-base: booting
> [2026-09-05 18:16:00] round-004-base: running workload
> [2026-09-05 18:19:15] ROUND 4: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
> [2026-09-05 18:19:15]          base    103.565   158.20    158.20    201.84   1434.45     5.497    0
> [2026-09-05 18:19:15]          skip     89.124   183.83    183.83    173.57    480.25     1.648    0
> [2026-09-05 18:19:15] skip vs base: bandwidth +16.20%, time -13.94%, hotspot IO -70.01%
> [2026-09-05 18:19:15] round-005-base: booting
> [2026-09-05 18:19:24] round-005-base: running workload
> [2026-09-05 18:22:41] round-005-skip: booting
> [2026-09-05 18:22:50] round-005-skip: running workload
> [2026-09-05 18:26:03] ROUND 5: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
> [2026-09-05 18:26:03]          base    104.567   156.68    156.68    203.78   1434.45     5.830    1
> [2026-09-05 18:26:03]          skip     89.035   184.02    184.02    173.47    480.25     1.648    0
> [2026-09-05 18:26:03] skip vs base: bandwidth +17.44%, time -14.85%, hotspot IO -71.72%
> [2026-09-05 18:26:03] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
> [2026-09-05 18:26:03] DONE: 5 pair(s); all test VMs stopped
> 
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..6e8f7ff7d44a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	u64 oldest_at = now;
>  	int oldest = -1;
>  	int i;
> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
> +
> +	/*
> +	 * Bdev inodes are usually shared by many memcgs so foreign
> +	 * tracking leads to frequent flushes which is counterproductive.
> +	 */
> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> +		return;
>  
>  	trace_track_foreign_dirty(folio, wb);
>  
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
