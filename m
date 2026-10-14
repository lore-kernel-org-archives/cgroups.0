Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DF556E074;
	Wed, 14 Oct 2026 18:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003594; cv=none; b=mTz4f01+VEGEzQJz1ioR0iprANK4vml2/s00yeLmN0lMi7O2O8iZ4QHTLvk1dd1a46txbG61qQPa6VsxizoX96gWv3YQBErv9AeqKK2m8nlPtjtYbmjnoL82ULHN5Hc137OtuyiRcxSjcZ99VYC+jbdcHxQUSoYgW5BI8ERWVW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003594; c=relaxed/simple;
	bh=QGeni+Dqy7rYyILLSs/q1fCNwL/enmT+EXAbDw7GYOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Huk1jqPx88ngZGw5iSmzoZXBw39VA9wfBcRWbHH8e1YBQ26V/sCVsL40/WzQIweNa/gjl0aRHcFQrgNIAjIkwhrpwFMv7h9zAguoDm7LqArS26rz969daYoM6ctVYChtEuUbhKtcHfwkpGp1MkEO6aBAxd6vUAEZgfPLyfF6Nzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fc1TvbQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fc1TvbQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343281F000C4;
	Wed, 14 Oct 2026 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003593;
	bh=ESvCGRLFTew8m7s5oFwM1Eu4zFgjax4mVQujOpbznXo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fc1TvbQ/IoFOWkS4r9GpWZ2uI/Fmq5vGoocDI2qZsvsZOVwo8dmzPHQ9AwpQI65xc
	 0hyNO9BHNGvfFFpSBYm6orjA9dwMSWtC7ZyO/ycpjw7otwP49fLanDBobCsJVEWMCr
	 V+BY4QuqvYvzydWxhGX/5ZlKzq0/6KndsbuCTpxkdJvRzjdoh7Ew7OQv7F9ut0mcUC
	 BcxLEXSN2DMEcYDt/rzRwnx5zVlXYIKJpbj97Vsl7f/CqzKtaKk7pBlz2sPbF5x/wk
	 GGohatcwUAzO3eKrwCn1+89fS13vuVrYOYYmgOM6V864X5fudq0RjKnemq2o8lEQHh
	 WPSB8j57GDIzQ==
Message-ID: <f4a5223e-7cf9-458f-9cef-23618da9fb09@kernel.org>
Date: Wed, 14 Oct 2026 20:46:19 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
 <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/14/26 19:17, Kairui Song wrote:
> On Tue, Oct 13, 2026 at 1:27 PM Chris Li <chrisl@kernel.org> wrote:
>>
>> On Mon, Oct 5, 2026 at 5:19 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>>
>>> Looking at the mailing list, that approach doesn't seem to work.
>>>
>>> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>>>
>>> 1 AM is certainly unpleasant.
>>>
>>> US vs. Asia is also tricky, but doable.
>>>
>>> China 8AM vs. US West Coast 5PM?
>>>
>>> China 9AM vs. US West Coast 6PM?
>>
>> Hi David,
>>
>> Thanks for organizing this. Time slot that works for Baoquan and
>> Kairui should also work for me.
> 
> Let's see Baoquan and other's suggestion, both slot are fine to me as well.
> 
>>
>> Hi Kairui,
>>
>> I understand that you have some face-to-face discussions at the
>> conference. Do we have a list of what has been aligned and what is
>> pending to discuss? We should have an agenda to avoid repeating
>> already aligned items.
> 
> Right, from my perspective, here are the following key points we can
> discuss further in the incoming meeting (most of them are not fully
> concluded yet):
> 
> 1. A limitation for the logical size: from my side, there are real
> usages for a global non-memcg limitation of the non-physical swap
> space: e.g. thin VMs as containers/pods with no cgroup limitations
> inside but which need in-VM memory compression and a proper limitation
> to avoid thrashing; or low-end devices/desktops that want global
> (root) limitations. And also, Android have a limitation on the ZRAM
> size (well for this one I'm not from Android team though so that's
> just my personal development experience with Android, enlarging the
> ZRAM size on several Phone swill cause serious junky of Apps due to
> over compression).
> 
> Nhat is concerned that exposing the sizing allows users to tune it and
> potentially misconfigure the system. However, I think a user with root
> permission should be fully aware of what they are doing or they can
> easily mess up the system in many ways and swap limitation is a very
> minor concern to me.
> 
> I think the requirement for a logical non-cgroup limitation is strong,
> but the discussion hasn't concluded on the implementation method.
> Perhaps something like a Kconfig combined with an interface or command
> line? More ideas are welcome.
> 
> 2. Charging: If you consider memory.swap is physical only then indeed
> we should not charge it, however, user are already doing that for
> years so this is a behavior change and we are also pushing memsw into
> memcgv2 as a interface to limit the logical memory usage of a
> container. So charging of the logical space is useful, how to handle
> that is tricky though.
> 
> From our usage, this should at least not block adding memsw or
> anything similar for memcgv2, even if you want more customized cgroup
> accounting, we need to charge it into some counter (a page counter,
> not just a statistic) in some way.
> 
> 3. Swapoff: This was discussed again too, as vswap was trying to
> remove it. I think the concern is mostly about maintenance,
> performance, and practicality. From my perspective it's a critical
> component both for preventing minor or major faults before predictable
> high traffic arrives, or for operations/debugging, and for releasing
> the swap metadata to rule out any potential swap / page fault effect.
> There are concerns about maintenance or suggestions to use MADV, while
> I'll be happy to explore and improve the current in-kernel
> implementation of swapoff later if needed but removing it is a really
> bad idea in my view.
> 
> 4. Writeback: No doubt we all agree that we definitely should have
> writeback support, Nhat's concern is that we should handle the case
> where some cgroup doesn't need zswap/compression and ensure that works
> well.
> 
> 5. Interface: Given the issues above, what should the interface look
> like (swapfile, sysfs, /proc, etc.) and how should multiple
> (non-physical) swapfiles be used? Nothing much is discussed about this
> part though. I've heard users mention the use case of multiple
> compression swap spaces, but I don't have a use case for that myself,
> so I don't have many comments.
> 
> 6. The one part that I think we can and should agree on it shat the
> implement approach: at this point I think VM_SPARSE is the right
> direction, Nhat is concerned about the testing on it, and I think we
> can have more data for that, and collabration is highly encouraged. I
> previously conducted many tests on everything posted from both sides,
> will try to post more on this too.
> 
> That's a lot of problems already. I think we can discuss these points
> further in the meeting.

Just in general, if I'm attending and it's 2/3am in the night, I would
appreciate a short summary of "these things were already sorted out". I might
have some weird swap-related dreams afterwards, but it would certainly help
keeping my brain awake.

Surprisingly, sometimes summarizing common understandings still sparks
discussions ;)

-- 
Cheers,

David
