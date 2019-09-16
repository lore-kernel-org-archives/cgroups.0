From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon, 16 Sep 2019 09:01:43 -0600
Message-ID: <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
 <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VJiHjQXkSvCrS+jTckU1P35l9SFt5+c8OTQowivUijA=;
        b=H+xaKl8Ys5y/fCTmn5Ye6W5ZY+/Lx1ksn/Eck5AgznrbtXbtpcriOL+pW3Ll2+Ky1W
         740uwrAhbHkuTR4CrLeNOI+1iLKn5s+M5iWWvvTj175A2VEbgZ7UeiUMVzRIS0WvCC+o
         FVI6IDTMOLQi9roahi0STUL+wM+DuiFxFjgU7rkGY/7DSv3sZBNEsPqze/JARp4WdPia
         ravMYckT7RqUrUsaAPOCiHunSC1na1oo34gpqo3CmrF1NDfV8BsOoi5cLFC7FQmf3mXH
         wVcvJgKROzfr1sZ3xvToVYR819AGTi5UgkAd/nMTAsU3Wx1kkTawBt0RAoHNoSwoH9zL
         VjNA==
In-Reply-To: <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, oleksandr@natalenko.name, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On 9/16/19 8:56 AM, Paolo Valente wrote:
> News of this change?  Can we have it (or the solution with the
> symlinks if you prefer it) for 5.4?

Coordinate with Tejun and bundle the stuff we need into a series, we
can definitely put that in 5.4. I did send out the initial pull request
for block, but I've got a few things lined up for a secondary pull
later this week.

-- 
Jens Axboe

