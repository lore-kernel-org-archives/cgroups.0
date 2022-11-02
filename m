From: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] block: Correct comment for scale_cookie_change
Date: Wed, 2 Nov 2022 10:11:48 -0400
Message-ID: <Y2J6pPj4/aVdoGPp@localhost.localdomain>
References: <20221018111240.22612-1-shikemeng@huawei.com>
 <20221018111240.22612-3-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Km8d07l+If3latZbcnno8TWKH4LLZv0VkyhOoXFA9PI=;
        b=3K17y2wDCpq6CGFi/JqscdFCZwJGvNNaM/UrrmYofJw1wR3fGyOhi0rlaMmUvngM6N
         1krgS08m59z2fr/guD+Fxxlexzk1wWL4DDBfFKhfYnmJzVrUGe1X4SPy/ewT8BQC0GfG
         cyN/fTXQ6bcPNPSW3tnZyUIjkUqa1IflSfWNU57n1QgVF2Pfb/1krse6RRVC5tWKohru
         eaMOhLitbn3Pvl2VfFWMFZMYpBalV/17Mrynnzxe6BuDm4NHgpy96rb9Ta41d8fsSuYQ
         4HSWJFbdNieK8n5myVnk2FIvFji3UCt22731b4pIAwKKstvvQJ57GK52yWp62ipKzz8Y
         WCxw==
Content-Disposition: inline
In-Reply-To: <20221018111240.22612-3-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Oct 18, 2022 at 07:12:39PM +0800, Kemeng Shi wrote:
> Default queue depth of iolatency_grp is unlimited, so we scale down
> quickly(once by half) in scale_cookie_change. Remove the "subtract
> 1/16th" part which is not the truth and add the actual way we
> scale down.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

This is perfect, thanks Kemeng

Reviewed-by: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>

Thanks,

Josef
