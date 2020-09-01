From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCHSET for-5.10/block] blk-iocost: iocost: improve donation,
 debt and excess handling
Date: Tue, 1 Sep 2020 16:57:43 -0600
Message-ID: <cac016f9-ee13-9fd4-22b2-8be0d830f076@kernel.dk>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8SCB1R5S0rIlXAP1gD/42mN3rEFGnClEAzglzWI/f5A=;
        b=kx9pMxbaG7HxeA/hSNOaElEvYF6zneOI88aycKG6Q8jpxb2w7bV344cmhdkTDMxzM8
         s4owDu6/DO5Uv9cHyTnKBdmy+nqJhz7wwHz61yAXmFMMhK4Cu789DJwxYjlbPXe0s5+l
         1eE7XdCSERl8fSlQzYXHj1ACbWfO6xdmj6kFMFBA+oZIO+F0oUEUFwv1qB4zVLOSf3Tb
         cEm0nPav5qtkrw25Z04awrm9iRz2WofDvEuWX38Z7ApDCYln3CV04pw1ye/mPQ710zxe
         cuHimPUl3H9I9rn9HJAOO2hqAuXJqTUInl3Y6aiY+aq7bLFN524E3gnv+652wfX5cgO4
         qCzw==
In-Reply-To: <20200901185257.645114-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org

1-2 applied for 5.9, and the rest for 5.10. Thanks Tejun.

-- 
Jens Axboe

