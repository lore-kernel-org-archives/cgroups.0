Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794584990;
	b=Ue9YrMcDFg7hxlpQoDE97Lp/Askj2wP+A5RUCAiYp4ZdjwbjT3+S9t7h6aPl+N8z47kO
	 fb0JHXte6eqoVozN/p9E/IeBTAoOaLZbgjy0jCeDzm4kXRKWb1Jzz3jsi4TMuZKUWeWaQ
	 BiAk3XYrDMAm2OmBVwJYPi05yqQtIVB8PgIsJB5tfms+xz+CKsi7j1gD/nqtwfFpE7AQK
	 CE4KwCEn8ggS8NXr8YOj5AdvVoAxB/fKaSsZok/Ywr8lkchiUyIQypt8TM33SPVjDA+WX
	 ae2e42VUh0Da0kcxoKydmJ1xysRl7MXToTOqYG9VlAQe+qlUpX5xAIKAd1A8afudHsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794584990;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFCVBlkrizuZWlE0hb6CXLduUGl+Zuu3dMj5O1kjYAw=;
	b=Xy5zsSqs11s+a7Mmy351FqaEN0vXmORCCWMTgi6iCLaCd3jhzfuUu4zbmH9vaY9RRLRc
	 /HE+AtVcewbdSxV/bgH4eh3utb/5ZIiaq+BWIjXXTZq4T9gibKxnwhm20YLdj12G2+Zbz
	 5KOhvGivzi/JTDwK0IMmII6uXT1xk51R+7C/bjP3NDLe7m2E1IbYTSXdrbe23dDF6VYkv
	 7AGZPmUoAzLJna4W0aBwDWDK/Fcr4EQ1UR1MYYO0ihaajjUvqd9yqFow70TwRs0EcVq7g
	 bEuyxpc1TXw/N4S2aiMZynorkl2EIZL8s/LlnYwLYkU2nBRkwxNHFe9kftOD+XGNxMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gt6PRoTj;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E30A606A330
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E30A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gt6PRoTj
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-491846221ffso1208446f8f.3
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 07:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794584989; x=1795189789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xFCVBlkrizuZWlE0hb6CXLduUGl+Zuu3dMj5O1kjYAw=;
        b=gt6PRoTjK9ushlCFmi0ZnyNwfS/RFssMXZcQGe2pK8ReE6W1cTJq9QVXKDgbsK7I/u
         QLCMljabk098avfl3K3IKbEHTrqIYq/AXSVFB8HFvwXiRgwuyPlUahqfKNnMoEHeWNhY
         M2X37MoMwgmAp9EJ0/2KidunymAnbPVB/RfOfz6vOoMoK5qp61eGjdqgAqsrjikxAQ9g
         VOSArufYGvu8H5cOCLxjsC78AuSgMVvDEJSKrB+upnCPCmd2dfiRfNqp2vhbKW5FbpPK
         9ovQ/9GGKfOYZbuRQ3U45LSKN9r42DvPuu/0zHggVTglptLhHgJaueP7ItMzfSE6n+Da
         5p9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794584989; x=1795189789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xFCVBlkrizuZWlE0hb6CXLduUGl+Zuu3dMj5O1kjYAw=;
        b=2iL+f3jKEw6TJMIaKXwKbxAuOHtDxNzG0CKJE4Poq412ZgUef6AQaXK1psQMFKZOW5
         aZH3VtKS6g8/8vqln9MTrGToy8wJjSIdPNeZfYuZy2o+0k+SYH8Aa8oW5vk3X3iW2zds
         LVvuaom6XOjHPa80ynRJQ62DpdNYaxKNaGT8omJLGYPczTwy3EFYdKXPjGFBaXxHI7Aj
         xQouZS5IodtokEREw8XwaIkuh5v9G49tkFCr2yiOiEfsbNFHZR4Lg55ihQcIKbRdWotb
         93eNnlbq73cbF4lzB/OH5sBHrmrAX/AdGCva5SxU2lLrfAOb7k+fuTbJACS9SNtsZyNh
         wxhw==
X-Forwarded-Encrypted: i=1; AL+hErGBejwZFs2o7bfyWZPRbahff+xOj68u6ijI5qEvNjyBsQiujeDihroBAKLV4a6XIz7TICiSDwaw@vger.kernel.org
X-Gm-Message-State: APuU4Z/rxCOWG6x8iK1muJav/eG2/Ey/RKFeprLL0PD7qbs8HZZ5+xZv
	UDDCKPHJtndjxvYHu8smilSP+fdRSaeRdOujRBCxq2od2lcsmchi+M20
X-Gm-Gg: AYBFou1Wf3EhpAWI3VgG9ipZ3wtoGX/SinsM2/I46fFQBaGxOFThuxhDMzXNfLtggzM
	R1lxTSt66ax+ATKETMN4lR20OHsJgaEhhiPi0M8rJ4TUbiem1QjDSh/0ie41FWMc6BB1ArOSAwt
	wr7UdshltMstMp8RAuZrifdyjMhTwlAbBV2YrAwJ+A4Qz/AqOnsfgc24WiPAs2W3M6hxRI8XbT8
	C1lP/vDF+9J9qYa9uSrYB5FeOvM9HtW8zMXoKZ9qtimez+iwZ7EROJZftFXtKzg/vFvpCiu/4tl
	necvdEZACkHZa+e0o8mITtdKFv4/jRCKm2SPrHjW+sd/YSqDg8h8/QFd4FwgymllvvhKqdPNqT8
	ChFPUHl5jer9YzBbzv7rJOBVPrB/VI7+Cg0burrLydd336Wkyv2OeW9MH56bjXpGNfIRPO6lsIX
	ttjd46E3mV3Jer4UUETpHCbwApDMR7XkLBGA4VgteEstogf0VYVp2YFX5Gb3gA2dPtpJH4rYqCw
	PxpCJwSMEtSS304Buc0CKWg/0W/ClcMJ4Ma2AiXk4K73qtR9Wels39F+n6GMpUEKfXzJKZVW5O9
	BhiJwdpHF3/NL7/mIJqTgdqK5HCzi4FGnugKtXLnPGS+L3iNP0MgQMASMfm3iXQpaGshTmyBHQM
	Z+A==
X-Received: by 2002:a05:6000:2084:b0:498:be72:6371 with SMTP id ffacd0b85a97d-49c713aa624mr6770868f8f.21.1794584988524;
        Fri, 13 Nov 2026 07:49:48 -0800 (PST)
Received: from andreayoga.wind3.hub ([31.189.56.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5d03b10fsm6797151f8f.1.2026.11.13.07.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:49:48 -0800 (PST)
From: Andrea Parri <parri.andrea@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only where room was made
Date: Fri, 13 Nov 2026 16:49:43 +0100
Message-ID: <20261113154943.14429-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <818f0461-4635-464c-be20-461cd4cd8341@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com> <20261108185406.1549770-19-mathieu.desnoyers@efficios.com> <avVk0UU8IRGoo77v@jlelli-thinkpadt14gen4.remote.csb> <d58e067d-05ae-4e4d-9d34-b0ac2741b211@efficios.com> <20261113150438.9119-1-parri.andrea@gmail.com> <818f0461-4635-464c-be20-461cd4cd8341@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Nov 13, 2026 at 10:20:16AM -0500, Mathieu Desnoyers wrote:

[...]

> Neither is needed. I propose to carry your patch in the next version,
> unchanged, right before this one. I already carry your cpuset_mutex
> fix that way. I rebase my patches on top of it. Then one series fixes
> the order of the two, and the selftests run on both.
>
> Tell me if you agree, or if you prefer to keep it separate. If your
> patch is picked up on its own first, I rebase on it instead.

Sounds good, thanks.  Please carry it unchanged, with Sebastian's
Reviewed-by [1].

[1] https://lore.kernel.org/20261113153549.Z8XPohWU@linutronix.de/

Thanks,
  Andrea
