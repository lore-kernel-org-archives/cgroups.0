Received: from mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44F3E49EA
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786965388; cv=none; b=HQhR34ocNMfIR4eflH1qryFFcZ28wl7vrb2CzvMALefdbIVLFTM3D4nA2lNYV9BZsyKXZMcy79rzJLgbW13moDRSsAOkVjTzmo9DZ2/0sNbrn14wV9/vqKOzEqFKF8gLGRosBzUs4SzeVcuFjF1IM3C1SrDuDi6rOumUCeHfSzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786965388; c=relaxed/simple;
	bh=loF7uxICqmGQt3wW0ry5WgjSFhP6qd7mp4uDC29Scf4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CHyJUnPo1d+Ooir0/z1J8IYezCSAKkDLVleba4Tf8/fDaNPfQ+jXE0bkDIpZYaDTuj8uNyxOTivWjtHA5Hdu9vxO+U4Wpq2HWZ6epIT3fs7rzZv+Un9IEWkPyKDZzsAzR6Xzg+CJ4CZ7DuGVLCTPAdBQ91Q1YWzhVW0ngBNLYwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qAyi6hYL; arc=none smtp.client-ip=91.218.175.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qAyi6hYL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=loF7uxICqmGQt3wW0ry5WgjSFhP6qd7mp4uDC29Scf4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786965384; v=1; x=1787570184;
 b=qAyi6hYL94Fub4gVBo8Rd1scupupswpmcpZ5pE5OaVa06KDDFft8qngsdUmYUuMjVMwmQlcu
 3P1vrfQTi+yIs9yT5pCGQeCQ3Zg1BpJG9Ks64wKYLCDu8J89jQ1zRQ7fWggDSI0p7xiaSxoSXn9
 bU/SVGChdDkL8cVtwY25evMY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from smtpclient.apple (2408:8606:1800:501::1:7)
	by mta12.migadu.com with ESMTPS id fd8ad7876ef347e7;
	Mon, 17 Aug 2026 11:16:13 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb_cgroup: call page_counter_set_max() outside
 VM_BUG_ON()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260817103433.191266-1-njilav@gmail.com>
Date: Mon, 17 Aug 2026 19:15:57 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DA59320F-B64D-4B3E-AF6C-56266362DCA8@linux.dev>
References: <20260817103433.191266-1-njilav@gmail.com>
To: Narek Jilavyan <njilav@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 17, 2026, at 18:34, Narek Jilavyan <njilav@gmail.com> wrote:
> 
> hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
> the huge page size and then applies it inside an assertion:
> 
> VM_BUG_ON(page_counter_set_max(fault, limit));
> VM_BUG_ON(page_counter_set_max(rsvd, limit));
> 
> With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
> i.e. ((void)(sizeof((__force long)(cond)))), whose operand is never
> evaluated.  page_counter_set_max() is not a predicate - it performs
> xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
> never applied and the counters keep page_counter_init()'s
> PAGE_COUNTER_MAX.
> 
> That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes
> the same rounded value and uses equality as its "unlimited" sentinel.
> PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is
> odd, so round_down() really does change it and the two sides disagree.
> With CONFIG_DEBUG_VM=n:
> 
> $ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> 9223372036854771712
> 
> and with this patch:
> 
> $ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> max
> 
> A debug option should not change cgroup output.
> 
> Call the function, then assert the result, as v6.12 did.  Use
> VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are
> identical under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not
> use BUG() variants.
> 
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Signed-off-by: Narek Jilavyan <njilav@gmail.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

