From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Wed, 30 Nov 2022 15:41:37 +0700
Message-ID: <fd28321c-5f00-ba94-daed-2b8da2292c1f@gmail.com>
References: <20221130070158.44221-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bClHHbBrNItVLT5DDquRBOoDnrUpgqSvIIymdz67XbA=;
        b=NZrOB5RgqscSru55svi/ZKjfdzqWbOne67Tfu8bqHX955TBLyuKMqIGaHH/XBd8dAz
         uUS2+d6mPbQdYR6NJoR9gbuO9kvfyIRDdTrM3xNG1drH6GNoo/J5zpd2N29hk5DEZjgT
         EPHUHPifO+vGT8CX8hcqw6wcG7CoK9RK9gbVKT26pSuLFj3HmqBLvECPl9QXv1EyaIUB
         9ybI+54269YSGi7ljWpvTlAfNLGroy9eK4RtyNP6iIbGkG8GjfCoAgEhy7Ypy03YOpzm
         htf6AdnEqzz3CR9eM4wbEDoVDZr/ys5w8T550YoJmSkD4mx9UaKD4QHvwkORPqAq+Dxx
         gBSw==
Content-Language: en-US
In-Reply-To: <20221130070158.44221-1-chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Liam.Howlett-Onf44Ee+mfbQT0dZR+AlfA@public.gmane.org, chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sujiaxun-xX5NlYq76+e1Z/+hSey0Gg@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

On 11/30/22 14:01, chengkaitao wrote:
> From: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 

Yikes! Another patch from ZTE guys.

I'm suspicious to patches sent from them due to bad reputation with
kernel development community. First, they sent all patches via
cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org (listed in Cc) but Greg can't sure these are really
sent from them ([1] & [2]). Then they tried to workaround by sending
from their personal Gmail accounts, again with same response from him
[3]. And finally they sent spoofed emails (as he pointed out in [4]) -
they pretend to send from ZTE domain but actually sent from their
different domain (see raw message and look for X-Google-Original-From:
header.

I was about to review documentation part of this patch, but due to
concerns above, I have to write this reply instead. So I'm not going
to review, sorry for inconvenience.

PS: Adding Greg to Cc: list.

[1]: https://lore.kernel.org/lkml/Yw94xsOp6gvdS0UF-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org/
[2]: https://lore.kernel.org/lkml/Yylv5hbSBejJ58nt-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org/
[3]: https://lore.kernel.org/lkml/Y1EVnZS9BalesrC1-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org/
[4]: https://lore.kernel.org/lkml/Y3NrBvIV7lH2GrWz-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org/

-- 
An old man doll... just what I always wanted! - Clara

