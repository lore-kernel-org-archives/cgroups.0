From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [syzbot] WARNING in __kfence_free
Date: Fri, 22 Apr 2022 13:09:11 +0800
Message-ID: <YmI4d8xR3tafv2Cq@FVFYT0MHHV2J.usts.net>
References: <000000000000f46c6305dd264f30@google.com>
 <YmEf8dpSXJeZ2813@elver.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpqDRBjWTFgnwu8hYqPDued7W5tN/z70+zi0V+kqfDQ=;
        b=Q0hcI1wq6TOk2nT188DONJl8NB23KNtCjhfItg9EEg/p3Wrhq0eawgIr8JTlnSl9gT
         RzIQDZfLJK+Un/ClfO2FXBkYSxX0RjMPs7MbYdAjubXsDgh9wwa+RtV9E5XVFLCszDIQ
         MK3KtHeydNAlOsqh4MLUdnTetvCSN8IWoMM0n9FKeVZF9sJISp/ncUeqhoYYHl/xuukl
         H3LmXrFpqgD8zzpVJaBj1kwZwxVDascj4aIViTToD8Q9SDtUes4R+Nq1PatVvkeb4RvG
         o8vKY2uDUfGaecPS6vWVIbDWWAjIFfHW9FnfCtkA+QERRjBrDY6cgpFwj0dMT3zWcrN9
         UHWw==
Content-Disposition: inline
In-Reply-To: <YmEf8dpSXJeZ2813-Zcm/davGjwjuPzagQnfukA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: syzbot <syzbot+ffe71f1ff7f8061bcc98-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 21, 2022 at 11:12:17AM +0200, Marco Elver wrote:
> On Thu, Apr 21, 2022 at 01:58AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    559089e0a93d vmalloc: replace VM_NO_HUGE_VMAP with VM_ALLO..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10853220f00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=2e1f9b9947966f42
> > dashboard link: https://syzkaller.appspot.com/bug?extid=ffe71f1ff7f8061bcc98
> > compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm64
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+ffe71f1ff7f8061bcc98-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 2216 at mm/kfence/core.c:1022 __kfence_free+0x84/0xc0 mm/kfence/core.c:1022
> 
> That's this warning in __kfence_free:
> 
> 	#ifdef CONFIG_MEMCG
> 		KFENCE_WARN_ON(meta->objcg);
> 	#endif
> 
> introduced in 8f0b36497303 ("mm: kfence: fix objcgs vector allocation").
> 
> Muchun, are there any circumstances where the assumption may be broken?
> Or a new bug elsewhere?

meta->objcg always should be NULL when reaching __kfence_free().
In theory, meta->objcg should be cleared via memcg_slab_free_hook().

I found the following code snippet in do_slab_free().

  /* memcg_slab_free_hook() is already called for bulk free. */
  if (!tail)
  	memcg_slab_free_hook(s, &head, 1); 

The only posibility is @tail is not NULL, which is the case of
kmem_cache_free_bulk(). However, here the call trace is kfree(),
it seems to be impossible that missing call memcg_slab_free_hook().

Thanks. 
