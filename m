From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [RESEND PATCH RFC] cgroup: support numabalancing disable in
 cgroup level
Date: Tue, 14 Dec 2021 10:50:28 +0800
Message-ID: <a6aa93b2-cb28-6d79-10ef-7b18bae11231@bytedance.com>
References: <20211213150506.61780-1-wanghonglei@didichuxing.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=QWQlvQssHrsTkmhAcYEyHsS+/G2qMiumDXBWc6CQdPo=;
        b=3h0OwKWCGXfI8pNcGzPhZHOkgihKsvKdmRRC2Gqv0AznLP9nxEcI3vAyIa3rjHnq0c
         Ns7W5Yt7y0ycNFkN70oSiEjPUy4z+wcDE+7UVedsF563i/iVbNS4n2LoStcLHCiDItwF
         QquCs6gnpalfdlidWc3DiJ932MrMOK4uhK0xVL01rTH5Ivn87KlomlLKXmjBvn3lAERt
         t9n/k0uVMPChhJBsCSkM7DIJeAJ8X0kt7vuilgVHi9y3Bvo8sXn59VaikU19J9GJwJq3
         DVXSFubI4QtWFikgeEoAqjSBDKC3HgmfUN/OfBCKTTUFlYhTfxNkxE8SXJE72EsDRtnX
         7kvA==
Content-Language: en-US
In-Reply-To: <20211213150506.61780-1-wanghonglei-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: wanghonglei-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org
Cc: bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, jameshongleiwang-KN7UnAbNpbg@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

Hi,
How about my per-process numa balancning patch;)

https://lore.kernel.org/all/20211206024530.11336-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
-- 
Thanks
Gang Li

