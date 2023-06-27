From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 10:24:15 +0200
Message-ID: <20230627-kanon-hievt-bfdb583ddaa6@brauner>
References: <20230626201713.1204982-1-surenb@google.com>
 <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687854263;
        bh=PN+dhNU90c6TSMh3/nk0lQ0xTCk2Ol9fv6nVZ+3C3Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jzpntFt4cDFZqdnwrhYYQu9Rl/AdiT/dgFwqBf9uhifEdWwBRB/S7RkW/lNEObdOD
         veTLCh6DRqPTzJ6vgmoz+qoJmY6o62HH07i2GPye7qgYSTjk/7HbebRORp60zwhyKq
         klfDw2Se8as5Kw0aL3AoWUhdQtPNPqzCykvpI6NNE/wnjUpFICvXM/jzQwClGPNnoJ
         aN2t25b2FEPFSitFyPrzZdY2Y507lIck+lAdzzqbrgRFrVBh6tK5laCYTAPUdiXXL2
         iLwRq19wb4oxMX/6BgEZyFIOcrsUg+4YGFRpNKVtFQhzDAaOWSSZ3udpE9ORPNxRK/
         WDbv8eOaCDkPw==
Content-Disposition: inline
In-Reply-To: <ZJn1tQDgfmcE7mNG-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Mon, Jun 26, 2023 at 10:31:49AM -1000, Tejun Heo wrote:
> On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > index 73f5c120def8..a7e404ff31bb 100644
> > --- a/include/linux/kernfs.h
> > +++ b/include/linux/kernfs.h
> > @@ -273,6 +273,11 @@ struct kernfs_ops {
> >  	 */
> >  	int (*open)(struct kernfs_open_file *of);
> >  	void (*release)(struct kernfs_open_file *of);
> > +	/*
> > +	 * Free resources tied to the lifecycle of the file, like a
> > +	 * waitqueue used for polling.
> > +	 */
> > +	void (*free)(struct kernfs_open_file *of);
> 
> I think this can use a bit more commenting - ie. explain that release may be
> called earlier than the actual freeing of the file and how that can lead to
> problems. Othre than that, looks fine to me.

It seems the more natural thing to do would be to introduce a ->drain()
operation and order it before ->release(), no?
