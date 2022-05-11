From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/6] mm: Kconfig: group swap, slab, hotplug and thp
 options into submenus
Date: Wed, 11 May 2022 11:22:58 -0400
Message-ID: <YnvU0hwCfQ11P8Ce@cmpxchg.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-4-hannes@cmpxchg.org>
 <20220510154037.c7916ee9d7de90eedd12f92c@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w9MfWQzcSMrfAB8m54hQ3mQgRCuKTad5K055CRIl8Vo=;
        b=QHywmB7fZKi72sdflTBtW+kFZJRQSuZqWDaMwXqm9WlGt+siby1JuJMbb4mVAD3aS5
         iejYTkI59BMc6y/oIXBVWa/9MeazGxDgdZ6JnQ4acVJEzufjZQsDtznMDuu+1warN0qK
         MYfH0+Of2lno/uFNjSHx3f2rOG+DoVkqmq+h1Yo5O5S0KFbMpMU866O+NGrpTpFVmwIo
         rZFIV/+obJD9S6I2t67nE7tVzhD3t8tjCZrDfcCgTj2X/3gaPOBFQPCIDW6o9dE/fle5
         3WnODSV3b58gj79dPkcuaodpP+ksbzv8GPwBbBm1Po7hU8tSatFR5ZUjnyObXnudlq7S
         4jDw==
Content-Disposition: inline
In-Reply-To: <20220510154037.c7916ee9d7de90eedd12f92c-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, May 10, 2022 at 03:40:37PM -0700, Andrew Morton wrote:
> On Tue, 10 May 2022 11:28:44 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > There are several clusters of related config options spread throughout
> > the mostly flat MM submenu. Group them together and put specialization
> > options into further subdirectories to make the MM submenu a bit more
> > organized and easier to navigate.
> 
> Causes
> 
> hp2:/usr/src/25> make allnoconfig

My bad. I'll respin those on top of the others and add allnoconfig
builds to my testing routine. Thanks.
