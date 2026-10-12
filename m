Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37CF456E19;
	Mon, 12 Oct 2026 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795537; cv=none; b=UE+O1ZPn6REq1WiH/s4SyW+T55A+ETZUWur4XC2oHRTgySYqmY1epK4zlyoTd/FugssNs7Sd/wW/5GnO4OC6chfzcS0l+faKKnqaZ9C5MOcX0f9O0YMoSsuIp3feZlzptWgZY5EDCJFtQAp6x5LjHXTG0RTTh3apCZdYrHnMD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795537; c=relaxed/simple;
	bh=UWOEjKqhNHs9zhTPeaZoLwaOpJi8NMcKoL/AZB09kJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahVEgKbIQBV7nc1JltM95+m8GtWqoYAwPvZVsKNVPSNdkoxxSpmDjK+lNNje/AKXHLJmT20v1v0AOoXXvxa5g19L8x6eTmc06YwIgZ+NxxOXgkxYbd7XqAL/1247oc9nn8uAF9RTRRBW2bh4exiW+NJopieyyksGmriMG+S1OLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=quXQbn7F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s5u1SfEg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=quXQbn7F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s5u1SfEg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="quXQbn7F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s5u1SfEg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="quXQbn7F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s5u1SfEg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9DF521F45A;
	Mon, 12 Oct 2026 08:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791795533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=quXQbn7FS7aeOplubr1TdQtxrb9w4EtRkM3EV3r+7E1ZHJTaBg9TMZoNw514/VzCYSPh3f
	8PZWlxnNpjRF0qDDiXtr5/tv25y0+mp0fKsJ7JnEz7B5ZsAbBgx4+BNl8+0aE7fxkr0daj
	emEqcpywDI9zsy93gwuW2g78NyYDzIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791795533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=s5u1SfEg+uoFRyCwiqJBGIDvVpHYnnByY92dZOZqkz9HcojMTkVH+vKBYg6rAqG54mJIH5
	lOarb7PjyZRNzbCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quXQbn7F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5u1SfEg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791795533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=quXQbn7FS7aeOplubr1TdQtxrb9w4EtRkM3EV3r+7E1ZHJTaBg9TMZoNw514/VzCYSPh3f
	8PZWlxnNpjRF0qDDiXtr5/tv25y0+mp0fKsJ7JnEz7B5ZsAbBgx4+BNl8+0aE7fxkr0daj
	emEqcpywDI9zsy93gwuW2g78NyYDzIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791795533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i693xgyEqFf7YJR68APm92EAi0kFh2Brj850PYxmknA=;
	b=s5u1SfEg+uoFRyCwiqJBGIDvVpHYnnByY92dZOZqkz9HcojMTkVH+vKBYg6rAqG54mJIH5
	lOarb7PjyZRNzbCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7609C13408;
	Mon, 12 Oct 2026 08:58:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tMM7FE2hzGruRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:58:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 04553A1403; Mon, 12 Oct 2026 10:58:48 +0200 (CEST)
Date: Mon, 12 Oct 2026 10:58:48 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, akpm@linux-foundation.org, tj@kernel.org
Subject: Re: [PATCH] fs: account filesystem bdev caches as kernel files
Message-ID: <3xivdukdcs45x2lql3fh3pogrkeb3piiexo2np4xscmz5yk4ot@jqvlshpakn4c>
References: <20261008130747.2868338-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008130747.2868338-1-sunjunchao@bytedance.com>
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 9DF521F45A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Thu 08-10-26 21:07:47, Julian Sun wrote:
> Filesystems such as ext4 use buffer heads to cache shared metadata in
> the bdev mapping. Charging these pages to individual memcgs can trigger
> foreign writeback of the bdev inode's entire owner wb, including
> unrelated file data.
> 
> Following the proposal in the linked discussion, set AS_KERNEL_FILE on
> the bdev mapping while it is used by a filesystem, so newly allocated
> cache pages are accounted to the root memcg. Empty the mapping before
> changing the flag to keep folio insertion and removal accounting
> consistent.
> 
> Multiple EROFS superblocks can share an extra data device. For example,
> two metadata images on /dev/loop0 and /dev/loop1 can reference the same
> data blob on /dev/loop2:
> 
>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop0 /mnt/a
>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop1 /mnt/b
> 
> Unmounting /mnt/a must not clear AS_KERNEL_FILE on /dev/loop2 while
> /mnt/b still uses it. Keep the flag set until the last filesystem user
> releases the device.
> 
> bd_openers includes raw-device opens that may outlive filesystem
> users, while bd_holders also counts partition claims on the whole
> device. Neither counts filesystem users of this mapping, so add
> bd_fs_users, protected by the bdev inode's i_rwsem.
> 
> Update this count in fs_bdev_register() and fs_bdev_unregister().
> These hooks cover both device-open helpers and callers such as btrfs
> that unregister a device and close it separately, without calling
> fs_bdev_file_release().
> 
> Buffered access to the mounted raw device also charges new cache
> pages to the root memcg. Such access is normally restricted to
> privileged users. Pages cached in ordinary file mappings retain their
> existing memcg accounting.
> 
> For filesystems that cache metadata in the bdev mapping, the benefit
> is expected to be most pronounced when multiple cgroups perform
> buffered overwrites alongside direct I/O on the same bandwidth-limited
> device, such as an HDD. Frequent foreign writeback
> reduces write coalescing, producing additional I/O that can saturate
> the device. Direct I/O bypasses the page cache and competes with this
> writeback traffic for device bandwidth.
> 
> An ext4 test combined repeated buffered overwrites of a 256 MiB file
> with foreground direct writes, while four source memcgs generated
> metadata and buffered writes. Device write bandwidth was capped at
> 200 MiB/s. In one baseline/patched pair, background file write I/O,
> including final sync, fell from 6.178 GiB to 1.652 GiB (-73.3%).
> Foreground bandwidth rose from 149.70 MiB/s to 184.19 MiB/s (+23.0%),
> and completion time fell from 109.444 s to 88.951 s (-18.7%).
> 
> Link: https://lore.kernel.org/cgroups/20260925064444.3944820-1-sunjunchao@bytedance.com/T/#m55ee048deb0aad4d1f2293978f25ee6904a5725a
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Good catch with EROFS. The patch looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

FWIW the problem pointed by Sashiko looks real but it's a preexisting issue
with broken bdev write locking when falling back to buffered IO. So it
isn't much related to your patch.

								Honza

> ---
>  block/bdev.c              |  2 +-
>  fs/super.c                | 59 +++++++++++++++++++++++++++++++++++++--
>  include/linux/blk_types.h |  1 +
>  include/linux/blkdev.h    |  1 +
>  4 files changed, 60 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index cd8323083740..766e170286ca 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -79,7 +79,7 @@ static void bdev_write_inode(struct block_device *bdev)
>  }
>  
>  /* Kill _all_ buffers and pagecache , dirty or not.. */
> -static void kill_bdev(struct block_device *bdev)
> +void kill_bdev(struct block_device *bdev)
>  {
>  	struct address_space *mapping = bdev->bd_mapping;
>  
> diff --git a/fs/super.c b/fs/super.c
> index 9d4025213521..7d271bb4cc6d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -25,6 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
>  #include <linux/memcontrol.h>
> +#include <linux/pagemap.h>
>  #include <linux/rhashtable.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
> @@ -1644,6 +1645,55 @@ static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
>  	return NULL;
>  }
>  
> +/*
> + * Filesystem metadata is shared across users and should be accounted to the
> + * root cgroup. Charging it to individual cgroups can trigger foreign writeback
> + * of the bdev inode's entire owner wb, including unrelated file data. For
> + * buffered overwrites, premature writeback reduces write coalescing and
> + * competes with foreground I/O, particularly on bandwidth-limited devices.
> + * This foreign writeback problem primarily affects filesystems such as
> + * ext4 that cache metadata in the bdev mapping using buffer heads.
> + *
> + * Raw buffered I/O also uses kernel-file accounting while a filesystem uses
> + * the device. This is independent of CONFIG_BLK_DEV_WRITE_MOUNTED: writes to
> + * a mounted device are dangerous administrative operations, and charging
> + * their cache to the root cgroup is acceptable.
> + */
> +static void fs_bdev_set_kernel_file(struct block_device *bdev, bool enable)
> +{
> +	struct address_space *mapping = bdev->bd_mapping;
> +	struct inode *inode = mapping->host;
> +
> +	inode_lock(inode);
> +	/*
> +	 * Multiple superblocks can share an extra device, as in EROFS.
> +	 * Switch accounting only for the first user and the last release.
> +	 * Raw openers may outlive all filesystem users, so bd_openers cannot
> +	 * determine when to restore ordinary page-cache accounting.
> +	 * Count at registration/unregistration: btrfs can unregister a device
> +	 * and close it separately, bypassing fs_bdev_file_release().
> +	 */
> +	if (enable) {
> +		if (bdev->bd_fs_users++)
> +			goto out;
> +	} else {
> +		if (--bdev->bd_fs_users)
> +			goto out;
> +	}
> +
> +	filemap_invalidate_lock(mapping);
> +	/* Folio removal must use the same accounting mode as insertion. */
> +	sync_blockdev(bdev);
> +	kill_bdev(bdev);
> +	if (enable)
> +		set_bit(AS_KERNEL_FILE, &mapping->flags);
> +	else
> +		clear_bit(AS_KERNEL_FILE, &mapping->flags);
> +	filemap_invalidate_unlock(mapping);
> +out:
> +	inode_unlock(inode);
> +}
> +
>  static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  {
>  	struct super_dev *sb_dev __free(kfree) = NULL;
> @@ -1654,7 +1704,7 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  		sb_dev = super_dev_lookup(dev, sb);
>  		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
>  			retain_and_null_ptr(sb_dev);
> -			return 0;
> +			goto registered;
>  		}
>  	}
>  
> @@ -1674,7 +1724,11 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  	}
>  
>  	retain_and_null_ptr(sb_dev);
> -	return err;
> +	if (err)
> +		return err;
> +registered:
> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), true);
> +	return 0;
>  }
>  
>  /**
> @@ -1765,6 +1819,7 @@ void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
>  	sb_dev = super_dev_lookup(dev, sb);
>  	rcu_read_unlock();
>  	super_dev_put(sb_dev);
> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), false);
>  }
>  EXPORT_SYMBOL_GPL(fs_bdev_unregister);
>  
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 98e21b4cbf32..19daea93bdec 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -58,6 +58,7 @@ struct block_device {
>  	struct address_space	*bd_mapping;	/* page cache */
>  
>  	atomic_t		bd_openers;
> +	unsigned int		bd_fs_users; /* Protected by bd_mapping->host->i_rwsem. */
>  	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
>  	void *			bd_claiming;
>  	void *			bd_holder;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 4f7905c3412b..f84dff95eae7 100644
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
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
