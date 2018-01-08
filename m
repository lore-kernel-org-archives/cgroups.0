From: Rouven Czerwinski <rouven@czerwinskis.de>
Subject: Re: [PATCH cgroup/for-4.15-fixes] cgroup: fix css_task_iter crash on CSS_TASK_ITER_PROC
Date: Mon, 08 Jan 2018 11:12:47 +0100
Message-ID: <87lgh8d5gg.fsf@czerwinskis.de>
References: <39625861-99c0-1c15-08a6-49b9d678c4c2@redhat.com> <20171213152914.GN3919388@devbig577.frc2.facebook.com> <121dc065-89ba-98ab-68ff-e86f1a636b06@redhat.com> <20171213213756.GX3919388@devbig577.frc2.facebook.com> <20171220151331.GA3413940@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=czerwinskis.de;
        s=mail; t=1515406370;
        bh=V06UA6GpXvFEXNebaa4N/nI060sFtJyFXujeF5KA4F4=;
        h=References:From:To:Cc:Subject:In-reply-to:Date:From;
        b=ltzYuL5Z6hQ4VylMNTnJUwpSUuoEScbHzyn/fVwtVvAvDvKOxwnRc11FcBkzutA31
         3B3IrughFD5z+XwA3wVh+z6Pb8tLWp3egK4tCSQvJkhAvfw/7KTyeLlubfX7uQ6fVa
         eY+Bk8fFJ1aaVnmX/A8ExNXeYneXOqTTuYM0GLEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=czerwinskis.de;
        s=mail; t=1515406367;
        bh=V06UA6GpXvFEXNebaa4N/nI060sFtJyFXujeF5KA4F4=;
        h=References:From:To:Cc:Subject:In-reply-to:Date:From;
        b=mWsy3NOKcStH0NV8PFhFzguhZecpLNQ/po+WoekfPL30Dsi2hdi+IGu+YWUOIkUGw
         22w3NHZZmbw36xgd1yhKXSSBHa0SLB2ZdQKpyXouQavd9f0kRePYPFrIy4OSFD4EbD
         pR+aH26MNrjwSTwyTXQL1lOdRLQrMLmOwp+jObNc=
In-reply-to: <20171220151331.GA3413940@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>, Zefan Li <lizefan@huawei.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, regressions@leemhuis.info, Bronek Kozicki <brok@incorrekt.com>, George Amanakis <gamanakis@gmail.com>

Hello, 

Tejun Heo <tj@kernel.org> writes:

> Applied the following to cgroup/for-4.15-fixes.  Will push out to
> linus later this week. [...] 

I can't find your fixes in master yet, did you perhaps forget to push
out?

Thanks and a happy new year,
Rouven
