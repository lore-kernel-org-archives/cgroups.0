From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: remove the superfluous judgment
Date: Thu, 19 May 2022 21:50:57 -1000
Message-ID: <YodIYdu0T+HYKlY7@slm.duckdns.org>
References: <20220518013647.1749568-1-zhangshida@kylinos.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YlH159IcSNXAnSMmJrm8SPIzKKgsdQNyWHqQ6RmP5X8=;
        b=UFMQ6EQgUHKYqvJqw5I6s0P7kMn6UxEfOGOyCHgjfGaTURsUdYbkyHzzQNaiSkc0B8
         kzo2XZXZ9YsddgW/3uR4CTQ49h2BWa17hKYq3sFHmshzOxgYsIOtGAQKCZEWty554kys
         Cp+JrBH/gYGExZiKTJzX7MyD9EcAeSczl6tQ1SohJuptWykoZcNPfK4YlyGmY24LsTWG
         Iwcbb2ILRU33S13LSaKFCK2mJntHkAXligibXRmYhjSIB/en61VfXoz0vLqiyYDMo71p
         fbR+7X7qgWrbdwGihSZdWt1PZ3Ii/ayrpduRnCLwcysQ7ZDEVmAs7O6VJE1Z7KM5DkOl
         LQKQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220518013647.1749568-1-zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shida Zhang <starzhangzsd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 18, 2022 at 09:36:47AM +0800, Shida Zhang wrote:
> Remove the superfluous judgment since the function is
> never called for a root cgroup, as suggested by Tejun.
> 
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Shida Zhang <zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>

Applied to cgroup/for-5.19.

Thanks.

-- 
tejun
