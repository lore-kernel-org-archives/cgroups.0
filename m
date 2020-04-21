From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 15/18] mm: memcontrol: make swap tracking an integral
 part of memory control
Date: Tue, 21 Apr 2020 10:39:23 -0400
Message-ID: <20200421143923.GC341682@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-16-hannes@cmpxchg.org>
 <e9d58c82-d746-dcd0-d9e3-6322014a3b03@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FUghwdK61ELIcdqNXkNEUPkemM8u8aFA3cSbQm57Oy0=;
        b=gFxehvHGSNlG++mszljqSCAK7x9JFhjfQndMRxcNzeicsRBEWHLOnuSk7TV/f0lpJS
         hI40Kn4d4RhA2dhOIjiFgB4c9koyFw954Gi9PeFxAZnTNJx7vt622EPZLNpn9eUYH9le
         O9pbbJh5hVwKmuS42wfYZ3Y+WPU27d7VfvhPFCoLpJ467jhpzjCYj6m1WrPsIbmBx/Kr
         4h/THAUC+GEjA1w+FrC360VuFTaR4mLjUzraOoMvViF56WaYnVAS8b6VWjmlABi86u0L
         2yIVk9FFEx1KfLomk93emTZXN5qcyqBBKpgW+00of/GRzhQUA58c3n0SxXHmwIwDoTJh
         opFQ==
Content-Disposition: inline
In-Reply-To: <e9d58c82-d746-dcd0-d9e3-6322014a3b03-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Alex,

thanks for your quick review so far, I'll add the tags to the patches.

On Tue, Apr 21, 2020 at 05:27:30PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/4/21 上午6:11, Johannes Weiner 写道:
> > The swapaccount=0 boot option will continue to exist, and it will
> > eliminate the page_counter overhead and hide the swap control files,
> > but it won't disable swap slot ownership tracking.
> 
> May we add extra explanation for this change to user? and the default
> memsw limitations?

Can you elaborate what you think is missing and where you would like
to see it documented?

From a semantics POV, nothing changes with this patch. The memsw limit
defaults to "max", so it doesn't exert any control per default. The
only difference is whether we maintain swap records or not.
