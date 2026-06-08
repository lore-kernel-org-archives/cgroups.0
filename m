Received: from lankhorst.se (unknown [141.105.120.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35273D3314;
	Mon,  8 Jun 2026 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.105.120.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780933352; cv=none; b=D5RMBbqU1isD02DY4tqoKVohg6zMx7HWu2JdBUffCOdbSAL/wbitJL4MwACB/0HWAO0A2JOw4r10x0k9IkAn+XCItxzTXbVzN4J0XCnk3z5XOCYytO5Lt83bL0Lw4FX+7enTw03AOYfKZjbWpNZakc6vRP/5+Iqzl3qAB7pKn3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780933352; c=relaxed/simple;
	bh=yEOieKCXcv06vNuoNgdqY2ql2LhHpG4SOd+tbelcK1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rrBGNuUktUSxXG2bxEcvFv7Lrzn4ei7g/kXH1EPqOIEcGbiu1vQ1WOyt+ogORUSGeGpkb5xYRDth3mrw0WgTeYCH0lkKLRikYcvkG1XdzhhYK9a59YozJgN75eMGZy4mLJ6jPjsV+gIhkd9a9+DpMntAMn5S3/Xjr9OhEWrPUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se; spf=pass smtp.mailfrom=lankhorst.se; dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b=jjHbK9Wq; arc=none smtp.client-ip=141.105.120.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lankhorst.se header.i=@lankhorst.se header.b="jjHbK9Wq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1780933348;
	bh=yEOieKCXcv06vNuoNgdqY2ql2LhHpG4SOd+tbelcK1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jjHbK9Wq/UkjdyR1CPaGt2LbGlVFCF1AgS2o1b7hzDnvpIXccZ3FDt6M7iVOR2SWG
	 VS7gh5ghgEwKy8gFBjxDdWe6sp/rT58mHtC0Kd1CC4hUWCz5GlA27uvAgGUUge/krg
	 BbZ8mn7BClVCsTeY14u8Tf9aY+jCQV1Aola4mNDjmV6Gc9aMd/kJE+G+3q8JeUxI0v
	 VT5usdK0TNIRkVCXJeK5SmQ/d9IDdxrI9OykiKVzdUR93rlNnCOMWwuEhuFbMdYKwV
	 +SPrFTcyX3bU6z7NIQoDDBo6SNEBPQvWQfHQTgNpxc7TPi+7j703Sw2nUzVceVDS/7
	 l7+IaHMInx2YA==
Message-ID: <c0dd1298-17be-44ba-8866-c8602aaa69c6@lankhorst.se>
Date: Mon, 8 Jun 2026 17:42:34 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/dmem: accept only one region per limit write
To: Maxime Ripard <mripard@kernel.org>
Cc: Natalie Vock <natalie.vock@gmx.de>, Eric Chanudet <echanude@redhat.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Albert Esteve <aesteve@redhat.com>
References: <20260605-cgroup-dmem-write-single-region-v1-1-9137f296579c@redhat.com>
 <271b1c16-3c3c-4a1e-b09e-c4361c63814c@gmx.de>
 <f00e7771-cd70-4c86-9fac-149897e02b12@lankhorst.se>
 <20260608-glorious-fluorescent-salamander-93daec@houat>
 <15bab7c9-0857-40b9-963b-9923c0e7392c@lankhorst.se>
 <20260608-rational-cuscus-of-enhancement-eecbfa@houat>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <20260608-rational-cuscus-of-enhancement-eecbfa@houat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 6/8/26 16:04, Maxime Ripard wrote:
> On Mon, Jun 08, 2026 at 03:13:56PM +0200, Maarten Lankhorst wrote:
>> Hey,
>>
>> On 6/8/26 14:42, Maxime Ripard wrote:
>>> On Sat, Jun 06, 2026 at 11:44:10PM +0200, Maarten Lankhorst wrote:
>>>> Hey,
>>>>
>>>> On 6/6/26 18:31, Natalie Vock wrote:
>>>>> On 6/6/26 00:44, Eric Chanudet wrote:
>>>>>> Accept only one "region value" pair entry for the dmem.max, dmem.min,
>>>>>> dmem.low files.>
>>>>>> This changes the UAPI that otherwise accepted multiple lines for setting
>>>>>> multiple entries in one write. No existing user is known to rely on
>>>>>> writing multiple regions in a single write.
>>>>>
>>>>> Ugh, shoot.
>>>>>
>>>>> For dmem.low specifically, there already are some userspace thingies floating around that may write more than one region/value pairs.
>>>>>
>>>>> These thingies all depend on that one patchset for dmemcg protection that I should really get around to merging[1]. Since the userspace utilities depend on not-yet-merged patches, they sort of have to expect stuff changing under their belts, so I wouldn't really consider those users a blocker by necessity.
>>>>>
>>>>> As I see it, we could go down one of two paths:
>>>>> 1. We go ahead with the patch as proposed, and I make sure that the users I know of adapt. Could be a bit icky wrt. "do not break userspace" rules, but since the already use non-merged UAPIs in one place, you can argue that these users kind of have to expect breakage.
>>>>> 2. We use the old handling allowing multiple lines for dmem.min and dmem.low only. This preserves compatibility but uglifies the code by quite a bit.
>>>>>
>>>>> All things considered, I think I personally would prefer going with 1. and taking the patch as proposed and just having one codepath handling every limit file. Just highlighting this so we don't do it on accident.
>>>>>
>>>>> [1] https://patchwork.freedesktop.org/series/163183/
>>>>>
>>>>
>>>> I prefer option 1 as well, but would like an ack from one of the core cgroup maintainers too,
>>>> and what Maxime's opinion on this as well.
>>>
>>> Option 1 works for me too if doable
>>>
>>> Maxime
>>
>>
>> I see this as an acked-by?
>>
>> I'll commit this patch to drm-misc-next if so.
>>
>> Fortunately it may not even break those scripts in the typical case
>> where only 1 region is registered, eg the most common laptop/desktop
>> case.
> 
> Natalie had a bunch of comments afaik, so I was expecting a v2, but if
> you intend to merge it as is, you can add it if you want.

Yeah forgot about that for a second, will wait for v2!

Kind regards,
~Maarten Lankhorst
