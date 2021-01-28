From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-cgroup: Remove obsolete macro
Date: Thu, 28 Jan 2021 07:33:53 -0700
Message-ID: <fd20b274-2fdc-7046-6571-d11e0a8cf0c4@kernel.dk>
References: <2d053708b596fe148c1d9e63a97117c150a0004a.1611818240.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3UJyCYyHELMaW+UVSUKIODWe8UUnEGgoP936EHMWBTE=;
        b=s/8G0pIfrzxemzeiVD4GkxI82+AzGvnsibV4H6ZREvhKAErR0KW0yF6f6G5MIp+ODk
         ABEm1aKAvUVJgyz+u6grfty+wsKgHlPEw11ngoZfP6Xemg19u5GNEPM6fah1KAQB7Sp8
         oXAPsFAqF0AWwrNEV7DNiL/RuDSPjd/SkiPhVdCOXPAq+cdWlAuvZo1m+CoqvVT5fFkE
         +mxqzgsqUuuzNWeUp+7zOWKQCn5MzMa/cB6yN6H8uCRA+ZbZJy/6AD2aBZO36uz/PT8z
         ja08dRmsk+qBPTSyDcOEuhxrz0M3eWb2dBdwGHM6HE/P84WBdVfjsW8BlI+NQU3rraut
         Z93Q==
In-Reply-To: <2d053708b596fe148c1d9e63a97117c150a0004a.1611818240.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang@linux.alibaba.com>, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 1/28/21 12:18 AM, Baolin Wang wrote:
> Remove the obsolete 'MAX_KEY_LEN' macro.

Applied, thanks.

-- 
Jens Axboe

