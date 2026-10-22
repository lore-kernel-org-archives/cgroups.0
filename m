Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.147.23.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792670469;
	b=fVCrqF9n7/drfVcmD+kS0iM0NlXR9IsgWKcvv1fkQbKhPJgsdIIh9qhZk4hMnya904Q0
	 Bj7VPAMqPYUZZurscipXWOU+7px8VnR+mUmZ1rgmAtK+pXHC2eJrnJPUC64lpO1LLEchx
	 RfKTtpBkKjyeWetwt8QDHM1mzEy3ON8igeO3o07L9r73g1JbybQj6BQfcZ+80UMQHL115
	 FA5VnBOYwnJ7hmvzftgbHyk57JwVoRR4SKNF52Cm3hOl4IB8CvAO9FLT2g9KVkBDr52Q7
	 Bz3BbR9cCMFLkUxxSzjgAG31iTli4UtLyHYmceJRyMirVzkfWa/EJagKeyKY6Y4ChPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792670469;
	h=DMARC-Filter:Received:X-Original-SENDERIP:X-Original-MAILFROM:
	 Received:X-Original-SENDERIP:X-Original-MAILFROM:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=s4DjmkflJ85sDaL3EcGa6JYsCik1zYKmblb+K5Ua+5E=;
	b=GDQI0y2bxdCMSECRDpl2laQXuRJC2YsLHq8GFoR34hKk9o0hluRFfVFhMclp2a7Y1AfN
	 nssKFFSE45LcK1Mglf37kQrdAgR1fxhHU8OtuuI8NHzdKkVBxY7BYDR9nCcuIR8bo24Ht
	 30j5kqFjnM8E+6U7rZX/yzeanyEgjHQYCL8SJF7nK10NDWWxOQUwhhMerBONN4JKKVy1o
	 JAn4goHRg6qQw2z7VUflA2t50EJnbx7Elu10aKszcwcUmCsx+/16nSNuJu6jTqrWtXWlj
	 tdevB8FMl5Sdf3mbNrzXiRRpf1r5Ik5MyQ/5UlUBxFxsCbQFn3JUGF+nBnJWa6qh0mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lge.com;
	spf=pass smtp.mailfrom=lge.com;
	arc=none smtp.remote-ip=156.147.23.52
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFDC606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 12:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FFDC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.52 with ESMTP; 22 Oct 2026 21:00:58 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 22 Oct 2026 21:00:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 22 Oct 2026 21:00:58 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
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
Message-ID: <atn6+gEwHUxUKhLB@yjaykim-PowerEdge-T330>
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

On Wed, Oct 21, 2026 at 10:18:35AM +0200, David Hildenbrand (Arm) wrote:
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
> 
> If anybody did not receive an invite but wants to join, please let me know.
> 
> If anybody received an invite and does not want to join, just ignore :)
> 
> -- 
> Cheers,
> 
> David

Thanks, David and Chris!

I'd like to participate in the meeting (This is 9:00 AM KST.)

However, I have a company meeting and issue around that time.
If everything is fine, I’ll join and participate in the discussion. 
And If an issue comes up, I may need to leave early.

Youngjun
