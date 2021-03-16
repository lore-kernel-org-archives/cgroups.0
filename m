From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Tue, 16 Mar 2021 12:02:46 -0400
Message-ID: <YFDWps+whDDhoan5@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
 <20210316153655.500806-3-schatzberg.dan@gmail.com>
 <CALvZod7sk52OYwxP=VRhS0q4xZ57UuSdL6Mi4Y956xDq3pTatQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWxtuf+bX9R9Cu8TrjqwnDkf028NcAMlaQLndtH+i54=;
        b=LYzEzss7CpK+82hRa1OyJ5aKdBxvMSCKamF0GMBN3uRD3MjSqMnlr4wAbcnVkeWmqO
         xMTtoGkM+2XtUWunjz/GozmOPWH81mpg0mMYthGk6NU3chxb1OT/zTWHxoOJjW+y7ntB
         FJVIMyD12Ki7bro2nKguFU5F2O98AsnxXJEy9BU/MUIDCgEKPjCkvKYOv7OcnEWKLr+Z
         tHmR/A8LIQypTA4XLaqM6qXCgMmhMrfhcMy7oejDQr/gpqQeDou3C+fazTlvvUvsY7VN
         C1wvmeXLITdnLCvnOkmS5rBkMbCOPGQtHiEJAyAk3aDaGwIt008WGNfYLgi//LIDoM8n
         dKkQ==
Content-Disposition: inline
In-Reply-To: <CALvZod7sk52OYwxP=VRhS0q4xZ57UuSdL6Mi4Y956xDq3pTatQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Mar 16, 2021 at 08:50:16AM -0700, Shakeel Butt wrote:
> You will need to rebase to the latest mm tree. This code has changed.

Thanks for the feedback, I will address these comments in another
rebase. I'll wait and see if there's any comments concerning the
loop-related patches but it sounds like this will need to go through
the mm-tree
