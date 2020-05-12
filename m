From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 12 May 2020 09:25:21 -0400
Message-ID: <20200512132521.GA28700@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PTFxC40Ec7wOMd+ERavExEghGhS6XBq7Wvj2fntglJ8=;
        b=FDNc3WJa0vcrIlXtpcLbJPEaHig6WYKGXLTihc5rLW4Tn+74OO99gK4BHreesy1ChH
         SC++AU7M8QcXLivZnsUyba7/CKQp5QHeH8x8ErzhuMiVTXM+aAxN7tbY2CtOUE+1jXWy
         QU3jhaZOLsHZw1Suudr7VLD+FYipFu/z6+6zO3/Ub5WbDJ5BsRpXTUaLJ8s7H4Nmk2y2
         sNHLjeYp/Z4VcDlAKwu3npXk/EXLKV+UdHeEYXbeaKJQOoblqk1Bz3iVz1W8SaTPJ6dm
         xfvM09tdptP49PnjyL/56fp5zzMY/iAab+1OfbdRzHsoRzoe3uIZkVjVLGoBnh1gWDTn
         BS8w==
Content-Disposition: inline
In-Reply-To: <20200428161355.6377-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas

Seems like discussion on this patch series has died down. There's been
a concern raised that we could generalize infrastructure across loop,
md, etc. This may be possible, in the future, but it isn't clear to me
how this would look like. I'm inclined to fix the existing issue with
loop devices now (this is a problem we hit at FB) and address
consolidation with other cases if and when those are addressed.

Jens, you've expressed interest in seeing this series go through the
block tree so I'm interested in your perspective here. Barring any
concrete implementation bugs, would you be okay merging this version?
