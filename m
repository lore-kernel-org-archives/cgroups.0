Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E9151DE17
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789756756; cv=pass; b=jsTyt2bvLr0WC2Sn7AxHmzJTHM0noUiViAdZykpT7zlIwwxBwmO5XNgjZaUkRfdacSpOWPUZZqwz8tFI9Ixvt8B9SDIITLa+gz+zgZ5FVpFv1gxh1JTWxLD2uPFfio12P6p+y99N5o4+EA4C+6WX6E4Pi7PcVJCR17/wd7tKEy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789756756; c=relaxed/simple;
	bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T1HTSWJD3NgVMbxSVylENqpCNmMH4cCeIbnaeeMZbw4UC+N//J2Omrn5rCOJywCIOIib5xON9+Gadu6lHPxuk7XPlk2NEzfLggBP3l/4cDF4Swj3fQpJ52648a//1gvsuatDzCEdYob4XnOG+IlKIm3aXO8RC2jHET6ps5XmSz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=obNnlZLY; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="obNnlZLY"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so7949475e9.3
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789756742; cv=none;
        d=google.com; s=arc-20260327;
        b=YR4S8RSs4bblDE0qHTkyvP+yTsjNKib84vw+UkWBnYIZl1JFp45Pi6EnOJK9TqcW5X
         RKxxSN7actCq/JMHE8f49sSjGa8nr1JybwMz5gtqTscOc3Zuu5xBpKHK2DnskfhIZiMV
         rhSFHtEh2pf+CypzrcrxeNQRlBDMw6hdSppeZCkQbO3aOKBTirTAwMLOjLIDnvTInWIl
         lnlgBGcAW2+O1TH+/o3yz1Qe3q+QOytzXfHQyb/YAlJobntGQoF7WHm6LnLpjYUsq84Z
         aGE5N3Ho4mahI4I4ukpGqbvPcfC9Q6yRtWlDnhsaXwIIirRJfY7VZlcotBolWRI2794a
         3Vyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
        fh=LApBWjI4qv+2iUIrruidGgse984AGhMnFFmpuqX+Lik=;
        b=JKQZJ+XRFPMHUM8Z+tJVtiSCG/+nwxS5iQf7UReeQNlibPKRJdcWIbq/bE5z8uZGcN
         fZ3MwBxshHmJceOgbMNPcnL9rxXfq/hejPJfHq3dgBjQ8WdA9CrwQQ36CUyJJnPhhnoo
         oeRqAvIIcOXcB2nPt835gAwfoGveFsQGJb3qO0dKuo3PvG5O8pChPsdPW/MGIgSfnFOb
         P4i3GS7qs5Gn2vvjMKcBcyLaa+iTaN4218Wvx3/n8w9o4NtydJgkJMpFFpO43yLTTnc/
         HUEoAuaYTDrD44pEC8RXnR7/TpyJiIY2euimTaleLkcfauqBIDbaREZa3MHhX6/sAkaV
         0xuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789756742; x=1790361542; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
        b=obNnlZLYFJzew1YQyEBNBo+9UTNHWK5MkuSuP2SqOmDg+26iuoZGFb3EykwWF5tdu4
         0pClMybpon2TygWZD8dORAxN9WaHCYsehi9QZkV0Btnw4QQIMoeqyHX+jCuLOq5lYppq
         LI+Dwlzw+zhoakhNUFHqaSjIlv99xjSbre3bBvnCrcjUW3mrAvxaJ9xEpaRantOaj2Ic
         QNoi7t1PHOKesq7p6xit6jlISLxbLSU1iRCaTXAj80G4Mf3noff87p8eKaTrx6WjFebo
         tAnGA3SOv0ZnnA8KXQ3uYfeO9EqvplfbHqxDwi8bZ96TDck0KfYnC649OwJOQEmGgQie
         8obA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789756742; x=1790361542;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
        b=Wjrmse4UOOxfPSMXZTzmUNPwC6YRrum1gfXDONX4PCcTnHJmCF79s9K1L00bVj/tkl
         Pw04oSqZ5HGw5LYdlf7HCRtBdHtXzT/itEIxBB7QxsPAlayclsuwmO4pyCtGYKabGQsg
         V+kA48BF+om1NogKSajdXc4ln2e+Tbs3ktsM6wEs5jOsnDsQXcK6+jEfo1bcc4GteQCV
         sWMnxujOX/A9Ct+eyNviURl/FcqfNKvga0DGN+V8qt2uT/ILnuIiNOrG8enkGqSQWDY6
         E0HyTuRNm9AKzGb6ZKwnc/SMeNa/Me8q8GqwLmQsysjPRgOyPJn8ge3h6dNQcAS80yBF
         ZCBA==
X-Forwarded-Encrypted: i=1; AKwUvBzq7vPPPmzgZb6VdLO7JayyKzVqfFcUSwA2RPEaUqeTiWDqzjuQlOv4dpoL0v210TkZiJEjl6Zo@vger.kernel.org
X-Gm-Message-State: AFuF++mYVFJ/MB8GHxsD6/SGLrqHsZIBPGyChFV5fd9jzGBnASJC+538
	d1wcEg2GfY1mxSPf8j4n9W5gS++cK9wEDHYCwn0RFxX9smKatqtukzQa7jIcEKpFSBWfQl+ZA7v
	UBquozEH0B/P6Gh1YQP8q+kyr7KDgmz4=
X-Gm-Gg: AYBFou1NoazwqbY0LGrpJcrQdR9CNMF2D6iVdR5v/vpQHgacKoxJ4VA61iaVT9U3Sv+
	kZGxs6W8WC6Q3uhfdKFYrC2fGoDbdd5/6rjP8S0Ch0pmlTZvr6Zhk1vFQe73/A7emPl9fpHSznA
	H8OIb1HyD7CnE/PM94GhWCoaae+uEGnl/ndsmOtDaajcVHXaHe8h2WofdBG4+oMJXc0SQmgi4Wt
	w1qsxyYG2LGq9M/QKk2eFP5oeNp3J3jzt9BTKA0Gb+aHGSOQ6ihdPz7EMu4RvEfbAANCcBH8F9F
	y0t9juuR5MhRdvMNVSQ5tHIu46FW0BiLvcz9+52fNWSVR6xNW6Yp/r0J4Ig6byy0Z6XfAb8jEin
	krId/QHmrOEA=
X-Received: by 2002:a05:600c:3f07:b0:49c:ee01:8c53 with SMTP id
 5b1f17b1804b1-49fc56713c5mr46641755e9.2.1789756742167; Fri, 18 Sep 2026
 11:39:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com>
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 18 Sep 2026 11:38:50 -0700
X-Gm-Features: AcwNN1Wvf5cok67nfOV01MjLnEAhXsQL9tKGdT3-XrD1J_-pQ2FeWcoNTuL8dyQ
Message-ID: <CAKEwX=MO7JjfTQU4NP_L6Uepk_WL0jYBKEB1woK-8brvQqCT=g@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] Virtual Swap Space (Swap Table Edition)
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 11:02=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> Patch 11 is an RFC. It swaps vswap's cluster xarray for the VM_SPARSE
> vmalloc array Baoquan He designed for xswap, to show that the data
> structure and the device model are separable: moving to his is one
> self-contained patch that adds no userspace interface. Note that
> per Baoquan's commentary (see [5]), I have skipped shrink for now, only
> freeing vtable when the cluster becomes free to minimize metadata
> overhead while keeping the skeleton in the free list. I have not done
> performance testing on this patch yet (the number is from the old design)=
,
> but I have run a suite of simple stress tests.
>
> It is adapted almost entirely from Baoquan's code (see [6]), so I have
> kept Baoquan's Co-developed-by and Signed-off-by tag.

To clarify a bit on the motivation of this exercise: Kairui and
Baoquan raised the concerns (for e.g in [1]) that if we were to go
with the xarray as a data structure first, switching it to the
VM_SPARSE vmalloc array would be difficult. I want to check this claim
by prototyping such a conversion. It is fairly straightforward and
simple to me. So it is not a valid concern to block the landing of
vswap.

If we are to actually switch to such a data structure, Baoquan should
be the one driving this, by showing that there are performance wins to
the switch :) It is his proposal, so the onus is on him to drive it to
completion. I'm happy to assist with the reviewing and testing!

[1]: https://lore.kernel.org/all/CAMgjq7AHRzBsbmGOx0s=3DTQFBwcn=3DDEU1naR44=
3sO6x+pJd6hAg@mail.gmail.com/
