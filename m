Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394838;
	b=n+Mi9xRU9vwydYd02TSYJlHhZ2m9MOsXJCITXUIvXuIrnLTlYJ7mZzXjAvYaxhxMrFEp
	 K/vz0WcFcN+79x29XacspdyYDu5oCJhQceaagEX7VT95DQNHa16f5PTtzAiMDEG74m9gG
	 +LF8g1lXvIfx8KQqZYYCssc48UNGu0B9rZJfUeTSHJrEBjHq2sO3A0YS/+16gREQ7oteQ
	 fuhCtdrd6NPPvyyJrva/ZnHha5/DTMn6ZHcfO1sE/7FpXlaCyxvYgOnnIjW2K9hbGG0z+
	 N0TMVtuN2GIBHYhrTbPOTQjDVtCUcX/p6No6DyjYKh54WKIVpfiTmFo13h+DIUpe9rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:From:To:Cc:Subject:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=p7B3c6D/X11fLUAKKmi13BRTcfCArxOmxqQgFnPzAxg=;
	b=NCqUBs6tGPyamur/WwWeNaGMr1KlPAeVTI+WYXPO8fMnqXBFngy2ohjwuU6J/0d2p1+H
	 1NB9QLnMCSTS1ARBTOPCo2VeUu1P7MguKOPU1q5cXugM0TvqB+9W1CALgh17Or51rdXbc
	 z9Pwo7jHxQGOsJTubvhnFZvtvarAj5ZvCLKhL8hkVseH5REDR5qM3WU9dujwtc1PWxIVm
	 5zn4OPzRDbrrP3OsceNy5Sz9pFCvFYfjyGs0bQZOBL1rpurXsIhs+ZFYO1REmGtUYACf3
	 oxARroaCIZDni7spXrSOlbemsRwTwu7KQCwOpi0mFXAMvGbA9/M6M+vC+kOfkoL510w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wfmQXoun;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AF6606A31A
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 00:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7AF6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wfmQXoun
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f07a960666so8348715ad.1
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 16:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795394837; x=1795999637; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p7B3c6D/X11fLUAKKmi13BRTcfCArxOmxqQgFnPzAxg=;
        b=wfmQXounwgi2H0Qxd61oGE737FXdx3pXDGCOw5wqSvHmhLwHbMYTvLOPgZ1H4nzjgD
         9xZkG+9qJCwNtxDlgINthLE2KrlkMUMLdkTfkRrxDnHg2/rRF6WcXNrtFZn/qVjya7pj
         GmPnzJlTLY18Bw6jiB9/PWzaufJ/EuY1zR/bDY4BNg5qVHJ4zAEf5u4OYbZwir3oJJ5z
         bWrI5gRmMuSG8UZAQ3EXEX981myLRid+1mc7xa3vIvUo30DDFi2XIQe6l+1+d/QDmIr1
         g8buEHoa1fy3Al0T/O3pbPGiy5AkuwlrIPoraLH1Sm1u/V9h97CJmibvWCcdVsbF+KQD
         Rxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795394837; x=1795999637;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7B3c6D/X11fLUAKKmi13BRTcfCArxOmxqQgFnPzAxg=;
        b=mVkBelSWQLU3MNDZc2D/OIDe8+R7dTnai8MQr93tDyRBDjnY6Yh1F+MXDK+qtwDiLx
         RpWaIGI9D4ANz4RU99yZhucXbgG2fkAF4nrKfRUzYbTibS8eiXNmkf7PDrW3VJVrqpNn
         109FsET9hQHrQRsBVdYbXpOSuUCuK0KMWs4oRV8eBxwgj8OSIfhyn0fuBS3W6tqU134c
         ddAUfIc0TTSDFoBM/f9/7qKBaItuLmvXDzcLmECFG706zaLh/4f9mpoijoHi859Zmatv
         PSupRs/2pA0i5aFAVi1Rd4StmribSS1HR+oQNnjRzIDTjUDca8kVFoH4y+O0tbliifJz
         gaUQ==
X-Forwarded-Encrypted: i=1; AL+hErFnnkIyu7F7ET202Ms5OUjZP23Tzy5eHUbg7SsOj7qTBGA6zM74AemKAual8effTGx4YBNpe9pd@vger.kernel.org
X-Gm-Message-State: APuU4Z/H1mFiQkOY/nQkp3JfVtjZhy0EIKrRQfcjL4gxw+PmmzWS5mDz
	iK3LLRr0Fiot2wUm4wGIU3xVK63ptjHKlePNBeLXTPt/d5aSTE8dNje4
X-Gm-Gg: AZFdTZcszmnuIuJuLZ2baJ5H4w4hZXyLGd4ixq03yh81MRLDlMirFAn7MX982OyWG6k
	3Wumf+VH23mfaCpbyPcXt5QEa5fWhMLNllwof87lnG52rob6nuf/65M+ty62XT/abgNKrkyGM2w
	d6heGz7WUHGsLwuza58J6LwQ8HVwg4wh5M+gKFDquv4Z7l1ROQiHeSFFVHyWAqzXUv1Sa/g9v6G
	i2uoc0nZHAY6D81vAvbxWoxxNuMuCbWd48Hxrael9/xYyw1wQwN9M1DZ7kKSIcfuTRM1IxadCu8
	r6v0h6iKvTgj93A5Sggh9hKVbEIpo+f5MdGo8eDtgJ+pTDm+Z0s/4oIWbz4B7pt1UQlBaiEqM9m
	q7NPsK6uCg3G5g9ck9MFq7b0/RszTXvHodMSI8/RU5i9MrGj03HJO5HkAC73vp9CBpSN5hGHkAx
	n0d08lYjQJmo9vkImy21cfOetJO5SbwEsEoB07JDfv2KdKIdg89oWghItJLxk5QarMJ8czmERvv
	paHFI4AKZD1md3bdPFPtLJHo4tgtIRSCsWCKtM8s21suJZGeO6YbbrjPklvb8T7iE/BEb7rPJzu
	jJXpBuPdsIKsotLAPvpdFeNMnHz6xaT9Yx6hiBfbQF9pZAPPT5l6T4y9VQYVZpJptjLUJszALZg
	J8Ga5e1iIWin0gbyLJTrRouEVwvlK2zACyg==
X-Received: by 2002:a17:90b:288e:b0:3b3:ec88:72a6 with SMTP id 98e67ed59e1d1-3b41c85284amr8792429a91.3.1795394836739;
        Sun, 22 Nov 2026 16:47:16 -0800 (PST)
Received: from localhost ([153.61.198.253])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm15471631a91.1.2026.11.22.16.47.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 16:47:16 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 00:47:15 +0000
Message-Id: <DN26CP5BB6O7.23ALW6CZUBYSD@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Karl Mehltretter" <kmehltretter@gmail.com>, <bpf@vger.kernel.org>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "Emil
 Tsalapatis" <emil@etsalapatis.com>, "Ihor Solodrai"
 <ihor.solodrai@linux.dev>, "Shuah Khan" <shuah@kernel.org>, "Tejun Heo"
 <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Waiman Long" <longman@redhat.com>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, "Puranjay Mohan" <puranjay@kernel.org>,
 <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH bpf-next] selftests/bpf: Disable preemption around
 css_rstat_updated()
In-Reply-To: <20261121082843.44614-1-kmehltretter@gmail.com>
References: <20261121082843.44614-1-kmehltretter@gmail.com>
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sat, Nov 21, 2026 at 12:28 AM Karl Mehltretter <kmehltretter@gmail.com> wrote:
> trace_cgroup_path_lock. On PREEMPT_RT this leaves preemption and
> interrupts enabled. On non-RT it masks interrupts, satisfying the
> assertion.

let's fix the kfunc instead

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index de816a4..d72fe72 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -131,6 +131,7 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
 		return;
 
+	guard(preempt)();
 	__css_rstat_updated(css, cpu);
 }
 

pw-bot: cr
