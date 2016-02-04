From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [mm -next] mapping->tree_lock inconsistent lock state
Date: Thu, 4 Feb 2016 09:18:16 +0900
Message-ID: <20160204001816.GA1861@swordfish>
References: <20160203153633.GA32219@swordfish>
 <20160203184509.GB4007@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=P7d9cdyHNH1qJ41AYAM6c+FRIXWriWEACNn6F4n88Uc=;
        b=ZWLJo8vHti24fZeUERzDJWXU00lTLnrq13VlFu5+PsrWYc32pMitN1Z5rHjwc1+iPj
         lT/X0VFe9Woy9rK6z8qZw64l/4oNOTZ6FJLoJ+tkJB7DPs4YXkoMuOnRqph33pGUbftS
         PI9JmnKQmwmde8xxS40CHpf/7fktsYENGmJET4Jr22mIxHeHmaOM0OdxYvWIkxA2lYn7
         LJS+pif3aySH2WmodDy3lm+z4WI75CKEBxyrodpEYRicvBumWwlmnG+5/wuxXGv3SGO/
         /liBQ7I1rvMaFF+fjj9Qcf5DRcrt15PNTZFMcRlpFnZga7JE7Xm/uy7a7KwWaKtJO/JE
         QVnw==
Content-Disposition: inline
In-Reply-To: <20160203184509.GB4007-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin LaHaise <bcrl-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On (02/03/16 13:45), Johannes Weiner wrote:
> On Thu, Feb 04, 2016 at 12:36:33AM +0900, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > next-20160203
> > 
> > [ 3587.997451] =================================
> > [ 3587.997453] [ INFO: inconsistent lock state ]
> > [ 3587.997456] 4.5.0-rc2-next-20160203-dbg-00007-g37a0a9d-dirty #377 Not tainted
> > [ 3587.997457] ---------------------------------
> > [ 3587.997459] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> 
> Thanks Sergey. Vladimir sent a patch to move mem_cgroup_migrate() out
> of the IRQ-disabled section:
> 
> http://marc.info/?l=linux-mm&m=145452460721208&w=2
> 
> It looks like Vladimir's original message didn't make it to linux-mm,
> only my reply to it; CC Ben LaHaise.

Thanks Johannes. Will test it (well, just in case) later today.

	-ss
