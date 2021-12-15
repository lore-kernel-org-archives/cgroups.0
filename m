From: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Wed, 15 Dec 2021 03:47:46 +0000
Message-ID: <20211215034746.GA1097530@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <20211214143822.GA1063445@odroid>
 <87584294-b1bc-aabe-d86a-1a8b93a7f4d4@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WX18AvwNcCC2p0SRhjMK6GhbrhT1JBIKs0M6zY3Lj7Q=;
        b=WPMmh69mSOiH8mgu7ySy0stRSmNQGrh1n9Iu5lufvirjG8da5krGccBikzmhxIsonV
         GbYy/0bHveh5UqULIOuHH20n1HJHPYTsvZW5BCUkJsJDXDgnV+nHa9RB4IBg2YWPJ/qe
         d5vdXmlTtFUjiF+1U4AFPGuBU6UXbON5hAccSzNXB5qEG8PdX3brb3YXmDMWwz1J8OgI
         UstG31izgnPdQHQofdMy4Pv5BBjgfkIxeFVKEuskD09VJSK12WfK1GTx0gXEl7PF3xsW
         1V9a83ysdKElKSmypE0spqdeA2uIe+86YAbXC1pKh4RUT89rp+4xvKASaUTEbBqH5mWU
         RuAA==
Content-Disposition: inline
In-Reply-To: <87584294-b1bc-aabe-d86a-1a8b93a7f4d4-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes@cmpxchg>

On Tue, Dec 14, 2021 at 03:43:35PM +0100, Vlastimil Babka wrote:
> On 12/14/21 15:38, Hyeonggon Yoo wrote:
> > On Tue, Dec 14, 2021 at 01:57:22PM +0100, Vlastimil Babka wrote:
> >> On 12/1/21 19:14, Vlastimil Babka wrote:
> >> > Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> >> > this cover letter.
> >> > 
> >> > Series also available in git, based on 5.16-rc3:
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> >> 
> >> Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> >> and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> >> 
> > 
> > Hello Vlastimil, Thank you for nice work.
> > I'm going to review and test new version soon in free time.
> 
> Thanks!
> 

You're welcome!

> > Btw, I gave you some review and test tags and seems to be missing in new
> > series. Did I do review/test process wrongly? It's first time to review
> > patches so please let me know if I did it wrongly.
> 
> You did right, sorry! I didn't include them as those were for patches that I
> was additionally changing after your review/test and the decision what is
> substantial change enough to need a new test/review is often fuzzy. 

Ah, Okay. review/test becomes invalid after some changing.
that's okay. I was just unfamiliar with the process. Thank you!

> So if you can recheck the new versions it would be great and then I will pick that
> up, thanks!

Okay. I'll new versions.

> 
> > --
> > Thank you.
> > Hyeonggon.
> 
