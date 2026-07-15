Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2053D5259
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 22:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784154881; cv=none; b=HCB/S86I8I9rJyMYdufJNDPkrpldRFnfRvsBWJgccT88wdNjXaIIkUaKbjD6+z6VU1hE+h7dAYFOsxDvqxYYcd3te6s9l2F2OunJEbyaTN4noWSq8Ck8bs4XV+CZFmTQDFvmMnrkkhugDcgdkRx6UnsoY9m8Surlrx9+IhMrmb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784154881; c=relaxed/simple;
	bh=MAbe7FFOxvk/HvR5Y86UBIzMmuEkVFfK1ZfCexZxO8k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MZn8l+JAqPFS50sukKbm14fnzaANm6/aVZn9BdwLPwi5BQ+7UoVXIb79b7uM9E35v655ucIeoLHSuQVDz6lSyCJ768rsBlk8coCFqCut39xu1qVzgGmsdRRgr2C7JpLvjCj/TDMBE7S6Zy9JFgQsZTsWzx52Je3YxuFPYeQzanw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=JAkHSR+J; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="JAkHSR+J"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4560d6f82edso1144309fac.3
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 15:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1784154878; x=1784759678; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=niLd5/LGzk3n5S3gnqCqcM7O0n/4L/Fl7i1GyHScQFo=;
        b=JAkHSR+J/lKZzFfSOa+qcnjWG4jwFN5eXGXjHUilfSDLw85wx8gmkaVKT5dfkfeJ1p
         qgK856/YYTvmGVmLPybXiValbIHUROtU81Ad61lUyEIKZpCq8BjK90yEFseI3JaM3XfY
         KL2SYa2uxzZaUwb6lDVrMSGOlN9kA6rXVkc1ZP+ANLAiRfqbyF53tnvD1fv5EU/mSDRA
         D/s3aIYzO41WBl39kdU2NWzgeymXwp9HMuclsS6QGAlcBhHAPL881pShUZXyUEFBtrVN
         b64zJEcIgtFYvSqGCnIJzRl9SMSNuEkTu+r6C4Dl06r6tTrZWU/r9g7kTCKrbqrwlMdw
         pDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784154878; x=1784759678;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=niLd5/LGzk3n5S3gnqCqcM7O0n/4L/Fl7i1GyHScQFo=;
        b=M7ENIXBJRBXTwu1nC9moXPUFBetFE8OPH5aM1yHIyshwHTBli8XxgC2mfkrGShwhN5
         aNhTlXOmjtbxLmDsd+YGt/xICn2NeLBFXrBjQFRra+2RV3fABNlFfVJ92cX+aNuNSyQQ
         3ZszAtgzOCqbGjz1wrcN66Wbx4TVMzx7v3HMk1QncTVRd1TXqCrj8Kr2NZ5CGYSglW6E
         T0SmmitemLKJjoaO/ZQzglynr67EsHMlukmVh9C2V7bKzJjD/h4DbG3YHN7EZeVdXez3
         xLomw/lPmcvlGdrznNsKaNBzaEwt/UWHZzRtufaeCodQMjlQORPqDTEvXsHilzD4CqMG
         KQsA==
X-Gm-Message-State: AOJu0Yxitfdv4fdulXvyyf2m9rkJxDvSsNnzJEKZwLQSHjSnacgNq66l
	4myyxE+nwnnK1Af/+YyDSQgIkKf4Kq9+T/pdC0aD+dqvRMJt+wxeMBmN6YJIw2kBclY=
X-Gm-Gg: AfdE7cn1WDdhPhpZKaNRIgbavL1MM7wjh7yEGF5hM8QWN7ZdUjaN3xSH2WwPnh7E1Rt
	/dPdMn7d/0ssLpCsLTcMb77NQ3D/vnIfAyjjK1BGfDF8HydyULIm+meO3MePWKnyJI22iLk8OuV
	UdoiX761VDmVbcLrHOYYuD4KDkYNOQI0lEuZmDhwzljQnThsGR/pUerOF9tJDu5iWhD7BQgGdMW
	YwKXFAB0t1h/Srb3mu6rcPWRYSPi22m/cIasPjGd/T6Qxaki+JP6LF3CQLQWEVIA9yCqYabBwEp
	M0ZBLQFKXeKb8MptSlbEZVAx+lTR0tGG65E2j7fnwyjyUfMJuc9y6P21/vNsTv2HLea0gpsxYls
	PX1GtcGhFVUL7ovz6vk7g0Mwx4TRLGieMPc8Id6QgHSDiEYC1LA1sUU3qzRRrkUklQllabzfc2F
	N+14pOQ4IXYOsaV5IDfuYS0m1QuuX7iJ4evis/LVu55eIMld/AJK9AXc8=
X-Received: by 2002:a05:6870:70a1:b0:451:738b:79a9 with SMTP id 586e51a60fabf-4560b3f2edcmr4833708fac.4.1784154878606;
        Wed, 15 Jul 2026 15:34:38 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45200b7b4c5sm14362722fac.10.2026.07.15.15.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 15:34:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: tj@kernel.org, josef@toxicpanda.com, Tao Cui <cui.tao@linux.dev>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
In-Reply-To: <20260715132407.1469777-1-cui.tao@linux.dev>
References: <20260715132407.1469777-1-cui.tao@linux.dev>
Subject: Re: [PATCH v4] blk-cgroup: fix leaks and online flag on
 radix_tree_insert failure
Message-Id: <178415487685.159585.7452024735126853374.b4-ty@b4>
Date: Wed, 15 Jul 2026 16:34:36 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15.2


On Wed, 15 Jul 2026 21:24:07 +0800, Tao Cui wrote:
> When radix_tree_insert() fails in blkg_create(), the error path has two
> issues:
> 
> 1. blkg->online is set to true unconditionally, even when the blkg was
>    never fully inserted.  Move the assignment inside the success block.
> 
> 2. The error path calls blkg_put() without first calling
>    percpu_ref_kill().  Because the refcount is still in percpu mode,
>    percpu_ref_put() only does this_cpu_sub() without checking for zero,
>    so blkg_release() is never triggered.  This permanently leaks the
>    blkg memory, its percpu iostat, policy data, the parent blkg
>    reference, and the cgroup css reference — the latter preventing the
>    cgroup from ever being destroyed.
> 
> [...]

Applied, thanks!

[1/1] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
      commit: dbbca20764382b4d411ec2918f4e278ffe547acc

Best regards,
-- 
Jens Axboe



