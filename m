From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] memcg, kmem: Use is_root_cache instead of hard
 code
Date: Wed, 30 Oct 2013 19:35:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310301935300.18783@chino.kir.corp.google.com>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com> <1382527875-10112-2-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=187ia/mWLypaooCiwBMf3L8w0TqBFtiN0abpgjMKh1A=;
        b=nJEg40QoBAicyjQJqef3WyuciC0K+LZZkIrvR6eJA1JvSFcpDDiXWjfX+cvv4RUQNG
         XewR0EUDJlo70CP0x4AkKIdALlSdCbNR69FWjuqwuYmyiVUHZCdpZByu4K/f7Z+bUFcX
         XG6HSxUdS/oVKFSNmNrY7SkzHd4CxCYPb4Tu6PJLp1GQhBjJmw6z4c58b/BDJ4Xn4Ud9
         zJGu4bQmG6j/zOHSR35uqNUfOox9CFVrmnblAbRxsUHlufFPuLdLC+CrJOjcssuYBLi7
         hg2MZC9KUmKclCPcLL9ietMQbsEA/bSGhqVbjwZBc5TbxEOi9ejPbHAbPrC3Ald7zuCy
         n+3w==
In-Reply-To: <1382527875-10112-2-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, 23 Oct 2013, Qiang Huang wrote:

> Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
