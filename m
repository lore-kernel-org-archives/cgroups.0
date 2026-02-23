Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A971E834B
	for <cgroups@vger.kernel.org>; Mon, 23 Feb 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771874539; cv=none; b=R+LQepWuOZeb+ajs8ejqqfygQwVOahHDbJylOnhVYkfELykf5EkL51c1MH3RXeOPwq8exaj+g3L+qZeGV9vtUqUmDcwrA+9oxsPK9KglwSIu8N3TISdzjhsf7buY23LnpioniChDS4qaShSlIJkyLc/OCRHzYKwV7PhpfdQ+cXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771874539; c=relaxed/simple;
	bh=6fs+jbOjp9m95hvh0abogRCjxKuGRNz+d/0oMVhxq6Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jK7RUjsSs/D6cKoV0jQSNMvhkFlbdlm7UDLdpnm5cdWeBOthxzHAdIJin3q+0Ki+easdP76ZLML9gNYM4nDIXUz1oKElB5TZOH0h1GsZDNJbg4feEV+kBO3CcTRbn4YcsIUcPGgWr8BiEQBl188/WK3EaQWTdYcvgIwtWQDCaUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eROIpp1q; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eROIpp1q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771874536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fs+jbOjp9m95hvh0abogRCjxKuGRNz+d/0oMVhxq6Y=;
	b=eROIpp1qpu/ongCjVJt/Z7mi5OTUFZeytb1N6rgy/KilNgwptKOiSSrU/uiBcoR2Mjf5Ks
	yiZvwpN/ejN28iTK/SrPZO+EQ6qeJNmeaum1gqkqmppG75WF5zNIcx8DwIdabNZnLym9Az
	KJ6va8lZGDzVIGSDJTIkF2Pvdm2ysiY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Uladzislau Rezki
 <urezki@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Michal Hocko
 <mhocko@suse.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Muchun Song
 <muchun.song@linux.dev>,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmalloc: streamline vmalloc memory accounting
In-Reply-To: <20260223160147.3792777-1-hannes@cmpxchg.org> (Johannes Weiner's
	message of "Mon, 23 Feb 2026 11:01:06 -0500")
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
Date: Mon, 23 Feb 2026 11:22:06 -0800
Message-ID: <87pl5v8dup.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Johannes Weiner <hannes@cmpxchg.org> writes:

> Use a vmstat counter instead of a custom, open-coded atomic. This has
> the added benefit of making the data available per-node, and prepares
> for cleaning up the memcg accounting as well.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
