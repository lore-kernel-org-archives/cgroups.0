Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555B643F0A8
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790362033; cv=none; b=CD/rZjnTmWMkojhNMOQUS7fqPPXYMeHFYKNSY1UoY3hII2daIsQWG/6WcH1BZSy/WVZDxqfMj1P/su0Qrxbcprnrgn8hRjdZMIsuOYX6fMqz02b+VNt99TopBKLlnM2cQIh2xiy8g5Ps0FCstHnD9JNyDOSKOCh8ADLqOy6HmfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790362033; c=relaxed/simple;
	bh=ZDB7Cv/GoRAaoC2nMm2ohyzn0qw/lGYfH7aEvgoflCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbWzGhXkMXo7hn3ZS4fwSGK+WiUEboXuYF9Pbo8kwAlq0erIUsLHI2EMD9WUg+gdfbheDS10Jz02m7bnD1kfEqQEU7gyW7z2GWPcGLrHqpvfGnq3d9REy327frATaab9TZDhWgCQpiiLx7TPQELINtqcWhTSIm4Fbz6ANElAOQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F0qMOSRQ; arc=none smtp.client-ip=91.218.175.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F0qMOSRQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZDB7Cv/GoRAaoC2nMm2ohyzn0qw/lGYfH7aEvgoflCA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790362028; v=1; x=1790966828;
 b=F0qMOSRQ6JdStYwkIiLROThp5fhWQvDBe4b4+Ss5aOXnkYoUS+EptNCziAOUr88AjVPfSCn+
 XXt64a96e436lPhdtAfUhahXy0Pc33Gw4EH9BGe9dnb42OkDIfBBDHHKRXNY5soNMjgcA29M5ov
 OmtVCYoUKRoUjPceKbIEYC94=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 58196d26f865613b;
	Fri, 25 Sep 2026 18:47:07 +0000
X-Mizu-Trace-ID: 58196d26f865613b
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 11:47:02 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbA6J7n999U7v0L@linux.dev>
References: <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKerXANxjILrKNs@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arKerXANxjILrKNs@MiWiFi-R3L-srv>

On Tue, Sep 22, 2026 at 11:28:45PM +0800, Baoquan He wrote:
> On 09/22/26 at 04:56am, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 4:43 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > >
> > > People can speak for themselves and suggest other time slots. You do not speak
> > > for anyone but yourself here. At this point this is derailing the conversation.
> > >
> > 
> > I am expressing my opinion, freedom of speech. As you can see in the
> > previous discussion, Baoquan wasn't able to join that time slot. He is
> > a major shareholder in XSwap. I worry that alignment vswap vs xswap
> > without Baoquan is ineffective. That is my opinion.
> 
> Thanks Chris. I know you are trying to involve more people to join and
> talk, and I appreciate it.
> 
> About the meeting time. I am in UTC+8. If the meeting is before 23:00
> my time, I can join. If it is later than that, it is too late for me,                                 
> and I can only discuss in the mailing list.                                                           
>                                                                                                       
> But I am fine if other people meet without me. Please do not block the                                
> meeting because of me.                                                                                

Hi Baoquan, don't worry, I will make sure that you are present in the
conversation. There isn't much time left before LPC and many people are
travelling next week, so we may have to schedule one after the LPC. 

