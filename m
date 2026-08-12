Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F8043553E
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786535105; cv=none; b=R9sIMEgu3BkKlBCx53K41zxi6GpEvpiQobWn1g5jiLs0sxqenJIxvmVGkn4EiLn1ushrQoBDypuU+IP9pKNRIhikq4Y6Xx0+E7tcAzGwRYYX02g9mkwdkvrtq2s5+/Py1QcYxrdBTZSBUarSWpYyQXyZGIEwxKO9+ka6+tQRfvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786535105; c=relaxed/simple;
	bh=OeJXuVy3ZiqMCZp1FFMcdF8rNLBZd0geSn/rRWorVVs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PvVyyo9dr5SA40D68kKzDh8rq0W+3XiQG8+sCUbh6pRnqYoHpKD/IdoXD8dRMsDrwb6434OeVAyywrEIXEg+goME6EM7kSGl1spoi1shKgdwuQFIK7HanVHLQu2brn1FErNhpeCMPQjmDLH8zcTbudgO/hcQMIhSS5/klHGqp40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Whc9hjyv; arc=none smtp.client-ip=91.218.175.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Whc9hjyv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OeJXuVy3ZiqMCZp1FFMcdF8rNLBZd0geSn/rRWorVVs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786535101; v=1; x=1787139901;
 b=Whc9hjyvjWXoDATryBpBZNIVPy098CX5Qkf6kIq24ywjwXBIAz6lEYsEC/FztPgW/18OtxaK
 cIa6Fgdr56BRwgS2OSlAoxbBvTyIX+gi57v+IOL24+yw6bx7YfkjCK1yx13m4SLjcThSLRVWFN6
 vpwr1Z4iToHvckgALPF9dbCs=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id c332a69d1f0206ed;
	Wed, 12 Aug 2026 11:45:00 +0000
Message-ID: <f83cbc30-ddc0-4c2b-a01e-4ba890df44ae@linux.dev>
Date: Wed, 12 Aug 2026 19:44:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cui.tao@linux.dev,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
 <a318c942-0776-4678-a9cd-504e713d25f5@linux.dev>
In-Reply-To: <a318c942-0776-4678-a9cd-504e713d25f5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/10/2026 10:58 AM, Ridong Chen wrote:
> 
> 
> On 8/8/2026 4:22 AM, Andrew Morton wrote:
>> On Fri,  7 Aug 2026 16:59:58 +0800 Ridong <ridong.chen@linux.dev> wrote:
>>
>>> Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
>>> c6f53ed8f213. Each open fd reads back max(its own value, the shared
>>> local_watermark), and both bugs live in that scheme.
>>
>> Thanks.
>>
>> We're missing the preferred description of the worst-case
>> userspace-visible effects of the bug.  It appears they're quite minor
>> so I'll assume this series is a post-7.2 thing.
>>
> 
> Agreed, post-7.2 is fine and neither is stable material.
> 
> Worst case for both: a reader of memory.peak (or memory.swap.peak)
> gets a value lower than the true peak, so a tool that sizes or bills a
> cgroup by peak usage under-reports it.
> 
> - Patch 1 (reader side, take peaks_lock in peak_show): a reader that
>    races an unrelated reset briefly gets the low value. Transient.
> 
> - Patch 2 (writer side, peak_write reset): a reset on one fd stores
>    the current usage into the other watchers instead of the old
>    watermark, dragging every other fd's peak down.
> 
> I'll spell this out in both changelogs in v2.
> 
>> Sashiko might have found a similar race on the writer side:
>>     https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
> 
> Yes, that's the writer side that patch 2 fixes;
> 

Hello everyone,

I would appreciate a review of this series. Should any feedback come up, I will 
update both the patch and the cover letter accordingly.

-- 
Best regards
Ridong

