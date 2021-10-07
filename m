From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: memcg memory accounting in vmalloc is broken
Date: Thu, 7 Oct 2021 11:04:40 +0300
Message-ID: <b3c232ff-d9dc-4304-629f-22cc95df1e2e@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=0BFtNW+uAic/gbXLZdgsDlSO4sw6Ifw/xoJaDaI55bU=; b=sFxVuxGF/K/sI9yRXtt
        iHelb55imrMwNRi00EL//AAgf9cXXhmdFaqfFlGjfOH9hCddiUk7c5W6sI2GLrh9HN41qQSKv/n/U
        WDKnaXDE6Fhh1q7If9NFVKPoW5fKf3hJ/EOgpbOJ+ver0iKgznhwp8QFOo0n5dKpOnV3Cr46vYA=;
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

vmalloc was switched to __alloc_pages_bulk but it does not account the memory to memcg.

Is it known issue perhaps?

thank you,
	Vasily Averin
