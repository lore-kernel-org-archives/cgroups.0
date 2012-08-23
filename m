From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Date: Thu, 23 Aug 2012 12:44:23 -0700
Message-ID: <20120823194423.GC14962@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
 <20120816200006.GG24861@google.com>
 <50340110.50607@redhat.com>
 <20120821214856.GC32596@google.com>
 <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Uing4F8mnV9zmbww93y806j14X0Jb7u9NEXN5yyivAQ=;
        b=pjD6gWrw2t9mlyI7iOtRAs1/j25EMFhXf3S/A6wPn7HhN0CDm6OCkdu2jmkxJzY/V8
         cY5HsMWJg4gY/zGvQWVVtnZiVt2TpUMaG90D5LBNAs707JZSikUoRLT7EhIJ2FwZEpaK
         bF2G0yATSrdeh048/hBEGSEryVwolX6b5WIvS8XbLtcalKXPC4r1RBatTiOTcrGX3WXo
         CFzE3Ue15gr6peH1Gst4zLmJU/X2GW7iJ0/xQTSL0+6cVIl4yjns6+QcU4RHymylhLZs
         oVyK2JdglHGorma2JuNbCRswUV9xtAUdbEe6TP3omkj2amp0rrmL6meuw6L8G7gxjmj9
         /Vkw==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208211606580.2383-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Hugh.

On Tue, Aug 21, 2012 at 04:29:53PM -0700, Hugh Dickins wrote:
> Are we expecting Aristeu+Zefan's simple_xattr patches to go into 3.7?

Yeah, probably.

> I don't have anything planned for shmem.c for 3.7 beyond a bugfix,
> which shouldn't interact with the simple_xattr changes at all
> (I could remove info->lock, but will not do so this time around,
> precisely so as not to interfere with those patches).
> 
> So it should be perfectly workable for you to take Aristeu+Zefan's
> shmem patches into your cgroup tree, then any further mods from
> mmotm will get layered on top.

I think this approach would be simpler.  Once Aristeu posts the
updated version, I'll route the whole series through cgroup/for-3.7.

Thanks.

-- 
tejun
