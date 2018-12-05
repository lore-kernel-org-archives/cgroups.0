From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 00/14] block: always associate blkg and refcount
 cleanup
Date: Wed, 5 Dec 2018 10:26:58 -0700
Message-ID: <4505f5f5-144d-39aa-24ac-477604c43212@kernel.dk>
References: <20181205171039.73066-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y0JPiAN+MBquXGfcJsu1JHXuGc4PyL3a4dgPwNvkMYo=;
        b=y0H/WKgIG3fgpLuvX1P/6QIfqMmu3n8qDBR5XkzCgiibl8hKJ0mzZ5jrA1YKg6MBP3
         fNFyqsHyzvhIz3m8MD1wXzw/0eapZy9CJyVJ2BuqUnZait/20SoOx3mHpRTE0J04ARQT
         pH+3diooIJka0Q/pjSO1pyFeg4UZpTK4B6AX3WBaushjf9RhtUGRdNtaCb6yxNpXSIKF
         rSzyuTKnnSrhIzhUfLIu6rZ2xDXC1veiBcwLLjq5xhSW4XaMFMPLjBkDRb4KIE9s0iyr
         KC6fy01zZa4IMt64xDp//xGHfUPCyqX004da1J37r8+8UmpDP5SrNA7CODEbo9RKvGSj
         fKMw==
In-Reply-To: <20181205171039.73066-1-dennis@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/5/18 10:10 AM, Dennis Zhou wrote:
> Hi everyone,
> 
> This is a minor update addressing the feedback from Mike and Josef.
> 
> v6:
> 0005: Address Mike's feedback for the flush bio comment.
> 0006: Add a WARN_ONCE() for blkg fallback suggested by Josef.

Thanks Dennis, applied for 4.21.

-- 
Jens Axboe

