Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BBD377AB3
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 06:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789800632; cv=none; b=TKNFsIJ0PE8AEAF2IDzlYAcCcTSjjoZjZ7xqLrhG47hJsuKr9CNpOGfvRAsjLz4woC0Nlot2mFDOziBoWOfdRutB12kBm0eI3mtB6RCHg8aKPyiiSd9/UsPnQGeKhR13iWvBlPiw7aKdH6asTETFCNaUkiXfCM+kVLrWSk9N1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789800632; c=relaxed/simple;
	bh=Fy0hcrpc8gMaop8QcMQpaxARuL214HEekfRBW/zK9rY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cv0Eeojx0sMUsnHOechDxVaTZfdZG/w4rTBuIW9+AldDOUKCdWQ80xuBDABjJlObGjV/fcP8P24e4HhrmC6QYURZHFDI6WIPjfugyZzktIeyOLmQaqdAEsIj7ZZqyvPscLchKP3rv3esfRwcvXTsJXmQTSJr+QJ7dkRWWKi0K6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIPvq99o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIPvq99o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6C81F0089E
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 06:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789800631;
	bh=Fy0hcrpc8gMaop8QcMQpaxARuL214HEekfRBW/zK9rY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MIPvq99olCRTHkZm1a4B8dnyivpeG0vonLr8KVJro7Umjvj9r0UHj8ViaTpLGli81
	 7F6VI1ERxQQ9TsQUsQ9qCudOMvh8Fk1oS07eNXTxn4buUuVhd8rszx4HuBGEFEnJhB
	 VjNFJjUT7d9mur+Simr0L5yO/ENwKxrpJTgO7iajCPeSZxc01krhauFJF6BKaOpsTB
	 TYe8xj1URdMs/kzH3QOQrF5L8Wa4FxwiFNyiDSND5OIAJMAYpGqyZN1rnwdRUf8WWL
	 66IyqD4hve/foAj8TIbwOXbjECgNfO8jwsJZ/WnjKdwLrLZ2KrnYROiRXvSq5YJ5m4
	 bMElivfCyeDOA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab1ef11so1309859d50.0
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 23:50:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwcOClrACde6AGjpUtxQc71U+tpk2IH+QU4tJx1Vo2t6TOI7rxUjwpIAkGVO+0/sNHoZmMhONLc@vger.kernel.org
X-Gm-Message-State: AFuF++nAfUu6+ef4egQa5Fl3EEECKyR4Avq/llpW1vkFhId0aIKOZY2Q
	Nxsdawnw9yOupVTRpJ99Cwr2Tc9JfbZ/Qga3hbGNv5DTiCLwx9KapV0uaIp3yH+guChlqzdGs22
	ZMHiY2xYgS1JAamy8eJUQqBeTEehTWVI8JDCc3/YvEQ==
X-Received: by 2002:a05:690e:80a:20b0:66f:c1bc:c085 with SMTP id
 956f58d0204a3-6717fdf9ab7mr1037245d50.77.1789800630447; Fri, 18 Sep 2026
 23:50:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com> <aqgMCIOFi0dKx_6L@fedora>
In-Reply-To: <aqgMCIOFi0dKx_6L@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 01:50:18 -0500
X-Gmail-Original-Message-ID: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
X-Gm-Features: AcwNN1UsCayhu6qSBcp0NCeBygOCBz7cKHDcf9ihkAi9fMFOHSellJ6quiD_7YE
Message-ID: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 10:00=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> >
> > Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> > UTC+8 folks.
> >
> > The time is still fine for me, though, I tend to stay up quite late
> > anyway ;) so that time works fine on my end if the slot is fixed.
> >
> > Is there a calendar invite or something, please send me one, I'm happy
> > to do a swap sync discussion there.
>
> Thanks for opening this up for discussion. While the time slot is a
> little late for me, I am not very sure if I can attend, will see.

No that time slot is too late for Asia developers. I don't think we
should use that time slot for swap alignment.

We should find a time slot more friendly to Asia.

Chris
