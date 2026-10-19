Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAC4552EDA;
	Mon, 19 Oct 2026 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419267; cv=none; b=JnlH2SyNCf2dNSQ2A67dAzGePC9XqFwAXIIaOXKK5C70/bAv3akDqWrMK6ho2VFdfhhDa3HIkN8DJSVOMTmVI/B4zf/5yHOI7/P6ZFyteAJGDlwnf9nq5Tczk6sQAO56tc0W84dLL9VpenD5Xq0ejNR6mC5QzN6xOath+4wIBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419267; c=relaxed/simple;
	bh=Ch7QAVs8y9P8kRkbNHCRoG1DNBpeV7Gdzcud7UUXypM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NH8tBZjKVRRnKEqXWfDl0jlNvZGAMXLh0QY+ul2iEixfFyr7zFMjOX9A0EScP+S+z2lKSs5M3ngUScPDxXKqO6jSWTqTXZcRsRUhjXDWmQUNNTQxA/zvbvCz2mli1/0SLpYRQC5MncIKgNcAFfTfjTN2vP76BnmZwaquphkCF30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkgx2V7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkgx2V7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE961F000C5;
	Mon, 19 Oct 2026 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792419266;
	bh=7796Na8Lv8R+oexI0qKXaPmDdfsdOtZrwkjrcnP6R9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mkgx2V7ufsKA0GuRgq4ukenZFT+R1sPN2WiOnCwsZ/VP3g3lmzZfDm00z3z2CAUIe
	 bTsfFvc2uuNXx8Vn8tZJie9CLGIPGzCOdZESkWLvl+e9muw7OpPOneBngK77eyLYhh
	 iJW5czRYIGrxsC3vz8IKHLDEW/zhdxem0GA/fbsfloeVeOgdG55um9Cwciq0sFqLzF
	 oeHvQaHqwL3bkMdwFC0FWUFJPwB7NXmAjV3n9cdCvXGe7NRh0XNwytR8/Y98qnyWsT
	 xEhkC6KUJ3LZWsgzN0j+/pK+hjnDgOLp+be77PjVvfihIacChpxEfBApH6ELx+aVCG
	 UbzM5bsEfOTzw==
Date: Mon, 19 Oct 2026 15:14:24 +0100
From: Harry Yoo <harry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <atYgxto1RXZyZtLB@thinkstation>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
 <atEkfmRFgXJCbJuK@thinkstation>
 <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
 <atYdi3O77m6XzaKu@thinkstation>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atYdi3O77m6XzaKu@thinkstation>

On Mon, Oct 19, 2026 at 02:46:37PM +0100, Harry Yoo wrote:
> In the function, RCU is the only mechanism that prevents release of
> the memcg

Uh, no. looking at the code again I might have been confused!

The caller is expected to have either 1) acquired RCU read lock,
or 2) have a reference to the cgroup.

I see a bunch of callers that acquires rcu_read_lock() before reading
memcg/lruvec from folio and passing it to mod_lruvec_state() (and then
get_non_dying_memcg_start()/end().

Callers like reclaim e.g.) mem_cgroup_iter() hold a reference to the
cgroup...

-- 
Cheers,
Harry / Hyeonggon
