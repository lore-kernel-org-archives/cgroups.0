Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E13C27FB2A;
	Wed, 22 Jul 2026 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681757; cv=none; b=Ws2jKya4vOAT2Ugz+msHqUHQS2rz3Ltqi0y/jDCdzLS05L3zPGRBnQmabHKAVIMeTgwKBi2DeWWHlXvahO7r21amGV8U172OeHd8dR1jAdtPxdGSgLfoUYt92FE9Ng3tUwR+sv5kH9R4F+lJ8/ypaiFddiUvVU1yJ9CY4ecL84s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681757; c=relaxed/simple;
	bh=Rva2ORXpLsMvFlm4EI5twwolCZ+rBoFhZqgG9kuK82Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VO5cB64MNBe+MVOG23SpOCqQAE2GtDzjGRpZWgz65yHJ6ABGBS7okQRBSio2/n/YGjvc3rJwjEx+VBG+11NKmbFnZ0JIq0Wop/adOxM5vlkBr2JjiLlPDAXhladbR/4PTQXSKY1ltOvrA7ffHj1Dj1eHuGf6/2jUSt0zt4J1s7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FuAAY/yo; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FuAAY/yo"
Message-ID: <1d596a2a-f930-449a-b8e8-4349d95578e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784681752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DRZCQburw7HgkreYBNUaHDCQ/ve0PWnL6l7wpHhXWFE=;
	b=FuAAY/yoInt8FpHJSquoeDZ9NamAcZJ9YBXv6ftCfMNzSK5KJCEE0BLqmx4Jy9HyzKoqDQ
	EzjpoKhahJcykPC1KM/nyCjngSwOjK3aTAqoivUbXjWPgHIRdY3S15bZ6eZ/wILM3dM3nt
	fPmFob1DXt3NO+fHZQNKe7ncV6sb9TU=
Date: Wed, 22 Jul 2026 08:55:37 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Omar Sandoval <osandov@osandov.com>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Stephen Brennan <stephen.s.brennan@oracle.com>, SeongJae Park <sj@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
 <1784596208654455.18988.seg@mailgw.kylinos.cn>
 <8f3a6021-0ef0-4ecc-bbe0-0be1c3c6834d@linux.dev>
 <e72f54ee-2ab6-462c-a9b4-4e05c3e85266@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <e72f54ee-2ab6-462c-a9b4-4e05c3e85266@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/21 21:20, Vlastimil Babka (SUSE) 写道:
> On 7/21/26 04:00, Ye Liu wrote:
>>
>> 在 2026/7/21 03:58, Omar Sandoval 写道:
>>> On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
>>>> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
>>> FWIW, if these scripts were in the drgn repo with test cases, these
>>> breakages would be caught by our CI and someone (usually me) would fix
>>> them up promptly :)
>>
>> When I first used the drgn tool, I noticed that some scripts were directly      
>> merged into the kernel repository, so I merged show_page_info.py into the kernel
>> repository as well. Later, I found that merging into the drgn repository was    
>> also a good option, so I merged it into the drgn repository as well,            
>> and maintain it there. Therefore, I currently use show_page_info.py regularly   
>> and update it promptly if I find any issues.                                    
> 
> Seems we could remove the in-kernel version then? Besides better regression
> testing, I'd assume the scripts in drgn repository can also handle ranges of
> kernel versions and not the single one as of the given kernel commit (and
> often not really due to undiscovered breakages) which IMHO is much for
> useful for using these scripts and tools.
> 
There are many drgn-based tools in the kernel repository. Should they all be removed?   
Or should existing scripts be retained? Should new drgn scripts not be merged           
into the kernel repository in the future, but instead directly merged into the          
drgn repository? I think Omar Sandoval would be very willing to accept new drgn scripts.


-- 
Thanks,
Ye Liu

