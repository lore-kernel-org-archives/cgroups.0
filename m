Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B223B2FD9
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790525863; cv=none; b=i/l7B4FOuvS8scMoE/I5RNyTSzK4rMf5pyPdyQId31hDDnjxppSpokQtDNe84vbXwhqhTILecePEXhqYEH07J5OllY1nIcmg0DqufWxIFBzHH5meK2p30PSLXxH0VkEieygH5Q5/s71RGbu/s1sdwIYPC/CGHIEWXIDfJjHDCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790525863; c=relaxed/simple;
	bh=/cWcHsJusU+znhxk6dnfZb8YGlzqsD0Jsc7WRoFFwng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QCr0gnotQx/Jy5YLf/Y9fV2UcIyxXvn7f/6R4mVIhptgb1VC9xD8Nt6vZAowy5rf48SvIHgCor5Gk15sqrmK9Ucwdtvdjs8sIRFKjYWPA1doF5ikr63km6uUdN7XHi3zDWN2bIoenU9uv54So8kcyAvZFiPQBi6F40wuJobFtc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H73g/G8y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H73g/G8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE171F0089C
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790525862;
	bh=USGq2m7h9orgFPTHEzwcgOdn0+wSQ8cWbMPpoviJBlY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H73g/G8yUwG8Os+36/abjl/U0qVPez979psGJqM6REqeteGdkN2LLxDLhvS5E/Vl8
	 Sc2VkBqJe0q58J8uEx0H721njHwR/XA6T7Xf7XGQVQHHfgm0F2CBK5Gpc+2T+kbeGG
	 7BpBL88906xqVKvEAhgi4YVuNRoGA1TNPTWFCMTSO7JWgV+lv5vgqPpiezwlmyUYSZ
	 YWq9P2SbpVnJcLSyjwoCvneFRblqZtidnwAy9R4QWz7Z8r7iAYK0rCacQIHAIzr1Pl
	 YzXDi0F8rU/bMyqAHFPxdL7YMtUrpa7h3VJG7AzPDOVI5o0XjLjo4d0lOfnW4ghEOl
	 qTq+u5QqWgx5Q==
Received: by mail-ej2-f19.google.com with SMTP id a640c23a62f3a-c2940ff2313so143820166b.1
        for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 09:17:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxj07g4fc7qe8FXXZQLb93DZQjLU6jXDGvvcN2WtB+yi34qG1dQ1HVaBbl+3RyVOAjXrGDpFHkG@vger.kernel.org
X-Gm-Message-State: AFuF++nh1mrHhL0qYuEvlMOfb/UtrlGHINw0tOmKgWVmkt6U1pCC1Ejr
	3m1+ABNykEbrdEDSekuvQGBupcOTGLKgbNsLEC9eLiZkwwllYj/FMjP5QbIUzKmZuhT0qrKMINU
	EuxmImgT4ivw3wKdDQr+sinO9+eK38n8HG7P5+anpWw==
X-Received: by 2002:a17:907:c310:b0:c25:f7db:4bef with SMTP id
 a640c23a62f3a-c2ac2389fa5mr1002872266b.21.1790525860493; Sun, 27 Sep 2026
 09:17:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
 <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
 <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com> <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
In-Reply-To: <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 06:17:29 -1000
X-Gmail-Original-Message-ID: <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
X-Gm-Features: AclHuK8lyU5HNKfMH-oiZ7t5RDtX6FakbfaPtRr5UYjAiWQbHf-Cp-W6HCn32gg
Message-ID: <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
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

On Sun, Sep 27, 2026 at 2:29=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sat, 2026-09-26 at 20:23 -1000, Chris Li wrote:
> > On Sat, Sep 26, 2026 at 2:59=E2=80=AFPM Rik van Riel <riel@surriel.com>
> > wrote:
> >
> >
> > > The fair resource use from memory.swap.max
> > > is to control how much of the fixed swap file
> > > (or swap partition) space each cgroup gets.
> >
> > That is the part I am not sure I understand correctly. Fair in what
> > sense? Using the swap file proportional to the memory limit of the
> > cgroup? Do you have an example of perfectly fair swap file usage for
> > a
> > cgroup with an 8G memory limit versus one with a 1G limit?
> >
> > Sorry I am a bit slow grasping what exactly the fair behavior is.
>
> Say we have a 64GB swap file, and several
> cgroups on the system, applications A & B,
> and system.slice.
>
> We might give system.slice a 10GB memory.swap.max,
> and each application a 25GB memory.swap.max.
>
> This way a memory leak in application B
> does not result in application A being
> unable to run.

Thanks for the explanation. To me, this is just standard
memory.swap.max limit behavior. I was thinking there was some new
concept of the fairness I haven't grasp..Thanks for the  clarification
anyway.

>
> The thing that leaks (if anything) ends up
> getting killed, not the innocent bystander.

I fully agree that is the behavior some of users want, it is what I
would want as well.

Chris
