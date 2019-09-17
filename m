From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Tue, 17 Sep 2019 08:14:04 -0700
Message-ID: <20190917151404.GJ3084169@devbig004.ftw2.facebook.com>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
 <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
 <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
 <1F3898DA-C61F-4FA7-B586-F0FA0CAF5069@linaro.org>
 <20190916151643.GC3084169@devbig004.ftw2.facebook.com>
 <64329DDB-FFF4-4709-83B1-39D5E6BF6AB6@linaro.org>
 <91deff5b-4a0d-a7ef-8bb2-7e7e5dad767b@kernel.dk>
 <8766046C-485D-479E-A4D0-AD9EF2F8EF7C@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YTPM3JqiD8c0vKHOkagGiX6LKB1z1tzStM2tYGa572U=;
        b=ILfTRupiAjHPFgfKc0g3+FaggjSSMypDaOk8g9mybm68giM925Tcm5vCM330ksEGll
         /L/qoHi5Xi+DhYyESQ9n0HpgfFRhX7btKH+OQKAKrJMgI/ZX1yFO146+eMG6w66/K/xi
         6IcyOMeQnwBWCOS4bvthkeRQD4jXQ/l+7WsusUExp1oJVu1CeBzrjM/fahln4hLwH/xJ
         2D8qJTO/4262g6ZdoggzspuKqFV21o35ZmjhbetgFD3m2YdAvgXcyvsXeTYvB5acm9jx
         ZT6vs6dJFGUd8Mi+kmVF+mM3CjHo3K/cF5yDmdYjSudHGMpXsuYbGoHddZ8PYYaBLuFt
         MT2A==
Content-Disposition: inline
In-Reply-To: <8766046C-485D-479E-A4D0-AD9EF2F8EF7C@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org

On Mon, Sep 16, 2019 at 06:45:03PM +0200, Paolo Valente wrote:
> Tested it too. Waiting for Tejun's patch to re-submit it with mine.

http://lkml.kernel.org/r/20190917151308.GH3084169@devbig004.ftw2.facebook.com

Thanks.

-- 
tejun
