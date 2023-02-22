From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Wed, 22 Feb 2023 08:57:08 -0400
Message-ID: <Y/YRJNwwvqp7nKKt@nvidia.com>
References: <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RIZyLsJETVGJGmuhJEPdBBNsg/5QmP04eJhuH91Hk0=;
 b=TntXxiLzAo+Kamy6sH0IlJzfsvDL+LHTJlcaP+B3dP0AFGrcME0nXipcCynUyCXYRGJh4Y43dCasn+qINtYu6HzXGHUgA+7OVUnv7LGUiZjaNLLRQEB+FLEj5ztLxfXBv5j0mCwSwlFljuSSqx4ba40WI3S6GoP93hD0iDGllbGUGyxhCLw0A5VU12o9njw3dDkpXmbFHxMyq1S8TuNJ9MhYin1/h7KAIgRtZ5+rf0bxpX8D5x76Mm6xXji9nP5GN2wikXoeJl9I9zW1Dwbu5ZU2PYqo9D3WzB/JNeC5tXawEh/yOe3WVCS89cLgYVKQnuadOG0jNdI+Ici2SDhXYg==
Content-Disposition: inline
In-Reply-To: <87o7pmnd0p.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Feb 22, 2023 at 10:38:25PM +1100, Alistair Popple wrote:
> When a driver unpins a page we scan the pinners list and assign
> ownership to the next driver pinning the page by updating memcg_data and
> removing the vm_account from the list.

I don't see how this works with just the data structure you outlined??
Every unique page needs its own list_head in the vm_account, it is
doable just incredibly costly.

Jason
