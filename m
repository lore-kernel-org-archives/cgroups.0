From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Mon, 26 Sep 2022 10:32:49 -0700
Message-ID: <CALvZod5QProaWZgT9ykb-vrrRHBpLfqVGgW2jd-Td8aX5MBZFw@mail.gmail.com>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org> <20220918092849.GA10314@u164.east.ru>
 <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g@mail.gmail.com>
 <20220921170259.GI8331@blackbody.suse.cz> <CADxRZqyAG5Co9hLEp6p8vPC9WyGERR6un-3Rqapyv14G4vPXJw@mail.gmail.com>
 <20220926102812.2b0696a7@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <sparclinux-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=TOL7/M5VC7IyaSB3mrG/Ev31pWD9V/lWqppYMcTBfKM=;
        b=p6wexZ/Y0XqAhWAhWQ77q6u0CZ18nCzFEAe4bvVo7S0nEW6WuU84QbuIrXyLDHCaTI
         3KVY8/kPjnuU77CzmlnP2RX4B3VTuD+DX8rWAEp9ezkmsub624war7PTzocq0HhayQIP
         GMxA2Fj0qaw1SQGShM7S0FWzngjRfNeVBrilh6JsDYrekTU3j+x+9dO9Jg8FhujrX5gZ
         /TgpCO0SU+Id76XQMhc88uxX0Gxua10lmdNBqa+I4rCCzSzqO6kIbK1MKmXUlUBcdR1P
         LOKdsKRMbjEv0YfhCObzK+sUJ9DWdA8R5U5Pli/Q77cTZRdgCOChdjHXdIV50NkngFID
         P8Ew==
In-Reply-To: <20220926102812.2b0696a7@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vasily Averin <vvs@openvz.org>, Anatoly Pugachev <matorola@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>, kernel@openvz.org, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Cgroups <cgroups@vger.kernel.org>, Sparc kernel list <sparclinux@vger.kernel.org>, Thorsten Leemhuis <linux@leemhuis.info>, Linus Torvalds <torvalds@linux-foundation.org>

On Mon, Sep 26, 2022 at 10:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 26 Sep 2022 16:06:08 +0300 Anatoly Pugachev wrote:
> > On Wed, Sep 21, 2022 at 8:03 PM Michal Koutn=C3=BD <mkoutny@suse.com> w=
rote:
> > > On Wed, Sep 21, 2022 at 05:44:56PM +0300, Anatoly Pugachev <matorola@=
gmail.com> wrote:
> > > > reverting this patch makes my sparc64 box boot successfully.
> > >
> > > The failed address falls into vmmemmap region (per your boot log
> > > output). It looks like the respective page/folio (of init_net struct)=
 is
> > > unbacked there (and likely folio_test_slab fails dereferencing ->flag=
s).
> > >
> > > Would you mind sharing your kernel's config?
> > > (I'm most curious about CONFIG_SPARSMEM_VMEMMAP, I'm not familiar wit=
h
> > > your arch at all though.)
> >
> > mator@ttip:~/dmesg$ zcat config-6.0.0-rc6-00010-gb7f0f527dc3c.gz | grep=
 VMEMMAP
> > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
> > CONFIG_SPARSEMEM_VMEMMAP=3Dy
> >
> > I do upload config and boot logs to
> > https://github.com/mator/sparc64-dmesg
> >
> > building a new kernel version/releases as 'make olddefconfig && make -j=
'
> > current version of booted 6.0.0-rc6 is available as
> > https://github.com/mator/sparc64-dmesg/blob/master/config-6.0.0-rc6-000=
10-gb7f0f527dc3c.gz
>
> Forgive my uniformed chime-in but Linus seemed happy with the size of
> -rc7 and now I'm worried there won't be an -rc8. AFAICT this is a 6.0
> regression. Vasily, Shakeel, do we have a plan to fix this?

I was actually waiting for Vasily to respond. Anyways, I think the
easiest way to proceed is to revert the commit 1d0403d20f6c ("net: set
proper memcg for net_init hooks allocations"). We can debug the issue
in the next cycle.
