From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/11] blk-throttle: remove unused variable td in
 tg_update_has_rules
Date: Wed, 23 Nov 2022 08:30:07 -1000
Message-ID: <Y35mr8VBkdU4Ig6o@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-11-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyc2BTmrFAzthNmrP4/3H7t5RS3aYIyVMvaG95YYS+g=;
        b=Z6hHweGDCSt8n1bmaTx7zdP45Ec7KKpXEdG51XEVDX4zn+dUxBRWbAwmgNOXLSxxTA
         9bxdiYtGiGfM8j9USUbcollVRPtMnrnmknVPDo8LIQQiVRjbBLwWlG3BW9/gL6NhGwMd
         ZztkzGHTOn5T16nNqu/ISZQE5JwON4LcMxN4CxpWgt7DIZjdNn2cEYIIpZX90MDRZjBk
         HKTY0OlbzCAztF1O5EOYuxrTCfZ8YaLSrwSZ9Omlbpy1HGQU/jlZa//Rbpy7zA67uV9z
         LOy5115Z6MtjQEYZRZdBhEH5IIYGX9XJ6Rv1uEvktqgFCOozr0I9Lm23H0ShkjP7LlRj
         KN4A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-11-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:04:00PM +0800, Kemeng Shi wrote:
> remove unused variable td in tg_update_has_rules

Please merge this into the prev patch.

-- 
tejun
