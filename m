Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D88B3FA5E6
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 02:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784599254; cv=none; b=E+wxqUfcwFY3y3TBOZqCVOtjpFokZj1XtqqsKYYmQLbGX397H03fFx5p1Kf34cecIKtn0dcm+u0NIX8JMf8OrjFGjmXJsL7BDd3zVVjw2tzCIRYI1xrL+7qzqPtgAdQwYaypENQ0Gd8z78zA5/66LhHNMC4FOI2ZaX1RSzQo0EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784599254; c=relaxed/simple;
	bh=uUHRz3rv6g++eb0Sd9SWlj9Mu+qkQRV5qu58HqYLdPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEaaVzvdpD/Kr5+b7zffcvBXdxoOJAj0mc4H6cmsBRYuJze3KRoZmGRMR4I4iZ/vPjoWNdQOGdP6x7ixzlVzj9GDPcZRRPEn9RuSmHczOuOKnAXqklLLWp3HT7dXrhWeR4KejwMnzn2WPXNi2JEbcRfuWrddPf7QHJM8UU5Mt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XcxrCj/b; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XcxrCj/b"
Message-ID: <8f3a6021-0ef0-4ecc-bbe0-0be1c3c6834d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784599249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hlysOoCIXjYG93rTZNcC0H9AwdEbo6YYMEzcZG/AOR0=;
	b=XcxrCj/bUTneGioyG2EZFHXlkOr5sWmFJtrpdY5cXlbMtg9+xzmmkP7P/4yQ4DgrZgiwol
	uqJ6unUEaSjvr9KUH3UMdFIFh5CPLJY8mAPPp6a0zklQ6HvZ8QznFjOgIfHJsDF6WcDLcj
	03e/k3nnsStroxzenosktp8ixudVCzY=
Date: Tue, 21 Jul 2026 10:00:37 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
To: Omar Sandoval <osandov@osandov.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <1784596208654455.18988.seg@mailgw.kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/7/21 03:58, Omar Sandoval 写道:
> On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
>>> In preparation for changes to the structure, abstract access to the
>>> objcg field with a slab_obj_ext_objcgp() function.
>>> Rename the field to _objcg to make an unexpected direct access a compile
>>> error.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Hm sashiko finds [1] that this is breaks tools/mm/show_page_info.py
>>
>> But I think it was already buggy. get_memcg_info() is supposed to return
>> memcg info for a page but in case of MEMCG_DATA_OBJEXTS there's no such info
>> for the whole page, there is only for individual slab objects and it doesn't
>> know which object so it effectively gets the first one. I think it should
>> just stop handling MEMCG_DATA_OBJEXTS, but that's a fix that should be sent
>> unrelated to this series.
>>
>> There's also tools/cgroup/memcg_slabinfo.py and that I think has been
>> already broken with memalloc profiling as it assuems slab.memcg_data is
>> still a raw struct obj_cgroup * and not struct slabobj_ext.
>>
>> I think it will be easier to fix it at once to handle the layout after this
>> series than trying to fix it first to handle the pre-series layout and then
>> update it with every relevant change.
>>
>> [1]
>> https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=5
> FWIW, if these scripts were in the drgn repo with test cases, these
> breakages would be caught by our CI and someone (usually me) would fix
> them up promptly :)

When I first used the drgn tool, I noticed that some scripts were directly      
merged into the kernel repository, so I merged show_page_info.py into the kernel
repository as well. Later, I found that merging into the drgn repository was    
also a good option, so I merged it into the drgn repository as well,            
and maintain it there. Therefore, I currently use show_page_info.py regularly   
and update it promptly if I find any issues.                                    

-- 
Thanks,
Ye Liu

