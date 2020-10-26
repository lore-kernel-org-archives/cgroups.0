From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Fixes to blkg_conf_prep
Date: Mon, 26 Oct 2020 07:58:09 -0600
Message-ID: <73a3223b-2a92-49ae-e985-13399d8bf86e@kernel.dk>
References: <20201022205842.1739739-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jszuR3zqMSYhTcL3FUWEd0lFc+5Piy/LuuN/X4w12ZE=;
        b=UlD2l9tJv9e7egQPf3vwasJKZ6rXr0MvOAppN+FYNHUSsOVJ4wViTv6XZYwfNWkmq5
         fiIwU8h6ppZ6HogWNMv9RlABvPE9gRUaaoeTYGd+ztltCWL8kQFiAcN0+WdLvxQqJTuv
         6lFC/it6ywbwaUXg3UEXACs2yxS1SJSYh0of0j8b9s09RFswgtjpY8yOXh1Dt7rSUhnG
         38KnV2lMNE0MZT6Q9Qpz3HU3k5APscM6Fa9FgNhLj8kfUekzFlF8jAmUwM7ePaMQY8eZ
         jKGQ7E+X77rdnKK2mGO2/OwLwpup1cnzqjNeDKaoUVfg7P/HOn2dchDnKrawUbgNcdNH
         oYRg==
In-Reply-To: <20201022205842.1739739-1-krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

On 10/22/20 2:58 PM, Gabriel Krisman Bertazi wrote:
> Hi Tejun,
> 
> In addition to addressing your comments the previously submitted fix to
> pre-allocate the radix node on blkg_conf_prep, this series fixes a small
> memleak on the same function.

Applied, thanks.

-- 
Jens Axboe

