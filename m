From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: add plugging support for punt bio
Date: Thu, 6 Aug 2020 09:16:34 -0600
Message-ID: <8f84e1fe-9fa5-b7e7-1f2f-b0c4a40614e2@kernel.dk>
References: <1596722082-31817-1-git-send-email-xianting_tian@126.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lkmeDFCb+vAIp5A4XwAMAJW588/NOgnU33kU5Ds2q8U=;
        b=wi4dRPNxYEFgOvGpsjjRxtDn2I9IamqHuFJzrb9/BuBRChg/enUxUB6jKiVJyf6FSn
         OEQMb2RXR2Ht+C6Ju/CpXw+3C8IXjLBhGdgnDRc+0mD42UF2fgmfGBI+NDEQDfVS+FPg
         8Yte0Alz1AaaMd1lh6L2ptLcnhrBzWalCQR42JDJeAyQD1H9NJDT0b18q5zQqirTk5sw
         MQTa65RVxamAwTEOlvLR1qATaDfFMPrdnpkmrZ75l2JmkJ2Zy9MPxE1hZyGlCwG5lUWc
         dMIBO4mmLkijKg2CX5kvhARvLNuj4R+a6FF2AhYbKN6g85KDBnPw2HmOoO1VsmzJJPBe
         6lpA==
In-Reply-To: <1596722082-31817-1-git-send-email-xianting_tian@126.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Xianting Tian <xianting_tian@126.com>, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On 8/6/20 7:54 AM, Xianting Tian wrote:
> Try to merge continuous bio to current task's plug fisrt.

The patch looks fine to me, but I'd really like to see a bit more
changelog here. The commit message should explain why the change
is made, rather it's a very brief explanation of what it does.

If the bio list is contiguous, then we do the plugging to improve
merging at the lower level. You probably ran into a case where
you saw sub-optimal merging? And now the performance is better
with the patch? How much?


-- 
Jens Axboe

