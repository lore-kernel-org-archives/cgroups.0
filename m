Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974589;
	b=ctG2O9M2EZyfOi4ILo23IKsovl/snPEJlP6O2tfL+p49KfGS+kU7cObYZpYMNIouHklB
	 Vsaczfm77oL5acuOEHdZOtTaBW5CXU2QLpXndFKsQZUNBGI3wpP+nTVvAf4MB0L1pGpy9
	 7sIAw4gcgGPr5dr4jwuRy+LEpY6DxjkfgGgQFH0zxGtiuon2DoNRyu+6RulEt7hGrgxSf
	 uLdxYKSoDoRQGy2On5glx9WOfl+LxLxOjqOrQLpzG/s2a7eahjFlmJHpnyRnk1BVqeKt0
	 jEL7J78s0Mu0xcjWeh6kYWMj2NpVSCQQdFskn447XLT/Pb7bySc4cAasIf0xjVSPmFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974589;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Iqu6C6KXsE4USp3iSBQ/mHI3K4Pk+aZ5OmB26zeDtpM=;
	b=gFszRoQfxXR1dpHJQ6ukNgrTbuhhgSJ0YE7hG0XBc4OQiIgvInLTHtP0y18WHcVCt6tM
	 HbwTvXy1kddCkyx5lEOqhVkcNMKjceRfEQue46c55ajoXTlJkvjEodoio2Y2a8hSuzI3i
	 j98XFcxXPb7I/YBwVlDs6MoQEcLXwmLcCtt5ZSDamnEdgWl7vJ7o/NAiLCidMZVwS8Dcj
	 /f7tVJwJxzSKGJJFSGchn+7D+5Y+dIiH+jRBcOwQtsfaIVaPJnHnKGnqTFVAOfkHmseAI
	 L1Pu0qUQZ4AMgJ0c/DUihIJcSpjyymaZ6m1+dL4CvYsno1YK6ZqPYqZJNuCz1IlXXIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYis7w0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280EA606A326
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYis7w0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB41F0089F;
	Fri,  6 Nov 2026 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974588;
	bh=Iqu6C6KXsE4USp3iSBQ/mHI3K4Pk+aZ5OmB26zeDtpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dYis7w0tUQde6/ADfk2fxt45SU+oba+XrjaE0hJO9IiTbhtBdqvho7edgmqZgqLwn
	 3RnXTN4nBxW2NFDHVMS2xOvL6nNYqTqKw/1j/q2Oc6Lr10uqgkne1flWV1gfwXFFJI
	 vCbtm/ZTEZJwUHn8b0t7MfRTQihfNXdzmelkiQH2hzdBKHKxiUZG2PZDAm9FTFvPeE
	 S49NFHOS0sW5i301mzJM42hQKSz9FhPlaKCMbfUBAZbIxHDjBpsBIrvBRjwSn1BuJ1
	 yUIHFyMXbSl+mPwQkcZWe+jbMMF8Xp4wZNDRmezlIyXakudGTHRQ/ebkvYRck4b39i
	 68fs5XCmBj9uQ==
Message-ID: <264c406d-9f71-48a2-8892-ad0c902e3c47@kernel.org>
Date: Fri, 6 Nov 2026 15:16:20 +0100
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
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
 yosry@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org
References: <20261029204157.117879-1-joannelkoong@gmail.com>
 <auPhT70GU-Zqe9Qy@linux.dev>
 <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
 <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
 <CAJnrk1acAiHB06DKAJhuSZBNHn0dkRYJ5RU54sSz+xGXhwwnwA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1acAiHB06DKAJhuSZBNHn0dkRYJ5RU54sSz+xGXhwwnwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/5/26 21:07, Joanne Koong wrote:
> On Thu, Nov 5, 2026 at 11:53 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>>
>> On Thu, Nov 5, 2026 at 11:37 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> Thanks, I'm planning on queue this.
>>>
>>
>> I'll send out a v3 today that adds the documentation Shakeel suggested
>> about the race between reparenting on offlining and stats update.
>>
> 
> I'm seeing that the patch was picked up yesterday into mm-new. 

Yes, soon Andrew should probably slow down on picking things that I am supposed
to pick now.

Will resolve itself once patches only cleanly apply against mm/core.git :)

For now, he will drop patches once I pick them.

> Could
> you or Andrew add this paragraph to the commit message after the
> "Accumulate the stats changes..." paragraph?:
> 
> "Applying the stats after dropping lru_lock means a batched update can
> race with reparenting when the memcg is being offlined. This is ok
> because updates to a dying memcg are redirected to its nearest
> non-dying ancestor, which is where its folios end up after
> reparenting."
> 
> Apologies for any inconveniences.

Done, thanks!

-- 
Cheers,

David
