From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup()
 handler
Date: Thu, 3 Mar 2022 11:14:06 +0100
Message-ID: <20220303101406.GE10867@blackbody.suse.cz>
References: <20220222005811.10672-1-rdunlap@infradead.org>
 <20220302185300.GA19699@blackbody.suse.cz>
 <9f8d4ddb-81ce-738a-d1f7-346ff9bf8ebd@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646302448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8hn+K1tGTvyF5f1kaIIx3YbkP2Kix2PLC93JbSkSwA=;
        b=iYFyvIhFWJzafeqkx9+fNKRZuKDSbPBEA/i0TMOKUK1aPllk0+d7K8Tfl+D3iwm8/e5BW4
        RgBKDKqBztOkqfV8lO1BPFfeF47Qwzp8Lc9UfhVyePkFd6hXmcyyU+In0Fyd230h+Nhqk2
        rvm1rmfx4/FU10+Oytt9coDRtbl+cVk=
Content-Disposition: inline
In-Reply-To: <9f8d4ddb-81ce-738a-d1f7-346ff9bf8ebd-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 02, 2022 at 04:53:19PM -0800, Randy Dunlap <rdunlap-wEGCiKHe2Lq=
WVfeAwA7xHQ@public.gmane.org> wrote:
> I don't think those strings (even with invalid option values) should be
> added to init's environment.

Isn't mere presence of the handler sufficient to filter those out? [1]

(Counter-example would be 'foo=3D1 foo=3D2' where 1 is accepted value by the
handler, 2 is unrecognized and should be passed to init. Is this a real
use case?)

> I'm willing to add a pr_warn() or pr_notice() for any unrecognized
> option value, but it should still return 1 IMO.

Regardless of the handler existence check, I see returning 1 would be
consistent with the majority of other memcg handlers.

For the uniformity,
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

(Richer reporting or -EINVAL is by my understanding now a different
problem.)

Thanks,
Michal

