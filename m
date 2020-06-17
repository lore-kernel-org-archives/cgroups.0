From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH for 5.8] mm: do_swap_page fix up the error code
 instantiation
Date: Wed, 17 Jun 2020 09:34:30 -0400
Message-ID: <20200617133430.GD616830@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-17-hannes@cmpxchg.org>
 <20200611093523.GB20450@dhcp22.suse.cz>
 <20200617084927.GK9499@dhcp22.suse.cz>
 <20200617090238.GL9499@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bI+LSwU3WmKQTw3s6Ynrm9kunWR6ux85bO94Rtl9UB8=;
        b=Hy1d/ERyRuOB+PHm+LELxp1o2YdldrppiRVKFZyx/RbXD3vjo9A0QBXm5PWd4kJKNe
         IpTqynvSN806MhwnVN8BDl15WWL5qjhtvYjVRcWHgUeRBKvUC/PdE1RBP/rcqSrba/fl
         gZP/7f3fWYzrqWgetaSNhIiuvxiMDLIRcfQdRga5mURGu115WWvvQ7yf5tu5CNqKKKod
         U9T2O66BCAeZX+b0MvOCrHEgUPMUuIEuuYHJ5tO/uUP4ZAE8NvbQVjnsCiwIAxlDoU/0
         atGiASzPLZ5wAKzHteiMjnyfArxhvqfXuueHlzWvnDsGFMgUpREHhBa0ohJAE1eRnFDR
         mAig==
Content-Disposition: inline
In-Reply-To: <20200617090238.GL9499-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Jun 17, 2020 at 11:02:38AM +0200, Michal Hocko wrote:
> Damn, I forgot to commit my last change (s@err@ret@). Sorry about the
> noise.
> 
> From 50297dd026ebf71fe901e1945a9ce1e8d8aa083b Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Date: Wed, 17 Jun 2020 10:40:47 +0200
> Subject: [PATCH] mm: do_swap_page fix up the error code
> 
> do_swap_page returns error codes from the VM_FAULT* space. try_charge
> might return -ENOMEM, though, and then do_swap_page simply returns 0
> which means a success.
> 
> We almost never return ENOMEM for GFP_KERNEL single page charge. Except
> for async OOM handling (oom_disabled v1). So this needs translation to
> VM_FAULT_OOM otherwise the the page fault path will not notify the
> userspace and wait for an action.
> 
> Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Good catch, thanks Michal.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
