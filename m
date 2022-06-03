From: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting in keyctl subsys
Date: Fri, 3 Jun 2022 07:23:40 +0300
Message-ID: <b7c24414-a4d2-5a0a-3473-7df76a2257af@linux.dev>
References: <1626682667-10771-1-git-send-email-nglaive@gmail.com>
 <0017e4c6-84d8-6d62-2ceb-4851771fec18@linux.dev>
 <YovnzLqXqEHY6SAC@kernel.org>
 <ca0ba233-ed09-5dce-5f38-2e05b1114610@linux.dev>
 <20220530133804.9215aa841958e84fdfe5272f@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654230222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPfpHB1TL79jIm4h7zpLLNq40C3N8P8MP8QnhyJBnmU=;
        b=UI4ysI84fFLOWkv8aa6WLVn+m4CGZW1sUydR8dmZcqqPublGhFuXs+Mdm2wG938URAtpPn
        Ez66JWI37VRsj49dXOsvXcOENfxa12+IlHuq53fQsnAK6g3M2uvofKMfkn6UYjs4DYHSaU
        4ChkpzNjX8BG6X4m/r52IQjkZIPQuW8=
Content-Language: en-US
In-Reply-To: <20220530133804.9215aa841958e84fdfe5272f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 5/30/22 23:38, Andrew Morton wrote:
> On Mon, 30 May 2022 12:38:28 +0300 Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> 
>> Dear Andrew,
>> could you please pick up this patch too?
>>
>> ...
>>
>>>> Reviewed-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>>
>> ...
>>
>>>> PS. Should I perhaps resend it?
> 
> Yes, would someone please resend.  And please also retest it - the
> patch is almost a year old.

Please postpone this patch, I need more time for investigations.

Thank you,
	Vasily Averin
