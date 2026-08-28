Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2298B38DC52
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787936051; cv=none; b=YY1VPPVc/tPbX44VzMOdJz7vbPkOVhIUEpZrjpkQWrZqC/on09lYacjtw2LqtLMhfPW7CZkwwW6MODFe8ZiAqLj9g16447Qt3yTjVhYOC/2jGoLZZX5heoCy6fkNFHobqKzTdIJpwfmcGiy2PX3jD+THK0PDs+Q9+NV8Hkr1w8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787936051; c=relaxed/simple;
	bh=psJGwL1+j+jKt7s0yptB6/W3PUUi95PtS5n+HITAWyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X20MUrzWXli5LPa4TL7NTSL+61jjwGhY41cynAFA4dOf+TQYRubRmogFbWeZajelVNFX6/xc+isaSNYK22iUNDPjjlvswoSOf/HIRH+Xjmq+BaaICaISuo5sidOj6QGtO0GfH15F3wOfYls/VQa1B8A7ZBUsYHoe54Tq8DT3iq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KMWLw46O; arc=none smtp.client-ip=95.215.58.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KMWLw46O"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=psJGwL1+j+jKt7s0yptB6/W3PUUi95PtS5n+HITAWyc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787936041; v=1; x=1788540841;
 b=KMWLw46OnClM4RT7i00HJSzN7lZFpKGoDxoP9mv7bV9IjQJrEBa+KRhkvUfg/PuVFI/A9M3Y
 2jxgN9LOTBrlm1buMQwNnwQBDC4s5i5FCLuEn5sjIpL0+C8mC06z+0dJ169vZhVwY7Wz2IQS01I
 BLV1xK7o9NKK2RKgJRs2TPmQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4322b439f1cc1ba4;
	Fri, 28 Aug 2026 16:53:51 +0000
X-Mizu-Trace-ID: 4322b439f1cc1ba4
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 09:53:50 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, falemi@asu.edu, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] refill_stock -- VM_WARN_ON_ONCE(mem_cgroup_is_root()) from
 a write to the cgroup-v2 root's memory.reclaim
Message-ID: <apG8lKU0xDitsvV7@linux.dev>
References: <CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com>

On Thu, Aug 27, 2026 at 10:28:57PM -0700, Farhad Alemi wrote:
> Hello,
> 
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
> 
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/145-memcg-vm_warn-refill_stock-root-cgroup/
> 
>   mem_cgroup_is_root(memcg)
>   WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940, CPU#1: repro/9490
>   Call Trace:
>    refill_stock+0x644/0x940
>    try_charge_memcg+0x12d6/0x1570
>    __obj_cgroup_charge+0x35/0xf0
>    obj_cgroup_charge+0x1de/0x210
>    obj_cgroup_charge_zswap+0x83/0x270
>    zswap_store+0x1620/0x2000
>    swap_writeout+0x94c/0x14c0
>    shrink_folio_list+0x3388/0x52b0
>    evict_folios+0x374d/0x48c0
>    try_to_shrink_lruvec+0xe72/0x1350
>    shrink_node+0x3320/0x3b90
>    do_try_to_free_pages+0x6a2/0x1990
>    try_to_free_mem_cgroup_pages+0x30d/0x830
>    user_proactive_reclaim+0x504/0x840
>    memory_reclaim+0x1f/0x30
>    cgroup_file_write+0x331/0x8f0
>    kernfs_fop_write_iter+0x3af/0x540
> 
> Our reproducer.c is available upon request.
> 
> Happy to test a patch if that would help.

Thanks for the report. Please test the following patch. I will send formal patch
after your testing.


diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a18ee4509ab..1709ac96bbde 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3157,7 +3157,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 

