From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 26 May 2020 22:09:22 -0700
Message-ID: <20200527050922.GB31860@infradead.org>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200512132521.GA28700@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <20200512133545.GA26535@infradead.org>
 <20200526142803.GA1061@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gHdtexCQGQRaatxx6IEb1gGC16jgjrLxhKEQOJ39uAQ=; b=kvM2IesnbKbAxu4uRnJqOjHn1U
        OkIhbK/PCHpdiGv/c7IzpFly3ueziTlwNiOXh/Y+3tpsSWg3LMrjVQ+LMnF+zEUZNmqNw6Kl5OnQC
        AFM8ATOv9heC9Nl0TZzyzRn1Cnh4gYHIngAMbimQN3Y4I0cpXIb2U3+NLOERIWMSbne/KPx/P0eB1
        uR6Bp59hrw2Fe+P1qymKKKRIW6o6dnreDzWkemnh2tSCnLr4wc7/wD9Y8oXYIwiecGkPqEyWeNGTw
        3dV84ae9v7pa1kHq0cQMpqc716FshZpviUGRx8aObBmHV3UBnQO0sia9QJcT5SegOXvISsfpGPctQ
        ZVrM3Gvg==;
Content-Disposition: inline
In-Reply-To: <20200526142803.GA1061-fkkBeQb8ge2DK6JXYb2XlJM2KBzDZLgSYRRNvcr/Vuo4Aut8bSbYrdcQFCl+OI4i@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea

On Tue, May 26, 2020 at 10:28:03AM -0400, Dan Schatzberg wrote:
> Will do - I'll split out the lock-use refactor into a separate
> patch. Do you have particular concerns about re-using the existing
> spinlock? Its existing use is not contended so I didn't see any harm
> in extending its use. I'll add this justification to the commit
> message as well, but I'm tempted to leave the re-use as is instead of
> creating a new lock.

Please don't share a lock for entirely separate critical sections that
are used from different contexts.
