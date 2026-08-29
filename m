Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032011C5D72
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788013953; cv=pass; b=UlySmL/SKEHstPScdzFhPyx30awqd/9BJQb4ZPIGtGd/grx1AamJNp06h9L2wuVZHfBQ9UNuVA0TLt+YxbtrHjOa5sukAuZV/yadJd4P1jaaWzVTbCPSborOXAzmD52lSlobyaEdRU2yJ8Iy5I4dShc28P0zuUhgb8Cof/ytPyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788013953; c=relaxed/simple;
	bh=bw9e0RkPAnFNpT6iU3Y4+l6yC1de+Muma8XPrpWZVgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6BAcZiNfHvvm26ikup6Sgl67ayPdg2GfonVSaYhJLVwuyAwy7Co8gBJEz14RWqfVZjEluOJCrims+0LT+tmuEXECR7gSy+D0+HMAiH+4KiXjNdqZf1CeP9rcg3D2EkzX2R0ZVYRqmqBILJXLvQ/uhzFhfx40iAzw5m+nNEbchk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJvacSe8; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJvacSe8"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2531f453eeso321951466b.3
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 07:32:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788013950; cv=none;
        d=google.com; s=arc-20260327;
        b=UuAlf/bgtcvEn21f6rvIIkMnA9sUJt0TqG1QOoH8BO1MHM0DD6bfTMXkd9b28EEHfD
         LjXgR77yrXHK1BPl04EH3c0gKWcPPkdOjVBQDj6p2zS6hzxr422Ckvz7BG2GPzza9EPw
         iOaW+wUkiauXLOJQTMHaLUu/GqyEqwyXoaW6CJX8FPmMChYuKIKdGEPhUzXKdhZns1pr
         kNr36/4W5/BiVIyLG7iKvbmQh3HNlTkx4RIkUnXheUCpuYx8i3/CZTgvJHMEnqPr4Nau
         ykFVLV7JVOIjf9tBFm1J75UajpH3RlKZtlThJwmn5FOeA7Ay/pJmwpjiT76JejnlMrLT
         qD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
        fh=Dx5+RPaRB4bIkdAXrkmNBYCLtVRQ2Oli7I7RQ8/s5R0=;
        b=BNDdRSp7lQESMZzgiqvajYIHlPhcvsaE+WPRiQ6ys1q6oLW2bn2noimKe16t6INIew
         j8ssej5kvOQL5yAMm/slcJkt5YnMgWk5fZ5uyDPacgrPTpiWLhc+6pmFwJxG8Uldk/gd
         wCKy3ejoJQt9ZUjf3Vzt+nrB9E9UFb4hr9YBwD7plky/zK5fQZEpDL/vJNjkA6ymvhK7
         D6/K3l6joEq553pgL0scdyNezHU96bmr4dbxwxApmcA7gV3pIoB2K/OLj75ayr1W7iUc
         JDi0WgTY3/xb5c7sXiFyOh5Oon3M5sZ4aPker3zDVtlVvgYxm5czPNnHi2J6GkdL2Tod
         NJxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788013950; x=1788618750; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
        b=aJvacSe8d8dMUG1tFKjW5ZeX6dU0OgdMfSIomUR5iMktRI+3Z40dN69p6OpS/rgrKQ
         BavwMUGMAqXtTNxvLjVGGCGqEfD/rCVlF+uo8zX9bYUE02AbvsuEqdZtP1afwj95ShID
         s31tX53rP5OPrkGsw8Xp+WZb2hULx6CbHrwRnmXP/ou+4hn3QiD82qN1S307ZNADQv1q
         qxZu0mkxG0qLBRa2oqQwrPe3zDbpCU4nO7ZIcUNgevTbU+HxvrUymqsb0ppCxxkQ3b9d
         eSOxfi+xGpcMrY/iAGPnA8pVXq+rOE0szRuH88fuP3psG2oKzH9v4GhSjvZSsOy8VmSb
         ow3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788013950; x=1788618750;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
        b=eO07ZKD+58J/5nPXQt29Oo2uK9+lKySXp2HONbssNSqeYym5Y5+VtAPhLXWC7k1VfD
         D+BlXwl54UsrB5i3bcgHcafosqz8NV7Sz6ROMCUWrKyiSxPOTkMw4l3hrjp4ereCnMys
         t7mR+WRj/CqH85e54pXSY00I4ioWeJnhJmktMz+FgvYMdvoHBsi+riFHb99PJ0TKX6xy
         skgKg92ZIk50C8FyrSIXnrODyj928tvTIYSu6ELnUTEFK6gJvVNDuKfkTLFjirzf9Cym
         7ZU9NWNvVEhLF9uNFQk7/8Zv17hHIvTQpcScSRCSGEws6aQdqQ+aZLeWArEdd2mafhZK
         Wcjg==
X-Forwarded-Encrypted: i=1; AHgh+RqTceAQmqCy9fbWs6rGSR5inM8oLUFsUiUAAPJ/rGmWMUWkwzDo2XnURE1dQbPFUyKXfgi9FKO6@vger.kernel.org
X-Gm-Message-State: AFuF++nR2w3fjy8JrUaZmtSS9nmsGqomy/02NbSu/O+debH7yKsHVmKY
	mdimALL0EuK7+vnExKg9PVrzMo0JUrIcmPbnSvR9QjR6vyvJbZhdYaXY9NIrfYlmz50m2ZS+0dw
	soEmQgly+Ud4L9bYgDhT2hPeeDB4dJuc=
X-Gm-Gg: AR+sD12OnoLfKB2406+fC8uKsSa4YK6DqMaSN1+dcF/H5G9CsZQ2W8xlRwTJEz6VWuP
	5PZjnAWrNdX8g/KlYRhF/+y5LpLvf9eLl3Fn04P3hpwyCyHwNRQUXNzEO4/07kLqK/kjTuI8ajF
	cAIXl8W7rbK4jDcC7bgBHE1cSwsoEk5PhckpbQB8KXlFiReTvxoc0q/KL30XDDvsghAnSFS6NsG
	AWONzicZSUSzycBfShdSNe58aB2bXSuuULjwBNMzMcMAgjxQBHmVEHIuQkLwTR8PVwcOS8pmI4r
	GbaPLSjHIpI3jkMSEqOU0CX+st0NKHwW9O1IwC27EyQ6KMYDDKPy0JZ6mdrLmwXpX+6/WKKN8yT
	fTg==
X-Received: by 2002:a17:906:99d0:b0:c25:6210:84e5 with SMTP id
 a640c23a62f3a-c256210a3f9mr776428566b.14.1788013949866; Sat, 29 Aug 2026
 07:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com> <20260828052949.52874-1-lianux.mm@gmail.com>
In-Reply-To: <20260828052949.52874-1-lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 29 Aug 2026 22:31:53 +0800
X-Gm-Features: AcwNN1U1XN5oJYNoIA4DZfdB5v_IkrXwFftUeLIhH3MOVieiywGaW9p9wEVYMfA
Message-ID: <CAMgjq7DONqF_TZaxtez0fVzxyNdiAzMBikM2nKdQojRqX_n-rw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mm/mglru: use explicit tier range in read_ctrl_pos()
To: Lian Wang <lianux.mm@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 1:30=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> Hi Kairui,
>
> > Replace it with explicit (tier_min, tier_max) parameters using a
> > closed [tier_min, tier_max] interval
>
> While touching read_ctrl_pos(), would it make sense to add:
>
>         lockdep_assert_held(&lruvec->lru_lock);

Hi Lian

Thanks for the suggestion. I don't think that's necessary, though.
Nothing will go wrong if the lock is not held, reporting warning is
kind of over react :)
