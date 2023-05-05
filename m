From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/5] memcg: flush stats non-atomically in
 mem_cgroup_wb_stats()
Date: Fri, 5 May 2023 05:19:11 -1000
Message-ID: <ZFUeb9UNmOETRxYQ@slm.duckdns.org>
References: <20230421174020.2994750-1-yosryahmed@google.com>
 <20230421174020.2994750-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683299953; x=1685891953;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QrpziiuRPJpNoKcFlKlNDYP3hr3GKLDf970mOGtKvuc=;
        b=Fj4FzNjR0Oz19A6ZjISxtRCIB+gQ3mormqowoEF1ln4EAGyvrsBXyRSKbqhyQLC+in
         o5fjKNvQ/yN0VkIUe2FBxZQFo8CuBxoJ2BHDLSjYh8+HdnZ3QVP+E3dS2Plzshy/p0pl
         Hf+Ipbvxtcy7Hi/3cT8d8Gb8J4VkAhSsEMdiy5ZKUcaPh932ZSd20eO3fYebZugEA49X
         mUUklW5aR3Rdjne/IP0kOlzyLqAlnitsZ0Nl/BTITfGcIQAdz5oicdNCa7j+DyuEkA1C
         Vd0a06+ACDVmjHz4Tb9Av8qWUmDjShH/SvaPwFsAA9tTqizN1m3Qn5TBxTXirG2Ivak4
         dJgQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230421174020.2994750-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Apr 21, 2023 at 05:40:17PM +0000, Yosry Ahmed wrote:
> The previous patch moved the wb_over_bg_thresh()->mem_cgroup_wb_stats()
> code path in wb_writeback() outside the lock section. We no longer need
> to flush the stats atomically. Flush the stats non-atomically.
>=20
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gman=
e.org>
> Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

--=20
tejun
