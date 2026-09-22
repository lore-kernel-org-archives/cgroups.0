Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625AD51C073
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091984; cv=none; b=HpvWGT/BrvCUGeI9ZDx0wiThN5DBhyx6bcOrQVjcZj9o2ek8EnSluOAUEwKY2no1L1My8POxEg2Yybatm10758UtctA5AfRL6XHtEYI5fpOCq3v9X4IDNPJ9/XH3tRuto2bBeK94yvLbkeR+Q3b37Ilk2iKnx5adBezqHwLOS6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091984; c=relaxed/simple;
	bh=e/G+x8EZ1Ezei3fqyde5MtjxhZdcvZ09vtY+lp4RtkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVPsz64j4LN5lhxK7wiWmyQO6nIUoj4HuQ7mGuiAhGvvuZPLQlQwnDmGrpNdptXvNLNNhXNHpaq4UJEtKHOZWiTNNpL2QL6YGGt9vEEMq38rRYNdG585iYSca+cS+x2ZCXrzRgqE7z+ZgoWzVPK0JKx1zhdlXhxqmBJHRJxXDqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=fWnluPAV; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="fWnluPAV"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43f9b120so1290177b3.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790091976; x=1790696776; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e/G+x8EZ1Ezei3fqyde5MtjxhZdcvZ09vtY+lp4RtkI=;
        b=fWnluPAV150JDAVRdWHGHXPZ1kEXrvrfEzQCYSe/UVNmni4cl19yNf0gZzLHTuvL08
         kBGRA2tsCSTxLE4f1fKgNK60wt9PW0yQ23OrSq40J86+UuGF03/1fCx2fKRNamCRgOXn
         XYlcaEEgKcDhCGJG+2hLB76ygbK1YXh+3oSYwoPEExEzMl9lk0JwxPWgNTKqYkb9UuIS
         Y/p6UuxeMWd4JOo8GoRz6VYTjFxQ+pJHRQaqfQJLP3RU0cCh4cC7/GhgLAc2ZzniT/Vr
         +lZxIbfgW7vrWab5DlmCwdobDU5fAR1DddDKUNJecRM4zGkRMMqON7Wt9v2TDqiFcLNW
         aB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091976; x=1790696776;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e/G+x8EZ1Ezei3fqyde5MtjxhZdcvZ09vtY+lp4RtkI=;
        b=kCYVgIBRTSSJLQQCxt5SrqnsW3P48AvvmSCEXeUh9OVvm9WXr8ytTbf7uUq/rSQsb/
         OW+4QbYXBxJakQCFrzj0EKNdP4M7XFB+e+T97AiaYQLqsffwYaXzsa99Ob0+f7rWhpSp
         cVPhanu4PLlM4j5djntnC0RFqUdsA8ZbOALyxCMJEmovIJeFiVLkpCpPilK11xHXMxfh
         WzJK/qjgRQiFPh3iT7cc+9UI9ADVsY8DxHt745UgNLOGiM0TZHtcUDPQyGn7y7C367BJ
         Xzc+LmDI+jP6ajrQ115N6JPGA4WuuH5hg9Mq2LO1zXjtamU59J3NxvEwjWr/zbekJAiJ
         Z4WQ==
X-Forwarded-Encrypted: i=1; AKwUvBxutvSw0WEzZdYBXNrpKKSRFz/tSB9YfU1YvWm4tCQzrBqlCgrEd8qO/4cm7Zu4Y8sgBXx1Cchh@vger.kernel.org
X-Gm-Message-State: AFuF++nOUxhyxWePt9UeBl5It/piwuGBHTeyyBKPyag8vYNfyXcIgVzT
	IGNughrZ3VsqTklC5ZJ5h22NCMjmsf7PYpLE7XyQhGKAxiY9tFIpaaewYfKQp6ewTA0=
X-Gm-Gg: AYBFou2aTGkW1Y8WCwqxTfo3fP250ommkRkZz1BopQPw/ctapHkHi+H61dxlpjxL1Qn
	b9PmbDTzxcTWb2X26fLeQ3MiH9OpMVD+uOnR4jO9TXg9KzkgYnrjFYVy6sPQFlsacUdaACJjBAL
	4Q38TUi1x6Hpqeyfq1XvO6kloLtn+4Bfu3EQy+i/N29u/hdUmr14NMUcigO/oPjMjRy7NQxhT0l
	PyCTl76xJrJIBC6YiPNCbF89AlnCamazLmOlTO4RtvFlL1xUS9t1Z1CRV/GXCXWy3JSItAZAOZF
	bhZ5M1wbNZJz0FS5Hj1hy9CxOGgmSaVa3RrEbWvatME7Qg9w0a2Kk2twmhrM1rV3ebHCRqxV4Gv
	dTcEEDTZODH+Ajsy/4DLyrVSm8PSj8t55686Sid6RX/Ksa7nUj4iQeNe96ZhFXF4p4CbWOXRA2D
	LdiFzfzgYrN9IGXClE8TZR1YltAQz2SO++NVrCdEAICZI1jJ2CrWyU1/HVfxDsyRyFv4gD
X-Received: by 2002:a05:690c:4990:b0:871:cdc:eaa5 with SMTP id 00721157ae682-8973041de06mr56957107b3.1.1790091975385;
        Tue, 22 Sep 2026 08:46:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532e693f69bsm8080941cf.2.2026.09.22.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:46:14 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:46:13 -0400
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
Message-ID: <arKixeYuuUKye7bL@cmpxchg.org>
References: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKZpJDpsavixjPx@cmpxchg.org>
 <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>

On Tue, Sep 22, 2026 at 05:30:44AM -1000, Chris Li wrote:
> In Chinese we have this saying: don't apply things to others that you
> wouldn't want applied to yourself. Do you want to participate in a
> technical meeting at 1 AM?

The only thing I would like less is having somebody else make that
decision for me.
