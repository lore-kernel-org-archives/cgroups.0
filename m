From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Sat, 21 Sep 2019 08:55:53 +0200
Message-ID: <FE1AEF80-F07F-42DE-A979-BC5AE72B25A1@linaro.org>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
 <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
 <4D39D2FA-A487-4FAD-A67E-B90750CE0BD4@linaro.org>
 <20190918151948.GL3084169@devbig004.ftw2.facebook.com>
 <4F416823-855F-4091-90B9-92253BF189FA@linaro.org>
 <A87FEC8A-3E1A-4DC8-89F7-5FAF63CF5B47@linaro.org>
 <de7664b1-6f47-8a7b-b231-727336c0ef85@kernel.dk>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=G+3UPEhERrKETlk0FsuOwaqKLSxXjoLtJQ8TkFpUanQ=;
        b=evkEodFPsQCy9q6aV3S9m0L2g7DE6Jx4M0MnI0imvyxJMf176t1gVqZYI3GQbP0Ww9
         2lD47ST6Shv9mG6w0mER4CKLC+uBdRfcdMal7Qqp21MqL2IOZry3tch/Or5s+nez9jo/
         x4Zc6AW2/ZdQ4WTW3QnN994vYcNDJtJm/Lj98TlUV42VFytLSWzKJTK7qCUT7ONxKX8l
         18O9Hax99+RMyOmpzbHROpEnGpRuL3tItse+yn0TYvtYP6y3dUNF4GpyLMWcYN3KXAda
         8dH9eS2f50YIRSPt3C6QxBRVCBBqZISO60GiNPJ22ZdB1/6Oyi3FrNQH0N+z43kOn5CF
         NPYw==
In-Reply-To: <de7664b1-6f47-8a7b-b231-727336c0ef85@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>



> Il giorno 20 set 2019, alle ore 15:05, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 9/20/19 12:58 AM, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 18 set 2019, alle ore 18:19, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>>>=20
>>>=20
>>>=20
>>>> Il giorno 18 set 2019, alle ore 17:19, Tejun Heo <tj@kernel.org> ha =
scritto:
>>>>=20
>>>> Hello,
>>>>=20
>>>> On Wed, Sep 18, 2019 at 07:18:50AM +0200, Paolo Valente wrote:
>>>>> A solution that both fulfills userspace request and doesn't break
>>>>> anything for hypothetical users of the current interface already =
made
>>>>> it to mainline, and Linus liked it too.  It is:
>>>>=20
>>>> Linus didn't like it.  The implementation was a bit nasty.  That =
was
>>>> why it became a subject in the first place.
>>>>=20
>>>>> 19e9da9e86c4 ("block, bfq: add weight symlink to the bfq.weight =
cgroup parameter")
>>>>>=20
>>>>> But it was then reverted on Tejun's request to do exactly what we
>>>>> don't want do any longer now:
>>>>> cf8929885de3 ("cgroup/bfq: revert bfq.weight symlink change")
>>>>=20
>>>> Note that the interface was wrong at the time too.
>>>>=20
>>>>> So, Jens, Tejun, can we please just revert that revert?
>>>>=20
>>>> I think presenting both io.weight and io.bfq.weight interfaces are
>>>> probably the best course of action at this point but why does it =
have
>>>> to be a symlink?  What's wrong with just creating another file with
>>>> the same backing function?
>>>>=20
>>>=20
>>> I think a symlink would be much clearer for users, given the =
confusion
>>> already caused by two names for the same parameter.  But let's hear
>>> others' opinion too.
>>>=20
>>=20
>> Jens, could you express your opinion on this?  Any solution you and
>> Tejun agree on is ok for me.  Also this new (fourth) possible
>> implementation of this fix, provided that then it is definitely ok =
for
>> both of you.
>=20
> Retaining both interfaces is arguably the right solution.

So you also are voting for BFQ to create two files, instead of having a
symlink, aren't you?  I just want to be certain before submitting one
more solution.

Looking forward to your confirmation,
Paolo

> It would be
> nice if we didn't have to, but the first bfq variant was incompatible
> with the in-kernel one, so we'll always have that out in the wild.
> Adding everything to stable doesn't work, as we still have existing
> kernels out there with the interface. In fact, in some ways that's
> worse, as you definitely don't want interfaces to change between two
> stable kernels.
>=20
> I know it's not ideal, and some better initial planning would have
> made it better, but we have to deal with the situation as it stands
> now.
>=20
> --=20
> Jens Axboe

