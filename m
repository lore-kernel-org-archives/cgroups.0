From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Wed, 18 Sep 2019 18:19:42 +0200
Message-ID: <4F416823-855F-4091-90B9-92253BF189FA@linaro.org>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
 <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
 <4D39D2FA-A487-4FAD-A67E-B90750CE0BD4@linaro.org>
 <20190918151948.GL3084169@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jkRvwN7j8d6+3yYxujaDpdYkk73iNWb6wxPtS0qswdE=;
        b=NkofmqnCSprkwxBJoUDKnTb+3Uj/9yc6OmR4Yulm/W/mK7DM5Yry64Bb0TLfbeA4w/
         0L360/+PzUU7wzqahEZy7qO+5UvxDTAuFOwOCAlEg3LFZvahuaRqYvKBr9K10Xko2Cx+
         XHb6rYgdUm5i86gYRLXVj6258yQs9Qw1UUxnefk5no8k4IgTFts/Ue/Ou5RUqYyJHQOv
         UFME+F58lY294Ujkr+Mw7u0QddYKlPHlIRh8zdFjNIMsMF1PIOFTOFLfuZsWEhEiI1+y
         rNCoJv6uVhgfXsk+B7W/Laa1irG7idIEgpNZWvrfpDHtsFgiepPac8d3vgK4e82lcrgY
         Gciw==
In-Reply-To: <20190918151948.GL3084169@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, oleksandr@natalenko.name, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>



> Il giorno 18 set 2019, alle ore 17:19, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello,
>=20
> On Wed, Sep 18, 2019 at 07:18:50AM +0200, Paolo Valente wrote:
>> A solution that both fulfills userspace request and doesn't break
>> anything for hypothetical users of the current interface already made
>> it to mainline, and Linus liked it too.  It is:
>=20
> Linus didn't like it.  The implementation was a bit nasty.  That was
> why it became a subject in the first place.
>=20
>> 19e9da9e86c4 ("block, bfq: add weight symlink to the bfq.weight =
cgroup parameter")
>>=20
>> But it was then reverted on Tejun's request to do exactly what we
>> don't want do any longer now:
>> cf8929885de3 ("cgroup/bfq: revert bfq.weight symlink change")
>=20
> Note that the interface was wrong at the time too.
>=20
>> So, Jens, Tejun, can we please just revert that revert?
>=20
> I think presenting both io.weight and io.bfq.weight interfaces are
> probably the best course of action at this point but why does it have
> to be a symlink?  What's wrong with just creating another file with
> the same backing function?
>=20

I think a symlink would be much clearer for users, given the confusion
already caused by two names for the same parameter.  But let's hear
others' opinion too.

Thanks,
Paolo

> Thanks.
>=20
> --=20
> tejun

