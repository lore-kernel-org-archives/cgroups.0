Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8B323416;
	Thu,  8 Oct 2026 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449479; cv=none; b=dZHRMGqdbDHys93iRNiVMDCBLNZey3t3ST6TG93nExsga5BAmoK+ZlxrKUMG059XIIyTHAQ6FO+uriaPMSY0RoWXOHQ+4yJGhV+au3A7LFDRKNIopYfQDhq9rMJjjvGOLqhHY8dRvGiw3yw4fWAzJrFeCbmGcvI+pzoO2ztx668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449479; c=relaxed/simple;
	bh=Jlhd7wkc7bNs6ST+GXoeDsxkZ6wKLU7IlGLpGcrTR1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQUa4+aRMWY09hmHEfBx44wasP4naO8u3t3uSINi02BDEfvDJORwQ8pUWm6D18W1jQOmaHKvDqgk/3TViPndKL+l4DeIhVnEUyeMGo8jLn075yoRdlddnjnOoqTvTBs4axF98BAGYe8kS/3u8ruDa0pRKvHta32Z73rShFrxroQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XnYsdjnN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=g3Va1iq1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XnYsdjnN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="g3Va1iq1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 758A021B8A;
	Thu,  8 Oct 2026 08:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791449473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/AeD2MF2duASzk4+OjGc0B5KDhiaEJ5Z4p2fwoqWO0=;
	b=XnYsdjnNpHHUrteojZSJYGhPs7rRcrITORW1dFFG16kBT/rCzANRIAAJUGQNI6tjPB/V7L
	SG7iPfPriMCg7RiNqBtlbQ+esugl2W+m2av1dJi+hdqAGwL8E8XoBZSItCKayhcSPlJBhn
	FVjnz4c3RijiMZj2Zs4sHhhUExanGws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791449473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/AeD2MF2duASzk4+OjGc0B5KDhiaEJ5Z4p2fwoqWO0=;
	b=g3Va1iq1SiddGrJTi41KaC3lC2olPYlQUIwhFo6m8okwOsYISDDdsftVaxxjiSgDJQWE3f
	1U/fd68PBSnbdLBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 498F31339F;
	Thu,  8 Oct 2026 08:51:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m/m0CYFZx2ryVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 08:51:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C325AA13FC; Thu, 08 Oct 2026 10:51:08 +0200 (CEST)
Date: Thu, 8 Oct 2026 10:51:08 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	willy@infradead.org, tj@kernel.org, akpm@linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <dzq3d5yosbsdeml4fdb3rpowxxnjau6edluw4xoewwwbv4hykg@ywkjm3xlbimv>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
 <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
 <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.60 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	R_DKIM_NA(2.20)[];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.13)[-0.656];
	MIME_GOOD(-0.10)[text/plain];
	NEURAL_HAM_LONG(-0.06)[-0.060];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,bytedance.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 758A021B8A
X-Spam-Flag: NO
X-Spam-Score: -0.60
X-Spam-Level: 
X-Rspamd-Action: no action

On Thu 08-10-26 16:00:13, Julian Sun wrote:
> On 10/6/26 12:25 AM, Jan Kara wrote:
> > On Mon 05-10-26 01:26:28, Christoph Hellwig wrote:
> >> On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
> >>> FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
> >>> for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
> >>> for bdev mappings will cause issues because some users may be using bdevs
> >>> directly for their workloads and they could still expect proper memcg
> >>> accounting to work in that case.
> >>
> >> Agreed that it should not set unconditionally.
> >>
> >>> We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
> >>> it when releasing bdev) but that would have to make sure there are no
> >>> folios in the bdev mapping when changing the flag as otherwise the
> >>> accounting would go wrong. Looks it might be doable but getting all the
> >>> cornercases right will be hairy and overall not very appealing to me...
> >>
> >> I'd rather not support special case writeback code just for this legacy
> >> fs abuses bdev buffer cache case.  And we basically need to tear
> >> down pagecache at unmount anyway, as i_blkbits can change, so while
> >> we do need to be careful, I don't think it really is a major issue.
> > 
> > OK, after some more thought yes, I think we can make that work.
> > 
> >> We might be able to restrict to setting it when
> >> CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
> >> shared mmap writers, as anyone using a modern kernel and cgroups really
> >> should have that disabled.
> > 
> > I don't think that's really needed. If such writes are happening, they are
> > *very* limited and done by a system administrator only (as they are very
> > dangerous) so the fact the writes will get charged to the root cgroup is
> > not an issue.
> 
> Hi, Jan, Christoph.
> 
> Thanks for your suggestions.
> 
> One remaining concern: while ext4 is mounted, buffered reads of the raw
> block device would also charge page-cache allocations to the root memcg,
> bypassing the reader's memcg memory limits. Is that acceptable?

Yes. If you have a setup where unprivileged user can read raw block device
with the filesystem mounted, your security model is very doubtful. I don't
think anybody sane can do that. Also setting up of loop devices and
mounting filesystem on top is privileged operation and if a user can do it,
memcg accounting is the least of your troubles. Of course even privileged
process can be constrained in a cgroup and this containment will not
account bdev pages properly in the case you describe but even then I have
hard time coming up with a tool that would read a significant portion of
the device (e.g. udev will be reading mounted bdevs but only small portions
of them) and even if it does, this would be a clean page cache which is
easy to reclaim.

So I cannot think of a practical setup where this charging behavior could be
a problem. Of course I could be proven wrong by some user complaining and
then we'd have to revert and go back to the drawing board.

> I've attached a preliminary diff. Does this approach look reasonable?
> If so, I'll split this into a formal patch series.

In principle, the mechanism looks good to me but I'd place it in
fs_bdev_file_open_by_dev() & fs_bdev_file_release() so that all block
device based filesystems are handled. ext4 is the most used filesystem that
has this problem with bdev memcg accounting but in principle exactly the
same problem happens for other filesystems using buffer heads so I'd prefer
handling it in the generic code instead of fixing them one-by-one as people
complain...

								Honza

> 
> diff --git a/block/bdev.c b/block/bdev.c
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -79,7 +79,7 @@ static void bdev_write_inode(struct bloc
>  }
> 
>  /* Kill _all_ buffers and pagecache , dirty or not.. */
> -static void kill_bdev(struct block_device *bdev)
> +void kill_bdev(struct block_device *bdev)
>  {
>  	struct address_space *mapping = bdev->bd_mapping;
> 
> @@ -89,6 +89,7 @@ static void kill_bdev(struct block_devic
>  	invalidate_bh_lrus();
>  	truncate_inode_pages(mapping, 0);
>  }
> +EXPORT_SYMBOL_GPL(kill_bdev);
> 
>  /* Invalidate clean unused buffers and pagecache. */
>  void invalidate_bdev(struct block_device *bdev)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
>  unsigned int block_size(struct block_device *bdev);
> 
>  #ifdef CONFIG_BLOCK
> +void kill_bdev(struct block_device *bdev);
>  void invalidate_bdev(struct block_device *bdev);
>  int sync_blockdev(struct block_device *bdev);
>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1279,6 +1279,56 @@ static void ext4_flex_groups_free(struct
>  	}
>  }
> 
> +/*
> + * Account ext4 metadata cache to the root cgroup. This filesystem-wide
> + * metadata is shared across users, so it is not naturally attributable
> + * to a single user cgroup.
> + *
> + * A bdev inode can contain metadata pages charged to many memory cgroups.
> + * Dirtying these pages can trigger foreign writeback of its entire owner wb,
> + * including unrelated file data. Premature writeback of buffered overwrites
> + * reduces write coalescing, increasing disk traffic and consuming bandwidth
> + * that could serve foreground direct I/O. This can hurt performance,
> + * particularly on bandwidth-limited devices such as HDDs.
> + *
> + * This does not depend on CONFIG_BLK_DEV_WRITE_MOUNTED. Writing directly to
> + * a mounted block device is dangerous and intended for system administration.
> + * Charging the cache from these writes to the root cgroup is acceptable.
> + */
> +static void ext4_bdev_set_kernel_file(struct block_device *bdev, bool enable)
> +{
> +	struct address_space *mapping = bdev->bd_mapping;
> +	struct inode *inode = mapping->host;
> +
> +	inode_lock(inode);
> +	filemap_invalidate_lock(mapping);
> +
> +	if (!!test_bit(AS_KERNEL_FILE, &mapping->flags) == enable)
> +		goto out;
> +
> +	/*
> +	 * Folio removal uses the mapping's current accounting mode. Remove old
> +	 * folios before changing it, excluding new raw-I/O cache allocations.
> +	 */
> +	sync_blockdev(bdev);
> +	kill_bdev(bdev);
> +
> +	if (enable)
> +		set_bit(AS_KERNEL_FILE, &mapping->flags);
> +	else
> +		clear_bit(AS_KERNEL_FILE, &mapping->flags);
> +out:
> +	filemap_invalidate_unlock(mapping);
> +	inode_unlock(inode);
> +}
> +
>  static void ext4_put_super(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -1387,6 +1437,7 @@ static void ext4_put_super(struct super_
>  #if IS_ENABLED(CONFIG_UNICODE)
>  	utf8_unload(sb->s_encoding);
>  #endif
> +	ext4_bdev_set_kernel_file(sb->s_bdev, false);
>  	kfree(sbi);
>  }
> 
> @@ -5852,6 +5903,8 @@ static int ext4_fill_super(struct super_
>  	if (ctx->spec & EXT4_SPEC_s_sb_block)
>  		sbi->s_sb_block = ctx->s_sb_block;
> 
> +	ext4_bdev_set_kernel_file(sb->s_bdev, true);
> +
>  	ret = __ext4_fill_super(fc, sb);
>  	if (ret < 0)
>  		goto free_sbi;
> @@ -5877,6 +5930,7 @@ static int ext4_fill_super(struct super_
>  	return 0;
> 
>  free_sbi:
> +	ext4_bdev_set_kernel_file(sb->s_bdev, false);
>  	ext4_free_sbi(sbi);
>  	fc->s_fs_info = NULL;
>  	return ret;
> 
> 
> > 
> > 								Honza
> 
> Thanks,
> -- 
> Julian Sun <sunjunchao@bytedance.com>
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
