Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242932F999A;
	Thu, 29 Jan 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712617; cv=none; b=t907/yWpBuc7FrNc/q0XzH57x9p6X8rbRZB1egLamav5TB+y60xPPTb7FnCW43VDU0iS6Izbe7svi7GsqL0J0LZGmRZr7Fu3NHzdiY5Pa3FNqbvWIrMlqLgRiIJBYEK+nl0//Ayo9dh+DsnjBz1iKkpaDkyshNUhWcQGAvpGygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712617; c=relaxed/simple;
	bh=VGNvcdu64FETQBdDokUrI7e58s6eZHVWcch41TMEnK4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=FWIDrR1a0iz6D+SM5+AnwQHwxlDRqJx/AmO3lAQnMRiUt5cPnL+EXzBakEl1Eur7SiVMjINWj9aqr4huVDIZmBxWOEwCTujd1RAf/xWNb70F8BN46DoKerv5nZeKOzaTASbpJXVaaIqlU/DYhTnBBiThwwjpslRZ/05ue4pzReE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zX5ukDmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zX5ukDmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFCC4CEF7;
	Thu, 29 Jan 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769712616;
	bh=VGNvcdu64FETQBdDokUrI7e58s6eZHVWcch41TMEnK4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zX5ukDmcle0ibR4bulwJp63KtfyUocBmZWuXRmY+mkh7P8Xq1ALo+4jZpXAIc2v5p
	 67pofPbXkUa3QvIBtCkHbHLi+Gxg+lfL69di78qTtzsN94cBHDV/4eTXTqsFX/FLwe
	 dn5yiGTFVTW+1cLwSi434LULu5YjuvTH5E1H1gXY=
Date: Thu, 29 Jan 2026 10:50:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>, Usama
 Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-Id: <20260129105015.0ed043764a4ad220334b7ae1@linux-foundation.org>
In-Reply-To: <20260129184054.910897-1-shakeel.butt@linux.dev>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Jan 2026 10:40:54 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> In META's fleet, we are seeing high level cgroups with zero file memcg
> stat but their descendants have non-zero file stat. This should not be
> possible. On further inspection by looking at kernel data structures
> though drgn, it was revealed that the high level cgroups have negative
> file stat which was aggregated from their children.
> 
> Another interesting point was that this specific issue start happening
> more often as we started deploying thp-always more widely which
> indicates some correlation between file memory and THPs and indeed it
> was found that file memcg stat accounting is buggy in the collapse code
> path from the start.

So this has no known runtime effect apart from incorrect accounting?

> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")

Should we cc:stable?


