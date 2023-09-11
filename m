From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 11 Sep 2023 21:34:14 +0200
Message-ID: <ZP9rtiRwRv2bQvde@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com>
 <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
 <ZP8SDdjut9VEVpps@dhcp22.suse.cz>
 <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694460855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GtgT2X4Lzwli3PQHVCNnWgiwe9JIqA+mySpJCTGonc=;
        b=inBeglmLIoSjZlhjij03px88WQrURLaG1YUEBgOpUyL20GxHeUP/Y88emsAQxatOusOYl+
        +Tbfps3gPaKBPyOLqvX5fZmSfkSJwTiVn9WprQ33JRTjhOvRWpHllAJj08kGrvRbfkrbJZ
        x2TW/UzxIda62LHY7iSw1knKIKhwACg=
Content-Disposition: inline
In-Reply-To: <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>

On Mon 11-09-23 12:15:24, Wei Xu wrote:
> On Mon, Sep 11, 2023 at 6:11=E2=80=AFAM Michal Hocko <mhocko@suse.com> wr=
ote:
> >
> > On Thu 07-09-23 17:52:12, Wei Xu wrote:
> > [...]
> > > I tested this patch on a machine with 384 CPUs using a microbenchmark
> > > that spawns 10K threads, each reading its memory.stat every 100
> > > milliseconds.
> >
> > This is rather extreme case but I wouldn't call it utterly insane
> > though.
> >
> > > Most of memory.stat reads take 5ms-10ms in kernel, with
> > > ~5% reads even exceeding 1 second.
> >
> > Just curious, what would numbers look like if the mutex is removed and
> > those threads would be condending on the existing spinlock with lock
> > dropping in place and removed. Would you be willing to give it a shot?
>=20
> Without the mutex and with the spinlock only, the common read latency
> of memory.stat is still 5ms-10ms in kernel. There are very few reads
> (<0.003%) going above 10ms and none more than 1 second.

Is this with the existing spinlock dropping and same 10k potentially
contending readers?
--=20
Michal Hocko
SUSE Labs
