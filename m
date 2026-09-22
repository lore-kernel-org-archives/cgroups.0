Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744F42AD03
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089644; cv=none; b=FkIZCT0JxpXJeBTEZELUcW+huuzxpkZIN+EXniZf/+VaUxg4g9uga6K9yZnYFtnMmFrn/1WlWit/QurYsowKc5TRsDp6EZL4f5RDoJGPMhBjBVi5eeorvuv54pOJzDGYJg2DUQURYJ5vzEpzinf6D8mkbtI8TguwcI/MZWXO2aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089644; c=relaxed/simple;
	bh=pQRCqIxdRi9n3oOnIO+L9DGoF0+Af1vETamIPNHLiuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXUFN8KQcjt4Y1+3QLR8P+0r8FWVIM52Zar8SOemgOUm5GLtBvn6ySGMKeWVFVadStjwTkW4CAAbc7DgKGV5jHkxRs5Ou8Mi9urORNzDEGd8njHYrcOjMQBp2J0f1Ad8QPp9c7Q1k2Hbf30NvF2ihTDD/yqsTubUbfiAHuccLLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=LRNyWPWk; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="LRNyWPWk"
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910c9ff1fso2682885a.2
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790089639; x=1790694439; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TzjZBDA5iUg3ko8RNpB6y9UNWK4AO1BnhWiKj7vnaJU=;
        b=LRNyWPWkHOlp/fa83u/CnOO+rOYP6lmeYLURZsifJgVh7e0a9xQX9ebmmrJdxddqpI
         IFlWiQIxNwJBn/2+QaxB5C44LKHBLKaNTI/YFZxi4u8fw+eH4LEeymEwtkf6Ph2MokmJ
         vvo0cff9ZAPlKfwO1zo+6gpLDgtePtgEsgZOcKmJBwsZqR8udGvcv6JWlZqqjrDPOa6m
         VUcLGER4qN40EIMy3FuvBp0x6is5U53mTfUY1wp1JtkXCQ9BpXWyIg14xrTYuLXtv3OF
         Ru0Iv75DwfSZfkdXMsmijJzeSmxFUhFJKhN9AiAOwVSs0MM6m30mZ842EqQjwffONkT4
         4syw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790089639; x=1790694439;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TzjZBDA5iUg3ko8RNpB6y9UNWK4AO1BnhWiKj7vnaJU=;
        b=FuS4xgkJFmIeiDLQWLb4XIJadJgPte4j7NMmnnI0PS4P9rE8s9nzGeigmOyx01YZia
         O+uCw24OIjm02v8F7B2eECgz4HzwLIDdQjK365dk5KJuezVElGukbkzYRC0i6iaDEee0
         ncnS8yFsDcKMqZ9ixYXTj7wtd9WvWJWx2tRKzbxe6rY9V5i6P++WhxznHe0WEHFXxDIl
         zRkSDXhXY21EsZQJYR2Zo4qyqRTZtWfJ+gyEp2KCF+gAVDXo1KkQ6n9AwZffQrGAckIq
         j9yY/8zGjE5TY+kShqMuBGWotnQo8CTah6liBLO7fEdd330Roh4eGTiwaCOnRlverobr
         zRSA==
X-Forwarded-Encrypted: i=1; AKwUvBz999u1bH4LE9Ie3e3yaJ+73/u2W129vg+s92zjappjVuJ1T9Zf05YGbZWrpIEQjqfrUkt+XWPu@vger.kernel.org
X-Gm-Message-State: AFuF++k4J2youFf1JdwwQcvir3rHVfrdQY07OYbXJq1S8SbbAf6qWif1
	tskpFwi+5CR2EAbPC+gSnV7JgbFnRkOUdgYQULBiOj6t8EjMKS00XaCAHHmYcW4v5Aw=
X-Gm-Gg: AYBFou2RcskB0Tn8blhWw7kB9eeYZ6jG2AfDEcAmFoI2foYiRJmhXYXE0+yB9V6R+7S
	bFlcFJ5ExpE40rcCX4QZesf0kVaSOZdyjIfoqFTqAZZlPhweOVchV408ZfERC0sT1WnJrtfjgcf
	LgcUURuxLzl+cy6n2DuNqv/ncDb6hXEiRlarXh2kITEVWMcmwGKexTNFZKw3dKLXoKUrzKJ4czF
	GC6Eowu/SIaN5mASfqlkQczHhDKmPOr9ClsoiQDANpeJSUJ6hvdBzRnDEdmd7KLu6wrUFHa/2zf
	rghq9NVr2/IMXSr/ZL9wWGo4r8nItvpIOVj/rTS2VaDKhd+alg2cjPU658Hj/NWCmXnfFl0995O
	FBn3JoUItZTES17z/YvpCyVd5xt9GCGWj/XzHpTSSyhc1MRdFuQEyD9SrGU6phDpl1E/ae5Ihw5
	99xldPUoYzNngRsiMiocPQqpRQjyMRqmBBR3i0dAI9ni0LM0BUmOQqdQw1OLHdp3psujTZ
X-Received: by 2002:a05:620a:2608:b0:939:35e5:94ba with SMTP id af79cd13be357-93c15d59204mr577391485a.6.1790089638560;
        Tue, 22 Sep 2026 08:07:18 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1cf10929sm167536485a.6.2026.09.22.08.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:07:17 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:07:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKZpJDpsavixjPx@cmpxchg.org>
References: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>

On Tue, Sep 22, 2026 at 04:56:48AM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 4:43 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > People can speak for themselves and suggest other time slots. You do not speak
> > for anyone but yourself here. At this point this is derailing the conversation.
> >
> 
> I am expressing my opinion, freedom of speech. As you can see in the
> previous discussion, Baoquan wasn't able to join that time slot. He is
> a major shareholder in XSwap. I worry that alignment vswap vs xswap
> without Baoquan is ineffective. That is my opinion.

Actually, he said he is not sure if he can make it, and before Nhat
could respond to that soft push you drew a hard line without actually
proposing a workable alternative that made Nhat give up instead.

So my free speech opinion is the same as Shakeel's: you're speaking
for others and thereby derailing efforts to align on something.

We all want Baoquan in the room.
