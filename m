From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 12 Nov 2018 11:14:06 +0100
Message-ID: <cf9ef5511050f321c358fe70b6b8494c@natalenko.name>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1542017646;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72TIsSGXu0dHKG6DZuALJbXW1GCv0RE0crx2Ct5jBss=;
        b=wGvtvYZgO/pweRHU+pieH6jqGL3xrzcJckx1bYs529Aa8eT5udCovgfbhc8dS+sNE1sW4Z
        lCdPLgfph/JEE2pJjWOJ9Y2dOvUf1EzP8Vqghj2U+sVyoKYUG6FH1GCDfF76SbBd0zLHI6
        GChlsGFpu3YiljBGISZ2YR4k+at+DcI=
In-Reply-To: <9e8adb3271680165d85994a225713391@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

On 12.11.2018 11:00, Oleksandr Natalenko wrote:
> I thought all the legacy stuff including CFS et al. is going to be
> removed in v4.21 completely=E2=80=A6

Paolo, [1] and [2].

[1] http://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-4.21/block
[2]=20
http://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-4.21/block&id=3Df382f=
b0bcef4c37dc049e9f6963e3baf204d815c

--=20
   Oleksandr Natalenko (post-factum)
