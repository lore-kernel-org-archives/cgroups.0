Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26D32FFDD6;
	Fri,  8 May 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778259069; cv=none; b=m2gTSPP5OZvK14HemyiQBG50jweHjATtaXh1YUV+OzSwKkVerb6YcggU1x+9P+D+ZTTzu5vWd519kvsO56gsDD5LTnwALDaB6mOOHHMvs30T6YyU6yoI6oMVsLogTRWeAjTCpkW5TV5IlqukHXhQcfShKsYA3+dEcQxfCFlr3AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778259069; c=relaxed/simple;
	bh=wfZHdxbphDCILLF5DQY94IvC3KOyp75rgVsh1kDweds=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=fyKZ/5Zg5bEXZpsBCVq2VBJVY+oJLEEFRehKptYC4W0vKSwyEbuKvyzknjzjvvEcd8nIt3FrY3iv5LC+8S9Yenmoosd/zGu9MpUH0TIs3phdG03uvjRXRRn06ath4riMxw8fmnxfVfbefCNLr4lpWbnPWmkVOrD8CSgGlbUo920=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMPJWU0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMPJWU0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9EFC2BCB0;
	Fri,  8 May 2026 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778259068;
	bh=wfZHdxbphDCILLF5DQY94IvC3KOyp75rgVsh1kDweds=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cMPJWU0jCW0z3TZ++dW6lonz13wMO8tor1O4VQq+lb4pNPP1epcErZvCKsBpeHwqm
	 VD2TSDTCBxHX7qOhroJOAXLMHYysCXKeQvL2HJiBhrTmLEAp2JM6yelsZNZHavhYpd
	 KaRhr63yFCB3JDvqlzg2QZoCCi6YQJNreJEh5QbeclNr6qPDNDchHOtg5r4sGdYzHl
	 TRGP+y6LV8u/KnGbXBtr1uXu8AziJyPXv9K2FzTCf0wp4RcE3iKg8U/SgQ3wxnQLC0
	 dog/SJFzxUeY6h/lnjtkx8lf+76ft76TXPYXuoTCOIZYoTDlHbGtLzwd4YvFIIIOAm
	 ejKvww3twkVAw==
Date: Fri, 08 May 2026 06:51:07 -1000
Message-ID: <a127e36e4fa970ddabe36a654088c7a1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: longman@redhat.com,
	chenridong@huaweicloud.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Fix incorrect variable check in online_cpus()
In-Reply-To: <20260508033453.1425026-1-lihongfu@kylinos.cn>
References: <20260508033453.1425026-1-lihongfu@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

> Hongfu Li (1):
>   selftests/cgroup: Fix incorrect variable check in online_cpus()

Applied to cgroup/for-7.2.

Thanks.

--
tejun
