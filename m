Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4462749E6
	for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 21:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770931240; cv=none; b=Ci3SIs1o5YC5EAozjPhD1UoQovio8YUCk0wwOxqz86m8D1oulMONzep6cHKxt4crmk6jWMeS0Ab9SQ5erhDKTopu/02uMjvvjzm7pToeUbFaDnQ6tlZpaby7Hqbt0WY+JnlMwK84y2QyIe11AgKlfMAnV/ToQqJJuA9S4mw/Xg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770931240; c=relaxed/simple;
	bh=hhvIY42ZejyjgeuhGD0cdgJZcMf17AiRbGuBQYVvt5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IT2ZJ4CjKmxcerf47xMnpv5H/XJ8bay/LRBWKpj6evSdGWjMtnxZGHACawkOJ5ickyH2rNEpeu49tIAppfjwaWBwpffg74HiIPKt3bUQQ9awRNrH2aVx1myqUHvmDIF9Z67jyJr0Q4BXIHWk3IvSolZpjUT9Y3w2Z0hECET2oOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWN4s6ty; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWN4s6ty"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b785801c93so684943eec.0
        for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 13:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931239; x=1771536039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m+vxOwDndj4zObe1CvOSxWnI7S8T1aXhKqAzJ6Mv/p0=;
        b=AWN4s6tyMV26gdB3lghhD+8s1mOFl6+J5Erodyw1OqX5hm8Zf+oe5YRkEg9rnwzcoX
         zroAxqKCu6u37LPXlYhskwSCNs48rH0qtwpR1Coz6g6/wQ438KcR0gVGap1PoBUNHJjg
         O++d8Cw+NXiL4Kxe43KJ7elX9CXKKSfNYpOR9qtb8CR3y9llWdl7uJyUMW9ksDOUtxmp
         NsLLXRKz8yDvaOxBBDd1g6XlxST0x82sSCdPKUq3wIrB6+YqFlt+4pkbK+w+3BKvqZ1o
         FBYc1sGYxK7L+abQak2XDESLEthKI7JQoHnCPJ76TaA9vAkMXW4CGeto0fVp541My+8P
         puXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931239; x=1771536039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+vxOwDndj4zObe1CvOSxWnI7S8T1aXhKqAzJ6Mv/p0=;
        b=jOzSGaZg/WqmdxUwoiwVvD0iJbVA+npjkoRzLXp67XF6GKuSlCsT9AdCcphTCNH++h
         UjiYzQ6i7MGMis9nPbKkdVVDgQGOlrvfHi95WbqLCXqS8u9qQx6IwWPumtmS3kcam9uE
         rRcylcvB4WT/SK+35edODx3DIlD29ew7ZCf2v2IVOieu0te7DtmoGHK3r6qW+zZ8IUC1
         yKnz7+HeOJa6o4g1q1fVIHGceHa8l/jqfOlEZj3GpHSdRHvpQ47b7t3qnTUc3erstAOD
         8aIYA5Eh11bjTaK2xgczXxHTPV0PGIWhDOu7rBSDciRvapWPSTVeBZBMonzmJI4ZNVbK
         W0lA==
X-Forwarded-Encrypted: i=1; AJvYcCVF5XithzUwNG+sAYnZ0i5RoWtCll9nWWSFf+k7WDjGNUYpBJbsu3b2ac1sMa7B3aGtIYeH5A2Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyxoKC+BS+CtjgCB5ZAWblt4bm46qHIyKJB+nytcWW3GHYNpNsy
	kPS/SzJMZOiTeAMO5HicRzon70XUmYPL6n0er37fPpRowYatQQEZNHDJ
X-Gm-Gg: AZuq6aLS233x5ocYpNBK8TVhKaYpliXhNrUJ7HvNRJSHBlWjRwFFwQxH45lFKXuVNOF
	JyY/yFIc9xLld/A+EbV2yEMEVKxSxXrkqaUDO8+yzqFgAtKJHS9WxDA10gLgoOSo+qrbDyfNOA1
	tOP9vrPm8BZPIZdBWCkaU2PmnKYjXpSU7hv71YdQGO4mkx78GgYiSLa1egQcXJrNX71V4N15ACO
	q94m46sI+X6I8ruIYOtlPQgPObTQA1TAt+/9NAaPJ4u+4GJIchfpoHKedji3ZuJDHHgg8qOMh2c
	W3drmAjqzElFw81ie8U0rDEXPFCJYzGMb7/x2QfbpLgUbLVOmGcTaA587mffHF27NZiEiUnf8ed
	PVBieLNXS4nONNNbrUdS4Cyit1EaEFkmx4igduO919LnaZu6fISe2iguCzUKXuZKJrCqJYRLNqO
	zJIbGhfo7CXlLwO5BncpS6SIdE3st6TjS/Xgq5LCabo54=
X-Received: by 2002:a05:7022:250f:b0:11b:9386:a3bf with SMTP id a92af1059eb24-1273985be5cmr198075c88.42.1770931238369;
        Thu, 12 Feb 2026 13:20:38 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a6942ccsm6165153c88.3.2026.02.12.13.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:20:38 -0800 (PST)
Message-ID: <ba761a76-78e1-4215-a95c-290f9ca8cb55@gmail.com>
Date: Thu, 12 Feb 2026 13:20:35 -0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: move pgscan and pgsteal to node stats
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-3-inwardvessel@gmail.com> <aY2BVsYlPa4QMbUC@tiehlicka>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <aY2BVsYlPa4QMbUC@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/26 11:29 PM, Michal Hocko wrote:
> On Wed 11-02-26 20:51:09, JP Kobryn wrote:
>> It would be useful to narrow down reclaim to specific nodes.
>>
>> Provide per-node reclaim visibility by changing the pgscan and pgsteal
>> stats from global vm_event_item's to node_stat_item's. Note this change has
>> the side effect of now tracking these stats on a per-memcg basis.
> 
> The changelog could have been more clear about the actual changes as
> this is not overly clear for untrained eyes. The most important parts
> are that /proc/vmstat will preserve reclaim stats with slightly
> different counters ordering (shouldn't break userspace much^W), per-node
> stats will be now newly displayed in /proc/zoneinfo - this is presumably
> the primary motivation to have a better insight of per-node reclaim
> activity, and memcg stats will now show their share of the global memory
> reclaim.
> 
> Have I missed anything?

That's accurate. Plus aside from reading /proc/zoneinfo they will also
be in /sys/devices/system/node/nodeN/vmstat. I see I could have been
more explicit about this. Let me make additions to the changelog in v2.
Thanks for taking a look.
