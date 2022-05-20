From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] memcg: enable accounting for kernfs nodes and iattrs
Date: Fri, 20 May 2022 01:12:33 +0000
Message-ID: <20220520011233.fxbqxcljfcrjk44n@google.com>
References: <Ynv7+VG+T2y9rpdk@carbon> <22ccf325-6aa5-9b55-4729-d03f34125650@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tRp9XwLCJd757nd6S6xrPEWJRWBLPfMUrN42v2RElFU=;
        b=kLj1335gWXNqN3m0x4aikHu59YFs4w9jVsakDkYazDHkv7NdPPTHMDWcCBbO3/UU6H
         C4koYXf/EG3VCj89YpQGoAsQcqkjWiUI4krLBCoyZ0vffn/xz7p+GjRLzkI0Djr3cUR7
         icY3wNQnvbaXZORjv/+6eb+8c/8U5ZM0Sd2cE2skWOCrjurR8T/B9QDmAf8S1w48L3bR
         87Z4HB468t+jYhTBRp28yYN2j311pzzKaC5m+TmiItPYKSuvb9j5Zd5tiOdshLhQ5Ts2
         I54OjEYN9vXGiN83EaXLux5pHpSMsc31hiSPBrS5buR9BD8XZhC4mZXKH3ayBQ0DRmHS
         IVJQ==
In-Reply-To: <22ccf325-6aa5-9b55-4729-d03f34125650-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:51:55PM +0300, Vasily Averin wrote:
> kernfs nodes are quite small kernel objects, however there are few
> scenarios where it consumes significant piece of all allocated memory:
> 
> 1) creating a new netdevice allocates ~50Kb of memory, where ~10Kb
>    was allocated for 80+ kernfs nodes.
> 
> 2) cgroupv2 mkdir allocates ~60Kb of memory, ~10Kb of them are kernfs
>    structures.
> 
> 3) Shakeel Butt reports that Google has workloads which create 100s
>    of subcontainers and they have observed high system overhead
>    without memcg accounting of kernfs.
> 
> It makes sense to enable accounting for kernfs objects, otherwise its
> misuse inside memcg-limited can lead to global memory shortage,
> OOM and random kills of host processes.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

You can keep the ack if you decide to include simple_xattr_alloc() in
following version or different patch.
