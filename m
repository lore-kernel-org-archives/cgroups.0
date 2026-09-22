Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5012A559CA0
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090939; cv=none; b=AqUYSbaClU72QCAevZiwD7PUB3BTRT1LZW51Jdpd1s64S3Kvc7B5r0Q1ICRZnP5fgvNvszrBdjo7T7BumKls6+wLgtSM7S8juNME8/l0RwzVF6XcrNZjwPtECWfdEgmNJR9QvLoK4ehSk8xwOJ0UYZmT8FS32QJ3FbQ+a3gwebE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090939; c=relaxed/simple;
	bh=yy9tOrtBWQOwfMGkz7znpOTF7ArUWzbkvnV86SHmbek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b90scOyoKuXzl9mZ8jv+As/sXRyHHCW6iiJ1lgzKIG2ycisfGQPIcdo8W8nVARUmAbNCh5x7kD5QS6w7oL8Kb+OARiflZ1twA2uGJxHjQxUcLfs8P7P3YYFxxnMgr1Mtr7Eed4ImgzJWXR1ZunZ9ZjvFN5/hW5uk6X5k4omP6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S1vE3SWo; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S1vE3SWo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yy9tOrtBWQOwfMGkz7znpOTF7ArUWzbkvnV86SHmbek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790090932; v=1; x=1790695732;
 b=S1vE3SWoaAoNMoHV1A2b0ZMVEpHw5mJcZXDPUnpFkWYTbXOWkw5ajVXr3cbf0Tf/6TaAQ6OC
 s2GV7HIvXlLEYN87kDTlncbe1lm5swthJDBaMe12ayGCLEqS8IOD3AjGHAA2bOty63VUW+QdY0j
 tCDH1VmhghHLUD8Nri7YS9A0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 6d3d1a28fd5fcdf1;
	Tue, 22 Sep 2026 15:28:52 +0000
X-Mizu-Trace-ID: 6d3d1a28fd5fcdf1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 23:28:45 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
Message-ID: <arKerXANxjILrKNs@MiWiFi-R3L-srv>
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

On 09/22/26 at 04:56am, Chris Li wrote:
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

Thanks Chris. I know you are trying to involve more people to join and
talk, and I appreciate it.

About the meeting time. I am in UTC+8. If the meeting is before 23:00
my time, I can join. If it is later than that, it is too late for me,                                 
and I can only discuss in the mailing list.                                                           
                                                                                                      
But I am fine if other people meet without me. Please do not block the                                
meeting because of me.                                                                                
                                                                                                      
For the discussion itself, I know it is a little hot these days. But I                                
still think it is useful. The disagreements are becoming more and more                                
clear, not vague like before. I can feel the consensus is getting                                     
closer. So I hope we can continue in the meeting or in the mailing list. 

Thanks
Baoquan
