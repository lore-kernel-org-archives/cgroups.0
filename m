From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 28 Apr 2020 22:27:32 -0400
Message-ID: <20200429022732.GA401038@cmpxchg.org>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j2BqRPlqFlKV+qbCocfSi2x/JssbK9MFgCKLqYpp14M=;
        b=yIS7iHAsJKIugA/8A/w12xYgJlTB3URYy1+zVBuG/07z9SfuYhVCBj5PiJkT0Sl+ji
         cXf8c1c1kahDA3yAOtTmKXArjKHd14VfmKaMdkMTPmYUTGT9rsh59FKalKFxHpPk83j/
         6h5k65Ipm/JdoKcB0TayOyf566CF1TYMAnhztvxsSe+BwiBqA3qd2wd4dPDUqUbXZhpF
         uHbegIniPpIGde6atAbSiqkWT/YfgXbyfmFXEoZf/A4Dbl49g/JVdbycBygXIQdXrWsS
         7yHAyDqE2Kg2ihWZShc7QF2VtZtp/xOzHOrit4A75A9vYuKtIEkgUrnHDttEgHdPRgAE
         B1jg==
Content-Disposition: inline
In-Reply-To: <20200428214653.GD2005-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tho

On Wed, Apr 29, 2020 at 07:47:34AM +1000, Dave Chinner wrote:
> On Tue, Apr 28, 2020 at 12:13:46PM -0400, Dan Schatzberg wrote:
> > This patch series does some
> > minor modification to the loop driver so that each cgroup can make
> > forward progress independently to avoid this inversion.
> > 
> > With this patch series applied, the above script triggers OOM kills
> > when writing through the loop device as expected.
> 
> NACK!
> 
> The IO that is disallowed should fail with ENOMEM or some similar
> error, not trigger an OOM kill that shoots some innocent bystander
> in the head. That's worse than using BUG() to report errors...

Did you actually read the script?

It's OOMing because it's creating 256M worth of tmpfs pages inside a
64M cgroup. It's not killing an innocent bystander, it's killing in
the cgroup that is allocating all that memory - after Dan makes sure
that memory is accounted to its rightful owner.

As opposed to before this series, where all this memory isn't
accounted properly and goes to the root cgroup - where, ironically, it
could cause OOM and kill an actually innocent bystander.
