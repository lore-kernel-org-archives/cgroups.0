Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD537268D;
	Fri, 17 Jul 2026 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309040; cv=none; b=KJ04BrzlMVzIGSAW2VwhioovhCGm+fbwmzgfq1e9QyDnQ8etr6fl4IFEuth78i3/nvVHZO24KYrblS+KkcMGVZdU7XX0ayUDOR9WcC2z/Q3roOoszZVgHVBD1wsy/h/Ho9yhW0psHYPOh/9oW//7vSOjvBEHhPLRw9I6fGDBmIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309040; c=relaxed/simple;
	bh=CnM+nYXm30Z0I4efHjGSv8zo99D3BgyXco4Mrpc7KBw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=XeSAu2OAqsIc+5nA0JS0BaUCogBnMHoNwSDM6Mux7QeJVwnPUi4OBQUedkLIp3wu8BuV8kwiWsVuW4mK8zdZd+7HJP/UvtFGv2CdsftkRyip7z+jCAvfC3t5u4ePi308oNPl0YZxAwcPhbDzhJIgSULwUf4GWljyhwHzIa8WEyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOgVxDU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOgVxDU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ADC1F00A3A;
	Fri, 17 Jul 2026 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309039;
	bh=FynOWi+8cbzPJyuD6qvzN2D1eQqr8qZ1mliz0SITIr0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oOgVxDU0z8Qq4CtxUlf931sX+yyyEkuhah/yMd1nyRYAW3W2Wju/EgaT5+2Ec8FbH
	 dawbYkDZ0zotSHBL/uF3c2BszxLSazLgst824ZLLp/uHWHRZc0GPRo2lzAx3spezsb
	 GAXxE9Q5Rc0Q9vRXa9NLlEEppLhRgJtpHFuPVRG9y+a5JjbUJufp0PmnHlkHjUlCI8
	 YZlSNSUDP9k02C592K4vmppHTehjxOVKIhz66ewMb6dwR8whIgUoOzm4aI1XM0QOb5
	 dxqStnSkmLYH147PmRinlTeSeoFLj4xTrNMY8c2TfVutE86mFIAPoaPTWXZri82tQ1
	 nFu185gt1hmsg==
Date: Fri, 17 Jul 2026 07:23:58 -1000
Message-ID: <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 "Michal Koutný" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
In-Reply-To: <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
Waiman's ack added. Please drop it from the mm series.

Thanks.

-- 
tejun
