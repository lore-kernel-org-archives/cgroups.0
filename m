From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Tue, 11 Jan 2022 10:05:52 -0800
Message-ID: <Yd3HAIh79YSUfpzT@carbon.dhcp.thefacebook.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yAY8PX7BTnX7FXfjKgeWGUT8GswRFwwcw+skPdHEHkc=;
 b=pVPIByDh6d18mnh/OwxEJ5Q9e8r5qoRRc5I+aVe2Adz87r8yeXSWbyeng2nKeNzKnXtZ
 QW90psPcDGBeyXXHYd8oYTtikSlXN9dW8wWa9E4TkRoPNq/yKXNqeaf2VQteDWg6n/Hz
 aL0oFK9SnjSFCG01480m2iFE9O682xW/TS8= 
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 01:02:59AM +0000, Wei Yang wrote:
> Instead of use "-1", let's use NUMA_NO_NODE for consistency.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

If the patch won't be dropped for Michal's work, please,
feel free to add
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Thanks!
