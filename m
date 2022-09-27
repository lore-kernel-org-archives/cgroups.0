From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] Revert "net: set proper memcg for net_init hooks
 allocations"
Date: Mon, 26 Sep 2022 19:00:01 -0700
Message-ID: <YzJZIa8xXYZozvov@P9FQF9L96D>
References: <20220926195931.2497968-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <sparclinux-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664244007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAUHGYCO/qQ2SwttBy7KnlWgbLVqmhgcIz7g3trZDTk=;
        b=olgkAn++swZM7w/xk8nii6twtgKZ5RPxlL+GEuWv+NNepi4z6oJsHjDrEzDGEZjvSBaIAz
        39Vj7Iw5tRsZLbE1qm+r2kt9UyeLxm71DUvj8c1RKQ8z/RaGpfb1v4jqzkvNVxu9VBtJgd
        8pZ7/DO788og4cRAdQn8VSjdRc9GkUA=
Content-Disposition: inline
In-Reply-To: <20220926195931.2497968-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Anatoly Pugachev <matorola@gmail.com>, Vasily Averin <vvs@openvz.org>, Jakub Kicinski <kuba@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, sparclinux@vger.kernel.org

On Mon, Sep 26, 2022 at 07:59:31PM +0000, Shakeel Butt wrote:
> This reverts commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9.
>=20
> Anatoly Pugachev reported that the commit 1d0403d20f6c ("net: set proper
> memcg for net_init hooks allocations") is somehow causing the sparc64
> VMs failed to boot and the VMs boot fine with that patch reverted. So,
> revert the patch for now and later we can debug the issue.
>=20
> Reported-by: Anatoly Pugachev <matorola@gmail.com>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Vasily Averin <vvs@openvz.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Michal Koutn=FD <mkoutny@suse.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: cgroups@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks, Shakeel!
