Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794577657;
	b=2mkATrE9idRqRuWcF/lgvBupfIrxhcrPbLyQ43Wi251kZpxlNfaSMTzhLZk8+TRqMMvl
	 9F9NFTo1caulMIZ/1t1G7JXoOXonRDfjAH7mopDHzxc8O4OS3GV6e0j3VdC6VDhzS5Ryg
	 tb8MmBmQlrKWEH6tkstrh7LzCS5rS098lfx/rqSpJtkp4ytcSAa/eVs9uPB+nh1cwwIA9
	 XQTZkGdXfN88Yvk5wkv7CgETTzimYuULzFJMg9txYW0c39vsYczRM1u8X3Y3mtyuKJTY2
	 0aUKeLrGDmmjUDDuQV5DgRzrqqiBYqNJn1lK8crT30ux8If0152DuisTJeh1JSxQKkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794577657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Uh3RNZiwQ8OEliQwz60GaSWCgjS92PjWqF45e5QPMWE=;
	b=zgy05g6YWojF30zTbIigP8d/pbmSvTAlTmJtW7i7m9PcS20W0auY+a/l2F/1hXU8eot2
	 jsf/kjkIfQC6rUXTWmo1Mj/tF1UjHl8dzMNsqv5fJbHI809bV8/BRsHnzcbIzmio0rG5J
	 0wiaZ/tUUzUIPy/R+hmAfoL6Ri0Yt6YSjrBiEfCArZkniwm3fS1WWqHKEe9LyPxw55PuC
	 F0DxzLD0LUiYPc1RI1OaRsqbbxPNgvMl70R/WfM4JIp+s3S/GXPOsCQGwKab8ztjru5Gg
	 /wMLUFkXJg0OW1HuhpM7KzmwQfR6ELFvNYkrnM4j2Q6dU6U2CZV4J6fDXTPPMTGBcnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mChKw73R;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D5606A336
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 13:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 166D5606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mChKw73R
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae1d132d52so771605a91.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 05:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794577656; x=1795182456; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uh3RNZiwQ8OEliQwz60GaSWCgjS92PjWqF45e5QPMWE=;
        b=mChKw73RMvMekalbwIWe8vJQeNvBuAqoFw9E6LWWYbcMqUuXDvVGlHTLU8n/PqxdKL
         j5K9gDqwD+/0CTMTFAtxDuqyu7cxgmBzY8Ju5hwgNLshJS4w/4lSN3SaYU3JEWz0+Xak
         da8uSjJJ10NkQfa73Hi//PBJluj78+H3S/po8W7LsqqH4uMBbF3g/iYIskDP2aKIdts9
         o7GQQLrvh2y8kGnXVLqcYJMCXCC9Jt9b8+0V65HBdYxpZFkn/ERRJ6MMZIMcrPOgV09m
         7eWINQ8gZ7gPfty3HBdvHYTcxr1IQD88TJYFrwZjM1pbJOzGg17meejlsNBHlIcEqiLo
         XdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794577656; x=1795182456;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uh3RNZiwQ8OEliQwz60GaSWCgjS92PjWqF45e5QPMWE=;
        b=TVhETrbYRrfikyf5fYFvvH/FvIZEmjI4uYEcQtBY76j3CcVk1nIxsJdJ0/D4PlKLT0
         JuNZHCNvXnfcAFphZIw4a7RkVlQaGHZZGpj/cZ9FgvS/6kjpMAgJqYgwjV+9M4K3cchg
         W/ezFlIvDT+yP1gbag/gytt2SXBsAX25MyDtfgKMc/Nntt2uhdL1uH9m4aDiiqmEz14g
         BZvuf49F4P0Yt/oAgaEAZNhEE1rjT7URASPOS7/uqs32UM+aLRw2rV3vnvJ0lm16/CUy
         IzKOxmVWcVMY0LnJrycYSkKn1ZOvPmzxUbNXbEc3aaeGKSnxUNpySU3rTzudwikOl9gs
         KrqQ==
X-Forwarded-Encrypted: i=1; AL+hErEbaZCRsgnoCPzY9FZUZVGJjtAFtbDdSq+qeAdh1bLPu2W4/9An/O0MB4s9XKttLFiVIlG5HdkD@vger.kernel.org
X-Gm-Message-State: APuU4Z+rsrH6Vzg/xrArVQUIM+CLQyDnqam1dEobk8clrQn4QuJt8UvT
	XyeiPKMd3Md/hxF5mLss+PSZIXA+5Oe93ueNAsByrLnieZeqL4ur+5YE+As90923bEI4mZOA79F
	8c2LMYA==
X-Received: from pjbgc19.prod.google.com ([2002:a17:90b:3113:b0:3b0:a379:b383])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a50:b0:3a8:c0cd:57f9
 with SMTP id 98e67ed59e1d1-3b1b0a0db23mr2345964a91.25.1794577656089; Fri, 13
 Nov 2026 05:47:36 -0800 (PST)
Date: Fri, 13 Nov 2026 05:46:14 -0800
In-Reply-To: <20260922071945.693714-1-fuad.tabba@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
Message-ID: <179441838666.82439.8379969006436543719.b4-ty@b4>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 22 Sep 2026 08:19:43 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Use FORCE for the sysreg header rule instead of duplicating the
>     generator's inputs. (Oliver)
>   - Added patch 2, the same class of bug in libcgroup.mk, found while
>     testing patch 1.
> 
> Two fixes for Makefile rules that name a directory where a file's mtime
> is what matters. The first is arm64-only: the sysreg header isn't
> regenerated on an incremental build when the sysreg table changes. The
> second is arch-independent: cgroup_util.o recompiles, and every test
> relinks, on the run after any rebuild in lib/. The two patches are
> independent.
> 
> [...]

Applied patch 1 to kvm-x86 fixes, thanks!

[1/2] KVM: selftests: Fix arm64 sysreg header dependencies
      https://github.com/kvm-x86/linux/commit/b2ddd6af0646

--
https://github.com/kvm-x86/linux/tree/next
