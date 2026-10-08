Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3F14052B4
	for <cgroups@vger.kernel.org>; Thu,  8 Oct 2026 08:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791446423; cv=none; b=Mbk5ANc5+5cU2F9umpjFC/7XuuvBNTmyJ9+pgcKEPRj94+ULJyKj97taSiL45zBCnZU34IK/GJ4WgTh/gearrNgzbHs2lCVmlDDbsG0gEGyxWnFar/AT5WuZZK75NdLO3/nQV4+GeS0k/6QoOXWGKeUp6GWiDLFg1NfCzwg5LT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791446423; c=relaxed/simple;
	bh=pn1ZYnsLKWKZKMLis4Mb4WSGKnhfbJ9BIt1r9rb52E0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SKgNrob9ZfjRmgg5dAZZuP+J0QGH6ute2k3yQK4yzlMgeNQpssloHJuryWdPkIA8b07rjEi8CjhQa7H1YxD2jGXPUJt958QSevyIF2d8g2hKwQIs27NCKXJ52K3pA1vQz5kAFGcIgSBrzQ4SBbeyRpWlgtH2aMTSSvDvHygpSlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lYGntjqN; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lYGntjqN"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso3486232a91.3
        for <cgroups@vger.kernel.org>; Thu, 08 Oct 2026 01:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791446420; x=1792051220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CEGNX9o2ekofmi3CaUGlBm2/+Xc2Ba7w+559DPi52mQ=;
        b=lYGntjqNq9YB2wtGRshdUZvQYShq/rw9kU4KVffTfSM9ptUbRqXOmWTE0SsnwV0dt6
         Foe/aZ97fTwkZJuxA31Tae7XHKtkCSQ2aLxCd3rJttf6yljZOVTRVk2/HrnXiEelMTc9
         XyniCLaM6s8v1Wn+cI91x/DRv2kOijyU5apHiq9hPz9rLfiE3YbJIscGbr3T3t5wr1hT
         nkMQ4G6g0+agTvLH6EbAgxiniOdO2jmBAKLZawzDpLf3DlNE/aSucOJRBFF4yae8iycF
         FBZ75fkdFobvI/8IwH7v1JqHUbUYODbgrHt6GVV0E72GnpY1650gf+APjget08NVCc9P
         f6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791446420; x=1792051220;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEGNX9o2ekofmi3CaUGlBm2/+Xc2Ba7w+559DPi52mQ=;
        b=lPdURb/2sqf9gNfya2MRWP6BS8+XJ5XCkdt1ObZKJInpCDhsxBnNVGv1Tbe2TtX0qf
         CuThXGH9Ha1l26Q0ch4/N7gfh7kpHYAPcrolecv0H+uimVDzAHLVuRggvCeCOitx9/Ab
         VHeGxO4EZkmeYygUDWmJ1NbpFcxAccT5xq4zhdn9oQfktZHgG5ccXPmUKI7V4nqmCIaR
         9+Fr7D4AvdQQ20rmuy5bzUGdXTUQDKWgX53ZPusoAE6b0uH2s4o1MFEf6xR6UvmXAo4P
         lOpq6W/T7d601j/vXlvseUZnplHjFfikySfIl/ZPKck3PNaA8O6OdSgfEEbl+kFzw5pU
         FCOw==
X-Forwarded-Encrypted: i=1; AKwUvBx1YlQAD65FNLTdpaKh2075UsnP38ac6PFpKKE0ABjwHSx6GuHUwyZ9HrYRwHxEuU28R2Bpq2Ir@vger.kernel.org
X-Gm-Message-State: AFq9FYKxFRjOsFKgUhp72orByUFkNvvKNRqbEWqB5D/5qdauX7ErUemL
	DT/HqHifSZFPCut5EYUzHxRz3F0Y6rok0d8N4YRE8Zc02/5ll/B3P7sLrweze8NBeOs=
X-Gm-Gg: AYBFou33gomzQ1OQcAR2mz7elFKw9VbSQq/2JOlasKmPqQX1x2Nf1SzIEoLkepDULoF
	jHBv1K0Dw0OEPf9mh/lF6edE7BWyj9V+1VcEnn/ABmrF+bNUdGvwA8+iqu90S2LLk5x4GBdF1gu
	14CetC27Hvv4yoxctIJHTpiyZjYnGpIcO9w9tTzn98mDlLBxc0im8vS+8T+er4I4JyQ2MACMFA+
	rkUYAkr9NcdAnEweEpbawcZg5CgYb5LE+6jBs9kw7SXRaRJZgZZs79CwTPBeDZp39W2lerP2IcP
	Kgt0Pp50IXpNgtGECHq65GuwevL8VOlWK2u3hT2XnGbHmqJfLxyMwNc+p64PFXI2NJ5rsB0wztJ
	zBzBIitg/IcAg4HFtWzxDBvxKKcZrbaRC6MpZcbtO88GpPxAmMggOa6fQT2esopIoyYhfDx5svs
	He3+nS6Z4kN098vej0P0d9ovuJr4LjD4odAb7Opx0n+DDL0LLyPmVqby0ZjzQTMxwV43pECVXPv
	dNjZeboofDcndNWSt3bS0+O18/cjJgylt7nLKsprnpd0Nd80BIP
X-Received: by 2002:a17:90b:534f:b0:3a8:5d1f:59ad with SMTP id 98e67ed59e1d1-3a8a1b04025mr3670596a91.43.1791446420072;
        Thu, 08 Oct 2026 01:00:20 -0700 (PDT)
Received: from [100.81.25.52] ([61.213.176.59])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab32bsm3141344a91.3.2026.10.08.01.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 01:00:19 -0700 (PDT)
Message-ID: <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
Date: Thu, 8 Oct 2026 16:00:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
 akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
 <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/26 12:25 AM, Jan Kara wrote:
> On Mon 05-10-26 01:26:28, Christoph Hellwig wrote:
>> On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
>>> FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
>>> for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
>>> for bdev mappings will cause issues because some users may be using bdevs
>>> directly for their workloads and they could still expect proper memcg
>>> accounting to work in that case.
>>
>> Agreed that it should not set unconditionally.
>>
>>> We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
>>> it when releasing bdev) but that would have to make sure there are no
>>> folios in the bdev mapping when changing the flag as otherwise the
>>> accounting would go wrong. Looks it might be doable but getting all the
>>> cornercases right will be hairy and overall not very appealing to me...
>>
>> I'd rather not support special case writeback code just for this legacy
>> fs abuses bdev buffer cache case.  And we basically need to tear
>> down pagecache at unmount anyway, as i_blkbits can change, so while
>> we do need to be careful, I don't think it really is a major issue.
> 
> OK, after some more thought yes, I think we can make that work.
> 
>> We might be able to restrict to setting it when
>> CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
>> shared mmap writers, as anyone using a modern kernel and cgroups really
>> should have that disabled.
> 
> I don't think that's really needed. If such writes are happening, they are
> *very* limited and done by a system administrator only (as they are very
> dangerous) so the fact the writes will get charged to the root cgroup is
> not an issue.

Hi, Jan, Christoph.

Thanks for your suggestions.

One remaining concern: while ext4 is mounted, buffered reads of the raw
block device would also charge page-cache allocations to the root memcg,
bypassing the reader's memcg memory limits. Is that acceptable?

I've attached a preliminary diff. Does this approach look reasonable?
If so, I'll split this into a formal patch series.

diff --git a/block/bdev.c b/block/bdev.c
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -79,7 +79,7 @@ static void bdev_write_inode(struct bloc
 }

 /* Kill _all_ buffers and pagecache , dirty or not.. */
-static void kill_bdev(struct block_device *bdev)
+void kill_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;

@@ -89,6 +89,7 @@ static void kill_bdev(struct block_devic
 	invalidate_bh_lrus();
 	truncate_inode_pages(mapping, 0);
 }
+EXPORT_SYMBOL_GPL(kill_bdev);

 /* Invalidate clean unused buffers and pagecache. */
 void invalidate_bdev(struct block_device *bdev)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
 unsigned int block_size(struct block_device *bdev);

 #ifdef CONFIG_BLOCK
+void kill_bdev(struct block_device *bdev);
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1279,6 +1279,56 @@ static void ext4_flex_groups_free(struct
 	}
 }

+/*
+ * Account ext4 metadata cache to the root cgroup. This filesystem-wide
+ * metadata is shared across users, so it is not naturally attributable
+ * to a single user cgroup.
+ *
+ * A bdev inode can contain metadata pages charged to many memory cgroups.
+ * Dirtying these pages can trigger foreign writeback of its entire owner wb,
+ * including unrelated file data. Premature writeback of buffered overwrites
+ * reduces write coalescing, increasing disk traffic and consuming bandwidth
+ * that could serve foreground direct I/O. This can hurt performance,
+ * particularly on bandwidth-limited devices such as HDDs.
+ *
+ * This does not depend on CONFIG_BLK_DEV_WRITE_MOUNTED. Writing directly to
+ * a mounted block device is dangerous and intended for system administration.
+ * Charging the cache from these writes to the root cgroup is acceptable.
+ */
+static void ext4_bdev_set_kernel_file(struct block_device *bdev, bool enable)
+{
+	struct address_space *mapping = bdev->bd_mapping;
+	struct inode *inode = mapping->host;
+
+	inode_lock(inode);
+	filemap_invalidate_lock(mapping);
+
+	if (!!test_bit(AS_KERNEL_FILE, &mapping->flags) == enable)
+		goto out;
+
+	/*
+	 * Folio removal uses the mapping's current accounting mode. Remove old
+	 * folios before changing it, excluding new raw-I/O cache allocations.
+	 */
+	sync_blockdev(bdev);
+	kill_bdev(bdev);
+
+	if (enable)
+		set_bit(AS_KERNEL_FILE, &mapping->flags);
+	else
+		clear_bit(AS_KERNEL_FILE, &mapping->flags);
+out:
+	filemap_invalidate_unlock(mapping);
+	inode_unlock(inode);
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1387,6 +1437,7 @@ static void ext4_put_super(struct super_
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
+	ext4_bdev_set_kernel_file(sb->s_bdev, false);
 	kfree(sbi);
 }

@@ -5852,6 +5903,8 @@ static int ext4_fill_super(struct super_
 	if (ctx->spec & EXT4_SPEC_s_sb_block)
 		sbi->s_sb_block = ctx->s_sb_block;

+	ext4_bdev_set_kernel_file(sb->s_bdev, true);
+
 	ret = __ext4_fill_super(fc, sb);
 	if (ret < 0)
 		goto free_sbi;
@@ -5877,6 +5930,7 @@ static int ext4_fill_super(struct super_
 	return 0;

 free_sbi:
+	ext4_bdev_set_kernel_file(sb->s_bdev, false);
 	ext4_free_sbi(sbi);
 	fc->s_fs_info = NULL;
 	return ret;


> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
