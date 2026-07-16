Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998D8431E67;
	Thu, 16 Jul 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213029; cv=none; b=o1P51w3PX2EFCysedJYXsEgd3BMauwQdyEiaOmE/CgekVdHWat6R0dZSi8fkVJKLwB8RlvPqpejVabvehrVnqZCIC2wLtOCak7PrHybeRlvPXYvSfFBgItquIFnBk4ue+JsPJGu6lsW9UeE/HoWJE99/AZf8n7bRjRFmQZ3Uhic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213029; c=relaxed/simple;
	bh=mTe8D8nzgtbigkSBp1hbXfnITsUxOIHKOJYVryZbmRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCtF6pqYUkbX+kWRKlPSTZ15mvypY6ofX5mmTXxO0pvvbGP5ov9J6TSDPQuSX47a4R6fJIBNKLBRNFdnqS5RvfXmNccTt4L6J6PuWAmpd1emtD7RBgt5vnBuaT7Y5UdVvVV3/cWrJF/7BsB8wFX+X3vNQ9fGWp7uovrZqPDLJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJauAJak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJauAJak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C0C1F000E9;
	Thu, 16 Jul 2026 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213020;
	bh=mU+AkHG+unovjoou+Gc++cD5SyJh4xwusPC7zchS0m8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FJauAJakhRvLtd584lr/GAriHLfmUjBqPUdRIv4YrgWA5IhTqvb2tRcX1o3i24R+g
	 2broTkPr1VeFpwXQXpsesKck8xUKjn83EjzPBr+yqgR86w4zBP2aCYT00Cyd2D2cix
	 MPeXf+WXorOO0Rj40ZtpBDXH2RA/12A1xbXD7FbhFEUpMG5hgiCDiPukBTEedWe6UH
	 9hPL/878X3Rs4xlvQjToaIItSVqWLW2hOQ6RBfrZ3UtIibFGKvR8bhvbGRZyEKSLnU
	 u9w+91zOogOw1vMlsvBhVj2vSKayZKuflTHagKlETCzG+3EdoJU4Mn4mixnFkK5pPV
	 lqcN8AinTwW6g==
Message-ID: <01aa6803-e6a7-4172-94ef-043914e2f794@kernel.org>
Date: Thu, 16 Jul 2026 16:43:36 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/12] mm/slab: change struct slabobj_ext to a union
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-8-9a49c4ccf4c3@kernel.org>
 <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/16/26 06:11, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:11 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> No functional change intended, the layout is still effectively static.
>>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> This is much cleaner than what I was preparing. Nicely done!
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>> ---
>>  mm/slab.h | 41 +++++++++++++++++++++++++++++++++--------
>>  mm/slub.c | 17 +++++++++--------
>>  2 files changed, 42 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 3ad9777ad600..359ab8caf61e 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -554,14 +554,34 @@ static inline bool need_kmalloc_no_objext(void)
>>   * if MEMCG_DATA_OBJEXTS is set.
>>   */
>>  struct slabobj_ext {
> 
> Perhaps we should add a comment here stating that every element of
> this union should be pointer-sized?
> 

OK, how about this?

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -550,10 +550,14 @@ static inline bool need_kmalloc_no_objext(void)
 }
 
 /*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
+ * Extended information for slab objects stored as a pointer to an array in
+ * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
  */
 struct slabobj_ext {
+       /*
+        * All elements of the union should be pointer-sized to avoid memory
+        * waste
+        */
        union {
 #ifdef CONFIG_MEMCG
                struct obj_cgroup *_objcg;

