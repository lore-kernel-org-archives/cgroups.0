From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg, kmem: use cache_from_memcg_idx instead of
 hard code
Date: Wed, 30 Oct 2013 19:40:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310301940400.18783@chino.kir.corp.google.com>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com> <1382527875-10112-4-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=187ia/mWLypaooCiwBMf3L8w0TqBFtiN0abpgjMKh1A=;
        b=ILvkYVl1pbbToN0TRgPN6L05Y6GxMmhPr2ZDEBC57ltC/PxryE7q4+Xuco4GleDnFG
         AYtFbO2OgR4edO8SJk2Wn9/5nElz5e/a+UCOEMuyJLAv/WF9g5risyNDHlByHMXDOF8y
         twFZQ73wq6Klhv0yN/5WNrXeLkk/ahPmeEim4GTfzjjI824KSdVMbUcftdTLSs//mSXQ
         mcVdZC+qCXY7tFGg86SG1qi3wVQ486Yr+xuM2R/vcx8WpJfHUBtnu90LDSaPvdOez2u7
         q9Iq2j7JnfKNAWb0DGYNtglGXU1j/xzgDrg3hhia2FsSzln3wTfbWHnktqAzagaBJXjL
         nCng==
In-Reply-To: <1382527875-10112-4-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, 23 Oct 2013, Qiang Huang wrote:

> Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
