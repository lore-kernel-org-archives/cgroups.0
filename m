From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 05:55:26 -0700
Message-ID: <CAG53R5UOogG1itd8AzMOWnpnyGqKSRLY4CNrX5HWGfdF3q-F3w@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
	<CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
	<20160405012504.GG24661@htj.duckdns.org>
	<20160405090627.GA26425@infradead.org>
	<CAG53R5WBBUj6=B81Q-zEwL_xy3_yXUofJ6p921baqnqeVocDPQ@mail.gmail.com>
	<20160405124252.GA4348@infradead.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=g/lr3oCIpVf7ATDM/3BwzOSwCDAMhSc5QsvDj0+D7BY=;
        b=Uyqx2cSJTCXUXflPNGzHHB4sQxrWh3+OCdfpUr0RRAeiZww1Wb1jcD93+cG1uj2Nvw
         duM3X96sERj9JHANVvSZf8ERl+tDlyW677Tn9RLDmf5e9EGvMKe7KtLAudd044PqGf4O
         MLQW0ERqsZxmUSHvxbqquD3X6d3gCVuVh1fruGv80FlpZJD2tgN0enRu/u2Du2DOm5Fi
         tExuI99HhMkBjJHRS3KehpPWoeu6mIHaqsifobJG5rSufhlXEZ+Y+J9QHVeC2x74WSMP
         QCHUJPLHxltk2tFMm57dAZZRcmSbg+goLRECUE0ialIsuHC3zK++wBXRg0G7Eks72xY2
         vFWQ==
In-Reply-To: <20160405124252.GA4348-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Christoph,

On Tue, Apr 5, 2016 at 5:42 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Tue, Apr 05, 2016 at 05:39:21AM -0700, Parav Pandit wrote:
>> I am not really trying to address OFED issues here. I am sure you
>> understand that if ib_core.ko kernel module is in-kernel module than,
>> for all the fixes/enhancements that goes to it would require people to
>> upgrade to newer kernel, instead of just modules upgrade. Such heavy
>> weight upgrade slows down the adoption which i am trying to avoid here
>> by placing knobs in right kernel module's hand.
>
> What a load of rubbish.  The Linux kernel is one program and should be
> upgraded together.

Just because we add one more rdma resource, we need to ask someone to
upgrade kernel?

Flexibility is coming at very minimal cost, so what exactly is the
issue in having that instead of forcing architecture to give away
that? Whole code is hardly 700 odd lines.

>
>> Its like making ib_core.ko from module to in kernel component, if I
>> understand correctly nobody wants to do that.
>
> We allow splitting subsystems out where it's easily doable to avoid the
> resources consumption if they're all built in.  For cgroups it's not
> really practical, but that doesn't mean you can upgrade invidual parts
> of a complex program without a lot of precaution.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
