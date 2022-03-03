From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup()
 handler
Date: Wed, 2 Mar 2022 16:53:19 -0800
Message-ID: <9f8d4ddb-81ce-738a-d1f7-346ff9bf8ebd@infradead.org>
References: <20220222005811.10672-1-rdunlap@infradead.org>
 <20220302185300.GA19699@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=CYkF4j9ODOf6PWDsqe5HpkOYKbyWN1x6jkFXxFgeeIM=; b=PIczBbwmNfBbdA0anRDnP9sLT/
        D3I9C7NxiY8yS5fxYRvD+X1Y8NvnQsAJ6KbMn84+WnmOEZa+a3EleuPGwa0XtNrxd/DGw/ef1rtU1
        3bIf2Ys5DyFChgu/ygcGG8BnMmFukl2vNmbxFArASFSZY6ZyT0XLRlLQa8fSBlXNPCjJoowfq4jS9
        bp+QFItZn2MI13nEq4VGHgZejK9Npe9yw+z2aObmhsMYU9751wB+FsdPvNlHBJng2wtpaCJ5DwQqC
        lk3yguR7pD9mPkSib4B1IcaZyooSafWXX2OS9hQcj3fEAcyqabJ6+MSKUbxvAzcBFKIHSE/Qq0kaC
        PiXVDfqQ==;
Content-Language: en-US
In-Reply-To: <20220302185300.GA19699-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 3/2/22 10:53, Michal Koutn=C3=BD wrote:
> On Mon, Feb 21, 2022 at 04:58:11PM -0800, Randy Dunlap <rdunlap-wEGCiKHe2=
LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> __setup() handlers should return 1 if the command line option is handled
>> and 0 if not (or maybe never return 0; it just pollutes init's environme=
nt).
>=20
> Interesting.
>=20
>> Instead of relying on this '.' quirk, just return 1 to indicate that
>> the boot option has been handled.
>=20
> But your patch would return 1 even when no accepted value was passed,
> i.e. is the command line option considered handled in that case?

Yes, for some definition of "handled."  It was seen by the __setup handler.

> Did you want to return 1 only when the cgroup.memory=3D value is
> recognized?

Not really. I did consider that (for all of the similar patches that I am
posting).

I don't think those strings (even with invalid option values) should be
added to init's environment.

I'm willing to add a pr_warn() or pr_notice() for any unrecognized
option value, but it should still return 1 IMO.

--=20
~Randy
