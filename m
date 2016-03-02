From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv9 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 3 Mar 2016 00:52:08 +0530
Message-ID: <CAG53R5W+k2FHc2oem6jjuW5107heHvmKODntz727ebGYkC2NDw@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<20160302174052.GH29826@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=jNbonpw46jiTobIAXqxSEHCRxlxlaKn/UU9o8siHMc8=;
        b=w8n1QIEiYrAnI/g/XyusSyfBCs0lPUAuDQtuLZqJ3o8gPMQrG7ENsXQsSPE3QaxLyZ
         MqYABomBWY826d2j32WlLKrPWfHrWBrVjdcp8BxidK2Wkr3BekHG0z8W7ShUW7c0QN7z
         8ksxPHMVOkV3rpQCBb2HFXhQWxu5i4gAiVjqIXSqrmaNpkHReqOAJrumbuyEwcbME0hr
         CbH5/hz++ebMjW/+OZmdf3Gw2lI9/wL6sx854+9C6kRnr+V28/nXLpWZWjFo2zsg+xpy
         l9Q7J5Gt4U+c483IebqdcOVViFqOyNJyYSjb+wbEYZk5cYgBRV8a+J6eXS6oNm9DL3ua
         UxUg==
In-Reply-To: <20160302174052.GH29826-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On Wed, Mar 2, 2016 at 11:10 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> It doesn't look like my reviews are getting through.  For now,
>
I have addressed all the review comments that you provided in v5 patch.
I admit that few comments have not followed CodingStyle and I owe to
fix it, which is bad on my part.
I have few 2 questions on your comments, I will ask there.

For cgroup lock - out of 3 proposals, you acknowledged that you are ok
with cgroup specific spin_lock, though you don't see that as big
saving.
Even though it can be made course gained by having single lock for the
whole rdma cgroup subsystem it raises contention among processes of
different cgroups, which is preferable to avoid.
So I have continued to have cgroup specific fine grain lock, which I
believe is ok as this is little efficient for first cut.

Including above one we agreed on almost all the points at design and
implementation level in previous patches.
If you see any issue, I am open to resolve them.

I will address comments given in patch v9.

> Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>
> --
> tejun
