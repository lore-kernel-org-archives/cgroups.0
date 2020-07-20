From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v16 14/22] mm/thp: add tail pages into lru anyway in
 split_huge_page()
Date: Mon, 20 Jul 2020 11:49:31 +0300
Message-ID: <20200720084931.jusstogio6j74uhs@box>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-15-git-send-email-alex.shi@linux.alibaba.com>
 <d478a44b-c598-e99b-d438-9387f208ad37@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tfIjuOSIlbet9/U1v7RlPXF9pVVwSHoUTTJkP/5CtL4=;
        b=1ditQAJ73I/pNYNr9SBkH/lg3J1Qh+5+0QLU2qG5EjXLx93eAZkNyUewnNXYvpWeTV
         YV/xN3j/4ZwEboXLMLnGfbfO4xeci2toTl8pyFqkRsxWyA9EvXVVSOr1g0MsPJskesbE
         k4PBkR2Ki4cPOgwtJbVTdk3Ytptep/N0TD+xqYef5fQ4TpfvGgac3p5P8weAUTMEGp4U
         Y3OoaUMDereGfXzrjFTsTAx/m6IYXSgwqVXhD8+qXC4el25pG3pP/FyI1ijaLYrVvkJ4
         Q6ZW4g2LmiRgteBMQu1yFt2zGwm4Px1npRWIIiydszKOm8aq45M/KXVDvuC+19ah2t5P
         6kSg==
Content-Disposition: inline
In-Reply-To: <d478a44b-c598-e99b-d438-9387f208ad37-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Mika =?utf-8?B?UGVudHRpbMOk?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>

On Fri, Jul 17, 2020 at 05:30:27PM +0800, Alex Shi wrote:
> 
> Add a VM_WARN_ON for tracking. and updated comments for the code.
> 
> Thanks
> 
> ---
> From f1381a1547625a6521777bf9235823d8fbd00dac Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Date: Fri, 10 Jul 2020 16:54:37 +0800
> Subject: [PATCH v16 14/22] mm/thp: add tail pages into lru anyway in
>  split_huge_page()
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Split_huge_page() must start with PageLRU(head), and we are holding the
> lru_lock here. If the head was cleared lru bit unexpected, tracking it.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

-- 
 Kirill A. Shutemov
