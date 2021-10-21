From: Youfu Zhang <zhangyoufu@gmail.com>
Subject: Re: [BUG] blk-throttle panic on 32bit machine after startup
Date: Thu, 21 Oct 2021 12:26:44 +0800
Message-ID: <CAEKhA2yENaRmCXaEYZFp_S55BnJxm51LwL7AbN24DZ7OpsUDag@mail.gmail.com>
References: <CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg@mail.gmail.com>
 <YW8EVVmrQpuiwyEC@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2FMynZOQufRpN0krg/fWL4lMAv54qnvK4coLS/EU4A=;
        b=AqSwHZhheu6j2y/Drfa4RgRI3nwNY2JKuGqCu+Xx++xkG4AObI86htgIpb57nuwjpN
         wu58Sl0HROuB1uMFrz9fZGGghx0tn61tA7J6/V4zbmEvfU8oqpJU9p+DvTzh0mhmiYbU
         auiGxnA2iTeL/UqkNEe20DJlf8dAnKOFjCQGqW080T8iYVdvoJRPZkHnrYJ8CoYNSdTL
         2XF+EoOs6rFjGodSO21/dQlXJbzIbNTr8Z+uzB82Sy7U32uTZbkS5ZdfAO45qrDVpnve
         3163bDwWERrIm+W++Z7OjZItL5Z8Uu6xdwvQhIs8adJ2LtA6w/h0+llXAs/D4ENlZbBS
         kvRQ==
In-Reply-To: <YW8EVVmrQpuiwyEC@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org

> This doesn't reproduce on 5.14.

I can reproduce this bug on 5.14 i386.
I ran the reproducer (slightly modified, sr0 instead of loop0, 11:0
instead of 8:0) on Debian installer live CD.
https://cdimage.debian.org/cdimage/daily-builds/daily/current/i386/iso-cd/debian-testing-i386-netinst.iso
I posted a screen recording at https://youtu.be/ULdoHizTi0k. Please check.

Thanks.
