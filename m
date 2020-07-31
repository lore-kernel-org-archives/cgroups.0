From: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2][next] Use flexible_array_size() helper in memcpy()
Date: Fri, 31 Jul 2020 12:12:07 -0500
Message-ID: <cover.1596214831.git.gustavoars@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215164;
        bh=pLbeAibfw5n2vkRG3FD5oxVwpEDd8hei+OHLkZgRQvw=;
        h=Date:From:To:Cc:Subject:From;
        b=Hjwd8hIOq2+YnSWgcfAaNT3mNNczNPK0tA7gx9oFNc8GF8v0yf3VaLACd2KhJjoA4
         SIBdIPBq9kLq+UFq5caZc18jgsGVVHJAAN4S4KuZl0bk1v34gwmAQXYRpLaaKeVLNu
         6C9M00qHahqAzb6E2MjmIm1ZUkDnfk6pTmD+ahFE=
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hi,

This small series aims to:

1. Make use of the flexible_array_size() helper in a call to memcpy()
2. While there, use the preferred form for passing the size of a structure type

Thanks

Gustavo A. R. Silva (2):
  mm: memcontrol: Use flex_array_size() helper in memcpy()
  mm: memcontrol: Use the preferred form for passing the size of a
    structure type

 mm/memcontrol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
2.27.0

