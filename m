From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon, 16 Sep 2019 18:45:03 +0200
Message-ID: <8766046C-485D-479E-A4D0-AD9EF2F8EF7C@linaro.org>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
 <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
 <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
 <1F3898DA-C61F-4FA7-B586-F0FA0CAF5069@linaro.org>
 <20190916151643.GC3084169@devbig004.ftw2.facebook.com>
 <64329DDB-FFF4-4709-83B1-39D5E6BF6AB6@linaro.org>
 <91deff5b-4a0d-a7ef-8bb2-7e7e5dad767b@kernel.dk>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zZRFcLGUdVnVAcdne0uKeJBEyAx10rOBH/SeHFjSiQc=;
        b=iTecFQloHelDoj6BafiGIlqL2AubioTSSuqHSPljPp0BFzKdCsfUFYs6FkMgymxurN
         SLRwOfBqdo1mHpt/4gs6khElgLAZBd/NP4eO6+msUb31cUXvlCroT59lBMhZEay4+7it
         tAHsJZUItXHSTCZuQbZqHtYGSV7yPeTsxIWKcMcAL71zhBY/n7fX9nDqdqtAutUB6YFU
         u26U6ob0F8N8FJKYqyA1v/GKIFISZ76NQH4WwvW0cQ1c/4yl5+m7g9YG7PCgW37R+9Kx
         bArVoTQG/Xsgn6dATft0MlWCt7vVe48bDpaXWKE0isC7xvqa0z3pS5jCp1+cbf9dGQz/
         7lwQ==
In-Reply-To: <91deff5b-4a0d-a7ef-8bb2-7e7e5dad767b@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org



> Il giorno 16 set 2019, alle ore 18:01, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 9/16/19 9:21 AM, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 16 set 2019, alle ore 17:16, Tejun Heo <tj@kernel.org> ha =
scritto:
>>>=20
>>> Hello, Paolo.
>>>=20
>>> On Mon, Sep 16, 2019 at 05:07:29PM +0200, Paolo Valente wrote:
>>>> Tejun, could you put your switch-off-io-cost code into a standalone
>>>> patch, so that I can put it together with this one in a complete
>>>> series?
>>>=20
>>> It was more of a proof-of-concept / example, so the note in the =
email
>>> that the code is free to be modified / used any way you see fit.  =
That
>>> said, if you like it as it is, I can surely prep it as a standalone
>>> patch.
>>>=20
>>=20
>> AFAICT your proposal contains no evident error.  Plus, no one seems =
to
>> have complained about the idea (regardless from the exact
>> implementation).  So I guess the best next step is to go for it.
>=20
> Not filling me with a lot of confidence that you actually tested it?
>=20

Tested it too. Waiting for Tejun's patch to re-submit it with mine.

Thanks,
Paolo

> --=20
> Jens Axboe

