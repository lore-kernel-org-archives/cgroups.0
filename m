Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AB35237A5;
	Tue, 22 Sep 2026 22:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790114576; cv=none; b=T3gXxtap6GD6RCtuRfohGhCYfV9mXuWJ7q5dBWPDTx0kSYGR2v39sN3MbpnIhlm5n/h+dfgQRNhtJm1ZDubHLso/SMmE5YiW0MR6jRLB7Qzle7kCRP6HJ0l00Unn2k5lf7W2pYxcAiFgUl7JA1/JoAfD5hjrk93Rx5sYEqi6ggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790114576; c=relaxed/simple;
	bh=OGADmb6pes4OKMrd9uXRPPINpnweSjMRF9tPgaq7Y10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHNUvpXehfL0bDAWzPu2E7wKwfEguFf0Bptt5IGkX47g4fZYaHhW0gIQesnFyneREzqMRV1hatRdAyUYOLkotZtoRb9r5cdX30BjP80PidHU7J1zalllEg2eRrUDDJALsMv5chcH5Sr8YWXOgNy1MK+JT9adwtpcU4T20nbdaas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OIISGB8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIISGB8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EE61F000FF;
	Tue, 22 Sep 2026 22:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790114566;
	bh=wKK9YycH0R2EJTI18dBMlcWfaIT8ieRU+CtcZa/oVek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OIISGB8iLktFJHhsseBPvUeW6nvs4ef8INNlkvc2mQqbl7kCara0wbYdvk6bmc8V0
	 mo3LABnhgureG84S77c2YVqFMW94a2U+tV9rTX/ZWRchLhR0zIoAIaPG/V8ADmWwVu
	 I+aPYtR6TpAo9fHOlsPuIzchTZz2+IDh6U0bnlw+y5x9r55c0cvQNRTRv5rENKtJVk
	 zYUBIeFNJ+yacsMvFYcZ1mG3uz516vwBoPKs6eXwjhkkj2Sa4g3royDjvUDKMi1pVf
	 GFN35lrWhQzMvApU+NSmRd2R+HxPygNOQnd/fKRAoFS1WB1dJVdiQDVwsV5LWkpm4c
	 dBPL+f78hp6zw==
Date: Tue, 22 Sep 2026 12:02:45 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	jack@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-ID: <arL7BVjrt9Fkv7Bp@slm.duckdns.org>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>

For the series,

 Acked-by: Tejun Heo <tj@kernel.org>

But let's wait for Jan.

Thanks.

-- 
tejun
