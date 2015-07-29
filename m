From: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Wed, 29 Jul 2015 07:13:47 -0700
Message-ID: <CANN689GLasWAMGAjqmceEWcpnjjLGMbQYPx6uTAU=K4sT1NNnA@mail.gmail.com>
References: <cover.1437303956.git.vdavydov@parallels.com>
	<20150729123629.GI15801@dhcp22.suse.cz>
	<20150729135907.GT8100@esperanza>
	<CANN689HJX2ZL891uOd8TW9ct4PNH9d5odQZm86WMxkpkCWhA-w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=qLaQqdTq1gvqRc63Vnuy8TQhRI/n5RQHwnODAKYijRM=;
        b=gyyXBkM96w0fE7nsIxXGnzadsakXAEHbiC/9qoHyEwS8eFBdAVQBDdkSP4ahqZQhqJ
         vsOmjFpjb1e63goW84o2+SemXVX4DmffA3gW8tqEvWx4WgkTeO66N5F2FSZaq04rBmoq
         1j9if+R/YnXQVal1vHVDd3bMaqFf0VQezY7/SubqZ4Jyu6SP/B+P/UNKVsGoJd/NL253
         HxTZXqBaSA3nrDJrKYdznuhzmf8JWHLaD9BuRSQp9U9IguZRzaOc2pgExAmRU3L2iR96
         u/2rD1hU1ss1NDTPQp5k3HzsWLETUQsRtwUvQzSWihxr+F2W13gMTt5EG6HY4Gw1nTFt
         v76g==
In-Reply-To: <CANN689HJX2ZL891uOd8TW9ct4PNH9d5odQZm86WMxkpkCWhA-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(resending as text, sorry for previous post which didn't make it to the ML)

On Wed, Jul 29, 2015 at 7:12 AM, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Jul 29, 2015 at 6:59 AM, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> >> I guess the primary reason to rely on the pfn rather than the LRU walk,
> >> which would be more targeted (especially for memcg cases), is that we
> >> cannot hold lru lock for the whole LRU walk and we cannot continue
> >> walking after the lock is dropped. Maybe we can try to address that
> >> instead? I do not think this is easy to achieve but have you considered
> >> that as an option?
> >
> > Yes, I have, and I've come to a conclusion it's not doable, because LRU
> > lists can be constantly rotating at an arbitrary rate. If you have an
> > idea in mind how this could be done, please share.
> >
> > Speaking of LRU-vs-PFN walk, iterating over PFNs has its own advantages:
> >  - You can distribute a walk in time to avoid CPU bursts.
> >  - You are free to parallelize the scanner as you wish to decrease the
> >    scan time.
>
> There is a third way: one could go through every MM in the system and scan their page tables. Doing things that way turns out to be generally faster than scanning by physical address, because you don't have to go through RMAP for every page. But, you end up needing to take the mmap_sem lock of every MM (in turn) while scanning them, and that degrades quickly under memory load, which is exactly when you most need this feature. So, scan by address is still what we use here.
>
> My only concern about the interface is that it exposes the fact that the scan is done by address - if the interface only showed per-memcg totals, it would make it possible to change the implementation underneath if we somehow figure out how to work around the mmap_sem issue in the future. I don't think that is necessarily a blocker but this is something to keep in mind IMO.

--
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
