Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352012EEE89
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788607904; cv=none; b=dAztwsm3F4nSTwmZ2/dFEsF6uwQ1UVPPj5jFNF0eazXSwaolsOb8a4Hx7Wjw7JJgYZWJZZP51o/+cwsIAOU4k7SEdxt6qu8xAzFjkiZ4z7s9e1RxrzreIt+ag9WqrQ1qHzq3+6PDRxKRY7NqewjQgxb4AZf68tX73+ymnD0SbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788607904; c=relaxed/simple;
	bh=a+318NUDjZ7swxZ+rAalax04uJWM8gRs2q06yNeOEVo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WjDBDNNj5at/BJFmtkH99jdJ/0n1jKAU9EzCE9vXZcmAiGAcc8bxF/mxRuEBWrgDI3JMGxBGhwSEKIrLJvvKLFr7mRjdxE/ZHoBG8+CxvuPSBAvVShHll5YzLs3midXLndMPdNyweZb92O9zB3P10W2HYxONvbLnN5QDdmD0eBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=AfqsP+eQ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="AfqsP+eQ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d715f4a587so27729335ad.2
        for <cgroups@vger.kernel.org>; Sat, 05 Sep 2026 04:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788607901; x=1789212701; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=W7vAWFstZpGX4WYLmty1byzm5V4S9GgHVdRHWeAep4s=;
        b=AfqsP+eQITReVZprVNgO5jN5tIodt7fSRTm9MqLgAsjyi457kAGueefnTid0ZduBXF
         FBCvgQs+d/UnonkFGMQoOpmabuW/TPx5y0M5Yhe/LdBTioucmmDYiO6LhskVkEWvyxXp
         IdioLaP7KEiUds6SEnn8/yam6cyvYItysFn0j8qcHf2NfqJuHE5tOervRcliH2a3/IJ6
         /EOGgudjFifiRu0WKZtj3gA9TGZjO+kXAf0+s2RUUCl6lyI+TW51LQBU8vlYXWU4zMLg
         0gZ1ZR4EEJGBhU2XxTF4+fdzPzjNT5GK8OwYtsucKNwOA/KS4OwLE1Gk9LV+OBSNtf6N
         69Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788607901; x=1789212701;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W7vAWFstZpGX4WYLmty1byzm5V4S9GgHVdRHWeAep4s=;
        b=j211wkzyQDG4MvAZNV1qhwgpvg/Tqvn+epmDZx9hKv00VedkbkyzclDowRsYPMGXkS
         mQ1Hudmzfk5J7Kb8aIWmLquVnu19EDVT9MWXdDEexNlbrKiKkMzaqrek4b5MjMY98uLY
         0/35hwn6JOlXb6WpRVKHjlN4WrD3rc9PQBNd3a9oSUELR3fCARapICk1Cy8sKbqpVlQZ
         20yw4U62whOyJjHaYP+s57HOiCJ20tKVPdTb5qbTgUbyMFq3ErihikdPq4hhkP4KC49r
         qDthoLBd77twKPhOZhUQFCUVj4kxwdFDSoqXODauYOIcHoaXvhoxcsSh+eg1jfHx8WwD
         LHbQ==
X-Forwarded-Encrypted: i=1; AKwUvBy1WWCYVbzg0dGLNhUpmmbfXUcInZkpnb51WW2rwUlKtbAd4yFTtkwRLKswnKU4coCy0qMwkPmU@vger.kernel.org
X-Gm-Message-State: AFuF++lsvsNkeX9PlstlqEVtK58r1Hus3LhyQK27QPeFdAC+jJnp2zsa
	aw1GqeiTphoLaK3xtAsQSTHFUw7pEKIbpiEOtok19YfdIBUnrE2HazDkJ5tCvhYsSf8=
X-Gm-Gg: AYBFou0LZMsHHolbJJSf+t6+y88J0xYT8RrzK0HHrHGSjzGashSfEx2qm38r9PtKNLf
	0LwIq86digAS1VGmBqtQS+Z90z9wbBBDFjEVVhmCuJ8/RLjCzjMlV773U79lFSIi7vIYWfDCcI/
	VcoIEZqdRiEO2QuaTrjX/s76Hfgj7KUxZgaaz/+9AM+njd/vaKq6o1SETC6GOmbJEoRZIwdtCMD
	bEqRMoHYwnKUrdamYnfrxjaEy2On83ivznS+pfXnpIfSyrk+Mbaq3i2KmS5gURwST2Ae3DI4hqB
	0gohlLJlKa848HKTs4d5pSpYY9wb65VqA8fYpVIcH83PSvWrU1WGs8l+vf0TK9mPjwi9t6EGK6z
	6FiVau9+rVlu/tJiVe5Yi0hKgGs8h51zWANbLQlduE7YJVGIPf2gTUt8sCAJBcQKdUG4Gggoc8N
	pg326FDbMAhTFdG0vcfuKQaszYSDOREdbBNvelyV9XtgGg1RvZj/Je/Kc07xMrZ4Q5C2bpGid8u
	uHp3iWG0fZsCHJzhL4CfHnk7BabOKC7
X-Received: by 2002:a17:903:468d:b0:2d9:56d8:75f with SMTP id d9443c01a7336-2db1266772dmr185281435ad.9.1788607901133;
        Sat, 05 Sep 2026 04:31:41 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1495b57fsm21654395ad.24.2026.09.05.04.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 04:31:40 -0700 (PDT)
Message-ID: <e71693a7-e19e-481d-8a4f-bce366310f4a@bytedance.com>
Date: Sat, 5 Sep 2026 19:31:36 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Julian Sun <sunjunchao@bytedance.com>
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 jack@suse.cz
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <apnYouiUINQR-98e@slm.duckdns.org>
 <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>
 <appm1E4rzQQB_srX@slm.duckdns.org>
In-Reply-To: <appm1E4rzQQB_srX@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/26 2:36 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 04, 2026 at 12:34:27PM +0800, Julian Sun wrote:
> ...
>>> Was this reproduced from an actual workload with adverse effects? If so, can
>>> you please explain the workload and effects with concrete details?
>>
>> Yes, this can be reproduced on many production machines. On one production
>> machine, we observed 102 wb works with WB_REASON_FOREIGN_FLUSH as their
>> reason, 101 of which belonged to the same wb. This wb was the owner of the
>> bdev inode, and dirty pages were continuously being generated for it.
> 
> This is the mechanism triggering.
> 
>> The logic here is that, Once a memcg has recorded the owner wb of a bdev
>> inode as foreign, any task in that memcg that reaches the throttling path in
>> balance_dirty_pages() may queue one WB_REASON_FOREIGN_FLUSH work item for
>> each recently recorded foreign wb, up to four in total, without checking
>> whether those target wbs caused the current dirty throttling.
>>
>> On this machine, the total nr_pages of the foreign-flush works was
>> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
>> Although nr_pages does not represent the number of dirty pages that will
>> ultimately be written back, the actual number of pages written back may
>> still be very large because the corresponding wb was continuously
>> accumulating dirty pages.
> 
> Is this necessarily an adverse effect tho? These are all metadata flushes,
> right? 

No. The foreign dirty records in this case are triggered by bdev inode
folios used for metadata and journal I/O, but the resulting writeback
work is not restricted to those folios or even to the bdev inode.
cgroup_writeback_by_id() queues writeback for the _entire_ target wb,
so it may write any eligible dirty inode attached to that wb.

> When they're gonna get written might change but do the extra flushes
> change how much is going to be written? If so, how? If not, are the extra
> flushes adding noticeable overhead in terms of cpu or io?

Yes, in our test, the extra foreign flushes increased device writes and
noticeably degraded the concurrent workload's performance. These flushes
also wrote ordinary file data in the target wb, not just bdev metadata.
More frequent writeback of the continuously overwritten file reduced
overwrite coalescing, generating more device I/O for the same logical
writes and leaving less bandwidth for the concurrent workload.

I tested both kernels in a QEMU/KVM VM with 4 vCPUs, 8 GiB RAM, cgroup v2
and ext4. The kernels use the same base and configuration; ordinary
periodic writeback remains enabled.

For the overwrite test, virtual NVMe write bandwidth is capped at 200
MiB/s. fio repeatedly overwrites a 256 MiB file in the root wb using
buffered I/O. Four memory- and I/O-limited memcgs generate metadata and
buffered writes, triggering dirty throttling and foreign flushes to that
wb. Concurrent fio measures completion of 16 GiB of sequential direct
writes on the same filesystem.

Across five pairs, both kernels completed the same 9 GiB of buffered
overwrites per run. Skipping bdev tracking reduced mean actual device
writes for that file from 5.60 GiB to 1.70 GiB (69.6%), including final
sync. Mean foreground completion time fell from 104.2 s to 89.1 s (14.4%),
bandwidth rose from 157.3 to 183.8 MiB/s, and p99 completion latency fell
from 1434 ms to 480 ms.

However, a separate metadata test confirmed the downside. With uncapped
storage and memory.high=256 MiB, a memcg creates 60,000 files paced at
4,000 files/s, each with a distinct 128-byte xattr, alongside occasional
buffered data writes. The xattrs occupy external 4 KiB blocks in this
setup. Across two warning-free pairs, skipping bdev tracking made
completion 31-33% slower including final sync, while device writes remained
around 524 MiB.

The metadata regression means these results do not establish a net benefit
from blanket skipping. Whether foreign flushes caused our production stalls
remains unconfirmed.

Core fio commands:

     fio --name=hotspot --filename="$dir/hot.data" --rw=write \
         --bs=64K --ioengine=psync --direct=0 --thread=1 \
         --size=256M --io_size=9216M --rate=64M \
         --refill_buffers=1 --invalidate=0 --eta=never \
         --output-format=json --output="$out/target.json" &
     hot_pid=$!


     fio --name=foreground --filename="$dir/foreground.data" \
         --rw=write --bs=1M --ioengine=libaio --iodepth=32 \
         --direct=1 --thread=1 --invalidate=0 --size=4096M \
         --io_size=16384M --eta=never --output-format=json \
         --output="$out/foreground.json"


The full five-pair overwrite log follows: base=original, skip=skip bdev
tracking, hot_GiB=device writes for the repeatedly overwritten file
including final sync.

[2026-09-05 17:52:10] RESULTS=/tmp/cgwb-20260905-175145; WARNING: reformats /dev/nvme5n1; 5 pair(s), limit=200 MiB/s
[2026-09-05 17:52:10] round-001-base: booting
[2026-09-05 17:52:20] round-001-base: running workload
[2026-09-05 17:55:36] round-001-skip: booting
[2026-09-05 17:55:45] round-001-skip: running workload
[2026-09-05 17:58:57] ROUND 1: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 17:58:57]              base    104.574   156.67    156.67    203.82   1434.45     5.862    0
[2026-09-05 17:58:57]              skip     89.125   183.83    183.83    173.62    480.25     1.656    0
[2026-09-05 17:58:57] skip vs base: bandwidth +17.33%, time -14.77%, hotspot IO -71.75%
[2026-09-05 17:58:57] round-002-skip: booting
[2026-09-05 17:59:06] round-002-skip: running workload
[2026-09-05 18:02:18] round-002-base: booting
[2026-09-05 18:02:27] round-002-base: running workload
[2026-09-05 18:05:42] ROUND 2: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:05:42]              base    103.533   158.25    158.25    201.75   1434.45     5.493    0
[2026-09-05 18:05:42]              skip     89.124   183.83    183.83    173.65    480.25     1.730    0
[2026-09-05 18:05:42] skip vs base: bandwidth +16.17%, time -13.92%, hotspot IO -68.50%
[2026-09-05 18:05:42] round-003-base: booting
[2026-09-05 18:05:52] round-003-base: running workload
[2026-09-05 18:09:06] round-003-skip: booting
[2026-09-05 18:09:15] round-003-skip: running workload
[2026-09-05 18:12:28] ROUND 3: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:12:28]              base    104.648   156.56    156.56    203.96   1434.45     5.334    1
[2026-09-05 18:12:28]              skip     89.243   183.59    183.59    173.92    480.25     1.824    0
[2026-09-05 18:12:28] skip vs base: bandwidth +17.26%, time -14.72%, hotspot IO -65.80%
[2026-09-05 18:12:28] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
[2026-09-05 18:12:28] round-004-skip: booting
[2026-09-05 18:12:37] round-004-skip: running workload
[2026-09-05 18:15:50] round-004-base: booting
[2026-09-05 18:16:00] round-004-base: running workload
[2026-09-05 18:19:15] ROUND 4: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:19:15]              base    103.565   158.20    158.20    201.84   1434.45     5.497    0
[2026-09-05 18:19:15]              skip     89.124   183.83    183.83    173.57    480.25     1.648    0
[2026-09-05 18:19:15] skip vs base: bandwidth +16.20%, time -13.94%, hotspot IO -70.01%
[2026-09-05 18:19:15] round-005-base: booting
[2026-09-05 18:19:24] round-005-base: running workload
[2026-09-05 18:22:41] round-005-skip: booting
[2026-09-05 18:22:50] round-005-skip: running workload
[2026-09-05 18:26:03] ROUND 5: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:26:03]              base    104.567   156.68    156.68    203.78   1434.45     5.830    1
[2026-09-05 18:26:03]              skip     89.035   184.02    184.02    173.47    480.25     1.648    0
[2026-09-05 18:26:03] skip vs base: bandwidth +17.44%, time -14.85%, hotspot IO -71.72%
[2026-09-05 18:26:03] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
[2026-09-05 18:26:03] DONE: 5 pair(s); all test VMs stopped

> 
>>>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>>>> blockdev pseudo superblock. This prevents bdev-originated records from
>>>> triggering later foreign flushes.
>>>
>>> If you do this, tho, that means now cgroups that accumulated a lot of
>>> metadata writes on ext4 and crunched for memory don't have a way to relieve
>>> the pressure outside of periodic or other lucky flushes. ie. I have a hard
>>> time judging whether this is net plus or not without learning more about how
>>> this patch came to be.
>>
>> How about this approach? Before queuing a WB_REASON_FOREIGN_FLUSH work item,
>> check the target wb and avoid queuing another one if it already has an
>> unfinished WB_REASON_FOREIGN_FLUSH work item.
>>
>> This approach can eliminate a large number of duplicate foreign flushes, but
>> one issue remains: a memcg may dirty only a small number of pages in a bdev
>> inode, and when that memcg enters dirty throttling, the throttling may be
>> completely unrelated to the wb that owns the bdev inode, yet a foreign flush
>> is still queued to that wb. This problem becomes more pronounced when the wb
>> has a large number of dirty pages. Perhaps we should track the number of
>> foreign pages in the memcg and avoid issuing a foreign flush when the number
>> is below a certain percentage?
> 
> Yeah, maybe, but I'm kinda having a hard time evaluating anything as the
> mental picture I have of the problem is too incomplete. Please fill us in.
> 
> Thanks.
> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
