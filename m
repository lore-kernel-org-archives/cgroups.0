From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 3/3] cgroup: Do not take css_set_lock in
 cgroup_show_path
Date: Fri, 5 May 2023 05:45:58 -1000
Message-ID: <ZFUktg4Yxa30jRBX@slm.duckdns.org>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-4-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683301560; x=1685893560;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PeJDF4qNyObb/6dnFVDbh66VJOaqj9OlNV5gVoC6Lw0=;
        b=ebChKD9JPNufACPPpce7Y36WdoKdtJnEgc472nYmg+3STxvplm1sSK2Xx8kf83TcqL
         BX1o46mJB9gs4k9aj9vd8GvU6FG8zcgR+80Q7iHHHzt5sSoCQxrha8ZWrAVqiGYh9kwj
         jRksz39E3pzbBJ5N2IDtOTzNvK2K/RKWSxhWND9eNT+dFhw7pRclnkyE8WeBjGW1h20k
         Soz/FUBG8C0R4v+N9JsPibT1rsEK6yyTIxOOIagO9CXo40nRo4WXSHDczqSAIKqr/lIc
         k5vhf5ImNmDMCRXfs8M/V9qzMJxpq4KH8r9EwqBZ/+zM9ZTjGXdj32TRVawJM7uQUCD8
         l/tA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230502133847.14570-4-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>

Hello,

On Tue, May 02, 2023 at 03:38:47PM +0200, Michal Koutn=FD wrote:
> /proc/$pid/mountinfo may accumulate lots of entries (causing frequent
> re-reads of whole file) or lots cgroupfs entries alone.
> The cgroupfs entries rendered with cgroup_show_path() may increase/be
> subject of css_set_lock contention causing further slowdown -- not only
> mountinfo rendering but any other css_set_lock user.
>=20
> We leverage the fact that mountinfo reading happens with namespace_sem
> taken and hierarchy roots thus cannot be freed concurrently.
>=20
> There are three relevant nodes for each cgroupfs entry:
>=20
>         R ... cgroup hierarchy root
>         M ... mount root
>         C ... reader's cgroup NS root
>=20
> mountinfo is supposed to show path from C to M.

At least for cgroup2, the path from C to M isn't gonna change once NS is
established, right? Nothing can be moved or renamed while the NS root is
there. If so, can't we just cache the formatted path and return the same
thing without any locking? The proposed changes seem a bit too brittle to
me.

Thanks.

--=20
tejun
