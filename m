Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008343E08F
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070734; cv=none; b=mPwda9i44n//ufiEG510vngkhyEW/4Vj3o4aWy4t20rzpAQmcpEI/g1qezGd91Pd4soV7dF7pfefpwzy65sOe0mkhKg4p1QVRci5d80s8SplrCwn4s3MkEPPxwu2QcObWP21iHNGB/4KcVjAy7EiI3e17kBPBMfGQqF2obRSHV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070734; c=relaxed/simple;
	bh=MxiZCmJT9Dufw+rEGKKJYfTRtYNzmG5IdUw5ajtU6+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZLw/BQLnJbPNpVrFahZQ9LWLQHOFgpSjx4xlXBJ1CHda//3OfB71ZXmjkY6LZwhXV0x/yeR0IuIOwUl4V+YNRjKY7iwPfBi12dboI3IKj69ujcx4eCPmTlCxgXyvZbdKlZdPFXgoQ0bfdYYGXwNYVdCPKbGVzITJNtn6MjUuMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Ox6D3lGj; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Ox6D3lGj"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so2907088a91.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 02:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790070725; x=1790675525; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b8gnsOu8dUZ3aA1jMaDEM+zSBKGqHWilm/tfYcR3Kt8=;
        b=Ox6D3lGjOYbouL6YmtZ2Bbed+sZAv+o7BqGuPt7M3avbUQOLV7UlsIoldA9Jlfx7ph
         gER/m0w+6zdnASZ17EqWmXnlnp/RkfAhobSw3xPIyFKiDrmZTamnA/osWEDlHHdnmmsU
         eStwOIW0JYWrPEegx3odIRd/zpsioQXSMmZWEUwYTlNwkFgasTfBqBnDakcKfTiSphJu
         M97cvRxknPzyLn2ktMGXD80Xc4Z5h1N3HrTSLiHWbI+P0SNuzfsKy9zeMeNl+HCV4nG7
         c6Kq3Evl9EWnAFGdU4bil0SmWlggUIZTFXxvUbUCvsr2wa1THzmwqoRk9sHMc4buPll5
         56jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790070725; x=1790675525;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b8gnsOu8dUZ3aA1jMaDEM+zSBKGqHWilm/tfYcR3Kt8=;
        b=fqYxg0yAUBN/bX+Cb4JuyVBBSPGP1V4oD2uIB7hOO6Jn2E2RDQYgKgXG1EmvpAjr49
         9Zmsyp1SZHvkmn2Jk96wXONtbwnQt73U/dXmr0azv9aSmt9uSLaZkGzYwbAIDuBRWojI
         rCA5KortIMfU/6MVE7qdGtjsqby6ZmmDA165TzAos0jk1+3FsemhW3LK0Q276oPlJMFy
         f+9tTPlC87PDamJcDgJtdJOO/DuXZrlKQGPQsgswc2XrA7/p+lXT1juZ8WdNKk8vQuO5
         EuKlv0UkynRgqw7e/pyvCOSmdXFXgdLgukCk2WvftOC/bEIdefwY/p8JNYoH4lTlIxRR
         9LBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxxqgUW+n4eB5RtsgNjfkszjQYUeViVnjbBwQ93+V4RlkcKZfo5fuTdS4WrVy3zOTjJNAaKy6ZI@vger.kernel.org
X-Gm-Message-State: AFuF++me8cU4UO8iJX1j9cT5qA3cMplASq4HSVSK7zW+5J/kw5Q6URhX
	DcTPeZoLd3whJRxdtEHqHOEBvENBm1KS+g+TI5r0g4yT82InV41aCSk9dAaqod26eR0=
X-Gm-Gg: AYBFou1gG7HVOTwdCClalbowOb1Ed7xh+JPp0+tAIiVzeRuiEpGKPlrwrlspe1WBvzJ
	2EVY84LrN5mmfyNHmiBucTYMczCz9cOntbZuOq1I/3SCjGY29Coxx7ik2IO0EZCdG8nKG7BHj0R
	YIuQW+u/xLmzC/sMxGy3gyF5BcLgEY+OalJ3v44wSwEi324o3oAt4x3NBl4EXon2rMEmGBHVVlW
	rv3qGppwrvDYjDw4VM5ZkfldPn7wfkoSQ+oN9PJHwaVoxKAHtYllmWV6bTPKDGTO3/4YZJkyeY9
	bi1oVart6j2vzK3KBFkPNANIphctxTaXnC8Yx62if5T0k7OibJVuxGzqcWeYfUTaxmoExJo7syd
	d6m7AVd1okCx2Ob3qwNyPAMg5kcSmb+dDFm/R6EBTBgS5WsRdLr51JrpM+8m/DFGaKlgfpjboyv
	k8+LwMdoz64cDt/y/AQioHDxOThPlm1lhyXSj2pXTahx/3Fhzq1SNBr6aGTpBrUgOm+xAbxZyWo
	drRFcEq0IgXIby00N79zPhR9VFz9QdHHisetgzm/dCYf51CWYud
X-Received: by 2002:a17:90b:2fce:b0:39e:14db:4371 with SMTP id 98e67ed59e1d1-3a0730a1432mr716576a91.1.1790070724728;
        Tue, 22 Sep 2026 02:52:04 -0700 (PDT)
Received: from [100.81.13.24] ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a067409854sm3905971a91.7.2026.09.22.02.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 02:52:04 -0700 (PDT)
Message-ID: <e9d4b9c8-1b0e-45fe-95b8-f999055357a9@bytedance.com>
Date: Tue, 22 Sep 2026 17:52:00 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, jack@suse.cz,
 akpm@linux-foundation.org
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
 <20260921120658.1627992-3-sunjunchao@bytedance.com>
 <b15c63490f9164bf46d68ff3ec5dfc02@kernel.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <b15c63490f9164bf46d68ff3ec5dfc02@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/22/26 1:55 AM, Tejun Heo wrote:

Hi, Tejun.

Thanks for your review.

> 
>> +static void bdev_frn_flush_work(struct work_struct *work)
>> +{
>> +	struct bdev_frn_flush_ctx *ctx =
>> +		container_of(work, struct bdev_frn_flush_ctx, work);
>> +
>> +	bdev_flush_by_dev(ctx->dev);
>> +
>> +	atomic_set(&ctx->inflight, 0);
>> +}
> 
> The in-flight window is now just the submission of the bdev mapping, and
> mem_cgroup_flush_foreign() runs on every throttle-loop iteration, so a
> memcg that keeps dirtying and throttling requeues the flush back to back.
> A folio the flush redirties, e.g. a buffer locked by a jbd2 checkpoint
> write, re-stamps the slot on its own. The old record stayed in flight for
> the whole owner-wb work. With a journal the write cadence of hot metadata
> is still bounded by the commit interval, but for nojournal ext4 and other
> buffer_head users it's bounded only by the throttle pause, for every
> tenant of the filesystem while any tenant throttles. Not measured. The
> description covers the target size but not the cadence.

The description, comment and tracepoint suggestions make sense;
I'll address those.

Dirtying or redirtying the same device during a flush can refresh its
recorded timestamp. This is expected. Another flush for the same
slot cannot be queued until bdev_flush_by_dev() returns and inflight
is cleared. A subsequent call to mem_cgroup_flush_foreign() can queue
the work again if the record is still valid and inflight has been cleared.> 
> Each pass also goes through wbc_attach_fdatawrite_inode() and
> wbc_detach_inode(), so it votes in the bdev inode's wb-switch detection
> like the owner-wb flush did, at the higher pass rate. Whether the bdev
> inode ends up switching wbs more often is an open question.
> 
>> +		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
>> +		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {
> 
> Records are only created when the workqueue exists and @at stays 0
> otherwise, so the wq test can't be false with a live record. Fine as
> documentation, but the cover lists it as a fix.
> 
>> +		INIT_WORK(&ctx->work, bdev_frn_flush_work);
>> +		atomic_set(&ctx->inflight, 0);
> 
> memcg is zero-allocated, so the atomic_set() isn't needed.
> 
> On patch 1, the kerneldoc's "does not wait for all I/O to complete"
> understates it, the flush waits for nothing.
> 
> Thanks.
> 
> --
> tejun

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
