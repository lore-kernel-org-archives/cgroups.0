From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] add/update/fix BFQ docs
Date: Wed, 16 Jun 2021 11:32:49 -0600
Message-ID: <40174fe2-ef72-99bd-2c75-5f00641f064b@kernel.dk>
References: <20210611030737.1984343-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q4gumIsyYAtBcDgBeiPSNtfPvFXvXc8mQGPj94mk7tU=;
        b=0/gByeCCO+jtXT10f358SOv5CX5VuTpPTBsWh15TdpdH0EE81yE6LKrzfDHqsQ31F8
         8Ob01KNdVt+lfSVo4nxcsYFLS6pUMbxntpBCXeA8bpdkhIp5cLJUD/RMwbCGAQxF0S4r
         PJMlL6XrLaBSt42KfMHRD/GEctTRbB7jhZPXRvqDB/uiyVRuLjyGP7ZTfzAl+/WwhPlr
         6x4K6G3tLrXQitckLUrzCMz3DyDi969BG2OHS0T0228CY3yEYX+s8cJWd85mbH7ZFA24
         wwtRvg0KMv4U8qg1mtfBjpEb7WryqWrVQJiRWk6BwOEO0i8rwY8VOaqnrBar84A7Kano
         /Rqw==
In-Reply-To: <20210611030737.1984343-1-kolyshkin@gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kir Kolyshkin <kolyshkin@gmail.com>, linux-doc@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, tj@kernel.org, paolo.valente@linaro.org, cgroups@vger.kernel.org

On 6/10/21 9:07 PM, Kir Kolyshkin wrote:
> Improve BFQ docs: fix formatting, adding a missing piece.
> 
> Fix cgroup v1 blkio docs which are not updated for CFQ -> BFQ.
> 
> Patches are on top of the latest docs-next (commit acda97acb2e98c97895).

Applied, thanks.

-- 
Jens Axboe

