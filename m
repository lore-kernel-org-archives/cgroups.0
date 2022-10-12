From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 16:33:00 -0700
Message-ID: <20221012163300.795e7b86@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665617582;
        bh=2Q43OD6ELjO061ruqIM9rlIj6RE37EF7791n2YoQok4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJHMm2+JGCrZkkkXFcE+oWTKipjRdIU5JJxgbankq6nNuQk7d8hYuaNRINumrQmos
         ArgGoad04753zZFQZkEzJpG0rFKM3b6062n+MG0f/VFUKoxCk6+sB0r3DQwBkuxHdp
         Fv9J37lA7Mhc6oZLUZ6CYzHLP3anao1k1bLM4AP+RjeX8RmCgFDOziruJBItlkG3U+
         FnHEks/27iS777oDY4eYuGX/eSckqCbE+8OMhS3A6ViE1oL7mnJn06oPc6VmgH773Y
         uQeF8Y4jW4IsBMF8OojmQG2KTb6+sWPOUMneGGy94L3FbLlS1JyegVEy9xfaZmwgUa
         c09+by+jC6I2g==
In-Reply-To: <20210817194003.2102381-1-weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Tue, 17 Aug 2021 12:40:03 -0700 Wei Wang wrote:
> Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> to give more control to the networking stack and enable it to change
> memcg charging behavior. In the future, the networking stack may decide
> to avoid oom-kills when fallbacks are more appropriate.
> 
> One behavior change in mem_cgroup_charge_skmem() by this patch is to
> avoid force charging by default and let the caller decide when and if
> force charging is needed through the presence or absence of
> __GFP_NOFAIL.

This patch is causing a little bit of pain to us, to workloads running
with just memory.max set. After this change the TCP rx path no longer
forces the charging.

Any recommendation for the fix? Setting memory.high a few MB under
memory.max seems to remove the failures.
