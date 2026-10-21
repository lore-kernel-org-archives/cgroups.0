Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573616;
	b=j0kyJj4CrevwWMqRCIKWzPREtEJpEZm1PXbOT/ARFFGRKYStGr5FQlXwHyaYDjSotyld
	 dA9cdMM08miyWN2SY+xu06KKuz6v78lCv0u5HSwkh1z6DRkAHCQSXuJyEzC1gEsJPyhz/
	 O/zjSgRB4/WKlFZJmxK3ky1ZKIGQrlqFkTy2XZEgPFTOsf2yPeQRoJiB7PvzUmonU79K2
	 LVx+N/ZvRFrAvubmaLCc0do5BJSLmLDc7MnmuNo49l73lCq0FLXxRInajbpvksxSUDT2D
	 rpqgJ1t6TY8VCQHv6bWKEMpecMTnpLR8/key7Zds1HQBsTu/pWD/l2+53ign6zPGNeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573616;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=uwQSFZ3FSogyaone7anL8mKsD0j7h3eCsLGxjb5kG8A=;
	b=SWklKqzOKupy4UcA3d+Ca04+5o7ITKAGHlAmvQzy4jxvGMl4KviV8JE8snYWC+VNymNs
	 ZFjqswAZt+SwZENdeusE8FBxTi4FyoaVFsUZtVHsutI1M/rwwi5N8q6wI1yFl0N1Zjt8f
	 fp0k15ZcAlW7g8aamURrHw1hO2k54Yz3dmoQQhw8L4xh494ThgOgCC9HtdgZ1Fj6XNfZn
	 ui/TaO/yiF2/fHg1lZ1OQ2XV2naHsFmEVVE6PmW5DP/C8dc7D+clUM3HFoJWTzjb/wMyG
	 RUWkdRs5ZDmcBR1+etpSmF9f5ot76cD9OABg4nIt6kVegbcKabWaUlHzOHQ8pP3/n2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="v+0qIXZ/";
	arc=none smtp.remote-ip=95.215.58.225
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCF8606A31D
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 09:06:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CCF8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v+0qIXZ/
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Po7qkO1SjHqn4Bxa+MKkPPqkGbMVv052HeJ8cSEw26c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792573613; v=1; x=1793178413;
 b=v+0qIXZ/fyvbcF5DEGvAHUQqdC8Vl7VnleFjNNvwB8O5CT5ZoXIXYrNJIy831Jz/dY05pH7l
 QgOs/T/9Y0sIOi05TSaiQ1zfjYdvLp3Yo4cjFeizd4mzNhRxuwox8qePnGLTSoh5xpkJJjDvRKC
 +KxplTTdY6JdWL+MCk/Jy3oM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 6eab166210853d46;
	Wed, 21 Oct 2026 09:06:52 +0000
X-Mizu-Trace-ID: 6eab166210853d46
X-Migadu-Flow: FLOW_OUT
Date: Wed, 21 Oct 2026 17:06:44 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
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
Message-ID: <atiApNwSTKejgcor@fedora>
References: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
 <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>

On 10/21/26 at 10:18am, David Hildenbrand (Arm) wrote:
> On 10/21/26 09:41, Chris Li wrote:
> > On Mon, Oct 19, 2026 at 5:35 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >>
> >> On Mon, Oct 19, 2026 at 5:28 AM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> I'm traveling this week, so it's a bit tricky. I cannot make Thursday morning.
> >>>
> >>> On Thursday I'll be traveling back from Cambridge. But hang on.
> >>>
> >>> My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30am - 2am.
> >>>
> >>> I could just naturally join that day.
> >>>
> >>> So one day later would work for me.
> >>
> >> Would that be too rushed for you? :)
> >>
> >> For everyone's convenience, this would be the time slot:
> >>
> >> PDT: Thu Oct 22, 5:00 PM
> > 
> > Works for me :-)
> > 
> >> EDT: Thu Oct 22, 8:00 PM
> >> Europe: Fri Oct 23, 2:00 AM
> > 
> > Ouch, David. If you commit to that, I understand it is very
> > challenging. Thank you for taking one for the team.
> > 
> >> China: Fri Oct 23, 8:00 AM
> > 
> > Other swap developers: Kairui, Baoquan, YoungJun and Barry, when you
> > have time, please comment on whether you can make the meeting as well.
> 
> I took the liberty to schedule the meeting and send out google calendar
> invitations to everyone on the CC list (to keep it simple on my end ;) ).

Thanks, David, I received the gmeet invite. I will join the meeting.

> 
> If anybody did not receive an invite but wants to join, please let me know.
> 
> If anybody received an invite and does not want to join, just ignore :)
> 
> -- 
> Cheers,
> 
> David
