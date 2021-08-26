From: Tejun Heo <tj@kernel.org>
Subject: Re: BFQ cgroup weights range
Date: Thu, 26 Aug 2021 07:25:24 -1000
Message-ID: <YSfOhM9+uJ5/FzY2@mtj.duckdns.org>
References: <20210824105626.GA11367@blackbody.suse.cz>
 <EC36D67F-D7CC-4059-8D3B-E0E64DFC3ADB@linaro.org>
 <20210826131212.GE4520@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wg3NGSKG8aeY7CfUKjajWr4BQ6jE7IKLYam6kXWpQR4=;
        b=FatKQJFGvF/uj4c0Nq7U98B9Wxi4EGgW/sF5kqboMN0PeaRo4s0JRHucj7JtTUJziS
         CEyuGxH/MDGiBkM8ahWO1ogWn/STms5ZQtaBM1ux/7Knf2VDDuICgA+frGaQgoyTdlAl
         MMuZuPWQw5Hu81El1wEZCOGc66b3/dRY5veu07iWn+9DHz7i42pEGCu5m66ZJHkgzoE2
         vsOpCTUTrDCNQlUnCXishzRWxHnU9G89l0IDTrEnadjFvl6GcrkvHnGdeUuaqPDzN3LY
         owiA4Hhm5e/61zLicZIProXx/hS7Tg55CE+iNcSBbnK/wH2Fol6jBvvGmPHoxUu+gyd4
         fGoA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210826131212.GE4520@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>, cgroups@vger.kernel.org

On Thu, Aug 26, 2021 at 03:12:12PM +0200, Michal Koutn=FD wrote:
> On Tue, Aug 24, 2021 at 02:51:47PM +0200, Paolo Valente <paolo.valente@li=
naro.org> wrote:
> > BFQ inherited these constants when we forked it from CFQ.  I'm ok with
> > increasing max weight to 10000.  I only wonder whether this would
> > break some configuration, as the currently maximum weight would not be
> > the maximum weight any longer.
>=20
> Thanks for the reply. Let me form the idea as a patch (and commit
> message) and discuss based on that if needed (+ccrosspost into cgroups
> ML).
>=20
> -- >8 --
> From: Michal Koutn=FD <mkoutny@suse.com>
> Subject: [PATCH] block, bfq: Accept symmetric weight adjustments
>=20
> The allowed range for BFQ weights is currently 1..1000 with 100 being
> the default. There is no apparent reason to not accept weight
> adjustments of same ratio on both sides of the default. This change
> makes the attribute domain consistent with other cgroup (v2) knobs with
> the weight semantics.
>=20
> This extension of the range does not restrict existing configurations
> (quite the opposite). This may affect setups where weights >1000 were
> attempted to be set but failed with the default 100. Such cgroups would
> attain their intended weight now. This is a changed behavior but it
> rectifies the situation (similar intention to the commit 69d7fde5909b
> ("blkcg: use CGROUP_WEIGHT_* scale for io.weight on the unified
> hierarchy") for CFQ formerly (and v2 only)).
>=20
> Additionally, the changed range does not imply all IO workloads can be
> really controlled to achieve the widest possible ratio 1:10^4.
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny@suse.com>

Looks fine to me.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--=20
tejun
