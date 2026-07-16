Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E263385AC
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 02:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784168962; cv=none; b=PLX3pI2l9yoKqWTGOnyaooU2Zfw3Te6RWpe2ilOeoBtCDX7P+BdPD/AtCn1i0AYGxG26UC1Wyxje/XaKJlarfyQ71kbUGh/R9yK5gGdxrAkwaE9VWjHT0XK/QXq6WPfcNRVqCsSBlJ3A6oUEy8L5t06lH9bILSm5eoDeoWJbm5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784168962; c=relaxed/simple;
	bh=U9Ofjux6FJ9zH8u7QJ/APU6XBkSG+fKa3Qqz1de3js4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MzNCUQ34iaZSVLAAI6qVmcIiafChaEjisKVsHFAR9Wn4vR14S03XI/ic0XHi068jBkCBUIPqlONwtbkI9IkzInIlIjNi/Fdzsqfz6IvF9pJXpE4WCNplbhbF3jGIIqy3drMni38byLxPWCQwYR8jzq1c4uoUMhUjE2OGBiNtG0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rdhgnoOF; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rdhgnoOF"
Message-ID: <c01c77ed-9ce2-43e6-8ab8-dc2a8fb43b4b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784168956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ahnMBpv0EUvokoPv1D+yV8tvyG49SF0lRDVbaeWeWVs=;
	b=rdhgnoOFQ2JyOJedrMszmsV7Mi67qyVefKSeNc3lWKTFc7BzvHcnYtOXXripbmfmKojmrs
	GJUtvcy7tx5/ao03jBE38WEBH9y2TKUAOfObVKwOJjxDI1yrdAf1acx6LQ3rkQcGARhDmI
	N6wEFt9JzW3qSVST6xCRXxHEvI+EdsU=
Date: Thu, 16 Jul 2026 10:29:02 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
To: "T.J. Mercier" <tjmercier@google.com>,
 Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, weixugc@google.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 willy@infradead.org, denghaojie@honor.com, baoquan.he@linux.dev,
 kaleshsingh@google.com, tao.wangtao@honor.com, zhangji1@honor.com,
 wangzhen5@honor.com
References: <20260714121529.2237261-1-wangzicheng@honor.com>
 <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 7/16/2026 1:55 AM, T.J. Mercier wrote:
> On Tue, Jul 14, 2026 at 5:15 AM Zicheng Wang <wangzicheng@honor.com> wrote:
>> The benefit is workload-dependent: file-cache-bound servers gain from
>> aging, anon-bound servers do not, so no kernel default is correct for
>> all.  The kernel also cannot know when to age: on Android the right
>> moment is the foreground-to-background transition, when the app's pages
>> are cold but their PTE accessed bits are still accurate from foreground
>> execution, a framework concept.
> 
> When an app transitions and becomes cached, we attempt to reclaim its
> entire workingset. We basically cat memory.current > memory.reclaim
> and freeze the cgroup.
> https://cs.android.com/android/platform/superproject/+/android-latest-release:system/core/libprocessgroup/task_profiles.cpp;drc=65bd7ab941a709bf049871406981022b988e1721;l=706
> 
> File / anon balance vs hotness and generational placement doesn't
> matter in that scenario because we want to get rid of all of it. So I
> don't really understand how you'd want to use an aging knob.
> 

When the app becomes the foreground app again, reclaiming all of its 
background memcg memory may increase refault data, which may in turn 
slow down warm-launch performance.

-- 
Best regards
Ridong

