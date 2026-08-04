Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D03F9F2F
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 02:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785809836; cv=none; b=kmdFyU/YpwMjGOUEl1HL7VtWCpMVzWgqrkyDEj52RC7zfIJd1XT1AkIMIXZ63Yd7I0afXK0ww69MAm7E/CyKXyI+86B3HEVkaz8BmE7yRcvGpzOvHI3M4QiWIodKaWUrk8CIayHM8fFa7slBrFZyEEswylzKc0CvqzIpNz6cbXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785809836; c=relaxed/simple;
	bh=UrrXCwNK3GQUfKmvUpjSPGBpvVTnLGns1lAc1wyUqI0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EF162iErr3D3+AfbDj6KSUnbdo0tMH9s+qyA6PEGfVF/J0yZBP0Cn9g0QGzYJaBdlyn//+i4fcxdMKGw+bTOwJdmSSttHMqdIxweA62frW36SMpKYPUhqSWAutBbUT8uEbLkqxqrv4VaMS8GkngNjrNf3Z/ONpPHRyXF4kxHblo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=qvdtpBvT; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="qvdtpBvT"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-497e6956acfso365444b6e.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 19:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785809832; x=1786414632; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W2eEyGdbWlXiyEtKf3R6jpZF7XuKvknYpyClxtBq0WI=;
        b=qvdtpBvTv+Ka13Mbp3KNmCxd19sHo5HJRbxO2wYS9S+JdYxtL38FGfx7B3xU9TTgDC
         jsbDqa2SnhEUO2vFkvnDx0OqmkSiuz1o0MAK5/swLjLFoQ2lC+WoV36fbjriyRMNTYBk
         aI0a6o4QOy5g5MzZoobAmLzdVnVIxMr0+poBgul/ozHyWlsBOFXBua7b2NCqBFIW2msV
         vx8W60P7Xy2Sh87zduwJwr4FnMFmjUJD51jqQBubTND+2VYcN85dmpJbKWKm1LxbEeTr
         uIjvYKNAo4WWTQe63ImuyToTLawoxdKECHf6VgnYIls/QCPhEYGt5O0e7IewAMdrFpIk
         0Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809832; x=1786414632;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W2eEyGdbWlXiyEtKf3R6jpZF7XuKvknYpyClxtBq0WI=;
        b=fGAu+fnUErw1jJ/cPzAx+oS+aNJv4a4OAaANiZBKkmycI+oxbS35ELT5JfJ4CMUHd/
         0ZNR+To7ihSWdzdrXpesMjLyyFs2Kow7TaHvbE7cNv221yKsZD/u45HrRzg5AfjXIO4h
         nkAIHeL5hFcWM/2/E5ORyk5DOlwiPAoAtXpBj+2S0lzrzF/IknBFB1hGJyiNi/C55Gwg
         +aLdf6Y0O4iit2yUEL7ulAo7vg8CSD13Fp7gMpYCKdM98ZpnyUVa7iCvPdD3fwCui5fw
         8CL98378123jQfstivzhyYdv70BZ1d5qyJ3GLBI93Q2eO5fo79uG3OXF3+8Ib06U+o81
         CemQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr799RipeXfYfVqoJsAN4c8Q7YFeM6+gRZbauwmJmpP7kVNRCzMRqLGAuG/CJBKPDP56iuoY5gK@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+McF6FGD5YA2sZ5sf0P5K3je6ZnN2NJwMRp3hXI+r8Mg8t+7Y
	09FiHtUvB9Vw3eU0OjfYnd8ucIWs/OGjba9AO7rYnDAvrGiceAWRx8gOfaCOohv6sHb3uLf1nWY
	YXSlrGMWx8g==
X-Gm-Gg: AR+sD10g5f86QGLcriSEx3ODVhsbi5OxeNl+UnWXi3ZYT6Mf8QeWOvsXOFqqELrRDjT
	a2AMYY1L4P6+Eg1gMRBu/O/8fnXSkZWjW2rTW6Vri12eRloOLUDKLfYZ93WJRzxxzagqGSLT6pl
	Lhj1iuPrDsZhLW6w+emDO1R5ysJ6IrDDOqLQCtTidZku66b/ntX73uYunMmrTzHvKabTLTnytrr
	RFZyTOpO1IGh3i9ZMz35nWVZL5S3gcMSqRLUfDTnlgddiHtwd6e05ytDCkz1tofwaMKSYAkJXlm
	p3nsXCLM/6cDPTxbpmDLgzEtrVBVnDulGznJL+FosWu7MZD4ETq1iFkDfVAfD7xp7IzpTVq7cJJ
	3OAwiwh5rxx94RYgLm2oJHveyEeToJQKNJzYPE/hFCOd3vPXow7gf2BktlJCYwKuUNRJ2+rTu4Y
	xrIw22mCBGZmgf4Rb5x9DyIGRBNk1VkEb9lQfRz3OvJ5wmpgwqUvzZ1QMapC1/9Jhrq8QcqJKjq
	TRBCUWQxSOWznNwOkiH4y0/B+MBp9OTqHPBJaZ9zZelVVnuamYa
X-Received: by 2002:a05:6808:3020:b0:492:7abc:422e with SMTP id 5614622812f47-4af98a34efemr2249723b6e.13.1785809832568;
        Mon, 03 Aug 2026 19:17:12 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18f07a55asm8914812a34.13.2026.08.03.19.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:17:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Tao Cui <cui.tao@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Omar Sandoval <osandov@fb.com>, Bart Van Assche <bvanassche@acm.org>, 
 Yu Kuai <yukuai@fygo.io>, Chaitanya Kulkarni <kch@nvidia.com>, 
 Hannes Reinecke <hare@kernel.org>, Ming Lei <ming.lei@redhat.com>, 
 Damien Le Moal <dlemoal@kernel.org>, Nilay Shroff <nilay@linux.ibm.com>, 
 linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
In-Reply-To: <20260720093726.28965-1-cui.tao@linux.dev>
References: <20260720093726.28965-1-cui.tao@linux.dev>
Subject: Re: [PATCH 0/4] block: drain per-cpu latency stats over possible
 CPUs
Message-Id: <178580983082.518281.5058620574595097621.b4-ty@b4>
Date: Mon, 03 Aug 2026 20:17:10 -0600
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 20 Jul 2026 17:37:22 +0800, Tao Cui wrote:
> Several block-layer latency statistics accumulate samples in per-cpu
> buckets and drain them periodically -- in timer callbacks, or at each
> check / reporting site -- using for_each_online_cpu().  When a CPU that
> holds pending samples is taken offline, that bucket is skipped during
> the drain: the samples are neither accumulated into the current window
> nor, where the drain also resets, cleared.  They sit in the bucket until
> the CPU is brought back online, at which point they are flushed into
> whatever window happens to be running.
> 
> [...]

Applied, thanks!

[1/4] block/blk-stat: drain per-cpu callback stats over possible CPUs
      (no commit info)
[2/4] block/blk-iolatency: account per-cpu latency stats over possible CPUs
      (no commit info)
[3/4] block/blk-iocost: collect per-cpu latency stats over possible CPUs
      (no commit info)
[4/4] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
      (no commit info)

Best regards,
-- 
Jens Axboe



