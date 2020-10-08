From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] block: Remove redundant 'return' statement
Date: Thu, 8 Oct 2020 08:00:19 -0600
Message-ID: <902fc772-4f41-d6a2-0c6b-162da8165f46@kernel.dk>
References: <633f73addfc154700b2f983bee6230f82de4c984.1601253090.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PQYn98Q50q5N/GLYfX3Z+7jVvi2JaNHakYRoBkO7GXY=;
        b=EHBbaI6273UHbYRwW0lrb+qFFTEFHFvupZksJI9ZWuORueuFoTwZhEsf7VVtmqCpsZ
         Cht1c6ZwHY9nTo/m1TMEZ+h1yTCXN7lRxFHAiuiLVHZ1Mt/P7fibkhs6f/xiAfrpFsOl
         Bwp/PSx7VrCPK+CzQZ+JCzm66XSv3ueEWynzvV1I8plJv+Ap2mytPr9bRQNDrlhvDhP/
         h2kequvNzD2Wxm2xY509SjVvJIhaApynr93c5UffSxxQdYeU58D9f3G1E3lYCLoAXAtA
         6VgUDhKGXGPpAR2x8XGW/+KZ52yqzqZfYYILIIc9eO8tVY1rdWnaQb+gK0fAArhzBBFD
         QE0w==
In-Reply-To: <633f73addfc154700b2f983bee6230f82de4c984.1601253090.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/27/20 6:42 PM, Baolin Wang wrote:
> Remove redundant 'return' statement for 'void' functions.

Applied, thanks.

-- 
Jens Axboe

