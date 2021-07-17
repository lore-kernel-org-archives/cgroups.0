From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] memcg: charge io_uring related objects
Date: Sat, 17 Jul 2021 12:51:39 -0600
Message-ID: <f2bc2044-bdbc-a1ac-1c5a-5d8c53d48b94@kernel.dk>
References: <1626519462-24400-1-git-send-email-nglaive@gmail.com>
 <CALvZod59c1TmiGA5afoy=eM6PH15hEpxsfo2+GJ48yExLz7odQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7W9cdpcFBJJS0JLbmMCkBOvi8E5p+r1Z1gKFFynRQDU=;
        b=rsqMLJgcK6fq8G0MUqltjXw06Aq8/3ZpkYLJPYDFYKyPTBdSrwNwIThmxlkvH7Bld9
         axVVt+nmfeUDQClTdycTcyLMAk6PM/rGoDdSEE7E38Zp/F9M8553U90UbubAcl7IOf3i
         G/V64Jm7ybdDURNn86qt0IInWc0jcZgE/VtVOXUBO8t7lUUmUdUU+XJtiAzmCGkIY+gZ
         zU+roz0sMtMvtPw7/azofKki4W0rRLdfMjsGzibf1bOpu7d6onnS9IuF8JWb9nLy5Cwc
         OXXncYWPhs+qBaSNv/jpwtGt2MaRRnvfS4ASvVIPajfDNZ8eXIFBSfSOI0rjetcx1pMu
         PYaA==
In-Reply-To: <CALvZod59c1TmiGA5afoy=eM6PH15hEpxsfo2+GJ48yExLz7odQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

On 7/17/21 11:03 AM, Shakeel Butt wrote:
> + Jens and Andrew

A lot of these are probably (mostly) pointless to account, I suspect
you'd get 99% of the way there by just doing io_mem_alloc(). But as
far as the patch is concerned, looks fine to me. If we're doing all
of them, then the patch is incomplete. If you send a v2 (that's for
the original author) I'll be happy to get it queude for 5.14.

-- 
Jens Axboe

