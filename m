Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDF44A5C42;
	Wed, 14 Oct 2026 08:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965787; cv=none; b=I+5ronEljDm656LhifdU6fBxDvtKsgu7y9eqPbKAXxgaOC77iZEuDihvYLtHHjHnZRGtXBrX5u24tCW5ZIeGuHjarbxNfbEhYWH+0Fq5d2WTnrfOP7xla1nQ6XyVnyiXxvOEOb9D4O6v4ugKIOb8dt+KPWr2vcepAdJeJaFPe8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965787; c=relaxed/simple;
	bh=FMDJH83nRF55wi7JxYkQaR7GOx6g6412MEv4fXpsJ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suU3Kzmx/hMqlbhTCdkFE38vamI5J+SIudVdVmGyN+NNIHANRViVaK9DHQhY6kemvGLeTGEur+e4pNjdOj7ge6AHRKDLxWjE2jHbQW+omknCUR2NI9fQXq+mihE57+jGB1wEbqJYM+avYNmE1WDuf0FdTA5Wnl1uVouPEKyBinI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jk25NULz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jk25NULz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DBE1F000FF;
	Wed, 14 Oct 2026 08:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965782;
	bh=pXk+bgsfV6vorpYN5oSqgTgpORjuife32Grsgb2Gqbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jk25NULzGFVBz2j4agtrSl8HWyhyVJORSzc5FsfdPnnB8S2UAZXm7EXn1s8z2jKtZ
	 5t2xWosLNq2Q+caqbUQxPJBMFSBVX1EZaOGSnAfmUQaanHzxL6nKlNVFBkGCVdv6TR
	 X7bBOc27Mq52Gz1VDSUkY7ZHlmWIVvjv5ZynWC/rCK/3eriytOQCM71BHwsqEJGHAN
	 5pvzwokjmX4VQHLc7cI7h9uJMSL4KR0Wj1TQFYtX9zyNiU/LnDeW9i/kSjw8zeJT8q
	 tE3QmKnXvleSUsC+OlE2V9jd7MbA69/6TSlR9zfJV+ze1x+eGmx1Qrlk12/GBaAO7S
	 KJ4ZQDtyaLpQw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v7 0/2] mm/slab, ipc: kmem_buckets kernel-doc and msg_msg accounting fixes
Date: Wed, 14 Oct 2026 10:15:56 +0200
Message-ID: <179196561882.18524.5893215402239363173.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014052338.nothing.279-kees@kernel.org>
References: <20261014052338.nothing.279-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 13 Oct 2026 22:23:41 -0700, Kees Cook wrote:
> As Vlastimil suggested[1], these are the first two patches of v6, split
> out for 7.4. The rest of the skb buckets series will come back for 7.5.
> 
> 2/2 now keeps SLAB_ACCOUNT on the msg_msg bucket caches and allocates
> with GFP_KERNEL_ACCOUNT as well, so a msg_msg is charged with
> CONFIG_SLAB_BUCKETS either way.
> 
> [...]

Applied to mm/slab.git slab/for-7.4/misc, thanks!

[1/2] mm/slab: Mark the kmem_buckets_create() context as a Context: section
      commit: 655668f0caf32a42fef10aaf31137e52f46a0260
[2/2] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
      commit: 49c0b3dedf7c8c64e432e63dd7b24f00909916d8

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>
