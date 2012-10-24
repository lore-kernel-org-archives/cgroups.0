From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/18] move slabinfo processing to slab_common.c
Date: Wed, 24 Oct 2012 09:43:09 +0300
Message-ID: <CAOJsxLFuHVKSnpN=+-7Z-C0mNgYu_pnS0jJgUmDkoPkdkgDteQ@mail.gmail.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
	<1350656442-1523-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=LTiSJFeayjszG48WMTuQ71FEWMGsRzdtyqML2CHvpVw=;
        b=ImpDz0W19bEznLhiNHF2rDSQI2G3uEpnCL4/7sjuRSfhMz6c943pSFuEk/H7LF3m3Y
         iLHIZ+upBulZk8P7/vTtnUwZFlQhfEp4a/b6vmER3Jg0BNRFomiVre/NhDi7wOSkzB61
         MAft1BLH+v7ue92WwcKogA5HvC8bDPkIUGLDJgzTQqGMnlcPVKGoMosd/N/UvMZMgzA6
         Jr8CiXM3FRxnkf5qxZU4HVWgkrloor0h7RzIswtT+/3w1o5zbkxnhJWh14QTLFti2cbs
         g5m9zsMnv0/9Q0T3LKwIAoCoG9rSVk2cwqt3wKOFXlYo9Y+wbAF0xomqO0M9jrq/POFn
         8yew==
In-Reply-To: <1350656442-1523-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Fri, Oct 19, 2012 at 5:20 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> This patch moves all the common machinery to slabinfo processing
> to slab_common.c. We can do better by noticing that the output is
> heavily common, and having the allocators to just provide finished
> information about this. But after this first step, this can be done
> easier.
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Acked-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I've applied patches 1-3. Thanks, Glauber!
