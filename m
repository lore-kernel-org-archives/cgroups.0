From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix problem with static_key decrement
Date: Thu, 19 Apr 2012 15:54:41 -0700
Message-ID: <20120419225441.GD10553@google.com>
References: <1334875758-20939-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XAvUVpF7BSAQ0RtNOGPOyLl9Jn1GmfWyA+5aCWn1w+Y=;
        b=B7RvOlo7B/Mb5IYoPUppjNReMkB06zvGk1+de4tRnRL9n7BerKVO63ZnD0LHOk77bO
         ZI8z9Ly9Mwn+OUpw0KDBZGaHCyHLvd9eWzcuP+/Dbl7qU1lFaovCSCqMvBNO7HZEGriT
         fKmHNenrfS3+rAyQRm6hCs1p7bIFYa2xhGlyrTWZ6fg71jkNS3LtZ2grLDh+Go3DjVdi
         VT+j3LX5AhICkuUtNtjp/zT0ubSaHryivoWX3bxRFrYVYFDHggzwp8us3WeQzAvRv2sy
         pv5XqewvazDSBn5HvrAGhk8MlkqyeYTCJok8GQ6yAaS9Z9mmc96Y/rjBsrIO7rHO42a/
         ZrhQ==
Content-Disposition: inline
In-Reply-To: <1334875758-20939-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, Apr 19, 2012 at 07:49:15PM -0300, Glauber Costa wrote:
> Hi,
> 
> This is my proposed fix for the sock memcg static_key
> problem raised by Kamezawa. It works for me, but I would
> Kame, please confirm.

Please detail the problem.  I don't follow what's the purpose here.

Thanks.

-- 
tejun
