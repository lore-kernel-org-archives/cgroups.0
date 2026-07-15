Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14F3E1CEF
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 09:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106120; cv=none; b=fiR8TuEKGCVgGN2s5efVFhHTx4a6dhGq9fBRw+ZC2i5vAYZBUb6PDwAzrqLspb+YTbLkstZ5l0+U/B6uW9ZE6mSSM+63Rz44Bipo2IoCvKIT1CE6UYTdRS2UXVpHDblno2uYEu+YNyD6ozwBLk12bbMQmpe3lZo65BZ2EtOtC/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106120; c=relaxed/simple;
	bh=Sjv5VCwSEt6zqYACQUTN7C7iuSdYRzhtwTyhw33MvX4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=O9dpUvwkE89Oh+FrqviLfnN/+0RGW83cnWUgUEIf64NYL0NJmED6IC4r3/7NhdzZ0nzjLvOe1XeCAlfvw/vD8KQhlQ87Xw5APDF5DZHP6aPesl/yeguPUyKEqUQ/Z5adwZ2GJULQQTFau9Dcbcc05h+Ayyq+ChkVAMxq73sJZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q/XfsBTU; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q/XfsBTU"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784106102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sjv5VCwSEt6zqYACQUTN7C7iuSdYRzhtwTyhw33MvX4=;
	b=Q/XfsBTUW7yoyG8P4VPqcKjBeYHCAjtmZ9ZOEvrYT/irTKB3NczjFc6IiAeDLmOyz/XYqi
	mnBjj4y1E6JtsAlkE+oNxbAQlvlyFmDNTcqp9R814r7Y7hVmkuqaQP+nF1khmXf6exTov/
	Lq42jc6yvm29mpqcLnS+s7kjrC6fLv4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 09:01:31 +0000
Message-Id: <DJZ0TRQNDNHG.3CD9OFRR949TK@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>, <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 3/4] mm/page_alloc: fixup alloc_pages_nolock_noprof()
 comment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Clark Williams"
 <clrkwllms@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
 <20260714-spin-trylock-followup-v2-3-3c20ed032b14@google.com>
 <DJYR00V65DBO.EAAIW26NL9ID@nvidia.com>
In-Reply-To: <DJYR00V65DBO.EAAIW26NL9ID@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Wed Jul 15, 2026 at 1:19 AM UTC, Zi Yan wrote:
> On Tue Jul 14, 2026 at 5:32 AM EDT, Brendan Jackman wrote:
>> Update the comment to reflect the recent change to allow flags in
>> gfp_nolock.
>>
>> Reported-by: sashiko-bot@kernel.org
>> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714=
e19d3@google.com
>
> The link below points to Sashiko's comment directly. You can find the
> link at the end of the title "Patch 6: ...".
>
> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e=
19d3%40google.com?part=3D6

Nice, thanks for the pointer.
