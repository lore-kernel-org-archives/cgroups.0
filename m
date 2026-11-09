Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217103;
	b=IGOv+wR72P0rkOkE0WlC9oCF5xKHRaFuuSfyx8A+jxAycXz35DuxMt1A7q1tgu5Tpke4
	 NIY/tuUYVMq6aKh5kIj5WjAQUB4PVzMKTzcMPM7Rn1pPK4X2KfprX7OyaQKZFF35LClBh
	 tESpsDeWtgCDNtQrGH3MgwwLG6p/QWb6W3K6jR/jZPPlBeQjNj6sAtl/YjYr92E9EJ6sp
	 oJvqPQo/HHr6jYOpzRTHwW12wgGTKlnGgtZKE8TvsWY3/3AKxez2qTE8APdRE4bZwwOrO
	 ZOV+Qei2uoCov71yYCyscl2ayiCleFtA+IC+y08wKPsz7jElkR5O0j6R4PX1Vv5Lt2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217103;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vMJSg0lmacnY+UcGHVNgSDJi3N4uyY4O9jJ0C/cw0zk=;
	b=PjT/5otiExcyYbGgeFd3Pveo6yxuP7yWqJDmUHCiMpQV0S1yzcmM34kzTdAtD8PrtqpG
	 w4YHVkBtP2sUL7IC9zxfRYp/9HVe1hVZAYjrhA0bxRwPiLv+3bDqTZ70kmy86pIgwr+Zb
	 JYeTCnhTHxdeqmM5kwbjuh35JSd+gZXsvNSylnNZMIqqqilaIZvFm2HT5gOr5jcqscB4q
	 I7ihgok8wPQsl6CGV2jtKNBhivpxqwuYpF2mgdV5bhKK+Vxep5j4w6EeGJUV4TuKXFR9N
	 IcU/hkS6as9X6SqAQqfTKtHU5J/vIFbjD2qf35d1Qmj+WnlEDm9bv2H6tZK8lJSJv9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=KHuzvPDs;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF060606A321
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:38:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF060606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=KHuzvPDs
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36dbde64409so1175765eec.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 01:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794217102; x=1794821902; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vMJSg0lmacnY+UcGHVNgSDJi3N4uyY4O9jJ0C/cw0zk=;
        b=KHuzvPDs+6IUSeE0sG+wgkRMym9JU7b7w/TEihVG7UtY5yKSCq3SU4YIsvUbbbqDUy
         DxddA6ecwe9WpOv46viIOiPIdVbetXLJnqlGywEHNMrGl2mdO89xFMffuFFs6WiF/OiR
         UVgbTxGt3rnTojai5e9wSzLKL+1PPCfI5Ua7Sat8QZBifbNzW+/gfXjwD0+0sY3Xl2ab
         9JXB8ldl9AWkZf44j0wGcmqdlLQahqrp0LC1NhwZ7AZT3FZkrI26FymnMvf0uQXsC3uL
         OOs5iEp7DtEdgrQZTn9/E76vpAZfksxvl3Q8hIXdktGmRE1N8EjlV2HKKzTior0FeMQi
         uXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794217102; x=1794821902;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vMJSg0lmacnY+UcGHVNgSDJi3N4uyY4O9jJ0C/cw0zk=;
        b=JhVO3ZwQsUQ60Hd4zyeBcCBGy4v+VzMrVr2mQT+dEXZ6zb7OeoWtde5gsNHmnu8eUt
         giORzAllYv7z4EoPErzKAQVAGarHi3zOlJthLlzA5tYvbAQV3G98XrzOaqzk+GhdQB77
         A6GGCGAnz9Nju4ChlKkKpT3TUsycGJFRNG6DXi8AVS9sMURZyErPQ9lPJb8LbJO5NCiN
         F898RldnJici+XlXcYJ02PJUFzR2L+H7mnScCaoQmDuAxPwLA6r6O0ecZd5NueaFrDMN
         dIxBJkS05YBCIcjkU8ui5wrD8/5w+XiPrmdeyrnrgHy0u21QDEMcdyi64Z4x13KVRIap
         tzWA==
X-Forwarded-Encrypted: i=1; AL+hErG9LOZDWEn0gBNExWejgMPlp/SEavd7fbe1JETs4ei+7FfZoFP47R9F3JiV4Ccf7eQYxssAckVY@vger.kernel.org
X-Gm-Message-State: APuU4Z92uHQyi9wo4KjZYA9fZMx914PQoVwNFJ1K40xRXzMM+CwE580K
	tqF4i5I9tCVad14RjsZ7TeBFodiWFMvtTG4nmubao7EfGN1GHQ0DUd6c9IcSJXnlnNg=
X-Gm-Gg: AYBFou1RqnLApYqWDdFMr8kE6ILrD2b9lDzV++uNZMihzpc5VBrALwgVdqnsKuh42sO
	V47pF+ho6OUB5jwvzWTWpMVXF0jkw2EZ+wclkfT2VDBQzGpIaJ+ouJqcmZjzf9U0+m3OS+zJJhp
	M4JjTXo2q85+XI9CMGGW36tBustv8XWv4hj9mC9QbJkzdwPlj66n67kO3VTD7PYoixbmi9VO2m+
	Nr3XCHzSoDvrRXMyJV+S/Raln0VJ9HalKx25D/RLljPxXb+5MVDLLt30E8K9cM1y/PAlRo4oHkk
	JRSKDXCkNg+PaKM5DsdduvFnsQFe86E4ZNmDE4NyFyE3FKDrPVdofxPvbKoeNGoAHVfCpzLkp5S
	tEBV4jxVYrbfv9uPjIYZZaY/YP3DD8YST0u1YpWyn2jmKD25/mng4crXD5tktnFAAA76bOdjT65
	pvhrAUtXUZhEkIbHcnO9H9gkJrYaomI1W2DToHjFhjFKKlESF5kggouRUohR+I8zhqBYaXsDTHa
	MEm4jt1ozygkYHXv0ZyJFu5N7JXlP1wNswb5tMtlciuiV/3F/C6Ca2BpHm2ckK1VL/lgz5jm+FX
	p0sCGxdrlTGS2DH4Oq3ieLVUyWR9Mk00H5bCUfmXXh42FPH8QuXxwhY+rarxWnm1uR/dK+uT
X-Received: by 2002:a05:7301:d80e:10b0:36a:50ec:db3f with SMTP id 5a478bee46e88-372575c557amr6835812eec.7.1794217101438;
        Mon, 09 Nov 2026 01:38:21 -0800 (PST)
Received: from [100.81.10.186] ([61.213.176.59])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-372669d2826sm12719426eec.29.2026.11.09.01.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 01:38:20 -0800 (PST)
Message-ID: <29bf4bce-cdb8-425c-8090-d8d84a749a73@bytedance.com>
Date: Mon, 9 Nov 2026 17:38:17 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: account filesystem bdev caches as kernel files
To: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk,
 brauner@kernel.org, akpm@linux-foundation.org, tj@kernel.org
References: <20261008130747.2868338-1-sunjunchao@bytedance.com>
 <3xivdukdcs45x2lql3fh3pogrkeb3piiexo2np4xscmz5yk4ot@jqvlshpakn4c>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <3xivdukdcs45x2lql3fh3pogrkeb3piiexo2np4xscmz5yk4ot@jqvlshpakn4c>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/12/26 4:58 PM, Jan Kara wrote:
> On Thu 08-10-26 21:07:47, Julian Sun wrote:
>> Filesystems such as ext4 use buffer heads to cache shared metadata in
>> the bdev mapping. Charging these pages to individual memcgs can trigger
>> foreign writeback of the bdev inode's entire owner wb, including
>> unrelated file data.
>>
>> Following the proposal in the linked discussion, set AS_KERNEL_FILE on
>> the bdev mapping while it is used by a filesystem, so newly allocated
>> cache pages are accounted to the root memcg. Empty the mapping before
>> changing the flag to keep folio insertion and removal accounting
>> consistent.
>>
>> Multiple EROFS superblocks can share an extra data device. For example,
>> two metadata images on /dev/loop0 and /dev/loop1 can reference the same
>> data blob on /dev/loop2:
>>
>>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop0 /mnt/a
>>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop1 /mnt/b
>>
>> Unmounting /mnt/a must not clear AS_KERNEL_FILE on /dev/loop2 while
>> /mnt/b still uses it. Keep the flag set until the last filesystem user
>> releases the device.
>>
>> bd_openers includes raw-device opens that may outlive filesystem
>> users, while bd_holders also counts partition claims on the whole
>> device. Neither counts filesystem users of this mapping, so add
>> bd_fs_users, protected by the bdev inode's i_rwsem.
>>
>> Update this count in fs_bdev_register() and fs_bdev_unregister().
>> These hooks cover both device-open helpers and callers such as btrfs
>> that unregister a device and close it separately, without calling
>> fs_bdev_file_release().
>>
>> Buffered access to the mounted raw device also charges new cache
>> pages to the root memcg. Such access is normally restricted to
>> privileged users. Pages cached in ordinary file mappings retain their
>> existing memcg accounting.
>>
>> For filesystems that cache metadata in the bdev mapping, the benefit
>> is expected to be most pronounced when multiple cgroups perform
>> buffered overwrites alongside direct I/O on the same bandwidth-limited
>> device, such as an HDD. Frequent foreign writeback
>> reduces write coalescing, producing additional I/O that can saturate
>> the device. Direct I/O bypasses the page cache and competes with this
>> writeback traffic for device bandwidth.
>>
>> An ext4 test combined repeated buffered overwrites of a 256 MiB file
>> with foreground direct writes, while four source memcgs generated
>> metadata and buffered writes. Device write bandwidth was capped at
>> 200 MiB/s. In one baseline/patched pair, background file write I/O,
>> including final sync, fell from 6.178 GiB to 1.652 GiB (-73.3%).
>> Foreground bandwidth rose from 149.70 MiB/s to 184.19 MiB/s (+23.0%),
>> and completion time fell from 109.444 s to 88.951 s (-18.7%).
>>
>> Link: https://lore.kernel.org/cgroups/20260925064444.3944820-1-sunjunchao@bytedance.com/T/#m55ee048deb0aad4d1f2293978f25ee6904a5725a
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> Good catch with EROFS. The patch looks good to me so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> FWIW the problem pointed by Sashiko looks real but it's a preexisting issue
> with broken bdev write locking when falling back to buffered IO. So it
> isn't much related to your patch.
> 
> 								Honza
> 
>> ---
>>  block/bdev.c              |  2 +-
>>  fs/super.c                | 59 +++++++++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h |  1 +
>>  include/linux/blkdev.h    |  1 +
>>  4 files changed, 60 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/bdev.c b/block/bdev.c
>> index cd8323083740..766e170286ca 100644
>> --- a/block/bdev.c
>> +++ b/block/bdev.c
>> @@ -79,7 +79,7 @@ static void bdev_write_inode(struct block_device *bdev)
>>  }
>>  
>>  /* Kill _all_ buffers and pagecache , dirty or not.. */
>> -static void kill_bdev(struct block_device *bdev)
>> +void kill_bdev(struct block_device *bdev)
>>  {
>>  	struct address_space *mapping = bdev->bd_mapping;
>>  
>> diff --git a/fs/super.c b/fs/super.c
>> index 9d4025213521..7d271bb4cc6d 100644
>> --- a/fs/super.c
>> +++ b/fs/super.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/blkdev.h>
>>  #include <linux/memcontrol.h>
>> +#include <linux/pagemap.h>
>>  #include <linux/rhashtable.h>
>>  #include <linux/mount.h>
>>  #include <linux/security.h>
>> @@ -1644,6 +1645,55 @@ static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
>>  	return NULL;
>>  }
>>  
>> +/*
>> + * Filesystem metadata is shared across users and should be accounted to the
>> + * root cgroup. Charging it to individual cgroups can trigger foreign writeback
>> + * of the bdev inode's entire owner wb, including unrelated file data. For
>> + * buffered overwrites, premature writeback reduces write coalescing and
>> + * competes with foreground I/O, particularly on bandwidth-limited devices.
>> + * This foreign writeback problem primarily affects filesystems such as
>> + * ext4 that cache metadata in the bdev mapping using buffer heads.
>> + *
>> + * Raw buffered I/O also uses kernel-file accounting while a filesystem uses
>> + * the device. This is independent of CONFIG_BLK_DEV_WRITE_MOUNTED: writes to
>> + * a mounted device are dangerous administrative operations, and charging
>> + * their cache to the root cgroup is acceptable.
>> + */
>> +static void fs_bdev_set_kernel_file(struct block_device *bdev, bool enable)
>> +{
>> +	struct address_space *mapping = bdev->bd_mapping;
>> +	struct inode *inode = mapping->host;
>> +
>> +	inode_lock(inode);
>> +	/*
>> +	 * Multiple superblocks can share an extra device, as in EROFS.
>> +	 * Switch accounting only for the first user and the last release.
>> +	 * Raw openers may outlive all filesystem users, so bd_openers cannot
>> +	 * determine when to restore ordinary page-cache accounting.
>> +	 * Count at registration/unregistration: btrfs can unregister a device
>> +	 * and close it separately, bypassing fs_bdev_file_release().
>> +	 */
>> +	if (enable) {
>> +		if (bdev->bd_fs_users++)
>> +			goto out;
>> +	} else {
>> +		if (--bdev->bd_fs_users)
>> +			goto out;
>> +	}
>> +
>> +	filemap_invalidate_lock(mapping);
>> +	/* Folio removal must use the same accounting mode as insertion. */
>> +	sync_blockdev(bdev);
>> +	kill_bdev(bdev);
>> +	if (enable)
>> +		set_bit(AS_KERNEL_FILE, &mapping->flags);
>> +	else
>> +		clear_bit(AS_KERNEL_FILE, &mapping->flags);
>> +	filemap_invalidate_unlock(mapping);
>> +out:
>> +	inode_unlock(inode);
>> +}
>> +
>>  static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>>  {
>>  	struct super_dev *sb_dev __free(kfree) = NULL;
>> @@ -1654,7 +1704,7 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>>  		sb_dev = super_dev_lookup(dev, sb);
>>  		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
>>  			retain_and_null_ptr(sb_dev);
>> -			return 0;
>> +			goto registered;
>>  		}
>>  	}
>>  
>> @@ -1674,7 +1724,11 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>>  	}
>>  
>>  	retain_and_null_ptr(sb_dev);
>> -	return err;
>> +	if (err)
>> +		return err;
>> +registered:
>> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), true);
>> +	return 0;
>>  }
>>  
>>  /**
>> @@ -1765,6 +1819,7 @@ void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
>>  	sb_dev = super_dev_lookup(dev, sb);
>>  	rcu_read_unlock();
>>  	super_dev_put(sb_dev);
>> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), false);
>>  }
>>  EXPORT_SYMBOL_GPL(fs_bdev_unregister);
>>  
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 98e21b4cbf32..19daea93bdec 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -58,6 +58,7 @@ struct block_device {
>>  	struct address_space	*bd_mapping;	/* page cache */
>>  
>>  	atomic_t		bd_openers;
>> +	unsigned int		bd_fs_users; /* Protected by bd_mapping->host->i_rwsem. */
>>  	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
>>  	void *			bd_claiming;
>>  	void *			bd_holder;
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 4f7905c3412b..f84dff95eae7 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
>>  unsigned int block_size(struct block_device *bdev);
>>  
>>  #ifdef CONFIG_BLOCK
>> +void kill_bdev(struct block_device *bdev);
>>  void invalidate_bdev(struct block_device *bdev);
>>  int sync_blockdev(struct block_device *bdev);
>>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
>> -- 
>> 2.39.5
>>

Hi Jan, Christian,

Thanks for the review, Jan.

Christian, would you be willing to pick this up for linux-next,
with Jan's Reviewed-by? Please let me know if anything else is
needed from my side.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
