Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793774569;
	b=JhSIbN7mZXxAh0VvpE9cFQ0nZf8LIeesvmg9pcOqaHYyf1Zi5VWbA7d04/oFLpRovH/J
	 clgsAEfUJ7BeD9imoXdwTMNz3eonZzk8pIX4Wn1hYgtxxJ4Y8DSpgtnI5f2y+Lw1CruTG
	 IJXkgqCUftUOmx9B7w6+8g3/RuL9pkI3tiPXVBzEkVA00WNq9DML5oT1W5k1LXIXBp5UQ
	 fNrBcxvgwwyvZnr0ZNfQ42T1tlixZfHUW1fi35VVdzPaeliSIc0DIs4/93x6HzCNsSCG8
	 nFF7W2nhVi1P82+qIAYSETEUMVJbSiudXjXfJVbQU44yIbB7BvtYs5gRqTJ0yyyiNKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793774569;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CaIA/Sr2kiTxJs6D9LfjF0iFIQjHh5ZBby7zBRLnjyI=;
	b=QHbc7CMBCLMmuuOJxtmk3Z392fiLBtO45mig3n4kC4PHQZJOuueEspgakYnclUYtFo9l
	 Ih46ix07nvrEjONaqLAPBUDHCtKkPtYFmW2zs59HlCiuLa5EW54Ih8yr16mYIsNgaUxe0
	 TFnTy/BXnyJY/fwCR0DZd5iL1KNaNm7HJjJ2y0ThA+skDSg29G65HeUwPr7lMLNOAwOoV
	 pOyfvKEdKzbt4AJUfQypBJeqzkhybfUG/bmiTaHrdu2R81w7sQR4Dn6bXTaZiXqlW/DVi
	 b+7EaHLFosKcu3wasEnI3zuR7hYCppUlYFh0a9+bkO88Sdhpib60IOPQJvdVCyLifUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b="fC4/WDT5";
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876DD606A32E
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 06:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 876DD606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=fC4/WDT5
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so627797eec.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 22:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793774563; x=1794379363; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CaIA/Sr2kiTxJs6D9LfjF0iFIQjHh5ZBby7zBRLnjyI=;
        b=fC4/WDT5oFZPWEWs60Q7RhuQZP4DJQe877ZJJI5AU7bF0gQrNjO5hGkH+3W/0KW5gw
         y77bERCqeS/9ocgr+2YbIxL0MU3EpNYL2hfq0FlDomKr7jM5/7L5JmuLAENe+1XuT/EV
         PTt72eKpBaHTGw82zOPYckddDQr6LDMsL/wcOFm7Ti3M/26Lxc9DbAy5JAeE0zPSrV+N
         OzRi6rNNV5Tf7k5usFH+FtGX1SGr76HKuj5Wf+m4Kf9XoNbmcp05AhYsFp26Vy1Tou5e
         PBkIZn42tGID6PUU8fX5iFI7V3+Kt7b+3yL0JJODXQxGXRWVLz+q4ELKzfxDBAVvsNCa
         U71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793774563; x=1794379363;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CaIA/Sr2kiTxJs6D9LfjF0iFIQjHh5ZBby7zBRLnjyI=;
        b=VRljYe73o2fmo1WmXuHfKs0C9ELkKYQnkzXkIiO6QnLClb7msE48XjIn/1smEk0nYI
         ZoWiYjUrpW0t0QLEzJ8mQqTPnJXQDDpiL4dx0km8QmBUIRyRPdKgKzyTGmJTsYPgKCoI
         HuVQVKAdxobpULllNNeSb+AM7YxELwsMKiBdbCIqR+yC7kFCTeU2sO7u7Sq0v1Lx8cBS
         xePHz9tOLdq7TkdVt+im0zJy00mp0evXVCeVNuFgVhYIeC8p6jnKh6ijnmSh6IB0ds4U
         jvd3WuvcPm3d/bH1ATmiAqfKXXtf94qyKn7IiZHIiqW71c/Pitm+LJKNsrusPqoLEzPj
         GM2A==
X-Forwarded-Encrypted: i=1; AKwUvBw/oA208ykrja+qUWwPnhFVHAhT/rQtd2e1gyGJDWxWWdFEuIX3eOC71Am4R7JpSlqX44roAwJk@vger.kernel.org
X-Gm-Message-State: APuU4Z83gu2t93peTn5F7VvIWcIyR7iBWEB8I89jOckVc5YKs/cLnJA6
	apSjB/gBud9sI2uPZptHvmzgG0J5TgaMQQFKhM3IPLNCX5MkRNuelLIUca8RC5cNRuk=
X-Gm-Gg: AYBFou3bChrtbDzk6D50Kqvt7gGmgLNrxm66avhZosELxWNsqIPIY4zYxIhKO2yYEzH
	I0uhSVoFUzcYSxoDmdblpNf6V2cqByUdkccX5I/ffkdgummxWPC6p8tj3qCAvNwJ4qTbFnnSKv4
	FZfjI0zO2QOPZ9Nw9toQ0eMZDWtbwTiQq4qh6cKPW/3CpJo68uh06WO5/spAliv82uNcLGgxyW0
	jMoyF6375vuWY+SU9qZph78sg9G0dwQCfdIcLP4OFa/cz9euVuit/4LFnWpylDKZmdtd6JB8mrK
	L5frt0gSWzn4X408rIpqmxtmI9ylJicjNqKQxNWWPU32KKEqzXAGh8crhtK61EZ9HXZblkYE6Yg
	9vx0udjJUBJNKPYWHqcT1VK6t3F/lJcoPB0dGqXV1iMqYvr6LRtUvdS/ily/sml/JdwuCsY09im
	nk9p7OrZ84Z+0If6M/a/ihUPtwtrR1WQZ3NXm+zpZRxogkU5CD8MjoE51hBL3VePhka5kYGu6+P
	dAxqSz1BrP7ObwhTiaxFJUMiOa5nJHsBE4GRHE5Qjvs02peecL1V8QBANecjHrrQLrAq2RXWqCA
	ViO1I9ox1so+FSbxkw54Q1HvzOe/BLCH1z1Cqw==
X-Received: by 2002:a05:7022:1711:b0:1ae:59d6:91d7 with SMTP id a92af1059eb24-1ae59d6945fmr17559078c88.40.1793774562347;
        Tue, 03 Nov 2026 22:42:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([61.251.99.240])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c57430sm5905073c88.18.2026.11.03.22.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:42:41 -0800 (PST)
Date: Wed, 4 Nov 2026 01:42:23 -0500
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org, mkoutny@suse.com,
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com,
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave
 controls
Message-ID: <aurTz8SiB-nQ22lJ@gourry-fedora-PF4VCD3F>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
 <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
 <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com>

On Wed, Nov 04, 2026 at 10:44:46AM +0800, Li Zhe wrote:
> 
> Does that distinction make the cgroup-scoped override acceptable? If not,
> could you suggest a better way to support this kind of administrative
> weight override without adding new mempolicy syscalls?
>

I'm a little confused why cgroup-anything is needed here when you could
just override the weight table / interleave functions.

I don't particularly like the idea of bpf hooks for a single mempolicy
mode as opposed to something more generally useful - and I question
how useful task-mempolicies are in general for tiered memory systems
(they also affect kernel allocation placement, which is not great).

You have many patch proposals recently trying to adjust the mempolicy
components and I think it might be helpful if we could chat a bit
about what big problems you're actually trying to solve.

I get that you want better control over task/task-groups, i think that
can be useful - but I also know that demotion immediately mucks all
this placement logic up (and we can't check vma / task policies at
demotion time) so I question how realisitic the value of these
extensions will be.

~Gregory
