From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Add memory.pressure_level events
Date: Tue, 19 Feb 2013 16:21:28 -0800
Message-ID: <CAOS58YOPjcH_pFFhPLJEAdaLkm5FoOy9mG2i-PkWAcb7O6V_Kw@mail.gmail.com>
References: <20130219044012.GA23356@lizard.sbx00618.mountca.wayport.net>
	<20130220001743.GE16950@blaptop>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=gvKwt9EaHmkxT25H4bDMH300uiPiXLyi+SgLTurTIXU=;
        b=aFeqYr7Q4R9F26J4VZLjKVhVNOIWfi4+4XsdRHrRIEElXwXsDYELR5Wyw9Y+qoz4SW
         C7GoTViHH8EzWBVyWQIi8r+hE5U8vkUW0gCqcSAq2EAwKJAw4AQlD7SuLUGl3V5C737P
         fHammyNlKq3jO72JvNsUUpYhoCxT8AXGvvZepg3GcNjZ3M3td6qgCzW5ezTsnVPa7zZ9
         Y28VR3x/2Ub5hMsUbiI4G/aSM0B6d22r0TX7HbD5lBekcYksjdCX8s7UoaXNeFEiPwZw
         n2ZR3k+OR7i0saDA1HTjIw7bs0HO/L7ItZizIrMZGEO9QELvW+L1mYcJOLCotJ+8Fz5R
         5NYw==
In-Reply-To: <20130220001743.GE16950@blaptop>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Leonid Moiseichuk <leonid.moiseichuk-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

Hello,

On Tue, Feb 19, 2013 at 4:17 PM, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Should we really enable memcg for just pressure notificaion in embedded side?
> I didn't check the size(cgroup + memcg) and performance penalty but I don't want
> to add unnecessary overhead if it is possible.
> Do you have a plan to support it via global knob(ie, /proc/mempressure), NOT memcg?

That should be handled by mempressure at the root cgroup. If that adds
significant amount of overhead code or memory-wise, we just need to
fix root cgroup handling in memcg. No reason to further complicate the
interface which already is pretty complex.

Thanks.

-- 
tejun
