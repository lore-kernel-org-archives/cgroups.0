From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Fri, 20 Sep 2019 08:58:47 +0200
Message-ID: <A87FEC8A-3E1A-4DC8-89F7-5FAF63CF5B47@linaro.org>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
 <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
 <4D39D2FA-A487-4FAD-A67E-B90750CE0BD4@linaro.org>
 <20190918151948.GL3084169@devbig004.ftw2.facebook.com>
 <4F416823-855F-4091-90B9-92253BF189FA@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yoSKv6iKPafqA3E2EdHP7bvoi3Wx6UArkcBIy3W3JgE=;
        b=cA+ud2rCE++WSHjLDz3AhrKm293GXSXkrwLk/s9r9iW4WBQtPmAPmvIByyMA9hh1VE
         ug54X6TIvCVMpSwKL/UF4ne11znZGpabGzgJd38sgYHeOHcP0/2tI2pKcuG4RMOFCpWL
         WXvdIzHkgfs83ngR0qoFEaQWT9jsT7EpNeCgUq6NtK+pK3hQCaFsuTU0gFmgEHlV/xz8
         uTE3pJzqyTC43dkjHllvIP7kco+gOSyIEFSD0+jDyqob2BoR9aMvCmvLE/BbOHNV/7Em
         o/QaogW/g3+Zt8xN2m1Et005rX98nd7opXkYqFNlJe1tkomlr7Oyi+mPBQBco6Acxvvf
         NyrQ==
In-Reply-To: <4F416823-855F-4091-90B9-92253BF189FA@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>



> Il giorno 18 set 2019, alle ore 18:19, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
>=20
>=20
>> Il giorno 18 set 2019, alle ore 17:19, Tejun Heo <tj@kernel.org> ha =
scritto:
>>=20
>> Hello,
>>=20
>> On Wed, Sep 18, 2019 at 07:18:50AM +0200, Paolo Valente wrote:
>>> A solution that both fulfills userspace request and doesn't break
>>> anything for hypothetical users of the current interface already =
made
>>> it to mainline, and Linus liked it too.  It is:
>>=20
>> Linus didn't like it.  The implementation was a bit nasty.  That was
>> why it became a subject in the first place.
>>=20
>>> 19e9da9e86c4 ("block, bfq: add weight symlink to the bfq.weight =
cgroup parameter")
>>>=20
>>> But it was then reverted on Tejun's request to do exactly what we
>>> don't want do any longer now:
>>> cf8929885de3 ("cgroup/bfq: revert bfq.weight symlink change")
>>=20
>> Note that the interface was wrong at the time too.
>>=20
>>> So, Jens, Tejun, can we please just revert that revert?
>>=20
>> I think presenting both io.weight and io.bfq.weight interfaces are
>> probably the best course of action at this point but why does it have
>> to be a symlink?  What's wrong with just creating another file with
>> the same backing function?
>>=20
>=20
> I think a symlink would be much clearer for users, given the confusion
> already caused by two names for the same parameter.  But let's hear
> others' opinion too.
>=20

Jens, could you express your opinion on this?  Any solution you and
Tejun agree on is ok for me.  Also this new (fourth) possible
implementation of this fix, provided that then it is definitely ok for
both of you.

Thanks,
Paolo

> Thanks,
> Paolo
>=20
>> Thanks.
>>=20
>> --=20
>> tejun

