From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-cgroup cleanups
Date: Thu, 20 Jun 2019 10:32:43 -0600
Message-ID: <2afccbe4-ef5e-6a74-551d-d91b2d1a267a@kernel.dk>
References: <20190606102624.3847-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lWaahTvqeFpcpOtko+DL9aqqDWntV26lpwBJ5O+GW9Q=;
        b=Ug1/ChKVDzZOYIsyHhPlKIGz91/Caw12cOGtM3k4qGRp0QUaNpaZajCdz1zUwJVnUU
         7hrEBLN5/30FS9zP1pmuXFOeTOFVTWQv6iudmJr2WyzkGjk/jBIgpLHR5Hb7Hp9GwxAq
         iVNNU/nNvttkOibLuAO8CYjoTxQTFLqMWrNGki6x3KloaUI4L/P42naGG2d1RXzD92nS
         utDAceIRT21JKaiDyEJwfXUG0u4F5Z6UU798naR+FLS7p932QPO1usvR/BG+CHz26Ind
         NV5+qAwaZYvaYBM1V4c/jK0cYw81pun9SmNQEg58GsmqfIXyBRIjiMCUiIrfZIkqrLwe
         cLLw==
In-Reply-To: <20190606102624.3847-1-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>
Cc: Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 6/6/19 4:26 AM, Christoph Hellwig wrote:
> Hi all,
> 
> below are a couple of cleanups I came up with when trying to understand
> the blk-cgroup code.

Applied, thanks.

-- 
Jens Axboe

