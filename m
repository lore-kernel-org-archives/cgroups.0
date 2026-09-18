Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A183845B0
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 10:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789726997; cv=none; b=QSc9ujnQaBVwruq8yDi8AQWzHDq2lI4iydrm9d6hrX7vo+jQ1EY5co/nQO6+nSHFHQJ1MdWThOo1Npa/I2wGXlGyCJfUDGBm1HAMDfksx/v9LU+lyi1kMEMALuOJXqWoy9fJy7jAI+tTLHdDRHaIvhyyjxIqNFA58YpxYn2Daj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789726997; c=relaxed/simple;
	bh=yrF6fA5tlOM0xGyL9ZU1WnjTazhuz2mrZ9NL1QXtunU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UZ79Pd4bOT1CAS986A+gzRHLaCMcnmQxrRoGnT7HAdjMh4GiumwYDgJjkGkcDmKw5PY6P3PB8NnjqOwqfB5bo6qOrnnj7s4o7RnkDc1O6iAMnN/xQRjDfI5QH6fbPMaEMSM2PPzk8a9a3MVTTFc56GECl/LT+QD9L7Dk6Z1ak04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aDfl18Hs; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aDfl18Hs"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yrF6fA5tlOM0xGyL9ZU1WnjTazhuz2mrZ9NL1QXtunU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789726990; v=1; x=1790331790;
 b=aDfl18HsfTBQ93648RB7nEKs5U6qqQTYncRFV75/11TDqHlHrZnEuqRdsr9AzQLDvZwHbxyb
 dY8NK6TrPj4WyM7g+mjo6blcs9TDmH4cmTiKT3DWFrA6R1BnFYEHYxI1eMI41Sil3zGiK/wYeYt
 9Yn00dMxZUk12PVTqH3UrTaE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 60349c2ffaecec43;
	Fri, 18 Sep 2026 10:23:00 +0000
X-Mizu-Trace-ID: 60349c2ffaecec43
X-Migadu-Flow: FLOW_OUT
Message-ID: <ada49654-0456-4b63-9f86-06ea9c97667d@linux.dev>
Date: Fri, 18 Sep 2026 18:22:57 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
To: Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev> <aq0HNe5s3zvOnM_I@tiehlicka>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aq0HNe5s3zvOnM_I@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shakeel, Michal,

在 2026/9/18 17:41, Michal Hocko 写道:
> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> The legacy cgroup v1 memory controller has already been moved out of
>>> the shared implementation at the file level (mm/memcontrol-v1.c) and at
>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>> per-cgroup state, however, still sits as individual members inside
>>> struct mem_cgroup, guarded by #ifdefs.
>>>
>>> This series isolates the deprecated implementation from the shared hot
>>> structure: all v1-only members are grouped into a dedicated
>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>
>>> With this in place the v1 implementation is self-contained: its
>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
>>> its eventual removal becomes a localized deletion of this struct
>>> together with mm/memcontrol-v1.c, instead of unwinding
>>> ifdef-scattered members across the shared header.
>>
>> Sorry I don't see any benefit of this code churn. The code is already behind
>> config. What exactly this code churn is giving us?
> 
> The only arguable upside is that this would make it ever so slightly
> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
> I am not convinced this is sufficient to justify the churn either.

Thanks for taking a look.

You are right that the file and Kconfig layers already isolate the v1
implementation at build time, and =n builds get nothing from this
series. The benefit is only for =y builds.

In a =y build today, the deprecated controller's state is still
embedded directly in struct mem_cgroup and common code accesses it
directly. This series moves that state behind a single
struct mem_cgroup_v1, complementing the existing file- and
Kconfig-level separation at the data structure level. The layout is
unchanged, so there is no runtime cost.

My intention was to explore whether this could serve as a general
pattern for isolating the remaining cgroup v1-only state, rather than
as a standalone memcg cleanup. I should have made that context clearer
in the cover letter.

If that isn't sufficient to justify the churn, I understand.

Thanks,
Tao

