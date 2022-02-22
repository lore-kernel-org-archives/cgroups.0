From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup-v1: Correct privileges check in release_agent
 writes
Date: Tue, 22 Feb 2022 08:13:09 -1000
Message-ID: <YhUntajxL3YrDXXg@slm.duckdns.org>
References: <20220217161128.20291-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZB+Gu7YpATSeA5t+N3YCnRgIG2ZtKKuUBwZ11FHjUfE=;
        b=RA5ZZcKVCaJu4k9+anC+SKGCGQerWGqOhKJaggLKQV7bGyHctRS7qpuJKLwzWJx3Wv
         Dey7ap2D5hO5jWRp53MeEF17hEm4V6cizKN1IjBybApavS5+4d3vKAO/eKEsgi5+pAct
         T9nbvEwNjHtHjH9OgbB4FdyB2PvlFDtrjGVHPbwXprRB+8x87LSxY4CLxE6wq0eSWYp0
         kjemJDp8QbuSY3VuODIS7aPNIfSVcqPvUNP1XKdmms7J15ZcFjzqJV529On+vnt42uIg
         ebWKFeYpqqrrqB0/DsXzqj2GtLcqPx0Qv/SuFKNMC/hqf3R+P8HbwUJWy+I5Ua+Q1Qjs
         f7zQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220217161128.20291-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>, Tabitha Sable <tabitha.c.sable@gmail.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Feb 17, 2022 at 05:11:28PM +0100, Michal Koutn=FD wrote:
> The idea is to check: a) the owning user_ns of cgroup_ns, b)
> capabilities in init_user_ns.
>=20
> The commit 24f600856418 ("cgroup-v1: Require capabilities to set
> release_agent") got this wrong in the write handler of release_agent
> since it checked user_ns of the opener (may be different from the owning
> user_ns of cgroup_ns).
> Secondly, to avoid possibly confused deputy, the capability of the
> opener must be checked.
>=20
> Fixes: 24f600856418 ("cgroup-v1: Require capabilities to set release_agen=
t")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/stable/20220216121142.GB30035@blackbody.sus=
e.cz/
> Signed-off-by: Michal Koutn=FD <mkoutny@suse.com>

Applied to cgroup/for-5.17-fixes.

Thanks.

--=20
tejun
