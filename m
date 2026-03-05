Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B211A6826
	for <cgroups@vger.kernel.org>; Thu,  5 Mar 2026 02:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772679132; cv=none; b=IV9if3zVqwta0VDeU4Dhlc67aaTjo17zZBr19BdO5Ycizlk8EkbyYxpJbVXd21hxAjZgcU3C3WYhORJbyJcNQfGmYGcQNWxy+UdmO/oSw6pUFA3Eih+OQxmmfJxoYmkJJ522NmP67dvV4u1SMIeo28o2WBcxnIfWVt7ZXDB7jGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772679132; c=relaxed/simple;
	bh=zx8TZn5R8eN/JcY0V2SLtTmYxjI4NqUJDrvWx1KKmLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljmbkWXRGztU8kUustD6HkJyaTUTh/qH9ATQAH35nP/4mGpFFkTfsouCWXAZU97ggRniJ5RDhbF1wYE8lZhgp7G4L1dK2kNMDAkurdXN1ds5KUt/FKSLeRLBMK3WJlhn+TjKbx1YvAr9twfmijfogBdsQjDNfIlKMI5KZAK5auI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gOPPgYw8; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gOPPgYw8"
Message-ID: <b7967290-3bb3-4ddd-ad9a-3bec79fb600b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772679128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSkchyqFNiFC8SjS3pBBe3FbQopPcRvirL1AZrVMU+U=;
	b=gOPPgYw84e15Pxl/7OLaZTWOrf1z/5qPnq28NF4nusBn+/l+49QgLJmFgtqU+RJDtBMUhF
	jt0dUNxuMMCtdqBXreF1p+E63wfJgnSeToSnqx8M97cqzpXhe379VJXMZ88d0LVUCar44Q
	XkjmYteq64u6G42+bVGg5KzCicYkJso=
Date: Thu, 5 Mar 2026 10:51:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
 <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
 <46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
 <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
 <vfmyb3pp2gatdrqa2uimw44pxioreo7zc373zn7buvdfzhejew@ndhaa4yl3bvh>
 <20260304140307.f51a33f77f6ddc1dfc0cf476@linux-foundation.org>
 <CAO9r8zP9VseSaEO6to9rcRW_TZ6E6Qk4ZQgj49g9bQOAdjgQvQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zP9VseSaEO6to9rcRW_TZ6E6Qk4ZQgj49g9bQOAdjgQvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 3/5/26 8:18 AM, Yosry Ahmed wrote:
> On Wed, Mar 4, 2026 at 2:03 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Wed, 4 Mar 2026 13:57:41 +0000 Yosry Ahmed <yosry@kernel.org> wrote:
>>
>>>>> What about this (untested), it should apply on top of 'mm: memcontrol:
>>>>> eliminate the problem of dying memory cgroup for LRU folios' in mm-new,
>>>>> so maybe it needs to be broken down across different patches:
>>>>>
>>>>
>>>> I applied  and tested it, so the final updated patches is as follows,
>>>> If there are no problems, I will send out the official patches.
>>>
>>> If I am not mistaken, Andrew prefers fixups to what he already has in
>>> mm-new (Andrew, please correct me if I am wrong).
>>
>> Yes, if the changes are reasonably small and the code has already
>> undergone significant review.
>>
>> Although the mm-new branch is quite speculative/early so I guess this
>> is less important there.
>>
>> Adding a sprinkle of -fix patches can be a pain all round, so nowadays
>> if someone sends a replacement series I'll generate and send a
>> what-you-changed-since-last-time diff.  So
>>
>> - we can check that the diff matches the changelogged updates
>> - reviewers don't have to re-review everything
>> - the author can eyeball it and think "yup, I meant to change that".
>>
>> I believe this series is due for quite a few updates so a full v6
>> resend series would be appropriate.  I'll generate the
>> how-you-changed-mm.git email from that.
> 
> Thanks for chiming in. Qi, if you send a new version, I think
> separating refactoring (and moving, if needed) mod_memcg_state() and
> mod_memcg_lruvec_state() into a separate patch will make things easier
> to review.

OK, will do.


