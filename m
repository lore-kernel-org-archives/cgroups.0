From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] block, bfq: switch 'bfqg->ref' to use atomic refcount
 apis
Date: Sun, 15 Jan 2023 20:53:50 -0700
Message-ID: <167384123010.165459.4491550988140898321.b4-ty@kernel.dk>
References: <20230103084755.1256479-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XeL2aMm/FlBSF1QP/YxXM0H+2tWA4RrG/z4nLNj/C5A=;
        b=Nm6l1cDkz2vKYpYch7neC71ii3Ml4A0/rJ0KvUmcnWfdFsSMdtGXrTzG1/moOYv8TK
         iWmbHXm3dqOaO2vRzYj/4hXl9g5NrIJUb0FO2TT8Pbp5ptAoadGB5kUxcaW7jUhPIgKG
         PRV5Y4mkwxImAB2LaNRbOljmMaoIJ07SeqDdWqX979SvzmpCEKSuLVG6UF3KsEWUejne
         eL8Yf4ZgKHMkunkjP2JjMIqY7woGKaaf+2WBxb9EuIXafNBxjibsOUyU3ahj84Bbl+9i
         yVxqB7uo70jIKu7kQfXMAYreaiMbZ/SkmYBbVAWgHpeoz2usqc11XDCygHZz17mSGfuP
         VIGQ==
In-Reply-To: <20230103084755.1256479-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Tue, 03 Jan 2023 16:47:55 +0800, Yu Kuai wrote:
> The updating of 'bfqg->ref' should be protected by 'bfqd->lock', however,
> during code review, we found that bfq_pd_free() update 'bfqg->ref'
> without holding the lock, which is problematic:
> 
> 1) bfq_pd_free() triggered by removing cgroup is called asynchronously;
> 2) bfqq will grab bfqg reference, and exit bfqq will drop the reference,
> which can concurrent with 1).
> 
> [...]

Applied, thanks!

[1/1] block, bfq: switch 'bfqg->ref' to use atomic refcount apis
      commit: 216f764716f34fe68cedc7296ae2043a7727e640

Best regards,
-- 
Jens Axboe



