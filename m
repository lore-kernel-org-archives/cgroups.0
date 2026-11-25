Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795570905;
	b=Yyg/Hjx6KiIccGBBLUD295mA/XTeE0CivzFX1OatjrWuU2L+4YZXII8iQ2gJhhUNqJc9
	 xOXixi356Ou4XsYsWszxltIKdciscqrBBkcbeTt83TiMIO3RbPgFDUjupGAEiGKpKnSiV
	 a7jT0B7EQB9CAOny0NUjMzIlpapyYAk+nWDYvGkDrBd+3584jokV+6d/z6QR2syzJ/Pr/
	 lGRH6+ZyCBLplZoOFDEWvis5W5QfKrPn56PNSODmef/9rtnK4sNuuv7w3G/EwIfb+ZldH
	 lT+LY4X1WRiQOKjVyeAOWiHseyIJRua1MV7vZnoCKxKx/3Dqkah4NhdCmr7EvR0cN1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795570905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0uALuexdmM829eAKCCxuAtcwAcX/KrdDY7PYwPZUEDc=;
	b=R0sPUV8MCQ02gpc1AcYDCltEEvnAo+fCcPyNd1gCjliL+GdHCkai3smoLntj0Xm85NEy
	 qjK/Jk09Wpmkg1ajlnIAz/tIsWQ6UKppFOBgI8q6Yowi3HoIUIApCW6iM3b/uthP+YmSi
	 GND102UaK9nqTeEj7hnMt1hMi+WkjWDwBPpWGUrGg8uB1/M2afQaHOn0SlZy8SDCRM5tD
	 UVfFTFe1H8KXPToRW277oKx/fpTtoJpCPNArOueBkofTeZj2/nzIJvPsIRrG6rq5M0QE1
	 9NlZqfmIhwLJPJHhTvtlPIj4an0YnlwU48vgGPZ2n4rm/ExMMo5EGxhnXwvCM+a7isw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WizpStaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3312606A323;
	Wed, 25 Nov 2026 01:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WizpStaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD771F000CF;
	Wed, 25 Nov 2026 01:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795570905;
	bh=0uALuexdmM829eAKCCxuAtcwAcX/KrdDY7PYwPZUEDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WizpStaM3pGyZ6aLPTA550frhN/LMtmfDktlk+ZzOz3iB/9QelKkTsH5MLGmLaUyP
	 itQsUN01OJ9EVXPsKFeHuxpI5NnkAeYhBtSez1PS1p7Z1NX7XTCCaakFGK4NSA08tY
	 haGL3bYL4fcmhiMEC+HRMV81GPTlCSor6X8StVGmwxfgythZ08KTWin9PirR7hhgiP
	 B2y6WpUhkadSTyg+rx2gedv/bEQQl+PpRpG7HF5KRmxbSbqUmQV4CliTMBMbZFrU0W
	 /84p1tYb2cgSHsqFS+vPiDXu+86RBRidyrB1S3LMydHmZdLi/C3eUyycB0ue/bZzEX
	 cGp0LT/HvtDFA==
From: SJ Park <sj@kernel.org>
To: Kairui Song <kasong@tencent.com>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Tianyi Chen <hi@tychen.cc>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when reparenting local stats
Date: Tue, 24 Nov 2026 17:41:36 -0800
Message-ID: <20261125014136.98425-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 24 Nov 2026 02:52:55 +0800 Kairui Song <kasong@tencent.com> wrote:

> lruvec_page_state_local() clamps negative values to zero on SMP.  That
> is right for readers reporting page counts, but can be wrong for
> reparenting once MGLRU updates the counters without the lruvec lock.
> 
> Reparenting runs after the forced stats flush, so a negative is a real
> balance that has to move to the parent, not be discarded. We will
> introduce lockless MGLRU promotion which may cause following problem:
> 
>  1. A refs CAS on a folio on the child's lruvec moves it from
>     inactive to active, and its active/inactive counter update follows
>     as a separate step.
> 
>  2. A concurrent isolation of the folio reads the folio as active,
>     debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
>     to it.
> 
>  3. The child is killed, and the two __update_lru_size() calls from
>     step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
>     +delta.
> 
> The child is left with NR_ACTIVE_* -delta while the parent holds the
> matching +delta, and reparenting the child's raw value is what cancels
> the parent's credit.  However, if the child happens to hold few enough
> folios for that counter to be negative, lruvec_page_state_local() clamps
> the child's negative to zero, which drops the debit instead, so the
> parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
> total overcounted as well, permanently: the child's local counters are
> gone once reparenting is done.
> 
> So use a raw signed helper and reparent with that.  Ordinary readers
> still keep the clamp.

Makes sense to me.

> 
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
