Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1F32E6BD
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 22:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785882126; cv=none; b=pvTl+azDS+yErrUxzNDZG296mhUHshokyMa2/DacIa4ns7TpmYvOp15EeE0xe5d1Yep7H+R5NsaRLBonFiN+mTFUXK+s7yke2fl1iTMRRERaCMsWOPLpPybyTpzYidqtzk2J15liy7VS6AyWYZd8q/QZvX7zsHbYljT5saBvWn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785882126; c=relaxed/simple;
	bh=W12dzO7vgZVNKvjV4g3A7AtcxuECvisYvjLVJtUwhC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efI/7qQ2ZGdxgiyssttDwNVyzd1G+b3uFfvTpNOJriJRlhG3Wf59In7Ah57+xEzz2pziGgRwZej2NhTuW3b2EP3ddMfIOmoa4fZbWY0+Ac4A2o8xLvaUn8fGQ2eV6qa+k/XywbxEK1LAEc6ASGQ3b3tll8D0xYZInLVZoDKrdfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6CJ6zNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6CJ6zNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2019A1F01563
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785882125;
	bh=W12dzO7vgZVNKvjV4g3A7AtcxuECvisYvjLVJtUwhC0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H6CJ6zNeAtAQ3czxPb2+pbEEI6hmiHWxWv9RE5aFyKKFrXkKk+QrAgTCmb/NTP43z
	 8skLFk45BzQAwII5zXNbFtzkiI5KeiqBsA8YUczb7d+eonBtZdhWYWTri0hDsvO/B9
	 Mb+saXeYdywjEhFHAWDWmuckw3XThl9b81viZbaX1Du+HSI71ByigszndUe3mD+ZqP
	 NvKafAExsCN+oyB8rx6WASiBVqNfUEgF9hi8txdRXH3t5st5cWq5k7YxLHRTLLQRe4
	 Qyc3S/02UY/2P9T56jF88VOFc3P3ecqLJnrSgwnKsKOt2JJBDIK4BXxLuE/qRPZ6v5
	 BcD4KfKTAqSHA==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e533aacf2so23486385a.2
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 15:22:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqnoIbnzR0G606206w1JtW7sTmLbS4HWwYDgZ32osD0eolCV+bOa+uhqW3uHMDdSZTpZ6CI9CDH@vger.kernel.org
X-Gm-Message-State: AOJu0YympIwX+UzvM1I46E1UiyY7zrYPemT5qix4Gj9ks6klfIHijaAo
	Ig9gSSztijNpkN2RH4ZPX4VG2K8e47ArIIqIA97PDdnuS4bQhYn8qxofVLXzP7YVAOCnbAYxhZy
	iJlBnZDDexeLyfT2uJ+uB2Vx8sSvq/HA=
X-Received: by 2002:a05:620a:270c:b0:92e:7cc9:a888 with SMTP id
 af79cd13be357-93649119b9bmr199237785a.2.1785882124377; Tue, 04 Aug 2026
 15:22:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
In-Reply-To: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 06:21:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wcq5UXq1RAoD8iygnKV95o=D+nOd01ncz4GQJ8Bge3ow@mail.gmail.com>
X-Gm-Features: AUfX_mybQ80Lx8PwialdKxVIhIqHFVhcCtwxrLLGtSQkGb3zGfEQ2A4Kq4si_Ec
Message-ID: <CAGsJ_4wcq5UXq1RAoD8iygnKV95o=D+nOd01ncz4GQJ8Bge3ow@mail.gmail.com>
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 6:09=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> There are a number of internal headers local to mm/ which reference
> functions and data types without including the relevant headers.
>
> mm/vma.h is a special case that intentionally does not include additional
> headers, but the others are not.
>
> This breaks tooling like clangd (which is where I noticed this), though t=
he
> build is OK due to the C files including the headers happening to include
> required dependencies.
>
> It's better to be explicit about dependencies anyway, so add the missing
> includes and fix clangd as a bonus.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
