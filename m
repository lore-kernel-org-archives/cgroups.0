Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793338838;
	b=Z4v4edYFViZZeFmzLLlEovDPUZvzBqaheqg6FJFJROcPVLxk66B42LCmcLNQultJcHoU
	 bYKr3l9n/FNJz/XvMs1SN3zfjSJOt1OnohPLgw99aPpP+H3npNMiSmwnImndDAG1rktFj
	 26lPfohGbaBLBiNM9NwjDLXguTh/G7j/g1otYlb50vU61wo2zDabJRBJTXbBTgAdIzgWF
	 naOHTooMH7N4U1D16AiJoHt9KuhNn93Yxn3uF9f9yYbks9QSqOkbiQ56ieUwQgBUhTGq4
	 gGQ7P+HLegcuVY3XmgrvlTLWZDJg1gpvFAYMoq4x+F/t/L1VE1YNNLqOFljjiTDirWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793338838;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CdWUt+AQIcUlWqOchiPx3xLQXUT8mVi20ovrVe6TqxY=;
	b=YUcAydOlUb+CVxku5NSRGO7NNDFRXdOKwdOOWolWWv1ONIiCuc0ZdIEZ9ka9EZd3QQCj
	 gMqC9LldQNSPIBuANCvlCdqFuqOEAQyzuAUlSpaDd1kw6ofKz2BL+5MRkheXXcqx0fsx2
	 or2r2YiBtaGoGSE3dHG4w1eyA/qhNQDmdpD3K8CTgM97yhpQIXxPoLyiWgDdUWrYcXUxv
	 y8sHN3goconwy/Rfcqrlyf1osM5k5+saa0f/Cy2f9/B45lIzWtM1GufWf/KwVVAm2hjC8
	 r4HbWw4yIS76ji85AM3iKjP0lcZEQ5IkqUy52jak4H4hJGdQTbXCDLyA2G/fYtcW+GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=izesOQcJ;
	arc=none smtp.remote-ip=95.215.58.124
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEFF606A31A
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 05:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FEFF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=izesOQcJ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Fp9j4vIf/d5KUh3gOQVHtCSAX3O/PbmV7P4bWJC36bU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793338835; v=1; x=1793943635;
 b=izesOQcJM5E9h+R5MSvYiurMQRyYhpA5Yw54y4gXe71PcPWxt+pobP7pmWLbuSv7crpyjZvb
 gmsfZBdiWOgHcTLDhs5pdI1aaNzbPDFsT59DzTsd3CZMwfx5nkT5vnJd9Gz8v/gwKfrANhixSro
 +nxd1ZVhT70aqZwW51TjTAgo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 04770debc8262b1a;
	Fri, 30 Oct 2026 05:40:23 +0000
X-Mizu-Trace-ID: 04770debc8262b1a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
Date: Fri, 30 Oct 2026 13:40:14 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev> <aq0HNe5s3zvOnM_I@tiehlicka>
 <aq1lqJdVZ1stTKCn@cmpxchg.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aq1lqJdVZ1stTKCn@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Johannes, Shakeel, Michal,

在 2026/9/19 00:24, Johannes Weiner 写道:
> On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
>> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>>> From: Tao Cui <cuitao@kylinos.cn>
>>>>
>>>> The legacy cgroup v1 memory controller has already been moved out of
>>>> the shared implementation at the file level (mm/memcontrol-v1.c) and at
>>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>>> per-cgroup state, however, still sits as individual members inside
>>>> struct mem_cgroup, guarded by #ifdefs.
>>>>
>>>> This series isolates the deprecated implementation from the shared hot
>>>> structure: all v1-only members are grouped into a dedicated
>>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>>
>>>> With this in place the v1 implementation is self-contained: its
>>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
>>>> its eventual removal becomes a localized deletion of this struct
>>>> together with mm/memcontrol-v1.c, instead of unwinding
>>>> ifdef-scattered members across the shared header.
>>>
>>> Sorry I don't see any benefit of this code churn. The code is already behind
>>> config. What exactly this code churn is giving us?
>>
>> The only arguable upside is that this would make it ever so slightly
>> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
> 
> I had the same thought. It's kiiind of nice to see which members are
> completely specific to memcg1.
> 
>> I am not convinced this is sufficient to justify the churn either.
> 
> IMO it helps that it's mostly in memcontrol-v1.c where the chances of
> interfering with other work are pretty slim.
> 
> The patch 1 + patch 2 split is a bit bothersome: indenting everything
> into a union, only to then move it out in the next patch.
> 
> Tao, if you folded these two patches to make it one clean extraction
> and changed over the sites at the same time, I would probably lean
> supportive on this.

Sorry for the late reply.

Thanks for the feedback.  Looking back, I think Johannes' point about
the patch split is fair.  I split the first two patches to keep the
initial step semantically neutral, but it also made the series look
like churn for the sake of churn.

I'll fold the first two patches into a single extraction in the next
revision.  That should present the change more directly and hopefully
make it easier to judge whether the resulting boundary is worthwhile.

Thanks,
Tao


