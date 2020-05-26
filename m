From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blkcg:Fix memory leaks in blkg_conf_prep()
Date: Tue, 26 May 2020 13:23:40 -0400
Message-ID: <20200526172340.GD83516@mtj.thefacebook.com>
References: <1589805366-328489-1-git-send-email-wubo40@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SYQZMFTEBJ18xeJeS1buRtQuG/fExe+cZBQxRWLCEdI=;
        b=DBB2dXXyQS8i2KL6fgI0iY3v+kzmXamXskvxCjgHOeueAxTFhY4qC9ElWV+f2i479K
         QgcXP98W5NFfdi6cLmwRIm5jRaajZ8Xq7c0jS72HCWME/8Aas5rcXPl/uwSEOB+PWYmO
         Z3J++foQU1ozkoo2brpOSl+duSw8dye0KsWj/pmWQjzzjVRDRm7PUb6cnoCrFBZvZwMW
         InpmBDBrFiYlJd+AhV8vkCA3HCv+Ri0pjM+wDegKgRiYKUdb2EOcEM6peCwi5NR1/peF
         tGUKznRKDoHnuAvvD+pPYLR7nxGJWvxFBE7FlmmQc/4cwA0CRXHJEEDCXEqIH6PsKNep
         vYRQ==
Content-Disposition: inline
In-Reply-To: <1589805366-328489-1-git-send-email-wubo40@huawei.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wu Bo <wubo40@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, Markus.Elfring@web.de, linux-kernel@vger.kernel.org, liuzhiqiang26@huawei.com, linfeilong@huawei.com

On Mon, May 18, 2020 at 08:36:06PM +0800, Wu Bo wrote:
> From: Wu Bo <wubo40@huawei.com>
> 
> If a call of the function blkg_lookup_check() failed,
> we should be release the previously allocated block group 
> before jumping to the lable 'fail_unlock' in the implementation of 
> the function blkg_conf_prep().
> 
> Suggested-by: Markus Elfring <Markus.Elfring@web.de>
> Signed-off-by: Wu Bo <wubo40@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
