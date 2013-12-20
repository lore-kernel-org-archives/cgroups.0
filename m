From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v14 16/18] vmpressure: in-kernel notifications
Date: Fri, 20 Dec 2013 20:46:05 +0400
Message-ID: <CAA6-i6oJrUquFa3Y=+vGCDjh7z8ZOxT20QuyWweyrrKGOeBGAA@mail.gmail.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
	<abff42910c131a9c94a7518de59b283ee0a2dcd1.1387193771.git.vdavydov@parallels.com>
	<20131220092659.0ed23cf5@redhat.com>
	<CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
	<20131220100332.0c5c1ad5@redhat.com>
	<20131220114439.23af09fc@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=FM0XTnjaqz26226hjTFJKHD2NSqFjXz8oBrNfWjBcMs=;
        b=nrw4z99dZMm7yylUsDLa3rnRzSTl0EuhLzTvyGbwRrD8lEOW7mDiG09Ki82S4YrqHm
         R5ZioCu7oqgyEZB0If5OQsPSMEfAFV8VQ4gntt2W+E7qoiYh4JcejnMiP/Q5bXRHj+n3
         b+eD1XpDBPfs2sslpfUPXY3wmStRjkbkbJhB0SY97E2IqJseJkI8BtAdLpEbB1KoaGe3
         27dr2YIPLhDGE1ztN6pQPDaZ7NUAMo+z167bEw6oKgygLzlEdGRM9mBPE3OWFo2kDyMQ
         nc+wBG8pvibVwZnOCggY84/65fnEyNY1MKmJCbp6y2SfgapAJFTmdQuw17xkj/OXJO30
         5nEA==
In-Reply-To: <20131220114439.23af09fc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Fri, Dec 20, 2013 at 8:44 PM, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 20 Dec 2013 10:03:32 -0500
> Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> > The answer for all of your questions above can be summarized by noting
>> > that for the lack of other users (at the time), this patch does the bare minimum
>> > for memcg needs. I agree, for instance, that it would be good to pass the level
>> > but since memcg won't do anything with thta, I didn't pass it.
>> >
>> > That should be extended if you need to.
>>
>> That works for me. That is, including this minimal version first and
>> extending it when we get in-tree users.
>
> Btw, there's something I was thinking just right now. If/when we
> convert shrink functions to use this API, they will come to depend
> on CONFIG_MEMCG=y. IOW, they won't work if CONFIG_MEMCG=n.
>
> Is this acceptable (this is an honest question)? Because today, they
> do work when CONFIG_MEMCG=n. Should those shrink functions use the
> shrinker API as a fallback?

If you have a non-memcg user, that should obviously be available for
CONFIG_MEMCG=n
