Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3797620E6E2;
	Fri, 17 Jul 2026 17:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309190; cv=none; b=NZ9PzImRsi1cRoKAZWDSOJoaNY8n2+SiaDAOQ4KVzjZ28Bb9Bp+MDjOIkaSAdVa7WvzDWu129N5uvR8hapQTke6jLBcUR8pb8z/Iy0SgvwoAQ7VUP+WGQm3SV4ueikj20Ox9og/vYheuBLhpMM0E3h/vVNeurh+tR4xacPoYZfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309190; c=relaxed/simple;
	bh=3QpFkltnQchaqBgei6aJhDpjEgTlInsCgAN6RgEC/84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPYa3PMSFpW0y1Noj2iB8OfthTh0S4mohqw/GhavTRvZF0nVdHV9yrFY3BnXzpl+Shp86GswJfl8XidyeZuTwqoh+N4vgcC+NX0ymsAHNFxYi5YdJ3XOjSizB1RI0BDurYiTRr33viT7Uni44+JG5/oNnw0T1iIYx72Pya9i96M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eq8Ng3s9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eq8Ng3s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C0A1F000E9;
	Fri, 17 Jul 2026 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309188;
	bh=RAK2U1t4VLrXzqivKyXPpAeDcpRK9SdlLlYcSqpm1Rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eq8Ng3s9VOHlQriXV043RpXIKYLuUf9RjW4hvAtu6sDVA/4G9Mbxo/KnTh34NSH7x
	 b/b+WY0eX/zEOqxb4W8NNh6MIhuokuqDduyk9ApGElOZdzhWymR4OUOUZrfJx5o1n+
	 JMUDsDypZsONfslZznajb5UdJUfTcu0dS8xHfzanEWV7z2sIQH4S3SY5fcW2J9EWwQ
	 y6rSV2CUq5XBSRJh+ec3PKt80A5XCUUSdAThy00dJ+rfDR+oy62Vi3V1B7fdXBzHDI
	 4DLuHcOZyO5TJ7kHPkf60PybKmnptNzVFpuih2M0CYbOq8nYwI+Vwz4SllZyrf20Dg
	 SdO2hpsuYlbSg==
Date: Fri, 17 Jul 2026 07:26:28 -1000
From: Tejun Heo <tj@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
Message-ID: <alplxFeazzK_Ziie@slm.duckdns.org>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
 <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>

On Fri, Jul 17, 2026 at 07:23:58AM -1000, Tejun Heo wrote:
> Hello,
> 
> Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
> Waiman's ack added. Please drop it from the mm series.

Never mind. I'll drop it from mine. Sorry about the noise.

-- 
tejun
