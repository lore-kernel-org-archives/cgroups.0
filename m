From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Fri, 28 Jan 2022 07:45:19 -0700
Message-ID: <164338111974.263985.3933987922467783334.b4-ty@kernel.dk>
References: <20211231032354.793092-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=tHZMd140zpIEoj2CecnDxVRiFeDUjbUC1wxqPW+oecg=;
        b=FgCuhEx0mkvM7saXOLOVMI1MIOyEj5vw3bcRnIuyWTYKhrkW+5bCVLOMQ/VchCGjEE
         SVzPxfw5nFI5+p3BLT9mptUsuaoS21kI1r6kJwKtFs2BmfSALC+TJe1e6WM5onQqnhbG
         Pd3KR3+SY7V7OPFQQ9h4TJnW5/dBIHbzjuYJf040JZbZG+ClOIDFW3uUY3yN6rHn+oiC
         P2ZdxxnCStjQ57ZOGVd4o5+H9yaLhpLYI1xf91xU/Eir5iEDxiskNhFH0wH6mQWtlCG8
         e6iXpYihbDomILqZ/1ePLK8ooOug8iYFDb03bohpV9fdaWr4f/lQZrlIO8QKDTm1XB1L
         FDUA==
In-Reply-To: <20211231032354.793092-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 31 Dec 2021 11:23:51 +0800, Yu Kuai wrote:
> Chagnes in v2:
>  - add comment in patch 2
>  - remove patch 4, since the problem do not exist.
> 
> Yu Kuai (3):
>   block, bfq: cleanup bfq_bfqq_to_bfqg()
>   block, bfq: avoid moving bfqq to it's parent bfqg
>   block, bfq: don't move oom_bfqq
> 
> [...]

Applied, thanks!

[1/3] block, bfq: cleanup bfq_bfqq_to_bfqg()
      commit: a9c77f6ec0b566439182a10b64dd3e60a0408849
[2/3] block, bfq: avoid moving bfqq to it's parent bfqg
      commit: 36ad7fe0ec7485ee435f7a40452c7a58598779d4
[3/3] block, bfq: don't move oom_bfqq
      commit: a0b98e6fba18a40aa9672cc3e0abf980456f3ae6

Best regards,
-- 
Jens Axboe


