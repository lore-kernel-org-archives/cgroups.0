From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Revert "net: set proper memcg for net_init hooks
 allocations"
Date: Tue, 27 Sep 2022 09:23:08 -0400
Message-ID: <YzL5PNgp/43a5N6K@cmpxchg.org>
References: <20220926195931.2497968-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <sparclinux-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=vjjvifvRbyamwiKwXAGlU+rtv6BwVcIgFInlxUxWOFk=;
        b=Me2NuFx7YYw5/6VUYsnM6+enyki04bmQjGYAmmDKSrf5RtYBaK9xqhr2G7e1NqO0QF
         Ul827IrzQJQRfEOyZkgCsX2wki8XYKYL5cf9AzTRaaapKaLlle+822jZUhlylP3lvpFO
         UzIDaN64+l2wrTV3kGjAhxlCc5+oL3qZq2hKSlJPIpr5pmyESjbis/n61/yAxqrx5wJe
         nBoHEvtvfn/inr7H2QrVltHXGms0vN5cgTjxAgUBCyKQ/QUm7FsmTSNJUwJhqi8aZIvu
         fYk0CsF+jffSBWIMmB3n81wwlP0GqE6NeVwKpmS/G7hpZxBC7g//LH0VSKKAmF+MH6yz
         nEvA==
Content-Disposition: inline
In-Reply-To: <20220926195931.2497968-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Anatoly Pugachev <matorola@gmail.com>, Vasily Averin <vvs@openvz.org>, Jakub Kicinski <kuba@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, sparclinux@vger.kernel.org

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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
