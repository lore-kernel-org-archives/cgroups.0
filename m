Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFC631355D
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 02:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786330724; cv=none; b=PFTGHtB5MuNcmxs46yAoROcsXJ3iMO2S97Tk6sFs9wpCQsPswVPA+vAJj4wC0ekAaJ1o5eTZKF3fPVsTxSEV1FIlruYIphJBibHEtaTePyge+iWQYRmccYjCPnItRaycknPb94s1YCLGHryJFgvNA8L5f7bEL79YnwxhNvNI4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786330724; c=relaxed/simple;
	bh=fLbFNKQqVjzAv7A+qACZCj+ArQCHtzn58jrOki8wUN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l413j8lbTNyweMR+jEFyvk10PkIlMTIlA4ALb2LCKG/0Nu5EsLwtJvp67Dy7SlpzwyIC6Ukl1ZlbDZ/JqTg58dQlAYLuBdbB39V9mFgGGIWkMCu9fgnE57TxNLLnq9d7KSI7fQOn9jzhT96WRgBxpYlpy2F/pl1sHGwcaNg4OYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B9mm7QNK; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B9mm7QNK"
Message-ID: <a318c942-0776-4678-a9cd-504e713d25f5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786330720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXCqoFJf3vzt1oImCMxR6zmmit+AxyUiAUJr9XJhOUs=;
	b=B9mm7QNK+NF8m3aikMjvabUf1QLFVjL+JiUZe7E5cZsfAzNPm2RoIgKOzfwhVFGJrK951b
	DF7hseUMQVA+MQEfEepP/3pN9a5HrdRkoJ74CxmW/dqGcL+HN0TzhmAzHb3YgIPtnjZGNq
	MCVx4jiKDFGhtbmUZkeYcEVVDYEM/8k=
Date: Mon, 10 Aug 2026 10:58:31 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/8/2026 4:22 AM, Andrew Morton wrote:
> On Fri,  7 Aug 2026 16:59:58 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
>> c6f53ed8f213. Each open fd reads back max(its own value, the shared
>> local_watermark), and both bugs live in that scheme.
> 
> Thanks.
> 
> We're missing the preferred description of the worst-case
> userspace-visible effects of the bug.  It appears they're quite minor
> so I'll assume this series is a post-7.2 thing.
> 

Agreed, post-7.2 is fine and neither is stable material.

Worst case for both: a reader of memory.peak (or memory.swap.peak)
gets a value lower than the true peak, so a tool that sizes or bills a
cgroup by peak usage under-reports it.

- Patch 1 (reader side, take peaks_lock in peak_show): a reader that
   races an unrelated reset briefly gets the low value. Transient.

- Patch 2 (writer side, peak_write reset): a reset on one fd stores
   the current usage into the other watchers instead of the old
   watermark, dragging every other fd's peak down.

I'll spell this out in both changelogs in v2.

> Sashiko might have found a similar race on the writer side:
> 	https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev

Yes, that's the writer side that patch 2 fixes;

-- 
Best regards
Ridong

