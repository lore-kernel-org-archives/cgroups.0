From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-ioweight
Date: Sat, 15 Jun 2019 08:57:43 -0700
Message-ID: <20190615155743.GF657710@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614015620.1587672-9-tj@kernel.org>
 <87pnngbbti.fsf@toke.dk>
 <20190614150924.GB538958@devbig004.ftw2.facebook.com>
 <87blyzc2n9.fsf@toke.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=V1Xn65jFA9fLzGnZCICEwL6tUShlHAvAc5j9I2/vRW4=;
        b=csyg6vgm0i4uNhPsUxiT5I9v9LOyUNu0/a9saVtXHrnPe9wqOlbnYU16Udzo53uh/u
         ntH7pwRtBjuYbe9ZRhTBP3W/jUlEuQnIvB0w7IG3x9Ic2hAnHAbtU0CPHO2gkqHUsvN6
         cbfvLAcvtmBIdwilZEn2cBDPcUNiKMGQEWZcQt6R+ZKmEM4/Opb3ub+9xk/GktAgEGmR
         7jDLFDvE5TNOV/yA2grBclF2D5ZeFv5ddWM5MPXh6kBco8WTEXIVO1CcoKFaaCofb2Bt
         XsIzD6JAPKS4+AxN7vQovTd0s8Zxat1tSWhNEOzrhnY6XwBMzmfPPOwBkM1nY3UjStQW
         Xtbw==
Content-Disposition: inline
In-Reply-To: <87blyzc2n9.fsf@toke.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org, Josef Bacik <jbacik@fb.com>

Hello,

On Fri, Jun 14, 2019 at 10:50:34PM +0200, Toke H=F8iland-J=F8rgensen wrote:
> > Within a single cgroup, the IOs are FIFO. When an IO has enough vtime
> > credit, it just passes through. When it doesn't, it always waits
> > behind any other IOs which are already waiting.
>=20
> OK. Is there any fundamental reason why requests from individual
> processes could not be interleaved? Or does it just not give the same
> benefits in an IO request context as it does for network packets?

I don't think there's any fundamental reason we can't.  Currently, it
just isn't doing anything it doesn't have to do while preserving the
existing ordering.  One different from networking could be that
there's more sharing - buffered writes are attributed to the whole
domain (either system or cgroup) rather than individual tasks, so the
ownership of IOs gets a bit mushy beyond resource domain level.

Thanks.

--=20
tejun
