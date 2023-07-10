From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/1] sched/psi: use kernfs polling functions for PSI
 trigger polling
Date: Mon, 10 Jul 2023 10:22:06 -1000
Message-ID: <ZKxobukY3EbLcks9@slm.duckdns.org>
References: <20230630005612.1014540-1-surenb@google.com>
 <CAJuCfpH1eoB4cb-huqoMOP9M-zzm40pEJPZgSO_9Z8ZP6bRGPQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689020529; x=1691612529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bVYuNT6EKDwT78XA7oQei5eRW2f7Pj43cJgZHxURJ0M=;
        b=b27G8isFzatJkPEvAH0d48BGZUoyFdMCKbweWfvbVBPqKbzF9JcyLH9MEwO0NY2QrG
         0qdQsJbOFewwEc03KkfZ/gtRabY4hraZtKISxttsRuyUvZXGx5v7DxFABCGJr5Iz0urE
         lbD74g84snd4sMBb3WCdgx+l9bsBYSwXxs5MZaH0aWsfC44+IY6WX2u3LvHRR2Fvd33F
         PIul173VaWZaiSRFzIm2Or9VPJKpWbT+TZaIBUfMetuj2qQYqdEn8nYLm1QvfMyDWdyq
         rznd0fdlTKGjA60hFUyrztVHERHufE/N8V+FxgBD1gb+1xRxg2xHtixyxNlgnCe/EBaF
         YJvQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpH1eoB4cb-huqoMOP9M-zzm40pEJPZgSO_9Z8ZP6bRGPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Thu, Jun 29, 2023 at 06:04:15PM -0700, Suren Baghdasaryan wrote:
> This patch is a replacement for the patchset posted at
> https://lore.kernel.org/all/20230626201713.1204982-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> The original patchset was more appropriate for Tejun's tree but this
> one is mostly touching PSI-related code, so I changed the recipient to
> PeterZ. That said, I would still greatly appreciate inputs from Tejun
> and Greg, and anyone else of course.

Yeah, this looks good to me.

Thanks.

-- 
tejun
