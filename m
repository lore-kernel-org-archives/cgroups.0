From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon, 16 Sep 2019 17:07:29 +0200
Message-ID: <1F3898DA-C61F-4FA7-B586-F0FA0CAF5069@linaro.org>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
 <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
 <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YZ7GwPwdP1QaRAGCDi3zfIX/FY2fDnM1sr/RMCpFxxc=;
        b=uzU2VkkDYVjQ1pTRUBOHpiQDlJuYycViFdnM2TZTPwRbR0+hs72PASEsad5ldWEHha
         6YwaULFVAh7vUXhyKLVU4sJUP6XgqbItTQN7+FQTGReXDU2nwmRrbDpsB33iZTaXfZGk
         /hyPUmC/1qHE/rSCxaVCgMuXBV/n0z9PuGGdu+OT8RtWn9xp9ARUADYcSUaN5+uA2Qz4
         70Ayj4BJshAmRS0FoLOw089B9rb8FHgGNjnB/B8f2J+ETsc3GQ67QTYCeTwtx0jElo+A
         qPMiqIBOdgda4xvjbBXhUbZHs1l/yrfqqUa7pD7EzbcMiUBo6s4KET/EDASXzqS0G1S5
         ceyw==
In-Reply-To: <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org



> Il giorno 16 set 2019, alle ore 17:01, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 9/16/19 8:56 AM, Paolo Valente wrote:
>> News of this change?  Can we have it (or the solution with the
>> symlinks if you prefer it) for 5.4?
>=20
> Coordinate with Tejun and bundle the stuff we need into a series,

Ok.

Tejun, could you put your switch-off-io-cost code into a standalone
patch, so that I can put it together with this one in a complete
series?

Thanks,
Paolo


> we
> can definitely put that in 5.4. I did send out the initial pull =
request
> for block, but I've got a few things lined up for a secondary pull
> later this week.
>=20
> --=20
> Jens Axboe
>=20

